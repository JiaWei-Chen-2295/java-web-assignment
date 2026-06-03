/**
 * Note App — File Upload Utility
 * Supports programmatic upload, drag-and-drop, and progress indication.
 */
(function () {
    'use strict';

    // ---------------------------------------------------------------
    // Core upload function
    // ---------------------------------------------------------------
    /**
     * Upload a file to the given endpoint.
     * @param {File} file - The file to upload.
     * @param {string} endpoint - The server endpoint (e.g. '/api/upload/image').
     * @param {Object} [extraFields] - Additional key-value pairs to include in the FormData.
     * @returns {Promise<Object>} Resolves with the parsed server response.
     */
    function upload(file, endpoint, extraFields) {
        return new Promise(function (resolve, reject) {
            if (!file) {
                reject(new Error('No file provided'));
                return;
            }

            var formData = new FormData();
            formData.append('file', file);

            if (extraFields && typeof extraFields === 'object') {
                Object.keys(extraFields).forEach(function (key) {
                    formData.append(key, extraFields[key]);
                });
            }

            var xhr = new XMLHttpRequest();
            xhr.open('POST', endpoint, true);

            // Progress tracking
            xhr.upload.onprogress = function (e) {
                if (e.lengthComputable) {
                    var pct = Math.round((e.loaded / e.total) * 100);
                    updateProgress(pct);
                    dispatchProgress(file.name, pct);
                }
            };

            xhr.onload = function () {
                hideProgress();
                if (xhr.status >= 200 && xhr.status < 300) {
                    try {
                        var resp = JSON.parse(xhr.responseText);
                        resolve(resp);
                    } catch (err) {
                        reject(new Error('Invalid server response'));
                    }
                } else {
                    var errMsg = 'Upload failed';
                    try {
                        var errResp = JSON.parse(xhr.responseText);
                        errMsg = errResp.message || errMsg;
                    } catch (e) { /* ignore */ }
                    reject(new Error(errMsg + ' (HTTP ' + xhr.status + ')'));
                }
            };

            xhr.onerror = function () {
                hideProgress();
                reject(new Error('Network error during upload'));
            };

            xhr.send(formData);
        });
    }

    // ---------------------------------------------------------------
    // Image-specific upload shortcut
    // ---------------------------------------------------------------
    /**
     * Upload an image file to /api/upload/image.
     * @param {File} file - The image file.
     * @param {string} [noteId] - Optional note ID to associate.
     * @returns {Promise<Object>}
     */
    function uploadImage(file, noteId) {
        var fields = {};
        if (noteId) fields.noteId = noteId;
        var cp = window.contextPath || '';
        return upload(file, cp + '/api/upload/image', fields);
    }

    // ---------------------------------------------------------------
    // Progress indicator (fixed overlay)
    // ---------------------------------------------------------------
    var progressEl = null;

    function ensureProgressEl() {
        if (progressEl) return;
        progressEl = document.createElement('div');
        progressEl.id = 'upload-progress-global';
        progressEl.className = 'upload-progress';
        progressEl.innerHTML =
            '<span class="upload-progress-text">Uploading...</span>' +
            '<div class="upload-progress-bar"><div class="upload-progress-bar-fill"></div></div>';
        document.body.appendChild(progressEl);
    }

    function showProgress() {
        ensureProgressEl();
        progressEl.classList.add('active');
    }

    function hideProgress() {
        if (!progressEl) return;
        setTimeout(function () {
            progressEl.classList.remove('active');
            var fill = progressEl.querySelector('.upload-progress-bar-fill');
            if (fill) fill.style.width = '0%';
        }, 300);
    }

    function updateProgress(pct) {
        showProgress();
        if (!progressEl) return;
        var fill = progressEl.querySelector('.upload-progress-bar-fill');
        if (fill) fill.style.width = pct + '%';
        var text = progressEl.querySelector('.upload-progress-text');
        if (text) text.textContent = 'Uploading... ' + pct + '%';
    }

    // Custom event for external listeners
    function dispatchProgress(fileName, pct) {
        document.dispatchEvent(new CustomEvent('upload-progress', {
            detail: { fileName: fileName, percent: pct }
        }));
    }

    // ---------------------------------------------------------------
    // Drag-and-drop support
    // ---------------------------------------------------------------
    /**
     * Enable drag-and-drop file upload on a target element.
     * @param {HTMLElement} targetEl - The element to accept drops.
     * @param {string} endpoint - Upload endpoint.
     * @param {Object} [options] - Options.
     * @param {Function} [options.onSuccess] - Called with server response.
     * @param {Function} [options.onError] - Called with error.
     * @param {Object} [options.extraFields] - Extra FormData fields.
     * @param {string} [options.accept] - MIME type filter (e.g. 'image/*').
     */
    function enableDragDrop(targetEl, endpoint, options) {
        if (!targetEl) return;
        options = options || {};

        var overlayEl = null;

        function createOverlay() {
            if (overlayEl) return;
            overlayEl = document.createElement('div');
            overlayEl.className = 'drag-overlay';
            overlayEl.innerHTML = '<span class="drag-overlay-text">Drop file to upload</span>';
            // Make target position relative if static
            var pos = getComputedStyle(targetEl).position;
            if (pos === 'static') {
                targetEl.style.position = 'relative';
            }
            targetEl.appendChild(overlayEl);
        }

        function showOverlay() {
            createOverlay();
            if (overlayEl) overlayEl.classList.add('active');
        }

        function hideOverlay() {
            if (overlayEl) overlayEl.classList.remove('active');
        }

        // Prevent default drag behaviors on the target
        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(function (evt) {
            targetEl.addEventListener(evt, function (e) {
                e.preventDefault();
                e.stopPropagation();
            });
        });

        var dragCounter = 0;

        targetEl.addEventListener('dragenter', function () {
            dragCounter++;
            showOverlay();
        });

        targetEl.addEventListener('dragleave', function () {
            dragCounter--;
            if (dragCounter <= 0) {
                dragCounter = 0;
                hideOverlay();
            }
        });

        targetEl.addEventListener('drop', function (e) {
            dragCounter = 0;
            hideOverlay();

            var files = e.dataTransfer.files;
            if (!files || files.length === 0) return;

            Array.from(files).forEach(function (file) {
                // Filter by accept type if specified
                if (options.accept) {
                    var acceptTypes = options.accept.split(',').map(function (t) {
                        return t.trim();
                    });
                    var matched = acceptTypes.some(function (type) {
                        if (type.endsWith('/*')) {
                            return file.type.startsWith(type.replace('/*', '/'));
                        }
                        return file.type === type || file.name.endsWith(type);
                    });
                    if (!matched) {
                        if (options.onError) {
                            options.onError(new Error('File type not accepted: ' + file.type));
                        }
                        return;
                    }
                }

                upload(file, endpoint, options.extraFields)
                    .then(function (resp) {
                        if (options.onSuccess) options.onSuccess(resp, file);
                        document.dispatchEvent(new CustomEvent('upload-complete', {
                            detail: { response: resp, file: file }
                        }));
                    })
                    .catch(function (err) {
                        if (options.onError) options.onError(err, file);
                        document.dispatchEvent(new CustomEvent('upload-error', {
                            detail: { error: err, file: file }
                        }));
                    });
            });
        });
    }

    // ---------------------------------------------------------------
    // Expose API
    // ---------------------------------------------------------------
    window.FileUpload = {
        upload: upload,
        uploadImage: uploadImage,
        enableDragDrop: enableDragDrop
    };
})();

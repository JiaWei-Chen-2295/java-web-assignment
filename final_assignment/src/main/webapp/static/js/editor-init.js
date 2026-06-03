/**
 * NoteApp — Editor.js 块编辑器（飞书式 WYSIWYG）+ 自动保存
 */
(function () {
    'use strict';

    var editor = null;
    var noteId = null;
    var saveTimer = null;
    var SAVE_DELAY = 1500;
    var isReady = false;
    var migratedFromMarkdown = false;

    function $(sel) { return document.querySelector(sel); }

    function setSaveStatus(state, message) {
        var el = $('#save-status');
        if (!el) return;
        el.className = 'save-status ' + state;
        var textEl = el.querySelector('.save-status-text');
        if (textEl) textEl.textContent = message || '';
        var icon = el.querySelector('i');
        if (icon) {
            icon.className = 'bi ' + (
                state === 'saved' ? 'bi-check-circle' :
                state === 'saving' ? 'bi-arrow-repeat spin' :
                'bi-exclamation-circle'
            );
        }
    }

    function dispatchContentChanged() {
        document.dispatchEvent(new CustomEvent('editor-content-changed'));
    }

    function uploadImage(file) {
        var cp = window.contextPath || '';
        var formData = new FormData();
        formData.append('file', file);
        if (noteId) formData.append('noteId', noteId);

        return fetch(cp + '/api/upload/image', { method: 'POST', body: formData })
            .then(function (r) {
                if (!r.ok) throw new Error('upload failed');
                return r.json();
            })
            .then(function (data) {
                if (!data.url) throw new Error('no url');
                return data.url;
            });
    }

    function resolveInitialData(payload) {
        var content = payload.content || '';
        var format = (payload.contentFormat || 'markdown').toLowerCase();
        var needsMigrate = format === 'markdown' || !content.trim();

        if (content.trim()) {
            try {
                var parsed = JSON.parse(content);
                if (window.MarkdownToEditorJs.isEditorJsData(parsed)) {
                    return {
                        data: window.MarkdownToEditorJs.normalizeDoc(parsed),
                        migrate: false
                    };
                }
            } catch (e) { /* markdown */ }
            needsMigrate = true;
        }

        if (needsMigrate) {
            migratedFromMarkdown = true;
            return {
                data: window.MarkdownToEditorJs.normalizeDoc(window.MarkdownToEditorJs.parse(content)),
                migrate: true
            };
        }
        return { data: window.MarkdownToEditorJs.normalizeDoc(window.MarkdownToEditorJs.emptyDoc()), migrate: false };
    }

    function saveNote() {
        if (!editor || !noteId || !isReady) return Promise.resolve();

        setSaveStatus('saving', '保存中...');
        var cp = window.contextPath || '';
        var titleInput = $('#note-title');
        var title = titleInput ? titleInput.value.trim() : '无标题笔记';

        return editor.save().then(function (output) {
            if (window.EditorWikiLink && window.EditorWikiLink.normalizeOutput) {
                output = window.EditorWikiLink.normalizeOutput(output);
            }
            var content = JSON.stringify(output);
            return fetch(cp + '/api/note/update', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    id: Number(noteId),
                    title: title || '无标题笔记',
                    content: content,
                    contentFormat: 'editorjs'
                })
            });
        })
        .then(function (resp) {
            if (!resp.ok) throw new Error('HTTP ' + resp.status);
            return resp.json();
        })
        .then(function (data) {
            if (!data.success) throw new Error('save rejected');
            setSaveStatus('saved', '已保存');
            if (migratedFromMarkdown) {
                migratedFromMarkdown = false;
                if (window.showToast) {
                    window.showToast('已从 Markdown 转为块编辑格式', 'success');
                }
            }
            dispatchContentChanged();
            if (window.EditorWikiLink && window.EditorWikiLink.refreshPanels) {
                window.EditorWikiLink.refreshPanels(noteId);
            }
            /* 保存完成后全量渲染 wiki-link（此时编辑器无焦点，安全操作） */
            if (window.EditorWikiLink && window.EditorWikiLink.decorateAllSafe) {
                window.EditorWikiLink.decorateAllSafe();
            }
        })
        .catch(function (err) {
            console.error('Save failed:', err);
            setSaveStatus('error', '保存失败');
            if (window.showToast) window.showToast('保存失败，请检查网络后重试', 'error');
        });
    }

    function scheduleSave() {
        if (!isReady) return;
        clearTimeout(saveTimer);
        setSaveStatus('saving', '等待保存...');
        saveTimer = setTimeout(saveNote, SAVE_DELAY);
    }

    function buildEditor(holderId, data) {
        return new EditorJS({
            holder: holderId,
            autofocus: false,
            data: data,
            placeholder: '输入正文，或键入 / 插入内容块…',
            minHeight: 280,
            defaultBlock: 'paragraph',
            i18n: {
                messages: {
                    toolNames: {
                        Text: '正文',
                        Heading: '标题',
                        List: '列表',
                        'Ordered List': '有序列表',
                        'Unordered List': '无序列表',
                        Checklist: '待办清单',
                        Quote: '引用',
                        Code: '代码',
                        Delimiter: '分割线',
                        Image: '图片',
                        Link: '链接',
                        Bold: '加粗',
                        Italic: '斜体'
                    },
                    tools: {
                        List: {
                            Ordered: '有序',
                            Unordered: '无序',
                            Checklist: '待办'
                        }
                    },
                    blockTunes: {
                        delete: '删除',
                        moveUp: '上移',
                        moveDown: '下移'
                    },
                    ui: {
                        blockTunes: {
                            toggler: {
                                'Click to tune': '点击调整',
                                'or drag to move': '或拖动移动'
                            }
                        },
                        inlineToolbar: {
                            converter: {
                                'Convert to': '转换为'
                            }
                        },
                        toolbar: {
                            toolbox: {
                                Add: '添加'
                            }
                        },
                        popover: {
                            'Convert to': '转换为',
                            'Filter': '筛选',
                            'Nothing found': '无匹配项'
                        }
                    }
                }
            },
            tools: {
                header: {
                    class: Header,
                    inlineToolbar: ['bold', 'italic', 'link'],
                    config: {
                        levels: [1, 2, 3],
                        defaultLevel: 2
                    }
                },
                list: {
                    class: EditorjsList,
                    inlineToolbar: true,
                    config: {
                        defaultStyle: 'unordered',
                        maxLevel: 4
                    }
                },
                quote: {
                    class: Quote,
                    inlineToolbar: true,
                    config: {
                        quotePlaceholder: '输入引用内容...',
                        captionPlaceholder: '输入引用来源...'
                    }
                },
                code: {
                    class: EnhancedCodeTool
                },
                delimiter: Delimiter,
                image: {
                    class: ImageTool,
                    config: {
                        uploader: {
                            uploadByFile: function (file) {
                                return uploadImage(file).then(function (url) {
                                    return {
                                        success: 1,
                                        file: { url: url }
                                    };
                                }).catch(function () {
                                    return { success: 0 };
                                });
                            }
                        }
                    }
                }
            },
            onChange: function () {
                scheduleSave();
                dispatchContentChanged();
                /* 合并刷新：延迟 150ms 后统一执行，避免每次 keystroke 都触发多个刷新 */
                clearTimeout(window._editorRefreshTimer);
                window._editorRefreshTimer = setTimeout(function () {
                    if (window.EditorSlash && window.EditorSlash.onChange) {
                        window.EditorSlash.onChange();
                    }
                    if (window.EditorBlockUI && window.EditorBlockUI.refresh) {
                        window.EditorBlockUI.refresh();
                    }
                    if (window.EditorWikiLink && window.EditorWikiLink.onEditorChange) {
                        window.EditorWikiLink.onEditorChange();
                    }
                }, 150);
                var tips = document.getElementById('editorTips');
                if (tips) tips.style.display = 'none';
            },
            onReady: function () {
                isReady = true;
                setSaveStatus('saved', '已保存');
                dispatchContentChanged();
                var holder = document.getElementById(holderId);
                if (window.EditorSlash && window.EditorSlash.bind) {
                    window.EditorSlash.bind(holder);
                }
                if (window.EditorKeyboard && window.EditorKeyboard.bind) {
                    window.EditorKeyboard.bind(holder);
                }
                if (window.EditorBlockUI && window.EditorBlockUI.bind) {
                    window.EditorBlockUI.bind(holder);
                }
                if (window.EditorWikiLink && window.EditorWikiLink.bind) {
                    window.EditorWikiLink.bind(holder);
                }
                if (window.EditorWikiLink && window.EditorWikiLink.onEditorChange) {
                    setTimeout(window.EditorWikiLink.onEditorChange, 600);
                }
                var hint = document.getElementById('slashHint');
                if (hint) hint.style.display = 'none';
                if (migratedFromMarkdown) {
                    scheduleSave();
                }
            }
        });
    }

    function loadAndInit() {
        var holder = document.getElementById('editorjs');
        if (!holder) return;

        noteId = window.noteApp && window.noteApp.noteId;
        if (!noteId) {
            holder.innerHTML = '<p class="editor-error">无法加载笔记</p>';
            return;
        }

        var cp = window.contextPath || '';
        setSaveStatus('saving', '加载中...');

        fetch(cp + '/api/note/content?id=' + noteId)
            .then(function (r) {
                if (!r.ok) throw new Error('load failed');
                return r.json();
            })
            .then(function (payload) {
                var titleInput = $('#note-title');
                if (titleInput && payload.title) {
                    titleInput.value = payload.title;
                    document.title = (payload.title || '无标题笔记') + ' - NoteApp';
                }

                var resolved = resolveInitialData(payload);
                editor = buildEditor('editorjs', resolved.data);

                window.NoteEditor = {
                    save: saveNote,
                    getEditor: function () { return editor; },
                    getNoteId: function () { return noteId; },
                    isReady: function () { return isReady; }
                };
            })
            .catch(function (err) {
                console.error(err);
                setSaveStatus('error', '加载失败');
                holder.innerHTML = '<p class="editor-error">笔记加载失败，请返回后重试</p>';
            });
    }

    function bindTitle() {
        var titleInput = $('#note-title');
        if (!titleInput) return;

        titleInput.addEventListener('input', function () {
            var t = this.value.trim() || '无标题笔记';
            document.title = t + ' - NoteApp';
            scheduleSave();
        });
        titleInput.addEventListener('blur', function () {
            clearTimeout(saveTimer);
            saveNote();
        });
        titleInput.addEventListener('keydown', function (e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                var red = document.querySelector('#editorjs .ce-paragraph[contenteditable="true"]');
                if (red) red.focus();
            }
        });
    }

    document.addEventListener('keydown', function (e) {
        if ((e.ctrlKey || e.metaKey) && e.key === 's') {
            e.preventDefault();
            clearTimeout(saveTimer);
            saveNote();
        }
    });

    function init() {
        bindTitle();
        loadAndInit();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();

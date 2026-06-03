/**
 * Note App — Bidirectional Link Parser
 * Parses [[wiki links]] in rendered content and provides inline suggestions.
 */
(function () {
    'use strict';

    // ---------------------------------------------------------------
    // Configuration
    // ---------------------------------------------------------------
    var WIKI_LINK_REGEX = /\[\[([^\]]+)\]\]/g;

    // ---------------------------------------------------------------
    // Parse wiki links in rendered HTML
    // ---------------------------------------------------------------
    function parseWikiLinks(rootEl) {
        if (!rootEl) return;

        var walker = document.createTreeWalker(
            rootEl,
            NodeFilter.SHOW_TEXT,
            {
                acceptNode: function (node) {
                    // Skip inside <a>, <code>, <pre>, <script>, <style>
                    var parent = node.parentElement;
                    var tag = parent ? parent.tagName.toLowerCase() : '';
                    if (['a', 'code', 'pre', 'script', 'style'].indexOf(tag) !== -1) {
                        return NodeFilter.FILTER_REJECT;
                    }
                    if (WIKI_LINK_REGEX.test(node.textContent)) {
                        return NodeFilter.FILTER_ACCEPT;
                    }
                    return NodeFilter.FILTER_REJECT;
                }
            }
        );

        var textNodes = [];
        while (walker.nextNode()) {
            textNodes.push(walker.currentNode);
        }

        textNodes.forEach(function (textNode) {
            replaceWikiLinksInNode(textNode);
        });
    }

    function replaceWikiLinksInNode(textNode) {
        var text = textNode.textContent;
        var fragment = document.createDocumentFragment();
        var lastIndex = 0;
        var match;

        WIKI_LINK_REGEX.lastIndex = 0;

        while ((match = WIKI_LINK_REGEX.exec(text)) !== null) {
            // Text before the match
            if (match.index > lastIndex) {
                fragment.appendChild(
                    document.createTextNode(text.slice(lastIndex, match.index))
                );
            }

            // Create wiki-link element
            var linkText = match[1].trim();
            var a = document.createElement('a');
            a.className = 'wiki-link';
            a.textContent = linkText;
            a.href = '#';
            a.dataset.noteTitle = linkText;
            a.addEventListener('click', function (e) {
                e.preventDefault();
                navigateToNote(this.dataset.noteTitle);
            });

            fragment.appendChild(a);
            lastIndex = match.index + match[0].length;
        }

        // Remaining text
        if (lastIndex < text.length) {
            fragment.appendChild(
                document.createTextNode(text.slice(lastIndex))
            );
        }

        if (lastIndex > 0) {
            textNode.parentNode.replaceChild(fragment, textNode);
        }
    }

    // ---------------------------------------------------------------
    // Navigate to a note by title (resolve via API)
    // ---------------------------------------------------------------
    function navigateToNote(title) {
        var cp = window.contextPath || '';
        fetch(cp + '/api/note/search?keyword=' + encodeURIComponent(title))
            .then(function (resp) {
                if (!resp.ok) throw new Error('HTTP ' + resp.status);
                return resp.json();
            })
            .then(function (results) {
                if (results && results.length > 0) {
                    window.location.href = cp + '/note/edit?id=' + results[0].id;
                } else {
                    // No match found; optionally create a new note
                    if (confirm('Note "' + title + '" not found. Create it?')) {
                        window.location.href = cp + '/note/new';
                    }
                }
            })
            .catch(function (err) {
                console.error('Failed to resolve wiki link:', err);
            });
    }

    // ---------------------------------------------------------------
    // Inline suggestion dropdown (for editor input)
    // ---------------------------------------------------------------
    var suggestionDropdown = null;
    var activeSuggestionTarget = null;

    function createSuggestionDropdown() {
        if (suggestionDropdown) return;
        suggestionDropdown = document.createElement('div');
        suggestionDropdown.className = 'wiki-suggestion-dropdown';
        suggestionDropdown.style.cssText =
            'position:absolute;z-index:1100;background:#fff;border:1px solid #e2e8f0;' +
            'border-radius:8px;box-shadow:0 4px 12px rgba(0,0,0,0.1);max-height:240px;' +
            'overflow-y:auto;display:none;min-width:200px;';
        document.body.appendChild(suggestionDropdown);
    }

    function showSuggestions(items, rect) {
        if (!suggestionDropdown) createSuggestionDropdown();

        suggestionDropdown.innerHTML = '';

        if (!items || items.length === 0) {
            suggestionDropdown.style.display = 'none';
            return;
        }

        items.forEach(function (item) {
            var option = document.createElement('div');
            option.className = 'wiki-suggestion-item';
            option.textContent = item.title;
            option.dataset.noteId = item.id;
            option.style.cssText =
                'padding:8px 14px;cursor:pointer;font-size:0.875rem;color:#1e293b;transition:background 0.15s;';
            option.addEventListener('mouseenter', function () {
                this.style.background = '#eef2ff';
            });
            option.addEventListener('mouseleave', function () {
                this.style.background = 'transparent';
            });
            option.addEventListener('mousedown', function (e) {
                e.preventDefault();
                insertWikiLink(item.title);
            });
            suggestionDropdown.appendChild(option);
        });

        suggestionDropdown.style.top = (rect.bottom + window.scrollY + 4) + 'px';
        suggestionDropdown.style.left = rect.left + 'px';
        suggestionDropdown.style.display = 'block';
    }

    function hideSuggestions() {
        if (suggestionDropdown) {
            suggestionDropdown.style.display = 'none';
        }
        activeSuggestionTarget = null;
    }

    function insertWikiLink(title) {
        // Replace the current [[... with [[title]]
        if (activeSuggestionTarget && activeSuggestionTarget.editor) {
            // For Editor.js: re-render after link insertion
            // The caller should handle actual text insertion
        }
        // Fallback: dispatch a custom event
        document.dispatchEvent(new CustomEvent('wikilink-inserted', {
            detail: { title: title, fullLink: '[[' + title + ']]' }
        }));
        hideSuggestions();
    }

    function fetchSuggestions(query) {
        if (!query || query.length < 1) {
            hideSuggestions();
            return;
        }

        var cp = window.contextPath || '';
        fetch(cp + '/api/note/search?keyword=' + encodeURIComponent(query))
            .then(function (resp) {
                if (!resp.ok) throw new Error('HTTP ' + resp.status);
                return resp.json();
            })
            .then(function (results) {
                // Get caret position for dropdown placement
                var sel = window.getSelection();
                if (sel.rangeCount > 0) {
                    var range = sel.getRangeAt(0);
                    var rect = range.getBoundingClientRect();
                    showSuggestions(results, rect);
                }
            })
            .catch(function () {
                hideSuggestions();
            });
    }

    // ---------------------------------------------------------------
    // Monitor typing for [[ triggers
    // ---------------------------------------------------------------
    var inputBuffer = '';
    var suggestionDebounce = null;

    function handleEditorInput(e) {
        var target = e.target;
        var text = target.textContent || target.innerText || '';

        // Look for an opening [[ that hasn't been closed
        var openIdx = text.lastIndexOf('[[');
        if (openIdx !== -1) {
            var afterOpen = text.slice(openIdx + 2);
            var closeIdx = afterOpen.indexOf(']]');

            if (closeIdx === -1) {
                // Still typing the link
                activeSuggestionTarget = target;
                var query = afterOpen;

                clearTimeout(suggestionDebounce);
                suggestionDebounce = setTimeout(function () {
                    fetchSuggestions(query);
                }, 200);
                return;
            }
        }

        hideSuggestions();
    }

    // ---------------------------------------------------------------
    // Auto-parse wiki links on page load (for read-only views)
    // ---------------------------------------------------------------
    function autoParse() {
        // Parse in note content areas
        var contentAreas = document.querySelectorAll('.note-content, .note-body, .editor-body, .ce-block');
        contentAreas.forEach(function (el) {
            parseWikiLinks(el);
        });

        // Also observe for dynamically rendered content
        var observer = new MutationObserver(function (mutations) {
            mutations.forEach(function (m) {
                m.addedNodes.forEach(function (node) {
                    if (node.nodeType === 1) {
                        parseWikiLinks(node);
                    }
                });
            });
        });

        observer.observe(document.body, {
            childList: true,
            subtree: true
        });
    }

    // ---------------------------------------------------------------
    // Boot
    // ---------------------------------------------------------------
    function init() {
        autoParse();
        createSuggestionDropdown();

        // Listen for input on contenteditable / editor areas
        document.addEventListener('input', function (e) {
            var tag = e.target.tagName.toLowerCase();
            var isEditable = e.target.isContentEditable ||
                             tag === 'textarea' ||
                             e.target.closest('.codex-editor');
            if (isEditable) {
                handleEditorInput(e);
            }
        });

        // Hide dropdown on click outside
        document.addEventListener('mousedown', function (e) {
            if (suggestionDropdown && !suggestionDropdown.contains(e.target)) {
                hideSuggestions();
            }
        });

        // Hide on Escape
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') {
                hideSuggestions();
            }
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    // Expose API
    window.LinkParser = {
        parse: parseWikiLinks,
        navigate: navigateToNote
    };
})();

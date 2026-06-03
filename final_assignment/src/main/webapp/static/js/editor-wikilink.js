/**
 * 文档间引用：[[笔记标题]] 双向链接（Editor.js 集成）
 */
(function (global) {
    'use strict';

    var WIKI_REGEX = /\[\[([^\]]+)\]\]/g;
    var holderEl = null;
    var suggestionEl = null;
    var pickerEl = null;
    var suggestDebounce = null;
    var decorateTimer = null;

    function cp() {
        return global.contextPath || '';
    }

    function escapeHtml(t) {
        var d = document.createElement('div');
        d.textContent = t;
        return d.innerHTML;
    }

    /** 解析 [[标题#id]]、[[标题|id]]、[[#id]]、[[标题]] */
    function parseWikiInner(inner) {
        var raw = (inner || '').trim();
        var withId = raw.match(/^(.+?)[#|](\d+)$/);
        if (withId) {
            return { title: withId[1].trim(), id: withId[2] };
        }
        if (/^#\d+$/.test(raw)) {
            return { title: '', id: raw.slice(1) };
        }
        return { title: raw, id: null };
    }

    function bracketLink(title, noteId) {
        var t = (title || '').trim() || '无标题笔记';
        if (noteId) {
            return '[[' + t + '#' + noteId + ']]';
        }
        return '[[' + t + ']]';
    }

    function htmlToBracket(html) {
        if (!html) return '';
        var div = document.createElement('div');
        div.innerHTML = html;
        div.querySelectorAll('a.wiki-link').forEach(function (a) {
            var title = a.dataset.noteTitle || a.textContent || '';
            var id = a.dataset.noteId || null;
            a.replaceWith(document.createTextNode(bracketLink(title.trim(), id)));
        });
        return div.innerHTML;
    }

    function attrEscape(s) {
        return String(s).replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/</g, '&lt;');
    }

    function wikiAnchorHtml(ref) {
        var label = ref.title || (ref.id ? '笔记' : '');
        var html = '<a class="wiki-link" href="#" contenteditable="false" tabindex="-1" ' +
            'data-note-title="' + attrEscape(label) + '"';
        if (ref.id) {
            html += ' data-note-id="' + attrEscape(ref.id) + '"';
        }
        html += '>' + escapeHtml(label) + '</a>';
        return html;
    }

    function bracketToHtml(text) {
        if (!text) return text;
        return text.replace(WIKI_REGEX, function (_, inner) {
            return wikiAnchorHtml(parseWikiInner(inner));
        });
    }

    function normalizeOutput(output) {
        if (!output || !output.blocks) return output;
        output.blocks.forEach(function (block) {
            var d = block.data;
            if (!d) return;
            if (d.text) d.text = htmlToBracket(d.text);
            if (d.caption) d.caption = htmlToBracket(d.caption);
            if (block.type === 'list' && d.items) {
                normalizeListItems(d.items);
            }
        });
        return output;
    }

    function normalizeListItems(items) {
        items.forEach(function (it) {
            if (typeof it === 'string') return;
            if (it.content) it.content = htmlToBracket(it.content);
            if (it.items && it.items.length) normalizeListItems(it.items);
        });
    }

    function getBlockEditables(blockEl) {
        if (!blockEl) return [];
        return Array.from(blockEl.querySelectorAll(
            '.ce-paragraph[contenteditable="true"], .ce-header[contenteditable="true"], ' +
            '.cdx-quote__text[contenteditable="true"], .cdx-list__item-content[contenteditable="true"]'
        ));
    }

    function decorateEditable(el) {
        if (!el || el.dataset.wikiDecorating === '1') return;
        var html = el.innerHTML;
        if (!html || html.indexOf('[[') === -1) return;
        if (html.indexOf('wiki-link') !== -1 && html.indexOf('[[') === -1) return;

        el.dataset.wikiDecorating = '1';
        var sel = window.getSelection();
        var hadFocus = document.activeElement === el;
        var saved = null;
        if (hadFocus && sel && sel.rangeCount) {
            saved = { start: sel.getRangeAt(0).cloneRange() };
        }

        el.innerHTML = bracketToHtml(html);

        if (saved && hadFocus) {
            try {
                sel.removeAllRanges();
                sel.addRange(saved.start);
            } catch (e) { /* ignore */ }
        }
        delete el.dataset.wikiDecorating;
    }

    function decorateAll() {
        if (!holderEl) return;
        holderEl.querySelectorAll('.ce-block').forEach(function (block) {
            getBlockEditables(block).forEach(decorateEditable);
        });
    }

    /** 计算点击处在 contenteditable 纯文本中的偏移 */
    function offsetAtPoint(editable, clientX, clientY) {
        var node = null;
        var offset = 0;
        if (document.caretRangeFromPoint) {
            var range = document.caretRangeFromPoint(clientX, clientY);
            if (range) {
                node = range.startContainer;
                offset = range.startOffset;
            }
        } else if (document.caretPositionFromPoint) {
            var pos = document.caretPositionFromPoint(clientX, clientY);
            if (pos) {
                node = pos.offsetNode;
                offset = pos.offset;
            }
        }
        if (!node || !editable.contains(node)) {
            return -1;
        }
        var walker = document.createTreeWalker(editable, NodeFilter.SHOW_TEXT);
        var total = 0;
        var current;
        while ((current = walker.nextNode())) {
            if (current === node) {
                return total + offset;
            }
            total += (current.textContent || '').length;
        }
        return -1;
    }

    /** 点击 [[...]] 纯文本时跳转（未渲染成 <a> 时也能用） */
    function tryNavigatePlainWiki(e, editable) {
        var text = editable.textContent || '';
        if (text.indexOf('[[') === -1) return false;

        var pos = offsetAtPoint(editable, e.clientX, e.clientY);
        if (pos < 0) return false;

        var re = /\[\[([^\]]+)\]\]/g;
        var match;
        while ((match = re.exec(text)) !== null) {
            var start = match.index;
            var end = start + match[0].length;
            if (pos >= start && pos <= end) {
                e.preventDefault();
                e.stopPropagation();
                var ref = parseWikiInner(match[1]);
                navigateToNote(ref.title, ref.id);
                return true;
            }
        }
        return false;
    }

    function handleWikiPointer(e) {
        if (!holderEl || !holderEl.contains(e.target)) return;

        var link = e.target.closest('a.wiki-link');
        if (link && holderEl.contains(link)) {
            e.preventDefault();
            e.stopPropagation();
            navigateToNote(
                link.dataset.noteTitle || link.textContent,
                link.dataset.noteId
            );
            return;
        }

        var editable = e.target.closest('[contenteditable="true"]');
        if (editable && holderEl.contains(editable)) {
            tryNavigatePlainWiki(e, editable);
        }
    }

    function onEditorChange() {
        clearTimeout(decorateTimer);
        decorateTimer = setTimeout(decorateAll, 300);
    }

    function navigateToNote(title, noteId) {
        if (noteId) {
            global.location.href = cp() + '/note/edit?id=' + noteId;
            return;
        }
        var inner = parseWikiInner(title);
        if (inner.id) {
            global.location.href = cp() + '/note/edit?id=' + inner.id;
            return;
        }
        fetch(cp() + '/api/note/resolve?title=' + encodeURIComponent(inner.title || title))
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (data.found && data.id) {
                    global.location.href = cp() + '/note/edit?id=' + data.id;
                } else if (global.showToast) {
                    global.showToast('未找到笔记「' + title + '」', 'warning');
                }
            })
            .catch(function () {
                if (global.showToast) global.showToast('无法打开链接', 'error');
            });
    }

    function insertTextAtSelection(text) {
        var sel = window.getSelection();
        if (!sel || !sel.rangeCount) return false;
        var range = sel.getRangeAt(0);
        range.deleteContents();
        range.insertNode(document.createTextNode(text));
        range.collapse(false);
        sel.removeAllRanges();
        sel.addRange(range);
        return true;
    }

    function replacePartialWikiLink(title, noteId) {
        var sel = window.getSelection();
        if (!sel || !sel.rangeCount) return;
        var node = sel.anchorNode;
        var el = node && node.nodeType === 1 ? node : node && node.parentElement;
        var editable = el && el.closest('[contenteditable="true"]');
        if (!editable) return;

        var full = editable.textContent || '';
        var openIdx = full.lastIndexOf('[[');
        var link = bracketLink(title, noteId);
        if (openIdx === -1) {
            insertTextAtSelection(link);
        } else {
            var before = full.slice(0, openIdx);
            var after = '';
            var closeIdx = full.indexOf(']]', openIdx);
            if (closeIdx !== -1) after = full.slice(closeIdx + 2);
            editable.textContent = before + link + after;
            decorateEditable(editable);
        }
        hideSuggestions();
        if (global.NoteEditor && global.NoteEditor.save) {
            global.NoteEditor.save();
        }
    }

    function ensureSuggestionDropdown() {
        if (suggestionEl) return suggestionEl;
        suggestionEl = document.createElement('div');
        suggestionEl.className = 'wiki-suggestion-dropdown';
        suggestionEl.id = 'wikiSuggestionDropdown';
        document.body.appendChild(suggestionEl);
        return suggestionEl;
    }

    function showSuggestions(notes, rect) {
        var menu = ensureSuggestionDropdown();
        menu.innerHTML = '';
        if (!notes || !notes.length) {
            menu.style.display = 'none';
            return;
        }
        notes.forEach(function (note, i) {
            var item = document.createElement('div');
            item.className = 'wiki-suggestion-item' + (i === 0 ? ' active' : '');
            item.innerHTML = '<i class="bi bi-file-earmark-text"></i><span>' + escapeHtml(note.title) + '</span>';
            item.addEventListener('mousedown', function (e) {
                e.preventDefault();
                replacePartialWikiLink(note.title, note.id);
            });
            menu.appendChild(item);
        });
        menu.style.display = 'block';
        menu.style.top = (rect.bottom + window.scrollY + 6) + 'px';
        menu.style.left = Math.min(rect.left, window.innerWidth - 280) + 'px';
    }

    function hideSuggestions() {
        if (suggestionEl) suggestionEl.style.display = 'none';
    }

    function handleInput(e) {
        var editable = e.target.closest && e.target.closest('[contenteditable="true"]');
        if (!editable || !holderEl || !holderEl.contains(editable)) return;

        var text = editable.textContent || '';
        var openIdx = text.lastIndexOf('[[');
        if (openIdx === -1) {
            hideSuggestions();
            return;
        }
        var after = text.slice(openIdx + 2);
        if (after.indexOf(']]') !== -1) {
            hideSuggestions();
            decorateEditable(editable);
            return;
        }

        clearTimeout(suggestDebounce);
        suggestDebounce = setTimeout(function () {
            fetch(cp() + '/api/note/search?keyword=' + encodeURIComponent(after.trim()))
                .then(function (r) { return r.json(); })
                .then(function (notes) {
                    var currentId = global.NoteEditor && global.NoteEditor.getNoteId();
                    notes = (notes || []).filter(function (n) {
                        return String(n.id) !== String(currentId);
                    });
                    var sel = window.getSelection();
                    if (sel && sel.rangeCount) {
                        showSuggestions(notes, sel.getRangeAt(0).getBoundingClientRect());
                    }
                })
                .catch(hideSuggestions);
        }, 200);
    }

    function ensurePicker() {
        if (pickerEl) return pickerEl;
        pickerEl = document.createElement('div');
        pickerEl.className = 'wiki-picker-overlay';
        pickerEl.id = 'wikiNotePicker';
        pickerEl.innerHTML =
            '<div class="wiki-picker-dialog">' +
            '<div class="wiki-picker-header">' +
            '<span>引用笔记</span>' +
            '<button type="button" class="wiki-picker-close" aria-label="关闭"><i class="bi bi-x-lg"></i></button>' +
            '</div>' +
            '<input type="search" class="wiki-picker-search" placeholder="搜索笔记标题…" autocomplete="off">' +
            '<div class="wiki-picker-list"></div>' +
            '</div>';
        document.body.appendChild(pickerEl);

        pickerEl.querySelector('.wiki-picker-close').addEventListener('click', closePicker);
        pickerEl.addEventListener('click', function (e) {
            if (e.target === pickerEl) closePicker();
        });
        pickerEl.querySelector('.wiki-picker-search').addEventListener('input', function () {
            loadPickerNotes(this.value.trim());
        });
        return pickerEl;
    }

    function loadPickerNotes(keyword) {
        var list = pickerEl.querySelector('.wiki-picker-list');
        fetch(cp() + '/api/note/search?keyword=' + encodeURIComponent(keyword || ''))
            .then(function (r) { return r.json(); })
            .then(function (notes) {
                var currentId = global.NoteEditor && global.NoteEditor.getNoteId();
                notes = (notes || []).filter(function (n) {
                    return String(n.id) !== String(currentId);
                });
                if (!notes.length) {
                    list.innerHTML = '<div class="wiki-picker-empty">暂无其他笔记</div>';
                    return;
                }
                var html = '';
                notes.forEach(function (n) {
                    html += '<button type="button" class="wiki-picker-item" data-title="' +
                        escapeHtml(n.title) + '" data-id="' + n.id + '">' +
                        '<i class="bi bi-file-earmark-text"></i>' +
                        '<span>' + escapeHtml(n.title) + '</span></button>';
                });
                list.innerHTML = html;
                list.querySelectorAll('.wiki-picker-item').forEach(function (btn) {
                    btn.addEventListener('click', function () {
                        insertWikiLinkBlock(btn.dataset.title, btn.dataset.id);
                        closePicker();
                    });
                });
            })
            .catch(function () {
                list.innerHTML = '<div class="wiki-picker-empty">加载失败</div>';
            });
    }

    function openPicker() {
        ensurePicker();
        pickerEl.classList.add('open');
        var input = pickerEl.querySelector('.wiki-picker-search');
        input.value = '';
        loadPickerNotes('');
        setTimeout(function () { input.focus(); }, 50);
    }

    function closePicker() {
        if (pickerEl) pickerEl.classList.remove('open');
    }

    function insertWikiLinkBlock(title, noteId) {
        var ed = global.NoteEditor && global.NoteEditor.getEditor();
        if (!ed || !ed.blocks) return;

        var linkText = bracketLink(title, noteId);
        var api = ed.blocks;
        var idx = api.getCurrentBlockIndex();
        if (idx < 0) idx = api.getBlocksCount() - 1;
        api.insert('paragraph', { text: linkText }, {}, idx + 1, true);
        onEditorChange();
        if (global.NoteEditor.save) global.NoteEditor.save();
        if (global.showToast) global.showToast('已插入引用', 'success');
    }

    function refreshPanels(noteId) {
        if (!noteId) return;
        loadForwardLinks(noteId);
        loadBacklinks(noteId);
    }

    function renderLinkList(containerId, items, opts) {
        var container = document.getElementById(containerId);
        if (!container) return;
        if (!items || !items.length) {
            container.innerHTML = '<div class="outline-empty"><span>' + (opts.emptyText || '暂无') + '</span></div>';
            return;
        }
        var html = '';
        items.forEach(function (item) {
            var id = opts.idField ? item[opts.idField] : item.targetId;
            var title = opts.titleField ? item[opts.titleField] : item.targetTitle;
            html += '<a href="' + cp() + '/note/edit?id=' + id + '" class="note-link-item">' +
                '<i class="bi bi-file-earmark-text"></i><span>' + escapeHtml(title || '无标题') + '</span></a>';
        });
        container.innerHTML = html;
    }

    function loadForwardLinks(noteId) {
        fetch(cp() + '/api/note/forward-links?id=' + noteId)
            .then(function (r) { return r.json(); })
            .then(function (links) {
                renderLinkList('forwardLinksList', links, {
                    idField: 'targetId',
                    titleField: 'targetTitle',
                    emptyText: '输入 [[标题]] 或 / → 引用笔记（保存后生成 [[标题#id]]）'
                });
                var badge = document.getElementById('forwardLinkCount');
                var tabBadge = document.getElementById('forwardLinkCountTab');
                var n = links ? links.length : 0;
                if (badge) {
                    badge.textContent = n;
                    badge.style.display = n > 0 ? '' : 'none';
                }
                if (tabBadge) {
                    tabBadge.textContent = n;
                    tabBadge.style.display = n > 0 ? '' : 'none';
                }
            })
            .catch(function () { /* ignore */ });
    }

    function loadBacklinks(noteId) {
        fetch(cp() + '/api/note/backlinks?id=' + noteId)
            .then(function (r) { return r.json(); })
            .then(function (links) {
                renderLinkList('backlinksList', links.map(function (bl) {
                    return { targetId: bl.sourceId, targetTitle: bl.sourceTitle };
                }), {
                    idField: 'targetId',
                    titleField: 'targetTitle',
                    emptyText: '暂无其他文档引用本篇'
                });
                var badge = document.getElementById('backlinkCount');
                var tabBadge = document.getElementById('backlinkCountTab');
                var total = (links ? links.length : 0);
                if (badge) {
                    badge.textContent = total;
                    badge.style.display = total > 0 ? '' : 'none';
                }
                if (tabBadge) {
                    tabBadge.textContent = total;
                    tabBadge.style.display = total > 0 ? '' : 'none';
                }
            })
            .catch(function () { /* ignore */ });
    }

    function bind(holder) {
        holderEl = holder;

        holder.addEventListener('input', handleInput, true);
        holder.addEventListener('mousedown', handleWikiPointer, true);
        holder.addEventListener('click', function (e) {
            if (e.target.closest('a.wiki-link')) {
                e.preventDefault();
            }
        }, true);

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') {
                hideSuggestions();
                closePicker();
            }
        });
        document.addEventListener('mousedown', function (e) {
            if (suggestionEl && !suggestionEl.contains(e.target)) {
                var inEditor = e.target.closest && e.target.closest('#editorjs');
                if (!inEditor) hideSuggestions();
            }
        });

        setTimeout(decorateAll, 500);
        if (global.NoteEditor && global.NoteEditor.getNoteId()) {
            refreshPanels(global.NoteEditor.getNoteId());
        }
    }

    global.EditorWikiLink = {
        bind: bind,
        openPicker: openPicker,
        insertWikiLink: replacePartialWikiLink,
        normalizeOutput: normalizeOutput,
        onEditorChange: onEditorChange,
        refreshPanels: refreshPanels,
        navigate: navigateToNote
    };

    document.addEventListener('wikilink-inserted', function (e) {
        if (e.detail && e.detail.title) {
            replacePartialWikiLink(e.detail.title);
        }
    });
})(window);

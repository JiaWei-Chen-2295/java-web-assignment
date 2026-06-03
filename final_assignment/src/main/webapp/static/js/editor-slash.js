/**
 * Editor.js 块级斜杠菜单
 */
(function (global) {
    'use strict';

    var COMMANDS = [
        { label: '标题 1', desc: '大标题', type: 'header', config: { level: 1, text: '' } },
        { label: '标题 2', desc: '中标题', type: 'header', config: { level: 2, text: '' } },
        { label: '标题 3', desc: '小标题', type: 'header', config: { level: 3, text: '' } },
        { label: '正文', desc: '普通段落', type: 'paragraph', config: { text: '' } },
        { label: '无序列表', desc: '项目符号', type: 'list', config: { style: 'unordered', items: [{ content: '', meta: {}, items: [] }] } },
        { label: '有序列表', desc: '编号列表', type: 'list', config: { style: 'ordered', meta: { start: 1, counterType: 'numeric' }, items: [{ content: '', meta: {}, items: [] }] } },
        { label: '待办', desc: '任务清单', type: 'list', config: { style: 'checklist', items: [{ content: '', meta: { checked: false }, items: [] }] } },
        { label: '引用', desc: '引用块', type: 'quote', config: { text: '', caption: '' } },
        { label: '代码', desc: '代码块', type: 'code', config: { code: '', language: '' } },
        { label: '分割线', desc: '分隔内容', type: 'delimiter', config: {} },
        { label: '引用笔记', desc: '链接到另一篇文档', type: 'wikilink', config: {} }
    ];

    var menuEl = null;
    var activeIndex = 0;
    var holderEl = null;
    var slashBlockIndex = -1;

    function ensureMenu() {
        if (menuEl) return menuEl;
        menuEl = document.createElement('div');
        menuEl.className = 'slash-menu block-slash-menu';
        menuEl.id = 'blockSlashMenu';
        document.body.appendChild(menuEl);
        return menuEl;
    }

    function hideMenu() {
        if (menuEl) menuEl.style.display = 'none';
        slashBlockIndex = -1;
    }

    function isOpen() {
        return menuEl && menuEl.style.display === 'block';
    }

    function getFocusedBlockIndex() {
        var idx = holderEl.querySelector('.ce-block--focused');
        if (!idx) {
            var sel = window.getSelection();
            if (!sel || !sel.anchorNode) return -1;
            var block = sel.anchorNode.nodeType === 1
                ? sel.anchorNode.closest('.ce-block')
                : sel.anchorNode.parentElement && sel.anchorNode.parentElement.closest('.ce-block');
            if (!block) return -1;
            idx = block;
        }
        var blocks = holderEl.querySelectorAll('.ce-block');
        for (var i = 0; i < blocks.length; i++) {
            if (blocks[i] === idx || blocks[i].contains(idx)) return i;
        }
        return -1;
    }

    function blockTextAt(index) {
        var block = holderEl.querySelectorAll('.ce-block')[index];
        if (!block) return '';
        return (block.textContent || '').trim();
    }

    function showMenu(filter) {
        var menu = ensureMenu();
        var list = COMMANDS;
        if (filter) {
            var q = filter.toLowerCase();
            list = COMMANDS.filter(function (c) {
                return c.label.toLowerCase().indexOf(q) >= 0 || c.desc.toLowerCase().indexOf(q) >= 0;
            });
        }
        if (list.length === 0) {
            hideMenu();
            return;
        }
        activeIndex = 0;
        var html = '<div class="slash-menu-category">插入块</div>';
        for (var i = 0; i < list.length; i++) {
            html += '<div class="slash-menu-item' + (i === 0 ? ' active' : '') + '" data-idx="' + i + '">' +
                '<div class="slash-menu-icon"><i class="bi bi-plus-square"></i></div>' +
                '<div class="slash-menu-text"><span class="slash-menu-label">' + list[i].label + '</span>' +
                '<span class="slash-menu-desc">' + list[i].desc + '</span></div></div>';
        }
        menu.innerHTML = html;
        menu._commands = list;
        menu.style.display = 'block';

        var sel = window.getSelection();
        if (sel && sel.rangeCount) {
            var rect = sel.getRangeAt(0).getBoundingClientRect();
            if (global.EditorPosition) {
                global.EditorPosition.place(menu, rect, { width: 300, maxHeight: 320, gap: 6 });
            } else {
                menu.style.top = (rect.bottom + 6) + 'px';
                menu.style.left = Math.min(rect.left, global.innerWidth - 300) + 'px';
            }
        }

        menu.querySelectorAll('.slash-menu-item').forEach(function (el, i) {
            el.addEventListener('mousedown', function (e) {
                e.preventDefault();
                applyCommand(menu._commands[i]);
            });
        });
    }

    function applyCommand(cmd) {
        hideMenu();
        if (cmd.type === 'wikilink') {
            if (window.EditorWikiLink && window.EditorWikiLink.openPicker) {
                window.EditorWikiLink.openPicker();
            }
            return;
        }
        var ed = window.NoteEditor && window.NoteEditor.getEditor();
        if (!ed || slashBlockIndex < 0) return;

        ed.save().then(function (data) {
            var blocks = data.blocks || [];
            if (slashBlockIndex >= blocks.length) return;

            var current = blocks[slashBlockIndex];
            var text = '';
            if (current && current.data && current.data.text) {
                text = String(current.data.text).replace(/^\//, '').trim();
            } else if (current && current.data && current.data.code !== undefined) {
                text = '';
            } else {
                text = blockTextAt(slashBlockIndex).replace(/^\//, '').trim();
            }

            var newBlock = { type: cmd.type, data: JSON.parse(JSON.stringify(cmd.config)) };
            if (newBlock.data.text !== undefined && text) {
                newBlock.data.text = text;
            }
            if (newBlock.type === 'list' && newBlock.data.items) {
                var li = window.MarkdownToEditorJs && window.MarkdownToEditorJs.listItem
                    ? window.MarkdownToEditorJs.listItem(text || '', newBlock.data.style === 'checklist' ? { checked: false } : {})
                    : { content: text || '', meta: {}, items: [] };
                newBlock.data.items = [li];
            }
            if (newBlock.type === 'header' && text) {
                newBlock.data.text = text;
            }
            if (newBlock.type === 'code' && text) {
                newBlock.data.code = text;
            }

            blocks[slashBlockIndex] = newBlock;
            return ed.render({ time: Date.now(), blocks: blocks, version: data.version || '2.28.0' });
        }).then(function () {
            if (window.NoteEditor && window.NoteEditor.save) {
                window.NoteEditor.save();
            }
        });
    }

    function onKeyDown(e) {
        if (!menuEl || menuEl.style.display !== 'block') return;

        var items = menuEl.querySelectorAll('.slash-menu-item');
        if (e.key === 'ArrowDown') {
            e.preventDefault();
            activeIndex = (activeIndex + 1) % items.length;
            items.forEach(function (el, i) { el.classList.toggle('active', i === activeIndex); });
        } else if (e.key === 'ArrowUp') {
            e.preventDefault();
            activeIndex = (activeIndex - 1 + items.length) % items.length;
            items.forEach(function (el, i) { el.classList.toggle('active', i === activeIndex); });
        } else if (e.key === 'Enter') {
            e.preventDefault();
            if (menuEl._commands && menuEl._commands[activeIndex]) {
                applyCommand(menuEl._commands[activeIndex]);
            }
        } else if (e.key === 'Escape') {
            hideMenu();
        }
    }

    function onInputCheck() {
        if (!holderEl) return;
        var idx = getFocusedBlockIndex();
        if (idx < 0) {
            hideMenu();
            return;
        }
        var text = blockTextAt(idx);
        if (text === '/' || (text.indexOf('/') === 0 && text.length < 20)) {
            slashBlockIndex = idx;
            var filter = text.length > 1 ? text.substring(1) : '';
            showMenu(filter);
        } else {
            hideMenu();
        }
    }

    function bind(holder) {
        holderEl = holder;
        /* 用 input 事件替代 keyup，让斜杠菜单响应更即时 */
        holder.addEventListener('input', onInputCheck);
        holder.addEventListener('click', function () {
            setTimeout(onInputCheck, 0);
        });
        document.addEventListener('keydown', onKeyDown);
        document.addEventListener('click', function (e) {
            if (menuEl && !menuEl.contains(e.target)) hideMenu();
        });
    }

    global.EditorSlash = {
        bind: bind,
        onChange: onInputCheck,
        hide: hideMenu,
        isOpen: isOpen
    };
})(window);

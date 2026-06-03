/**
 * Editor.js 键盘与光标增强：List v2 列表退出、空块删除、有序/无序切换
 */
(function (global) {
    'use strict';

    var holderEl = null;

    function getApi() {
        var ed = global.NoteEditor && global.NoteEditor.getEditor();
        return ed && ed.blocks ? ed : null;
    }

    function getCurrentBlockEl() {
        var focused = holderEl && holderEl.querySelector('.ce-block--focused');
        if (focused) return focused;
        var sel = window.getSelection();
        if (!sel || !sel.rangeCount) return null;
        var node = sel.anchorNode;
        if (node && node.nodeType !== 1) node = node.parentElement;
        return node ? node.closest('.ce-block') : null;
    }

    function blockType(blockEl) {
        if (!blockEl) return '';
        if (blockEl.querySelector('.cdx-list')) return 'list';
        if (blockEl.querySelector('.cdx-checklist')) return 'checklist';
        if (blockEl.querySelector('.ce-header')) return 'header';
        if (blockEl.querySelector('.ce-code')) return 'code';
        if (blockEl.querySelector('.cdx-quote')) return 'quote';
        return 'paragraph';
    }

    function isEmptyBlock(blockEl) {
        if (!blockEl) return true;
        var text = (blockEl.textContent || '').replace(/\u00a0/g, ' ').trim();
        if (blockType(blockEl) === 'code') {
            var ta = blockEl.querySelector('textarea');
            return !ta || !ta.value.trim();
        }
        return text.length === 0;
    }

    function isCaretAtBlockStart() {
        var sel = window.getSelection();
        if (!sel || !sel.rangeCount || !sel.isCollapsed) return false;
        var range = sel.getRangeAt(0);
        var block = getCurrentBlockEl();
        if (!block) return false;
        var test = range.cloneRange();
        test.selectNodeContents(block);
        test.setEnd(range.startContainer, range.startOffset);
        return test.toString().length === 0;
    }

    function listItemText(itemEl) {
        if (!itemEl) return '';
        var content = itemEl.querySelector('.cdx-list__item-content');
        if (content) {
            return (content.textContent || '').replace(/\u00a0/g, ' ').trim();
        }
        return (itemEl.textContent || '').replace(/\u00a0/g, ' ').trim();
    }

    function getListContext(blockEl) {
        var list = blockEl.querySelector('.cdx-list');
        if (!list) return null;
        var items = list.querySelectorAll(':scope > .cdx-list__item');
        if (!items.length) {
            items = list.querySelectorAll('.cdx-list__item');
        }
        var activeItem = items[0];
        var sel = window.getSelection();
        if (sel && sel.anchorNode) {
            var li = sel.anchorNode.nodeType === 1
                ? sel.anchorNode.closest('.cdx-list__item')
                : sel.anchorNode.parentElement && sel.anchorNode.parentElement.closest('.cdx-list__item');
            if (li) activeItem = li;
        }
        var isOrdered = list.classList.contains('cdx-list-ordered');
        var isChecklist = list.classList.contains('cdx-list-checklist');
        var itemText = listItemText(activeItem);
        var isLastItem = activeItem && items.length && items[items.length - 1] === activeItem;
        return {
            items: items,
            activeItem: activeItem,
            isOrdered: isOrdered,
            isChecklist: isChecklist,
            itemEmpty: itemText.length === 0,
            isLastItem: isLastItem,
            singleItem: items.length <= 1
        };
    }

    function plainTextFromBlock(blockEl) {
        var type = blockType(blockEl);
        if (type === 'list') {
            var parts = [];
            blockEl.querySelectorAll('.cdx-list > .cdx-list__item').forEach(function (li) {
                var content = li.querySelector('.cdx-list__item-content');
                var t = content ? (content.innerHTML || '').trim() : (li.innerHTML || '').trim();
                if (t) parts.push(t);
            });
            return parts.join('<br>') || '';
        }
        if (type === 'checklist') {
            var cparts = [];
            blockEl.querySelectorAll('.cdx-checklist__item-text').forEach(function (el) {
                var t = (el.innerHTML || '').trim();
                if (t) cparts.push(t);
            });
            return cparts.join('<br>') || '';
        }
        if (type === 'header') {
            var h = blockEl.querySelector('.ce-header, [contenteditable]');
            return h ? h.innerHTML : '';
        }
        var p = blockEl.querySelector('[contenteditable]');
        return p ? p.innerHTML : (blockEl.textContent || '');
    }

    function replaceBlockWithParagraph(index, html) {
        var api = getApi();
        var ed = global.NoteEditor.getEditor();
        if (!api || !ed) return Promise.resolve();

        return ed.save().then(function (data) {
            if (index < 0 || index >= data.blocks.length) return;
            data.blocks[index] = {
                type: 'paragraph',
                data: { text: html || '' }
            };
            return ed.render(data);
        }).then(function () {
            if (api.caret && api.caret.setToBlock) {
                api.caret.setToBlock(index);
            } else {
                focusBlock(index);
            }
            /* 不手动 save()，onChange 已自动触发 scheduleSave */
        });
    }

    function deleteCurrentBlock() {
        var api = getApi();
        if (!api) return;
        var idx = api.getCurrentBlockIndex();
        if (idx < 0) return;
        var total = api.getBlocksCount();
        if (total <= 1) {
            replaceBlockWithParagraph(0, '');
            return;
        }
        api.delete(idx);
        /* 不手动 save()，onChange 已自动触发 scheduleSave */
        if (global.showToast) global.showToast('已删除块', 'success');
    }

    function exitListToParagraph() {
        var blockEl = getCurrentBlockEl();
        var api = getApi();
        if (!blockEl || !api) return;
        var idx = api.getCurrentBlockIndex();
        var html = plainTextFromBlock(blockEl);
        return replaceBlockWithParagraph(idx, html).then(function () {
            if (global.showToast) global.showToast('已转为正文', 'success');
        });
    }
    function toggleListStyle() {
        var api = getApi();
        var ed = global.NoteEditor.getEditor();
        var blockEl = getCurrentBlockEl();
        if (!api || !ed || blockType(blockEl) !== 'list') return;

        var idx = api.getCurrentBlockIndex();
        ed.save().then(function (data) {
            var block = data.blocks[idx];
            if (!block || block.type !== 'list') return;
            if (block.data.style === 'checklist') {
                if (global.showToast) global.showToast('待办列表请在块设置中切换类型', 'info');
                return;
            }
            block.data.style = block.data.style === 'ordered' ? 'unordered' : 'ordered';
            if (block.data.style === 'ordered' && !block.data.meta) {
                block.data.meta = { start: 1, counterType: 'numeric' };
            }
            return ed.render(data);
        }).then(function () {
            focusBlock(idx);
            /* 不手动 save()，onChange 已自动触发 scheduleSave */
            if (global.showToast) {
                global.showToast('已切换列表类型', 'success');
            }
        });
    }

    function focusBlock(index) {
        setTimeout(function () {
            var api = getApi();
            if (api && api.getBlockByIndex) {
                try {
                    var block = api.getBlockByIndex(index);
                    if (block && block.holder) {
                        var editable = block.holder.querySelector('[contenteditable="true"]');
                        if (editable) editable.focus();
                    }
                } catch (e) { /* ignore */ }
            }
            var blocks = holderEl.querySelectorAll('.ce-block');
            if (blocks[index]) {
                var ed = blocks[index].querySelector('[contenteditable="true"]');
                if (ed) ed.focus();
            }
        }, 80);
    }

    function onKeyDown(e) {
        if (!global.NoteEditor || !global.NoteEditor.isReady()) return;
        if (global.EditorSlash && global.EditorSlash.isOpen && global.EditorSlash.isOpen()) return;

        var blockEl = getCurrentBlockEl();
        var type = blockType(blockEl);

        if ((e.ctrlKey || e.metaKey) && e.shiftKey && (e.key === 'Backspace' || e.key === 'D')) {
            e.preventDefault();
            deleteCurrentBlock();
            return;
        }

        if ((e.ctrlKey || e.metaKey) && e.shiftKey && e.key === '0') {
            e.preventDefault();
            exitListToParagraph();
            return;
        }

        if ((e.ctrlKey || e.metaKey) && e.shiftKey && e.key === 'L') {
            if (type === 'list') {
                e.preventDefault();
                toggleListStyle();
            }
            return;
        }

        if (e.key === 'Backspace' && isCaretAtBlockStart()) {
            if (type === 'list') {
                var ctx = getListContext(blockEl);
                if (ctx && ctx.itemEmpty && ctx.singleItem) {
                    e.preventDefault();
                    exitListToParagraph();
                    return;
                }
            }
            if ((type === 'checklist' || type === 'header') && isEmptyBlock(blockEl)) {
                e.preventDefault();
                exitListToParagraph();
                return;
            }
        }

        if (e.key === 'Enter' && !e.shiftKey && type === 'list') {
            var listCtx = getListContext(blockEl);
            if (listCtx && listCtx.itemEmpty && listCtx.isLastItem && listCtx.singleItem) {
                e.preventDefault();
                var api = getApi();
                var idx = api.getCurrentBlockIndex();
                api.insert(undefined, { text: '' }, {}, idx + 1, true);
                focusBlock(idx + 1);
                /* onChange 自动触发 scheduleSave，无需手动 save */
            }
        }
    }

    function bind(holder) {
        holderEl = holder;
        holder.addEventListener('keydown', onKeyDown, true);
    }

    global.EditorKeyboard = {
        bind: bind,
        deleteCurrentBlock: deleteCurrentBlock,
        exitListToParagraph: exitListToParagraph,
        toggleListStyle: toggleListStyle,
        replaceBlockWithParagraph: replaceBlockWithParagraph
    };
})(window);

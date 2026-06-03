/**
 * 块左侧操作栏：删除、转正文、列表类型切换（List v2）
 */
(function (global) {
    'use strict';

    var holderEl = null;
    var railClass = 'block-action-rail';

    function getApi() {
        var ed = global.NoteEditor && global.NoteEditor.getEditor();
        return ed && ed.blocks ? ed : null;
    }

    function blockType(blockEl) {
        if (!blockEl) return '';
        if (blockEl.querySelector('.cdx-list')) return 'list';
        if (blockEl.querySelector('.cdx-checklist')) return 'checklist';
        return 'other';
    }

    function listStyleClass(blockEl) {
        var list = blockEl.querySelector('.cdx-list');
        if (!list) return '';
        if (list.classList.contains('cdx-list-ordered')) return 'ordered';
        if (list.classList.contains('cdx-list-checklist')) return 'checklist';
        return 'unordered';
    }

    function ensureRail(blockEl) {
        var rail = blockEl.querySelector('.' + railClass);
        if (rail) return rail;

        rail = document.createElement('div');
        rail.className = railClass;
        rail.innerHTML =
            '<button type="button" class="bar-btn" data-action="grip" title="拖拽块（使用右侧 ⋮⋮）" tabindex="-1">' +
            '<i class="bi bi-grip-vertical"></i></button>' +
            '<button type="button" class="bar-btn" data-action="paragraph" title="转为正文 (Ctrl+Shift+0)">' +
            '<i class="bi bi-text-paragraph"></i></button>' +
            '<button type="button" class="bar-btn" data-action="list-toggle" title="切换有序/无序 (Ctrl+Shift+L)" style="display:none">' +
            '<i class="bi bi-list-ol"></i></button>' +
            '<button type="button" class="bar-btn bar-btn-danger" data-action="delete" title="删除块 (Ctrl+Shift+Backspace)">' +
            '<i class="bi bi-trash"></i></button>';

        rail.addEventListener('mousedown', function (e) {
            e.preventDefault();
            e.stopPropagation();
        });

        rail.addEventListener('click', function (e) {
            var btn = e.target.closest('[data-action]');
            if (!btn) return;
            e.preventDefault();
            e.stopPropagation();

            var api = getApi();
            if (!api) return;
            var blocks = holderEl.querySelectorAll('.ce-block');
            var idx = -1;
            for (var i = 0; i < blocks.length; i++) {
                if (blocks[i] === blockEl) { idx = i; break; }
            }
            if (idx < 0) idx = api.getCurrentBlockIndex();

            var action = btn.dataset.action;
            if (action === 'delete' && global.EditorKeyboard) {
                if (api.moveToBlock) api.moveToBlock(idx);
                global.EditorKeyboard.deleteCurrentBlock();
            } else if (action === 'paragraph' && global.EditorKeyboard) {
                api.moveToBlock(idx);
                global.EditorKeyboard.exitListToParagraph();
            } else if (action === 'list-toggle' && global.EditorKeyboard) {
                api.moveToBlock(idx);
                global.EditorKeyboard.toggleListStyle();
            }
        });

        blockEl.appendChild(rail);
        updateRail(blockEl);
        return rail;
    }

    function updateRail(blockEl) {
        var rail = blockEl.querySelector('.' + railClass);
        if (!rail) return;
        var toggleBtn = rail.querySelector('[data-action="list-toggle"]');
        var type = blockType(blockEl);
        var style = listStyleClass(blockEl);
        if (toggleBtn) {
            var showToggle = type === 'list' && style !== 'checklist';
            toggleBtn.style.display = showToggle ? '' : 'none';
            if (showToggle) {
                toggleBtn.title = style === 'ordered' ? '改为无序列表' : '改为有序列表';
                toggleBtn.querySelector('i').className = style === 'ordered' ? 'bi bi-list-ul' : 'bi bi-list-ol';
            }
        }
    }

    function refreshAllRails() {
        if (!holderEl) return;
        holderEl.querySelectorAll('.ce-block').forEach(function (block) {
            ensureRail(block);
            updateRail(block);
        });
    }

    function observeBlocks() {
        if (!holderEl) return;
        /* 只监听块增删（childList），不监听 subtree，避免输入时的文本变化触发全量刷新 */
        var observer = new MutationObserver(function (mutations) {
            var hasBlockChange = false;
            mutations.forEach(function (m) {
                if (m.type === 'childList') {
                    hasBlockChange = true;
                }
            });
            if (hasBlockChange) {
                refreshAllRails();
            }
        });
        observer.observe(holderEl, { childList: true, subtree: false });
        refreshAllRails();
    }

    function bind(holder) {
        holderEl = holder;
        observeBlocks();
        holder.addEventListener('mouseover', function (e) {
            var block = e.target.closest('.ce-block');
            if (!block || !holderEl.contains(block)) return;
            holderEl.querySelectorAll('.ce-block.is-hovered').forEach(function (b) {
                b.classList.remove('is-hovered');
            });
            block.classList.add('is-hovered');
            ensureRail(block);
        });
    }

    global.EditorBlockUI = { bind: bind, refresh: refreshAllRails };
})(window);

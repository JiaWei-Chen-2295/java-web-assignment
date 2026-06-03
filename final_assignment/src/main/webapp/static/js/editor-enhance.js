/**
 * Editor.js 增强：大纲、字数、侧栏、专注模式
 */
(function () {
    'use strict';

    var isFocusMode = false;

    function initSidebarTabs() {
        document.querySelectorAll('.sidebar-tab-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var target = this.dataset.tab;
                document.querySelectorAll('.sidebar-tab-btn').forEach(function (b) {
                    b.classList.remove('active');
                });
                document.querySelectorAll('.sidebar-tab-panel').forEach(function (p) {
                    p.classList.remove('active');
                });
                this.classList.add('active');
                var panel = document.getElementById('tab-' + target);
                if (panel) panel.classList.add('active');
            });
        });
    }

    function updateOutline() {
        var outlineEl = document.getElementById('outlineList');
        var ed = window.NoteEditor && window.NoteEditor.getEditor();
        if (!outlineEl || !ed || !window.NoteEditor.isReady()) return;

        ed.save().then(function (data) {
            var headers = (data.blocks || []).filter(function (b) {
                return b.type === 'header';
            });
            if (headers.length === 0) {
                outlineEl.innerHTML = '<div class="outline-empty"><span>添加标题块后显示大纲</span></div>';
                return;
            }
            var html = '';
            headers.forEach(function (h, i) {
                var level = (h.data && h.data.level) || 2;
                var text = (h.data && h.data.text) || '';
                var plain = text.replace(/<[^>]+>/g, '');
                var indent = (level - 1) * 14;
                html += '<div class="outline-item" data-idx="' + i + '" style="padding-left:' + (12 + indent) + 'px">' +
                    '<span class="outline-level outline-h' + level + '">H' + level + '</span>' +
                    '<span class="outline-text">' + escapeHtml(plain) + '</span></div>';
            });
            outlineEl.innerHTML = html;
        }).catch(function () { /* ignore */ });
    }

    function updateWordCount() {
        var el = document.getElementById('liveWordCount');
        var ed = window.NoteEditor && window.NoteEditor.getEditor();
        if (!el || !ed || !window.NoteEditor.isReady()) return;

        ed.save().then(function (data) {
            var plain = window.MarkdownToEditorJs.extractPlainText(data);
            var chinese = (plain.match(/[\u4e00-\u9fff]/g) || []).length;
            var english = plain.replace(/[\u4e00-\u9fff]/g, ' ').trim().split(/\s+/).filter(Boolean).length;
            var total = chinese + (english === 1 && plain.trim() === '' ? 0 : english);
            var chars = plain.replace(/\s/g, '').length;
            var readMin = Math.max(1, Math.ceil(chinese / 300 + english / 200));
            el.innerHTML =
                '<span class="stat-item"><span class="stat-value">' + total + '</span>字</span>' +
                '<span class="stat-divider">·</span>' +
                '<span class="stat-item"><span class="stat-value">' + chars + '</span>字符</span>' +
                '<span class="stat-divider">·</span>' +
                '<span class="stat-item">约 <span class="stat-value">' + readMin + '</span> 分钟</span>';
        }).catch(function () { /* ignore */ });
    }

    function scheduleUpdates() {
        clearTimeout(scheduleUpdates._t);
        scheduleUpdates._t = setTimeout(function () {
            updateOutline();
            updateWordCount();
        }, 400);
    }

    function toggleFocusMode() {
        isFocusMode = !isFocusMode;
        var shell = document.getElementById('docShell');
        var btn = document.getElementById('btnFocusMode');
        if (shell) shell.classList.toggle('focus-mode', isFocusMode);
        if (btn) btn.classList.toggle('active', isFocusMode);
    }

    window.toggleFocusMode = toggleFocusMode;

    function initPanelToggle() {
        var btn = document.getElementById('btnTogglePanel');
        var shell = document.getElementById('docShell');
        if (!btn || !shell) return;
        if (localStorage.getItem('noteapp-doc-panel') === 'closed') {
            shell.classList.add('panel-collapsed');
        }
        btn.addEventListener('click', function () {
            shell.classList.toggle('panel-collapsed');
            var closed = shell.classList.contains('panel-collapsed');
            localStorage.setItem('noteapp-doc-panel', closed ? 'closed' : 'open');
            btn.classList.toggle('active', !closed);
        });
        btn.classList.toggle('active', !shell.classList.contains('panel-collapsed'));
    }

    function initQuickActions() {
        var trigger = document.getElementById('quickActionsBtn');
        var menu = document.getElementById('quickActionsMenu');
        if (!trigger || !menu) return;
        trigger.addEventListener('click', function (e) {
            e.stopPropagation();
            menu.style.display = menu.style.display === 'block' ? 'none' : 'block';
        });
        document.addEventListener('click', function () {
            menu.style.display = 'none';
        });
    }

    function initShortcuts() {
        document.addEventListener('keydown', function (e) {
            if ((e.ctrlKey || e.metaKey) && e.shiftKey && e.key === 'F') {
                e.preventDefault();
                toggleFocusMode();
            }
            if (e.key === 'Escape' && isFocusMode) toggleFocusMode();
        });
    }

    function escapeHtml(t) {
        var d = document.createElement('div');
        d.textContent = t;
        return d.innerHTML;
    }

    function init() {
        initSidebarTabs();
        initPanelToggle();
        initQuickActions();
        initShortcuts();
        var focusBtn = document.getElementById('btnFocusMode');
        if (focusBtn) focusBtn.addEventListener('click', toggleFocusMode);

        document.addEventListener('editor-content-changed', scheduleUpdates);
        var wait = setInterval(function () {
            if (window.NoteEditor && window.NoteEditor.isReady()) {
                clearInterval(wait);
                scheduleUpdates();
            }
        }, 400);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();

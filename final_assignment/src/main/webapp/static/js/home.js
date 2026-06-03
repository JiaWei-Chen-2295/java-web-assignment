/**
 * NoteApp — 工作台首页交互
 */
(function () {
    'use strict';

    var STORAGE_KEY = 'noteapp-list-view';

    function initViewToggle() {
        var container = document.getElementById('noteListContainer');
        var pinned = document.getElementById('noteListPinned');
        var buttons = document.querySelectorAll('.view-toggle-btn');
        if (!buttons.length) return;

        var saved = localStorage.getItem(STORAGE_KEY) || 'list';
        applyView(saved);

        buttons.forEach(function (btn) {
            btn.addEventListener('click', function () {
                var view = this.dataset.view;
                applyView(view);
                localStorage.setItem(STORAGE_KEY, view);
            });
        });

        function applyView(view) {
            document.body.classList.toggle('notes-view-grid', view === 'grid');
            document.body.classList.toggle('notes-view-list', view === 'list');
            buttons.forEach(function (b) {
                b.classList.toggle('active', b.dataset.view === view);
            });
        }
    }

    // 双击行内空白不触发（保留链接跳转）
    function initRowClick() {
        document.querySelectorAll('.note-row').forEach(function (row) {
            row.addEventListener('click', function (e) {
                if (e.target.closest('.note-row-actions')) return;
                if (e.target.closest('button')) return;
            });
        });
    }

    function initSearchFocus() {
        var params = new URLSearchParams(window.location.search);
        if (params.get('keyword')) {
            var input = document.querySelector('.workspace-search input');
            if (input) input.focus();
        }
    }

    function init() {
        initViewToggle();
        initRowClick();
        initSearchFocus();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();

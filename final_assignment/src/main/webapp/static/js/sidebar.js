/**
 * NoteApp — Sidebar navigation and folder management
 */
(function () {
    'use strict';

    // Folder tree toggle expand/collapse
    function initFolderTree() {
        var tree = document.getElementById('folderTree');
        if (!tree) return;

        tree.addEventListener('click', function (e) {
            var toggle = e.target.closest('.folder-toggle');
            if (toggle) {
                e.preventDefault();
                e.stopPropagation();
                toggle.classList.toggle('expanded');
                var children = toggle.closest('.folder-node').querySelector('.folder-children');
                if (children) {
                    children.style.display = children.style.display === 'none' ? 'block' : 'none';
                }
            }
        });
    }

    // Highlight active sidebar item based on URL
    function highlightActive() {
        var path = window.location.pathname;
        var cp = window.contextPath || '';

        var items = document.querySelectorAll('.sidebar-item, .folder-item');
        items.forEach(function (item) {
            item.classList.remove('active');
        });

        // Check for note list with folder
        if (path === cp + '/note/list') {
            var params = new URLSearchParams(window.location.search);
            var folderId = params.get('folderId');
            if (folderId) {
                var folderItem = document.querySelector('[data-folder-id="' + folderId + '"]');
                if (folderItem) folderItem.classList.add('active');
            } else {
                var allItem = document.querySelector('[data-nav="all"]');
                if (allItem) allItem.classList.add('active');
            }
        } else if (path === cp + '/note/recent') {
            var recentItem = document.querySelector('[data-nav="recent"]');
            if (recentItem) recentItem.classList.add('active');
        } else if (path === cp + '/note/favorites') {
            var favItem = document.querySelector('[data-nav="favorites"]');
            if (favItem) favItem.classList.add('active');
        } else if (path === cp + '/graph') {
            var graphItem = document.querySelector('[data-nav="graph"]');
            if (graphItem) graphItem.classList.add('active');
        }
    }

    // Context menu for folders (right-click)
    function initFolderContextMenu() {
        var tree = document.getElementById('folderTree');
        if (!tree) return;

        tree.addEventListener('contextmenu', function (e) {
            var folderItem = e.target.closest('.folder-item');
            if (!folderItem) return;

            e.preventDefault();
            var folderId = folderItem.dataset.folderId;
            var folderName = folderItem.querySelector('.item-text').textContent.trim();

            showFolderContextMenu(e.clientX, e.clientY, folderId, folderName);
        });

        document.addEventListener('click', function () {
            removeContextMenu();
        });
    }

    function showFolderContextMenu(x, y, folderId, folderName) {
        removeContextMenu();

        var menu = document.createElement('div');
        menu.id = 'folder-context-menu';
        menu.style.cssText = 'position:fixed;z-index:9999;background:var(--bg-card);border:1px solid var(--border-default);' +
            'border-radius:var(--radius-lg);box-shadow:var(--shadow-lg);padding:4px;min-width:160px;left:' + x + 'px;top:' + y + 'px;';

        menu.innerHTML =
            '<button class="dropdown-item" style="width:100%" onclick="renameFolder(' + folderId + ',\'' + escapeHtml(folderName) + '\')">' +
            '<i class="bi bi-pencil me-2"></i>重命名</button>' +
            '<button class="dropdown-item" style="width:100%" onclick="newNoteInFolder(' + folderId + ')">' +
            '<i class="bi bi-file-plus me-2"></i>在此新建笔记</button>' +
            '<hr class="dropdown-divider" style="margin:4px 0;">' +
            '<button class="dropdown-item text-danger" style="width:100%" onclick="deleteFolder(' + folderId + ')">' +
            '<i class="bi bi-trash me-2"></i>删除文件夹</button>';

        document.body.appendChild(menu);

        // Adjust if off-screen
        var rect = menu.getBoundingClientRect();
        if (rect.right > window.innerWidth) menu.style.left = (x - rect.width) + 'px';
        if (rect.bottom > window.innerHeight) menu.style.top = (y - rect.height) + 'px';
    }

    function removeContextMenu() {
        var existing = document.getElementById('folder-context-menu');
        if (existing) existing.remove();
    }

    function escapeHtml(text) {
        var d = document.createElement('div');
        d.textContent = text;
        return d.innerHTML.replace(/'/g, "\\'");
    }

    // Global functions for context menu
    window.renameFolder = function (folderId, oldName) {
        var newName = prompt('重命名文件夹:', oldName);
        if (!newName || newName === oldName) return;

        var cp = window.contextPath || '';
        fetch(cp + '/api/folder/update', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: folderId, name: newName })
        })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            if (data.success) window.location.reload();
        });
    };

    window.deleteFolder = function (folderId) {
        if (!confirm('删除文件夹后，其中的笔记将移至"未分类"。确认删除？')) return;

        var cp = window.contextPath || '';
        fetch(cp + '/api/folder/delete', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: folderId })
        })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            if (data.success) window.location.reload();
        });
    };

    window.newNoteInFolder = function (folderId) {
        var cp = window.contextPath || '';
        window.location.href = cp + '/note/new?folderId=' + folderId;
    };

    // Init
    function init() {
        initFolderTree();
        highlightActive();
        initFolderContextMenu();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();

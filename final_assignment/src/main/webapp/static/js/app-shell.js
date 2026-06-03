/**
 * NoteApp — 全局壳层交互（侧栏、用户菜单、Toast、文件夹弹窗）
 */
(function () {
    'use strict';

    window.showToast = function (message, type) {
        var el = document.getElementById('appToast');
        if (!el) return;
        el.textContent = message;
        el.className = 'app-toast show' + (type ? ' toast-' + type : '');
        clearTimeout(el._timer);
        el._timer = setTimeout(function () {
            el.classList.remove('show');
        }, 2800);
    };

    // Sidebar collapse (desktop)
    var toggle = document.getElementById('sidebarToggle');
    var sidebar = document.getElementById('sidebar');
    var wrapper = document.getElementById('mainWrapper');
    var topbar = document.getElementById('topbar');

    if (toggle && sidebar) {
        var collapsed = localStorage.getItem('noteapp-sidebar-collapsed') === '1';
        if (collapsed) {
            document.body.classList.add('sidebar-collapsed');
        }

        toggle.addEventListener('click', function () {
            document.body.classList.toggle('sidebar-collapsed');
            var isCollapsed = document.body.classList.contains('sidebar-collapsed');
            localStorage.setItem('noteapp-sidebar-collapsed', isCollapsed ? '1' : '0');
            toggle.title = isCollapsed ? '展开侧栏' : '收起侧栏';
        });
    }

    // Mobile sidebar overlay
    if (toggle && sidebar && window.matchMedia('(max-width: 1024px)').matches) {
        toggle.addEventListener('click', function () {
            sidebar.classList.toggle('open');
        });
    }

    // User dropdown (no Bootstrap)
    var userBtn = document.getElementById('userMenuBtn');
    var userDropdown = document.getElementById('userDropdown');
    if (userBtn && userDropdown) {
        userBtn.addEventListener('click', function (e) {
            e.stopPropagation();
            var open = userDropdown.classList.toggle('show');
            userBtn.setAttribute('aria-expanded', open ? 'true' : 'false');
        });
        document.addEventListener('click', function () {
            userDropdown.classList.remove('show');
            userBtn.setAttribute('aria-expanded', 'false');
        });
    }

    // Ctrl+K search
    document.addEventListener('keydown', function (e) {
        if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') {
            e.preventDefault();
            var searchInput = document.getElementById('sidebarSearch');
            if (searchInput) {
                searchInput.focus();
                searchInput.select();
            }
        }
        if (e.key === 'Escape') {
            closeFolderModal();
        }
    });

    var searchInput = document.getElementById('sidebarSearch');
    if (searchInput) {
        searchInput.addEventListener('keydown', function (e) {
            if (e.key === 'Enter') {
                var keyword = this.value.trim();
                if (keyword) {
                    window.location.href = (window.contextPath || '') + '/note/list?keyword=' + encodeURIComponent(keyword);
                }
            }
        });
    }
})();

function openFolderModal() {
    var modal = document.getElementById('folderModal');
    if (modal) {
        modal.style.display = 'flex';
        document.getElementById('newFolderName').focus();
    }
}

function closeFolderModal() {
    var modal = document.getElementById('folderModal');
    if (modal) {
        modal.style.display = 'none';
        document.getElementById('newFolderName').value = '';
    }
}

function createFolder() {
    var name = document.getElementById('newFolderName').value.trim();
    if (!name) return;

    var cp = window.contextPath || '';
    fetch(cp + '/api/folder/create', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: name })
    })
    .then(function (r) { return r.json(); })
    .then(function (data) {
        if (data.success) {
            window.showToast('文件夹已创建', 'success');
            window.location.reload();
        }
    })
    .catch(function () {
        window.showToast('创建失败', 'error');
    });
    closeFolderModal();
}

var addFolderBtn = document.getElementById('addFolderBtn');
if (addFolderBtn) {
    addFolderBtn.addEventListener('click', openFolderModal);
}

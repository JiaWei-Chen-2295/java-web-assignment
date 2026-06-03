<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="common/header.jsp" %>

<c:if test="${empty note}">
    <script>window.location.href = '${pageContext.request.contextPath}/note/list';</script>
</c:if>

<c:if test="${not empty note}">
<div class="doc-shell" id="docShell">
    <header class="doc-topbar">
        <div class="doc-topbar-left">
            <a href="${pageContext.request.contextPath}/note/list" class="doc-back" title="返回工作台">
                <i class="bi bi-arrow-left"></i>
            </a>
            <span class="doc-topbar-label">文档</span>
        </div>
        <div class="doc-topbar-center">
            <span id="save-status" class="save-status saved">
                <i class="bi bi-check-circle"></i>
                <span class="save-status-text">已保存</span>
            </span>
        </div>
        <div class="doc-topbar-right">
            <div id="liveWordCount" class="word-count-bar"></div>
            <button type="button" class="doc-tool-btn" id="btnPin" title="置顶"
                    onclick="togglePin(${note.id})">
                <i class="bi bi-pin-angle${note.isPinned ? '-fill text-warning' : ''}"></i>
            </button>
            <button type="button" class="doc-tool-btn" id="btnFav" title="收藏"
                    onclick="toggleFavorite(${note.id})">
                <i class="bi bi-star${note.isFavorite ? '-fill text-warning' : ''}"></i>
            </button>
            <button type="button" class="doc-tool-btn" id="btnFocusMode" title="专注模式">
                <i class="bi bi-arrows-fullscreen"></i>
            </button>
            <button type="button" class="doc-tool-btn" id="btnTogglePanel" title="大纲与属性">
                <i class="bi bi-layout-sidebar-reverse"></i>
            </button>
            <div class="doc-more-wrap">
                <button type="button" class="doc-tool-btn" id="quickActionsBtn" title="更多">
                    <i class="bi bi-three-dots"></i>
                </button>
                <div class="quick-actions-dropdown" id="quickActionsMenu">
                    <div class="qa-item" onclick="deleteNote(${note.id})">
                        <i class="bi bi-trash text-danger"></i><span>删除笔记</span>
                    </div>
                    <div class="qa-divider"></div>
                    <div class="qa-item qa-shortcut"><span>保存</span><kbd>Ctrl+S</kbd></div>
                    <div class="qa-item qa-shortcut"><span>插入块</span><kbd>/</kbd></div>
                </div>
            </div>
        </div>
    </header>

    <div class="doc-body">
        <main class="doc-canvas" id="docCanvas">
            <div class="doc-canvas-inner">
                <article class="doc-sheet">
                    <input type="text" class="doc-title-block" id="note-title"
                           placeholder="无标题笔记" autocomplete="off">

                    <div class="doc-meta" id="docMeta">
                        <span><i class="bi bi-clock"></i> 更新于 <fmt:formatDate value="${note.updatedAt}" pattern="yyyy-MM-dd HH:mm"/></span>
                        <c:if test="${note.wordCount > 0}">
                            <span><i class="bi bi-text-paragraph"></i> ${note.wordCount} 字</span>
                        </c:if>
                    </div>

                    <div id="editorjs" class="editorjs-holder"></div>
                </article>

                <div class="editor-tips" id="editorTips">
                    <span>点击蓝色链接可跳转 · <kbd>[[</kbd> 引用文档</span>
                    <span><kbd>/</kbd> 插入块 · 引用笔记</span>
                    <span><kbd>Ctrl+S</kbd> 保存</span>
                </div>
            </div>
        </main>

        <aside class="doc-panel" id="editorSidebar">
            <div class="doc-panel-tabs sidebar-tabs">
                <button type="button" class="sidebar-tab-btn active" data-tab="outline">
                    <i class="bi bi-list-nested"></i> 大纲
                </button>
                <button type="button" class="sidebar-tab-btn" data-tab="info">
                    <i class="bi bi-sliders"></i> 属性
                </button>
                <button type="button" class="sidebar-tab-btn" data-tab="links">
                    <i class="bi bi-link-45deg"></i> 引用
                    <span id="forwardLinkCountTab" class="tab-badge" style="display:none;">0</span>
                </button>
            </div>

            <div class="sidebar-tab-panel active" id="tab-outline">
                <div id="outlineList" class="outline-list">
                    <div class="outline-empty"><span>添加标题块后显示大纲</span></div>
                </div>
            </div>

            <div class="sidebar-tab-panel" id="tab-info">
                <div class="sidebar-panel-section">
                    <div class="sidebar-panel-title"><i class="bi bi-folder2"></i> 文件夹</div>
                    <div class="sidebar-panel-content">
                        <select class="form-input" id="moveFolderSelect" onchange="moveNote(${note.id})">
                            <option value="">未分类</option>
                            <c:if test="${not empty folderTree}">
                                <c:forEach items="${folderTree}" var="folder">
                                    <option value="${folder.id}" ${note.folderId == folder.id ? 'selected' : ''}>${folder.name}</option>
                                    <c:if test="${not empty folder.children}">
                                        <c:forEach items="${folder.children}" var="child">
                                            <option value="${child.id}" ${note.folderId == child.id ? 'selected' : ''}>&nbsp;&nbsp;└ ${child.name}</option>
                                        </c:forEach>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </select>
                    </div>
                </div>
                <div class="sidebar-panel-section">
                    <div class="sidebar-panel-title"><i class="bi bi-tags"></i> 标签</div>
                    <div class="sidebar-panel-content">
                        <c:choose>
                            <c:when test="${not empty note.tags}">
                                <div class="tag-list">
                                    <c:forEach items="${note.tags}" var="tag">
                                        <span class="tag tag-default">${tag.name}</span>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted fs-sm">暂无标签</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="sidebar-tab-panel" id="tab-links">
                <div class="sidebar-panel-section">
                    <div class="sidebar-panel-header">
                        <span class="panel-title">本文引用</span>
                        <span id="forwardLinkCount" class="panel-badge" style="display:none;">0</span>
                    </div>
                    <div id="forwardLinksList" class="sidebar-panel-content">
                        <div class="outline-empty"><span>加载中...</span></div>
                    </div>
                </div>
                <div class="sidebar-panel-section sidebar-panel-section-divider">
                    <div class="sidebar-panel-header">
                        <span class="panel-title">反向引用</span>
                        <span id="backlinkCount" class="panel-badge" style="display:none;">0</span>
                    </div>
                    <div id="backlinksList" class="sidebar-panel-content">
                        <div class="outline-empty"><span>加载中...</span></div>
                    </div>
                </div>
            </div>
        </aside>
    </div>
</div>

<script>
    window.noteApp = { noteId: ${note.id} };
</script>

<!-- Editor.js + tools（本地静态资源，不依赖 CDN） -->
<script src="${pageContext.request.contextPath}/static/js/vendor/editorjs/editorjs.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/vendor/editorjs/header.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/vendor/editorjs/list.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/vendor/editorjs/code.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/vendor/editorjs/image.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/vendor/editorjs/quote.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/vendor/editorjs/delimiter.min.js"></script>

<script src="${pageContext.request.contextPath}/static/js/markdown-to-editorjs.js"></script>
<script src="${pageContext.request.contextPath}/static/js/editor-code-enhanced.js"></script>
<script src="${pageContext.request.contextPath}/static/js/app-shell.js"></script>
<script src="${pageContext.request.contextPath}/static/js/editor-init.js"></script>
<script src="${pageContext.request.contextPath}/static/js/editor-keyboard.js"></script>
<script src="${pageContext.request.contextPath}/static/js/editor-block-ui.js"></script>
<script src="${pageContext.request.contextPath}/static/js/editor-slash.js"></script>
<script src="${pageContext.request.contextPath}/static/js/editor-wikilink.js"></script>
<script src="${pageContext.request.contextPath}/static/js/editor-enhance.js"></script>

<script>
(function() {
    var noteId = window.noteApp.noteId;
    var cp = window.contextPath || '';
    function escapeHtml(text) {
        var d = document.createElement('div');
        d.textContent = text;
        return d.innerHTML;
    }

    window.togglePin = function(id) {
        fetch(cp + '/api/note/pin', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: id })
        }).then(function(r) { return r.json(); }).then(function(data) {
            if (data.success) {
                var icon = document.querySelector('#btnPin i');
                icon.className = icon.classList.contains('bi-pin-angle-fill') ? 'bi bi-pin-angle' : 'bi bi-pin-angle-fill text-warning';
                window.showToast('置顶状态已更新', 'success');
            }
        });
    };

    window.toggleFavorite = function(id) {
        fetch(cp + '/api/note/favorite', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: id })
        }).then(function(r) { return r.json(); }).then(function(data) {
            if (data.success) {
                var icon = document.querySelector('#btnFav i');
                var filled = icon.classList.contains('bi-star-fill');
                icon.className = filled ? 'bi bi-star' : 'bi bi-star-fill text-warning';
                window.showToast(filled ? '已取消收藏' : '已收藏', 'success');
            }
        });
    };

    window.deleteNote = function(id) {
        if (!confirm('确定删除这篇笔记吗？')) return;
        fetch(cp + '/api/note/delete', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: id })
        }).then(function(r) { return r.json(); }).then(function(data) {
            if (data.success) window.location.href = cp + '/note/list';
        });
    };

    window.moveNote = function(id) {
        var folderId = document.getElementById('moveFolderSelect').value;
        fetch(cp + '/api/note/move', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: id, folderId: folderId || null })
        }).then(function(r) { return r.json(); }).then(function(data) {
            if (data.success) window.showToast('已移动到所选文件夹', 'success');
        });
    };
})();
</script>
</c:if>

<%@ include file="common/footer.jsp" %>

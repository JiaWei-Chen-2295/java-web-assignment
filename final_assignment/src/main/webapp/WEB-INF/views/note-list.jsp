<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="common/header.jsp" %>

<c:set var="isHome" value="${empty viewMode && empty keyword && empty currentFolder}" />

<div class="workspace fade-in">
    <c:if test="${isHome}">
    <section class="workspace-hero">
        <div class="hero-content">
            <h1 class="hero-title">你好，${sessionScope.currentUser.username}</h1>
            <p class="hero-desc">记录想法、整理知识，用 [[双向链接]] 串联笔记，在知识图谱中探索关联。</p>
            <div class="hero-actions">
                <a href="${pageContext.request.contextPath}/note/new" class="btn btn-primary">
                    <i class="bi bi-plus-lg"></i> 新建笔记
                </a>
                <a href="${pageContext.request.contextPath}/graph" class="btn btn-secondary">
                    <i class="bi bi-diagram-3"></i> 知识图谱
                </a>
            </div>
        </div>
        <div class="hero-stats">
            <div class="stat-card">
                <span class="stat-value">${not empty notes ? notes.size() : 0}</span>
                <span class="stat-label">全部笔记</span>
            </div>
            <div class="stat-card">
                <span class="stat-value">${not empty recentNotes ? recentNotes.size() : 0}</span>
                <span class="stat-label">近期活跃</span>
            </div>
        </div>
    </section>
    </c:if>

    <div class="workspace-toolbar">
        <div class="toolbar-left">
            <h2 class="workspace-heading">
                <c:choose>
                    <c:when test="${viewMode == 'favorites'}"><i class="bi bi-star-fill heading-icon warning"></i> 我的收藏</c:when>
                    <c:when test="${viewMode == 'recent'}"><i class="bi bi-clock-history heading-icon"></i> 最近编辑</c:when>
                    <c:when test="${not empty currentFolder}"><i class="bi bi-folder2-open heading-icon"></i> ${currentFolder.name}</c:when>
                    <c:when test="${not empty keyword}"><i class="bi bi-search heading-icon"></i> 「${keyword}」</c:when>
                    <c:otherwise><i class="bi bi-files heading-icon"></i> 全部笔记</c:otherwise>
                </c:choose>
            </h2>
            <c:if test="${not empty notes}">
                <span class="workspace-count">${notes.size()} 篇</span>
            </c:if>
        </div>
        <div class="toolbar-right">
            <form action="${pageContext.request.contextPath}/note/list" method="get" class="workspace-search">
                <i class="bi bi-search"></i>
                <input type="text" name="keyword" placeholder="搜索标题或内容..." value="${keyword}">
            </form>
            <div class="view-toggle" role="group" aria-label="视图切换">
                <button type="button" class="view-toggle-btn active" data-view="list" title="列表视图">
                    <i class="bi bi-list-ul"></i>
                </button>
                <button type="button" class="view-toggle-btn" data-view="grid" title="卡片视图">
                    <i class="bi bi-grid"></i>
                </button>
            </div>
            <a href="${pageContext.request.contextPath}/note/new" class="btn btn-primary btn-sm">
                <i class="bi bi-plus-lg"></i><span class="btn-label">新建</span>
            </a>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty notes}">
            <c:set var="showPinnedLabel" value="false" />
            <c:forEach items="${notes}" var="n">
                <c:if test="${n.isPinned && empty keyword}"><c:set var="showPinnedLabel" value="true" /></c:if>
            </c:forEach>

            <c:if test="${showPinnedLabel}">
            <section class="note-section">
                <h3 class="section-label"><i class="bi bi-pin-angle-fill"></i> 置顶</h3>
                <div class="note-list-view" id="noteListPinned">
                    <c:forEach items="${notes}" var="note">
                        <c:if test="${note.isPinned}">
                            <%@ include file="note-item-fragment.jspf" %>
                        </c:if>
                    </c:forEach>
                </div>
            </section>
            </c:if>

            <section class="note-section">
                <c:if test="${showPinnedLabel}">
                    <h3 class="section-label">其他笔记</h3>
                </c:if>
                <div class="note-list-view" id="noteListContainer">
                    <c:forEach items="${notes}" var="note">
                        <c:if test="${empty keyword ? !note.isPinned : true}">
                            <%@ include file="note-item-fragment.jspf" %>
                        </c:if>
                    </c:forEach>
                </div>
            </section>
        </c:when>
        <c:otherwise>
            <div class="empty-state workspace-empty">
                <div class="empty-state-icon"><i class="bi bi-journal-plus"></i></div>
                <h3>
                    <c:choose>
                        <c:when test="${not empty keyword}">没有找到匹配的笔记</c:when>
                        <c:when test="${viewMode == 'favorites'}">还没有收藏</c:when>
                        <c:otherwise>开始你的第一篇笔记</c:otherwise>
                    </c:choose>
                </h3>
                <p>
                    <c:choose>
                        <c:when test="${not empty keyword}">换个关键词试试</c:when>
                        <c:otherwise>支持 Markdown、双向链接与知识图谱</c:otherwise>
                    </c:choose>
                </p>
                <c:if test="${empty keyword}">
                    <a href="${pageContext.request.contextPath}/note/new" class="btn btn-primary">
                        <i class="bi bi-plus-lg"></i> 新建笔记
                    </a>
                </c:if>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
var cp = window.contextPath || '';

function toggleFav(id, btn) {
    fetch(cp + '/api/note/favorite', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id: id })
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.success) {
            var icon = btn.querySelector('i');
            var filled = icon.classList.contains('bi-star-fill');
            icon.className = filled ? 'bi bi-star' : 'bi bi-star-fill text-warning';
            window.showToast(filled ? '已取消收藏' : '已收藏', 'success');
        }
    });
}

function deleteNote(id, btn) {
    if (!confirm('确定删除这篇笔记吗？')) return;
    fetch(cp + '/api/note/delete', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id: id })
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.success) {
            var row = btn.closest('.note-row');
            row.classList.add('is-removing');
            setTimeout(function() { row.remove(); window.showToast('笔记已删除', 'success'); }, 280);
        }
    });
}
</script>

<%@ include file="common/footer.jsp" %>

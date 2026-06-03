<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NoteApp - ${param.title != null ? param.title : "个人知识管理"}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
    <c:if test="${pageLayout == 'editor'}">
        <link href="${pageContext.request.contextPath}/static/css/editor.css" rel="stylesheet">
    </c:if>
</head>
<body class="${pageLayout == 'editor' ? 'layout-editor' : 'layout-app'}">
<script>window.contextPath = '${pageContext.request.contextPath}';</script>

<c:if test="${not empty sessionScope.currentUser && pageLayout != 'editor'}">
<!-- Sidebar (Feishu light nav) -->
<aside class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <a href="${pageContext.request.contextPath}/note/list" class="sidebar-brand">
            <div class="sidebar-logo"><i class="bi bi-journal-richtext"></i></div>
            <span class="sidebar-title">知识库</span>
        </a>
    </div>

    <div class="sidebar-search">
        <div class="sidebar-search-wrap">
            <i class="bi bi-search"></i>
            <input type="text" class="sidebar-search-input" id="sidebarSearch"
                   placeholder="搜索笔记" autocomplete="off">
            <kbd class="sidebar-search-kbd">⌘K</kbd>
        </div>
    </div>

    <nav class="sidebar-nav">
        <div class="sidebar-section">
            <a href="${pageContext.request.contextPath}/note/list"
               class="sidebar-item ${activeNav == 'all' ? 'active' : ''}" data-nav="all">
                <i class="bi bi-house-door item-icon"></i>
                <span class="item-text">工作台</span>
            </a>
            <a href="${pageContext.request.contextPath}/note/recent"
               class="sidebar-item ${activeNav == 'recent' ? 'active' : ''}" data-nav="recent">
                <i class="bi bi-clock-history item-icon"></i>
                <span class="item-text">最近编辑</span>
            </a>
            <a href="${pageContext.request.contextPath}/note/favorites"
               class="sidebar-item ${activeNav == 'favorites' ? 'active' : ''}" data-nav="favorites">
                <i class="bi bi-star item-icon"></i>
                <span class="item-text">我的收藏</span>
            </a>
            <a href="${pageContext.request.contextPath}/graph"
               class="sidebar-item ${activeNav == 'graph' ? 'active' : ''}" data-nav="graph">
                <i class="bi bi-diagram-3 item-icon"></i>
                <span class="item-text">知识图谱</span>
            </a>
        </div>

        <div class="sidebar-section">
            <div class="sidebar-section-title">
                <span>文件夹</span>
                <button type="button" class="add-btn" id="addFolderBtn" title="新建文件夹">
                    <i class="bi bi-plus"></i>
                </button>
            </div>
            <div class="folder-tree" id="folderTree">
                <c:if test="${not empty folderTree}">
                    <c:forEach items="${folderTree}" var="folder">
                        <div class="folder-node">
                            <a href="${pageContext.request.contextPath}/note/list?folderId=${folder.id}"
                               class="folder-item ${currentFolderId == folder.id ? 'active' : ''}"
                               data-folder-id="${folder.id}">
                                <i class="bi bi-folder2 item-icon"></i>
                                <span class="item-text">${folder.name}</span>
                                <c:if test="${folder.noteCount > 0}">
                                    <span class="item-badge">${folder.noteCount}</span>
                                </c:if>
                            </a>
                            <c:if test="${not empty folder.children}">
                                <div class="folder-children">
                                    <c:forEach items="${folder.children}" var="child">
                                        <a href="${pageContext.request.contextPath}/note/list?folderId=${child.id}"
                                           class="folder-item ${currentFolderId == child.id ? 'active' : ''}"
                                           data-folder-id="${child.id}">
                                            <i class="bi bi-folder2 item-icon"></i>
                                            <span class="item-text">${child.name}</span>
                                            <c:if test="${child.noteCount > 0}">
                                                <span class="item-badge">${child.noteCount}</span>
                                            </c:if>
                                        </a>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </c:if>
            </div>
        </div>
    </nav>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/note/new" class="btn-new-note">
            <i class="bi bi-plus-lg"></i>
            <span>新建笔记</span>
        </a>
    </div>
</aside>

<header class="topbar" id="topbar">
    <div class="topbar-left">
        <button type="button" class="topbar-btn" id="sidebarToggle" title="收起侧栏">
            <i class="bi bi-layout-sidebar"></i>
        </button>
        <div class="topbar-breadcrumb">
            <a href="${pageContext.request.contextPath}/note/list">工作台</a>
            <span class="sep">/</span>
            <span class="current">${breadcrumb != null ? breadcrumb : '全部笔记'}</span>
        </div>
    </div>
    <div class="topbar-right">
        <a href="${pageContext.request.contextPath}/note/new" class="btn btn-primary btn-sm topbar-create">
            <i class="bi bi-plus-lg"></i><span>新建</span>
        </a>
        <div class="topbar-user-wrapper">
            <button type="button" class="topbar-user" id="userMenuBtn" aria-expanded="false">
                <div class="avatar">${sessionScope.currentUser.username.substring(0,1).toUpperCase()}</div>
                <span class="name">${sessionScope.currentUser.username}</span>
                <i class="bi bi-chevron-down user-chevron"></i>
            </button>
            <div class="dropdown-menu user-dropdown" id="userDropdown">
                <div class="user-email">
                    <i class="bi bi-envelope"></i>
                    <span>${sessionScope.currentUser.email}</span>
                </div>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/user/logout">
                    <i class="bi bi-box-arrow-right"></i>
                    <span>退出登录</span>
                </a>
            </div>
        </div>
    </div>
</header>

<div class="main-wrapper" id="mainWrapper">
</c:if>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="common/header.jsp" %>

<div class="workspace fade-in" style="max-width:1200px;">
    <!-- Page Header -->
    <div class="page-header">
        <div>
            <h1><i class="bi bi-diagram-3" style="color:var(--c-primary);"></i> 知识图谱</h1>
            <div class="subtitle">可视化展示笔记之间的双向链接关系</div>
        </div>
        <div style="display:flex; gap:8px; align-items:center;">
            <span id="graph-stats" class="tag tag-primary" style="padding:4px 14px;font-size:13px;">
                <i class="bi bi-arrow-repeat spin"></i> 加载中...
            </span>
            <button id="refreshBtn" class="btn btn-secondary btn-sm">
                <i class="bi bi-arrow-clockwise"></i> 刷新
            </button>
        </div>
    </div>

    <!-- Graph Container -->
    <div class="card" style="overflow:hidden;">
        <div id="graph-container" style="min-height:560px;width:100%;"></div>

        <div style="padding:12px 20px; border-top:1px solid var(--border-light); display:flex; gap:20px; flex-wrap:wrap; align-items:center; font-size:12px; color:var(--text-tertiary);">
            <span style="display:flex;align-items:center;gap:6px;">
                <span style="width:10px;height:10px;border-radius:50%;background:var(--c-primary);display:inline-block;"></span>
                笔记节点
            </span>
            <span style="display:flex;align-items:center;gap:6px;">
                <span style="width:20px;height:2px;border-radius:1px;background:var(--border-default);display:inline-block;"></span>
                双向链接
            </span>
            <span style="display:flex;align-items:center;gap:4px;">
                <i class="bi bi-info-circle"></i> 单击或双击节点打开笔记 · 拖拽节点可调整布局
            </span>
        </div>
    </div>
</div>

<!-- ECharts CDN -->
<script src="https://cdn.jsdelivr.net/npm/echarts@5/dist/echarts.min.js"></script>

<!-- Graph Script -->
<script src="${pageContext.request.contextPath}/static/js/graph.js"></script>

<!-- Refresh button handler -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        var refreshBtn = document.getElementById('refreshBtn');
        if (refreshBtn) {
            refreshBtn.addEventListener('click', function() {
                if (window.GraphView && window.GraphView.refresh) {
                    window.GraphView.refresh();
                }
            });
        }
    });
</script>

<%@ include file="common/footer.jsp" %>

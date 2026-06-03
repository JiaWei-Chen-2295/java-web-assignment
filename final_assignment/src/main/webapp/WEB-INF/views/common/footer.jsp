<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<c:if test="${not empty sessionScope.currentUser && pageLayout != 'editor'}">
</div><!-- /.main-wrapper -->
</c:if>

<!-- Toast -->
<div id="appToast" class="app-toast" role="status" aria-live="polite"></div>

<!-- New Folder Modal -->
<div id="folderModal" class="modal-overlay" style="display:none;">
    <div class="modal-card">
        <h3 class="modal-title">新建文件夹</h3>
        <input type="text" id="newFolderName" class="form-input" placeholder="文件夹名称">
        <div class="modal-actions">
            <button type="button" class="btn btn-secondary" onclick="closeFolderModal()">取消</button>
            <button type="button" class="btn btn-primary" onclick="createFolder()">创建</button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/app-shell.js"></script>
<c:if test="${pageLayout != 'editor'}">
<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/static/js/home.js"></script>
</c:if>
</body>
</html>

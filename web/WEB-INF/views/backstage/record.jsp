<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<link href="${pageContext.request.contextPath}/static/css/backstage/record.css" rel="stylesheet"/>
<script src="${pageContext.request.contextPath}/static/js/record.js"></script>
<div id="record-top">
    <div id="record-operate">
        <% if (request.getParameter("m") != null){ %>
        <input />
        <button class="search">搜索</button>
        <button class="modify">修改</button>
        <button class="delete">删除</button>
        <% }else{ %>
        <button class="submit">提交</button>
        <% } %>
    </div>
    <div id="record-choose-color">
        <span class="active" style="background: rgb(255,255,255)"></span>
        <span style="background: rgb(255,137,132)"></span>
        <span style="background: rgb(255,145,220)"></span>
        <span style="background: rgb(160,168,255)"></span>
        <span style="background: rgb(156,255,247)"></span>
        <span style="background: rgb(175,255,172)"></span>
        <span style="background: rgb(255,228,155)"></span>
    </div>
</div>
<div id="record-body">
    <textarea></textarea>
</div>
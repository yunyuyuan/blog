<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<link href="${pageContext.request.contextPath}/static/css/backstage/blog.css" rel="stylesheet"/>
<link href="${pageContext.request.contextPath}/static/css/public/markdown.css" rel="stylesheet"/>
<script src="${pageContext.request.contextPath}/static/js/backstage/blog.js"></script>
<div id="blog-top-tool">
    <div id="manipulate">
        <% if (request.getParameter("m") != null){ %>
        <input type="number" placeholder="输入博客open_id"/>
        <button class="search">搜索</button>
        <div>
            <span class="show-whole"></span>
        </div>
        <button class="modify">修改</button>
        <button class="delete" style="background: rgba(255,53,51,0.68)">删除</button>
        <% }else{ %>
        <div>
            <span class="show-whole"></span>
        </div>
        <button class="submit">提交</button>
        <% } %>
    </div>
</div>
<div id="body">
    <div id="top-input">
        <input placeholder="输入标签,用','隔开"/>
    </div>
    <div id="left-input" style="margin-right: 2%">
        <div>
            <input id="input-cover" placeholder="封面">
        </div>
        <div class="blog-title">
            <textarea id="input-title" placeholder="标题"></textarea>
        </div>
        <div class="blog-content">
            <textarea id="input-content"></textarea>
        </div>
    </div>
    <div id="right-show">
        <div class="blog-title">
            <span></span>
        </div>
        <div class="blog-content">
            <span class="mark-container"></span>
        </div>
    </div>
</div>

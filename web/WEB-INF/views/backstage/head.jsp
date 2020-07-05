<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%!
    private static final List<String> fonts = Arrays.asList("write", "code", "ico");
%>
<%
    String c = request.getParameter("c");
    String color_mod = (String) session.getAttribute("color_mod");
    String class_ = "black";
    if (color_mod!=null && color_mod.equals("white")){
        class_ = "white";
    }
%>
<style>
    :root{
        --write-font: "write-font";
        --code-font: "code-font";
        --ico-font: "ico-font";
    }
    <% for (String s: fonts){ %>
    @font-face {
        font-family: '<%= s %>-font';
        src: url('${pageContext.request.contextPath}/static/css/fonts/<%= s %>/<%= s %>.eot');
        src: url('${pageContext.request.contextPath}/static/css/fonts/<%= s %>/<%= s %>.eot?#iefix') format('embedded-opentype'),
        url('${pageContext.request.contextPath}/static/css/fonts/<%= s %>/<%= s %>.woff2') format('woff2'),
        url('${pageContext.request.contextPath}/static/css/fonts/<%= s %>/<%= s %>.woff') format('woff'),
        url('${pageContext.request.contextPath}/static/css/fonts/<%= s %>/<%= s %>.ttf') format('truetype'),
        url('${pageContext.request.contextPath}/static/css/fonts/<%= s %>/<%= s %>.svg#<%= s %>-font') format('svg');
        font-weight: normal;
        font-style: normal;
    }
    <% } %>
</style>
<div id="-head-container" data-path="${pageContext.request.contextPath}">
    <a class="<%= (c.equals("blog"))? "active":"" %>" href="${pageContext.request.contextPath}/backstage?c=blog">写博客</a>
    <a class="<%= (c.equals("m_blog"))? "active":"" %>" href="${pageContext.request.contextPath}/backstage?c=m_blog">改博客</a>
    <a class="<%= (c.equals("record"))? "active":"" %>" href="${pageContext.request.contextPath}/backstage?c=record">写随笔</a>
    <a class="<%= (c.equals("m_record"))? "active":"" %>" href="${pageContext.request.contextPath}/backstage?c=m_record">改随笔</a>
    <a class="<%= (c.equals("upload"))? "active":"" %>" href="${pageContext.request.contextPath}/backstage?c=upload">传图片</a>
    <a class="<%= (c.equals("onerow"))? "active":"" %>" href="${pageContext.request.contextPath}/backstage?c=onerow">改单行</a>
</div>
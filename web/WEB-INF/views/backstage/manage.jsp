<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%!
    private List<String> all_c = Arrays.asList("blog", "m_blog", "record", "m_record", "upload", "onerow");
%>
<%
    String is_manager = (String) session.getAttribute("is_manager");
    if (!(is_manager!=null && is_manager.equals("true"))){
        response.sendRedirect("/verify_manager");
        return;
    }
    String c = request.getParameter("c");
    c = (c!=null && all_c.contains(c))? c:"blog";
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= c %></title>
    <jsp:include page="/WEB-INF/views/backstage/publicHead.jsp"/>
</head>
<body>
    <jsp:include page="/WEB-INF/views/backstage/head.jsp">
        <jsp:param name="c" value="<%= c %>"/>
    </jsp:include>

    <div id="container">
        <% switch (c) {
            case "blog": %>
        <jsp:include page="/WEB-INF/views/backstage/blog.jsp"/>
        <% break;
            case "m_blog": %>
        <jsp:include page="/WEB-INF/views/backstage/blog.jsp">
            <jsp:param name="m" value="t"/>
        </jsp:include>
        <% break;
            case "record": %>
        <jsp:include page="/WEB-INF/views/backstage/record.jsp"/>
        <% break;
            case "m_record": %>
        <jsp:include page="/WEB-INF/views/backstage/record.jsp">
            <jsp:param name="m" value="t"/>
        </jsp:include>
        <% break;
            case "upload": %>
        <jsp:include page="/WEB-INF/views/backstage/upload.jsp"/>
        <% break;
            case "onerow": %>
        <jsp:include page="/WEB-INF/views/backstage/onerow.jsp"/>
        <% break;
        } %>
    </div>
</body>
</html>

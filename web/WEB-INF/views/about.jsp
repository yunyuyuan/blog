<%@ page import="org.springframework.jdbc.core.JdbcTemplate" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%!
    private JdbcTemplate jdbcTemplate;
    private static final SimpleDateFormat formater = new SimpleDateFormat("yyyy年MM月dd日");
    public void jspInit(){
        jdbcTemplate = (JdbcTemplate) WebApplicationContextUtils.getWebApplicationContext(getServletConfig().getServletContext()).getBean("jdbcTemplate");
    }
%>
<%
    boolean is_singleload = request.getHeader("x-single")!=null;
    JSONObject about = JSONObject.parseObject(jdbcTemplate.queryForObject("select about from onerow where id=0", String.class));
%>
<!DOCTYPE html>
<html>
<head>
    <title>关于</title>
    <meta name="description" content="yunyuyuan的小站-关于此站" />
    <% if (!is_singleload){ %>
    <jsp:include page="/WEB-INF/views/plugin/publicHead.jsp"/>
    <% }%>
    <script src="${pageContext.request.contextPath}/static/js/about.js"></script>
    <link href="${pageContext.request.contextPath}/static/css/about.css" rel="stylesheet"/>
</head>
<body>
    <% if (!is_singleload){ %>
    <jsp:include page="/WEB-INF/views/plugin/head.jsp">
        <jsp:param name="bg" value="1"/>
    </jsp:include>
    <% }else{ %>
    <bg>1</bg>
    <% } %>
    <div id="container">
        <div id="body-wrap">
            <div id="show-wrap">
                <div id="about-div">
                    <img id="paper-img" src="${pageContext.request.contextPath}/static/img/constant/paper.jpg" alt="paper"/>
                    <img id="feather-img" src="${pageContext.request.contextPath}/static/img/constant/feather.png" alt="feather"/>
                    <p id="about-text"><%= about.get("content") %></p>
                    <b id="about-time"><%= formater.format(about.get("time")) %></b>
                </div>
            </div>
        </div>
        <% if (!is_singleload){ %>
        <jsp:include page="/WEB-INF/views/pendant/footer.jsp"/>
        <% } %>
    </div>
</body>
</html>

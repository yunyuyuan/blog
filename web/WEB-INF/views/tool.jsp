<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%!
    private static final List<String> all_tools = Arrays.asList("b64", "url", "md5", "ico", "cps", "qr");
    private static final List<String> has_count = Arrays.asList("url", "ico", "cps");
    private JdbcTemplate jdbcTemplate;
    public void jspInit(){
        jdbcTemplate = (JdbcTemplate) WebApplicationContextUtils.getWebApplicationContext(getServletConfig().getServletContext()).getBean("jdbcTemplate");
    }
%>
<%
    boolean is_singleload = request.getHeader("x-single")!=null;
    String para_t = request.getParameter("t");
    String what_tool = (para_t!=null && all_tools.contains(para_t))? para_t: "b64";
    int count = 0;
    if (has_count.contains(what_tool)){
        count = jdbcTemplate.queryForObject("select num from num_count where name=?", new Object[]{what_tool}, Integer.class);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>一些小工具</title>
    <meta name="description" content="yunyuyuan的小站-一些小工具。提供base64图片转换；短链生成；MD5加密；ico制作功能"/>
    <% if (!is_singleload){ %>
    <jsp:include page="/WEB-INF/views/plugin/publicHead.jsp"/>
    <% } %>
    <script src="${pageContext.request.contextPath}/static/js/tool.js"></script>
    <link href="${pageContext.request.contextPath}/static/css/tool.css" rel="stylesheet"/>
</head>
<body>
    <% if (!is_singleload){ %>
    <jsp:include page="/WEB-INF/views/plugin/head.jsp">
        <jsp:param name="bg" value="1"/>
    </jsp:include>
    <% }else{ %>
    <bg>2</bg>
    <% } %>
    <div id="container">
        <div id="body-wrap">
            <div id="show-wrap">
            <div id="code-wrap">
                <div id="left-list">
                    <ul id="all-tool-ul">
                        <li class="tool-li <%= (what_tool.equals("b64"))? "active":"" %>"><a data-singleload href='?t=b64'>图片/B64互转</a></li>
                        <li class="tool-li <%= (what_tool.equals("url"))? "active":"" %>"><a data-singleload href='?t=url'>短链生成</a></li>
                        <li class="tool-li <%= (what_tool.equals("md5"))? "active":"" %>"><a data-singleload href='?t=md5'>MD5加密</a></li>
                        <li class="tool-li <%= (what_tool.equals("ico"))? "active":"" %>"><a data-singleload href='?t=ico'>图片转ico</a></li>
                        <li class="tool-li <%= (what_tool.equals("cps"))? "active":"" %>"><a data-singleload href='?t=cps'>js/css压缩</a></li>
                        <li class="tool-li <%= (what_tool.equals("qr"))? "active":"" %>"><a data-singleload href='?t=qr'>二维码生成</a></li>
                    </ul>
                </div>
                <div id="right-show">
                    <% switch (what_tool) {
                        case "b64": %>
                    <jsp:include page="/WEB-INF/views/tools/base64.jsp"/>
                    <% break;
                        case "url": %>
                    <jsp:include page="/WEB-INF/views/tools/url.jsp">
                        <jsp:param name="count" value="<%= count %>"/>
                        <jsp:param name="has_login" value='<%= session.getAttribute("login_id")!=null %>'/>
                    </jsp:include>
                    <% break;
                        case "md5": %>
                    <jsp:include page="/WEB-INF/views/tools/md5.jsp"/>
                    <% break;
                        case "ico": %>
                    <jsp:include page="/WEB-INF/views/tools/ico.jsp">
                        <jsp:param name="count" value="<%= count %>"/>
                    </jsp:include>
                    <% break;
                        case "cps": %>
                    <jsp:include page="/WEB-INF/views/tools/compressor.jsp">
                        <jsp:param name="count" value="<%= count %>"/>
                    </jsp:include>
                    <% break;
                        case "qr": %>
                    <jsp:include page="/WEB-INF/views/tools/qr.jsp" />
                    <% break;
                    } %>
                </div>
            </div>
        </div>
        </div>
        <% if (!is_singleload){ %>
        <jsp:include page="/WEB-INF/views/pendant/footer.jsp"/>
        <% } %>
    </div>
</body>
</html>

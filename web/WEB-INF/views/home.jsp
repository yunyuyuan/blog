<%@ page import="org.springframework.jdbc.core.JdbcTemplate" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%!
    private JdbcTemplate jdbcTemplate;
    private static final SimpleDateFormat blog_formater = new SimpleDateFormat("yyyy-MM-dd");
    private static final SimpleDateFormat formater = new SimpleDateFormat("dd MMM, yyyy", Locale.ENGLISH);
    public void jspInit(){
        jdbcTemplate = (JdbcTemplate) WebApplicationContextUtils.getWebApplicationContext(getServletConfig().getServletContext()).getBean("jdbcTemplate");
    }
%>
<%
    boolean is_singleload = request.getHeader("x-single")!=null;
    Map<String, Object> new_blog = jdbcTemplate.queryForMap("select open_id, create_time, title, content, cover, views, comments_num from blogs order by id desc limit 1");
    Map<String, Object> new_record = jdbcTemplate.queryForMap("select content, create_time, color from blog.record order by id desc limit 1");

    String welcome = jdbcTemplate.queryForObject("select welcome from onerow limit 1", String.class);
%>
<!DOCTYPE html>
<html>
<head>
    <title>yunyuyuan的小站</title>
    <meta name="description" content="yunyuyuan的小站-phyer.cn"/>
    <% if (!is_singleload){ %>
    <jsp:include page="/WEB-INF/views/plugin/publicHead.jsp" />
    <% } %>
    <script src="${pageContext.request.contextPath}/static/js/home.js"></script>
    <link href="${pageContext.request.contextPath}/static/css/home.css" rel="stylesheet"/>
</head>
<body>
    <% if (!is_singleload){ %>
    <jsp:include page="/WEB-INF/views/plugin/head.jsp">
        <jsp:param name="bg" value="0"/>
    </jsp:include>

    <% }else{ %>
    <bg>0</bg>
    <% } %>
    <div id="container">
        <div id="body-wrap">
            <div id="show-wrap">
                <div id="home-head">
                    <div>
                        <div><%= welcome %></div>
                    </div>
                </div>
                <div id="home-bottom">
                    <div id="home-left">
                        <div id="new-blog">
                            <p>新文章</p>
                            <div class="blog-wrap">
                                <b><%= new_blog.get("title") %></b>
                                <div class="blog-main">
                                    <article>
                                        <span><%= new_blog.get("content") %></span>
                                        <img class="lazy-img" onerror="this.onerror='';this.src='${pageContext.request.contextPath}/static/img/constant/error.jpg'" src="${pageContext.request.contextPath}/static/img/constant/loading.gif" data-s="<%= new_blog.get("cover") %>" alt="cover"/>
                                    </article>
                                    <a data-singleload href="${pageContext.request.contextPath}/article/<%= new_blog.get("open_id") %>"></a>
                                </div>
                                <div>
                                    <span class="blog-c"><%= blog_formater.format(Long.parseLong((String) new_blog.get("create_time"))) %></span>
                                    <span class="blog-v"><%= new_blog.get("views") %></span>
                                    <span class="blog-s"><%= new_blog.get("comments_num") %></span>
                                </div>
                            </div>
                        </div>
                        <div id="new-record">
                            <p>新随笔</p>
                            <span style="background: <%= new_record.get("color") %>"><span><%= formater.format(Long.parseLong((String) new_record.get("create_time"))) %></span><%= new_record.get("content") %></span>
                        </div>
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

<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="cn.phyer.blog.dao.BlogDao" %>
<%@ page import="static cn.phyer.blog.tool.calcPageCount" %>
<%@ page import="cn.phyer.blog.dao.BlogEntity" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%!
    private BlogDao blogDao;
    private JdbcTemplate jdbcTemplate;
    private static final int ONE_PAGE_COUNT = 8;
    private static final List<String> all_what = Arrays.asList("all", "time", "tags");
    private static final SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
    private static final SimpleDateFormat year_formater = new SimpleDateFormat("yyyy");
    private static final SimpleDateFormat month_formater = new SimpleDateFormat("MM.dd");
    public void jspInit(){
        blogDao = (BlogDao) WebApplicationContextUtils.getWebApplicationContext(getServletConfig().getServletContext()).getBean("blogDao");
        jdbcTemplate = (JdbcTemplate) WebApplicationContextUtils.getWebApplicationContext(getServletConfig().getServletContext()).getBean("jdbcTemplate");
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    boolean is_singleload = request.getHeader("x-single")!=null;
    String para_p = request.getParameter("p");
    String para_tag = request.getParameter("t");
    para_tag = (para_tag!=null)? para_tag: "";
    boolean is_time_tag = para_tag.matches("\\d{4}");
    String para_what = request.getParameter("w");
    para_what = (all_what.contains(para_what))? para_what: "all";

    int now_page = 1,blog_count = blogDao.getBlogCount(para_tag, is_time_tag), page_count = 0;
    List<BlogEntity> blogs = null;
    Map<Object, List<List<Object>>> timelines = null;
    JSONArray tags = new JSONArray();
    switch (para_what){
        case "all":
            try {
                now_page = (para_p != null) ? Math.max(1, Integer.parseInt(para_p)) : 1;
            }catch (Exception ignore){}
            page_count = calcPageCount(ONE_PAGE_COUNT, blog_count);
            if (now_page > page_count){
                response.sendRedirect(request.getRequestURL()+"?p="+ page_count);
                return;
            }
            blogs = blogDao.getSomeBlogs((now_page-1)*ONE_PAGE_COUNT, ONE_PAGE_COUNT, para_tag, is_time_tag);
            break;
        case "time":
            timelines = new HashMap<>();
            for (Map<String, Object> line: blogDao.getTimeLine()) {
                String year = year_formater.format(Long.parseLong((String) line.get("create_time")));
                String month = month_formater.format(Long.parseLong((String) line.get("create_time"))).replaceAll("(^|\\.)0", "$1");
                if (!timelines.containsKey(year)){
                    timelines.put(year, new ArrayList<>());
                }
                timelines.get(year).add(Arrays.asList(month, line.get("open_id"), line.get("title")));
            }
            break;
        case "tags":
            tags = JSONArray.parseArray(jdbcTemplate.queryForObject("select all_cate from onerow where id=0", String.class));
            for (int i=0;i<tags.size();i++){
                String tag_ = (String) tags.get(i);
                int count_for_tag = jdbcTemplate.queryForObject("select count(*) from blogs where json_contains(tag, json_quote(?), '$')", new Object[]{tag_}, Integer.class);
                tags.set(i, new Object[]{tag_, count_for_tag});
            }
            break;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>文章</title>
    <meta name="description" content="yunyuyuan的小站-所有文章"/>
    <% if (!is_singleload){ %>
    <jsp:include page="/WEB-INF/views/plugin/publicHead.jsp"/>
    <% } %>
    <script src="${pageContext.request.contextPath}/static/js/article.js"></script>
    <link href="${pageContext.request.contextPath}/static/css/article.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/static/css/public/article.css" rel="stylesheet"/>
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
                <div>
                    <div id="article-head">
                        <a class="<%= (para_what.equals("all"))? "active":"" %>" data-singleload href="${pageContext.request.contextPath}/article?w=all">列表</a>
                        <a class="<%= (para_what.equals("time"))? "active":"" %>" data-singleload href="${pageContext.request.contextPath}/article?w=time">时间线</a>
                        <a class="<%= (para_what.equals("tags"))? "active":"" %>" data-singleload href="${pageContext.request.contextPath}/article?w=tags">标签</a>
                        <% if (para_what.equals("all")){ %>
                        <span><b><%= (para_tag.equals(""))? "全部":para_tag %></b>-第<b><%= now_page %><strong>/</strong><%= page_count %></b>页&nbsp;&nbsp;<b><%= blog_count %></b>篇文章</span>
                        <% } else if (para_what.equals("time")){ %>
                        <span>跨越<b><%= timelines.size() %></b>年&nbsp;&nbsp;<b><%= blog_count %></b>篇文章</span>
                        <% } else{ %>
                        <span>共<b><%= tags.size() %></b>个标签&nbsp;&nbsp;<b><%= blog_count %></b>篇文章</span>
                        <% } %>
                    </div>
                </div>
                <div id="article-wrap">
                    <% if (para_what.equals("all")){ %>
                    <div id="article-dispose">
                        <%
                            for (Object blog: blogs){
                                BlogEntity article = (BlogEntity) blog;
                        %>
                        <jsp:include page="/WEB-INF/views/pendant/article.jsp">
                            <jsp:param name="href" value="${pageContext.request.contextPath}/article/<%= article.getOpen_id() %>"/>
                            <jsp:param name="cover" value="<%= article.getCover() %>"/>
                            <jsp:param name="title" value="<%= article.getTitle() %>"/>
                            <jsp:param name="dcb" value="<%= article.getDcb() %>"/>
                            <jsp:param name="time" value="<%= formater.format(article.getCreate_time()) %>"/>
                            <jsp:param name="view" value="<%= article.getViews() %>"/>
                            <jsp:param name="cmt" value="<%= article.getComments_num() %>"/>
                        </jsp:include>
                        <% } %>
                    </div>
                    <jsp:include page="/WEB-INF/views/pendant/turnPage.jsp">
                        <jsp:param name="p" value="<%= now_page %>"/>
                        <jsp:param name="c" value="<%= blog_count %>"/>
                        <jsp:param name="o" value="<%= ONE_PAGE_COUNT %>"/>
                        <jsp:param name="f" value="turn_atc_page"/>
                    </jsp:include>
                    <% } else if (para_what.equals("time")){ %>
                    <div id="timeline-wrap">
                        <button id="timeline-slide">收起</button>
                        <ul id="timeline">
                            <%
                                Object[] sort_years = timelines.keySet().toArray();
                                Arrays.sort(sort_years, Collections.reverseOrder());
                                for (Object year: sort_years){
                                    List<List<Object>> months = timelines.get(year);
                            %>
                            <li class="timeline-year-li" data-down>
                                <span><a data-singleload href="${pageContext.request.contextPath}/article?t=<%= year %>"><%= year %></a><b>(<%= months.size() %>)</b></span>
                                <ul class="timeline-month-ul">
                                    <% for (List<Object> month: months){ %>
                                    <li>
                                        <a data-singleload href="${pageContext.request.contextPath}/article/<%= month.get(1) %>">
                                            <span><%= month.get(0) %></span>
                                            <%= month.get(2) %>
                                        </a>
                                    </li>
                                    <% } %>
                                </ul>
                            </li>
                            <% } %>
                        </ul>
                    </div>
                    <% }else{ %>
                    <div id="tags">
                        <% for (Object info: tags){
                            Object[] inf = (Object[]) info;%>
                            <a data-singleload href="${pageContext.request.contextPath}/article?t=<%= inf[0] %>"><%= inf[0] %>(<span><%= inf[1] %></span>)</a>
                        <% } %>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
        <% if (!is_singleload){ %>
        <jsp:include page="/WEB-INF/views/pendant/footer.jsp"/>
        <% } %>
    </div>
</body>
</html>

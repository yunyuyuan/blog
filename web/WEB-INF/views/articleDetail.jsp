<%@ page import="qiang.blog.dao.BlogDao" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="qiang.blog.dao.BlogEntity" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%!
    private BlogDao blogDao;
    private SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    public void jspInit(){
        blogDao = (BlogDao) WebApplicationContextUtils.getWebApplicationContext(getServletConfig().getServletContext()).getBean("blogDao");
    }
%>
<%
    boolean is_login = session.getAttribute("login_id")!=null;
//    boolean is_login = true;
    boolean is_singleload = request.getHeader("x-single")!=null;
    String para_id = request.getRequestURI().replaceFirst(".*/(?=\\d*$)", "");
    BlogEntity blog;
    List<Map<String, Object>> last_and_next;
    try{
        blog = blogDao.getOneBlog(para_id);
        blogDao.addView(para_id);
        if (blog == null){
            response.sendRedirect("/404");
            return;
        }
        // last和next
        last_and_next = blogDao.getLastNext(para_id);
    }catch (NumberFormatException e){
        response.sendRedirect("/404");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= blog.getTitle() %></title>
    <meta name="description" content="yunyuyuan的小站-<%= blog.getTitle() %>"/>
    <% if (!is_singleload){ %>
    <jsp:include page="/WEB-INF/views/plugin/publicHead.jsp"/>
    <% } %>
    <script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js" onerror="exchange(this,'${pageContext.request.contextPath}/static/js/lib/qrcode.min.js')"></script>
    <script src="https://cdn.bootcss.com/highlight.js/9.18.1/highlight.min.js" onerror="exchange(this,'${pageContext.request.contextPath}/static/js/lib/highlight.min.js')"></script>
    <script src="${pageContext.request.contextPath}/static/js/articleDetail.js" data-main></script>
    <link href="${pageContext.request.contextPath}/static/css/articleDetail.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/static/css/public/markdown.css" rel="stylesheet"/>
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
                <div id="blog-wrap">
                    <div id="blog-head">
                        <b><%= blog.getTitle() %></b>
                        <div>
                            <span title="发布时间"><%= formater.format(blog.getCreate_time()) %></span>
                            <span title="假的浏览量"><%= blog.getViews() %></span>
                            <span><%= blog.getComments_num() %></span>
                        </div>
                    </div>
                    <div id="blog-content">
                        <span class="mark-container">
                            <%= blog.getContent() %>
                            <span id="update-time">更新时间: <%= formater.format(blog.getUpdate_time()) %></span>
                        </span>
                        <div id="last-and-next">
                            <%
                                Map<String, Object> the_last = last_and_next.get(1);
                                if (the_last != null){
                            %>
                            <a class='last' data-singleload href="${pageContext.request.contextPath}/article/<%= the_last.get("open_id") %>">
                                <b>上一篇</b>
                                <span><%= the_last.get("title") %></span>
                            </a>
                            <%
                                }else out.print("<a class='last'><b>到头啦</b></a>");
                                Map<String, Object> the_next = last_and_next.get(0);
                                if (the_next != null){
                            %>
                            <a class='next' data-singleload href="${pageContext.request.contextPath}/article/<%= the_next.get("open_id") %>">
                                <b>下一篇</b>
                                <span><%= the_next.get("title") %></span>
                            </a>
                            <% }else out.print("<a class='next'><b>到头啦</b></a>"); %>
                        </div>
                        <div id="tag-div">
                            <span title="标签"></span>
                            <% for (Object tag: JSONArray.parseArray(blog.getTag())){ %>
                            <a title="<%= tag %>" data-singleload href="${pageContext.request.contextPath}/article?t=<%= URLEncoder.encode((String) tag, StandardCharsets.UTF_8) %>"><%= tag %></a>
                            <% } %>
                        </div>
                        <div class="article-footer">
                            <div>
                                <span>作者:<b>yunyuyuan</b>链接: <a href="<%= request.getRequestURL() %>"><%= request.getRequestURL() %></a></span>
                                <span>如转载请注明出处。小站无打赏系统，您的点击与分享是我最大的动力！</span>
                            </div>
                            <span title="二维码" onclick="gen_qr(this)">分享本文</span>
                            <div id="qr"></div>
                        </div>
                    </div>
                    <div id="blog-comment">
                            <% if (is_login){ %>
                                <jsp:include page="/WEB-INF/views/pendant/cmt.jsp">
                                    <jsp:param name="div_id" value="id='comment-to-blog'"/>
                                    <jsp:param name="maxlength" value="2048"/>
                                    <jsp:param name="callback" value="comment_submit"/>
                                </jsp:include>
                            <% }else{ %>
                            <b style="font-size: 1.2rem;color: black;display: flex;align-items: center;"><a style="color: rgb(255, 165, 0);margin: 0 10px;cursor: pointer;font-size: 1.2em" onclick="$('#-head-login img').click()">登录</a>后评论</b>
                            <% } %>
                        <div id="show-comment">
                            <p>评论列表</p>
                            <ul id="comment-ul" data-p="1">
                            </ul>
                            <jsp:include page="/WEB-INF/views/pendant/turnPage.jsp">
                                <jsp:param name="p" value="1"/>
                                <jsp:param name="c" value="1"/>
                                <jsp:param name="o" value="8"/>
                                <jsp:param name="f" value="turn_cmt_page"/>
                            </jsp:include>
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

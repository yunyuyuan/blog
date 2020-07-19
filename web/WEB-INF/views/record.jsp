<%@ page import="cn.phyer.blog.dao.RecordDao" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="static cn.phyer.blog.tool.calcPageCount" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%!
    private RecordDao recordDao;
    private static final SimpleDateFormat formater = new SimpleDateFormat("dd MMM, yyyy", Locale.ENGLISH);
    public void jspInit(){
        recordDao = (RecordDao) WebApplicationContextUtils.getWebApplicationContext(getServletConfig().getServletContext()).getBean("recordDao");
    }
%>
<%
    boolean is_singleload = request.getHeader("x-single")!=null;
    String para_p = request.getParameter("p");
    Map<String, String[]> all_para = new HashMap<>(request.getParameterMap());
    all_para.remove("p");
    int now_page = 1;
    try{
        now_page = Math.max(1, Integer.parseInt(para_p));
    }catch (Exception ignore){}
    int record_count = recordDao.getRecordCount();
    int page_count = calcPageCount(10, record_count);
    if (now_page > page_count){
        response.sendRedirect(request.getRequestURL()+"?p="+ page_count);
        return;
    }
    List<Map<String, Object>> all_record = recordDao.getSomeRecord((now_page - 1) * 10, 10);
%>
<!DOCTYPE html>
<html>
<head>
    <title>:-)</title>
    <meta name="description" content="yunyuyuan的小站-随笔"/>
    <% if (!is_singleload){ %>
    <jsp:include page="/WEB-INF/views/plugin/publicHead.jsp"/>
    <% } %>
    <script src="${pageContext.request.contextPath}/static/js/record.js"></script>
    <link href="${pageContext.request.contextPath}/static/css/record.css" rel="stylesheet"/>
</head>
<body>
    <% if (!is_singleload){ %>
    <jsp:include page="/WEB-INF/views/plugin/head.jsp">
        <jsp:param name="bg" value="3"/>
    </jsp:include>

    <% }else{ %>
    <bg>3</bg>
    <% } %>
    <div id="container">
        <div id="body-wrap">
            <div id="show-wrap">
            <div id="record-wrap">
                <% for(Map<String, Object> record: all_record){ %>
                <div class="record" style="background: <%= record.get("color") %>" data-i="<%= record.get("id") %>">
                    <b><%= formater.format(new Date(Long.parseLong((String) record.get("create_time")))) %></b>
                    <span><%= record.get("content") %></span>
                </div>
                <% } %>
                <jsp:include page="/WEB-INF/views/pendant/turnPage.jsp">
                    <jsp:param name="p" value="<%= now_page %>"/>
                    <jsp:param name="c" value="<%= record_count %>"/>
                    <jsp:param name="o" value="<%= 10 %>"/>
                    <jsp:param name="f" value="turn_rcd_page"/>
                </jsp:include>
            </div>
            </div>
        </div>
        <% if (!is_singleload){ %>
        <jsp:include page="/WEB-INF/views/pendant/footer.jsp"/>
        <% } %>
    </div>
</body>
</html>

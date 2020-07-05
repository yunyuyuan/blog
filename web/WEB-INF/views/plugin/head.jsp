<%@ page import="qiang.blog.dao.UserDao" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%!
    private UserDao userDao;
    private static final List<String> fonts = Arrays.asList("write", "code", "ico");
    public void jspInit(){
        userDao = (UserDao) WebApplicationContextUtils.getWebApplicationContext(getServletConfig().getServletContext()).getBean("userDao");
    }
%>
<%
    boolean is_login = session.getAttribute("login_id") != null;
    Map<String, Object> info = null;
    String email = "";
    if (is_login){
        int sql_id = (int) session.getAttribute("login_id");
        info = userDao.getNameAvatar(sql_id);
        email = userDao.getEmail(sql_id);
    }
%>
<style>
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
<div id="-head-container" data-path="${pageContext.request.contextPath}" data-is-login="<%= is_login %>">
    <a class="signature" data-singleload href="${pageContext.request.contextPath}/">
        <img src="${pageContext.request.contextPath}/static/img/favicon.png" alt="签名"/>
        <span>云与原</span>
    </a>
    <div id="-head-main" data-tog="up">
        <span id="-head-menu"></span>
        <div>
            <a title="文章" class="-head-tag" data-singleload href='${pageContext.request.contextPath}/article'>
                <img src="${pageContext.request.contextPath}/static/img/constant/title1.png" alt="文章"/>
            </a>
            <a title="在线小工具" class="-head-tag" data-singleload href='${pageContext.request.contextPath}/tool'>
                <img src="${pageContext.request.contextPath}/static/img/constant/title2.png" alt="工具"/>
            </a>
            <a title="心随着笔" class="-head-tag" data-singleload href='${pageContext.request.contextPath}/record'>
                <img src="${pageContext.request.contextPath}/static/img/constant/title3.png" alt="随笔"/>
            </a>
        </div>
    </div>
    <div id="-head-other">
        <span title="更多" onclick="slide_other()"></span>
        <div data-s="f">
            <span title="设置"></span>
            <span title="关于"><a data-singleload href="${pageContext.request.contextPath}/about"></a></span>
        </div>
    </div>
    <div id="-head-login">
        <% if (is_login){ %>
        <img title="已登录" src="<%= info.get("avatar_url") %>" onerror="err_avatar(this)" data-s="<%= ((String)info.get("nickname")).charAt(0) %>" alt="avatar"/>
        <% }else{ %>
        <img title="登录" src="${pageContext.request.contextPath}/static/img/action/default.png" alt="default"/>
        <% } %>
    </div>
</div>
<div id="login-div">
    <div>
    <div id="login-wrap">
        <span class="login-close"></span>
        <% if (is_login){ %>
        <img class="logo" src="<%= info.get("avatar_url") %>" onerror="err_avatar(this)" data-s="<%= ((String)info.get("nickname")).charAt(0) %>" alt="logo"/>
        <span class="login-state"><%= info.get("nickname") %>,您已登录</span>
        <div>
            <input id="input_e" maxlength="128" placeholder="邮箱" value="<%= email %>"/>
            <button id="change_email">修改</button>
        </div>
        <i>注:输入邮箱则会收到评论回复提醒,留空不会收到</i>
        <button>登出</button>
        <% }else{ %>
        <img class="logo" src="${pageContext.request.contextPath}/static/img/favicon.png" alt="logo"/>
        <span class="login-state">选择登录方式</span>
        <div id="login-main">
            <img title="腾讯qq" src="${pageContext.request.contextPath}/static/img/constant/qq.png" alt="qq"/>
            <img title="github" src="${pageContext.request.contextPath}/static/img/constant/github.png" alt="github"/>
            <img title="microsoft" src="${pageContext.request.contextPath}/static/img/constant/ms.png" alt="ms"/>
        </div>
        <% } %>
        <b></b>
    </div>
    </div>
</div>
<div id="-head-set">
    <div>
    <div>
        <div class="set-head">
            <b>设置</b>
            <span></span>
        </div>
        <div class="set-body">
            <ul>
                <li class="set-color">
                    <b>颜色</b>
                    <div>
                        <span title="white" style="background: var(--white-c)"></span>
                        <span title="dracula" style="background: var(--dracula-c)"></span>
                    </div>
                </li>
                <li class="set-animate">
                    <b>动画</b>
                    <div>
                        <div class="set-animate-wrap set-sky-animal">
                            <div class="toggle-wrapper sky_animate" data-checked>
                                <span>天空动画</span>
                                <div><b></b></div>
                            </div>
                            <label class="animate-count">
                                <a>云彩数量</a>
                                <input data-a="cloud_count" type="range" min="4" max="20" step="4"/>
                                <b></b>
                            </label>
                        </div>
                        <div class="set-animate-wrap set-bg-animal">
                            <div class="toggle-wrapper bg_animate" data-checked>
                                <span>背景动画</span>
                                <div><b></b></div>
                            </div>
                            <div class="animate-cate">
                                <span title="snow">雪花</span>
                                <span title="leaf">落叶</span>
                            </div>
                            <label class="animate-count">
                                <a>雪花数量</a>
                                <input data-a="snow_count" type="range" min="5" max="50"/>
                                <b></b>
                            </label>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
    </div>
    </div>
</div>
<div id="to-top">
    <img id="to-top-img" title="回到顶部" onclick="to_top()" src="${pageContext.request.contextPath}/static/img/action/toTop.png" onmouseenter="this.src='${pageContext.request.contextPath}/static/img/action/toTop.gif'" onmouseleave="this.src='${pageContext.request.contextPath}/static/img/action/toTop.png'" alt="top"/>
</div>
<jsp:include page="/WEB-INF/views/plugin/loading.jsp"/>
<jsp:include page="/WEB-INF/views/pendant/zoom.jsp"/>
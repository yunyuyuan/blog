<%@ page import="cn.phyer.blog.dao.ImgDao" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Objects" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%!
    private ImgDao imgDao;
    private static final int ONE_PAGE_COUNT=15;
    public void jspInit(){
        imgDao = (ImgDao) WebApplicationContextUtils.getWebApplicationContext(getServletConfig().getServletContext()).getBean("imgDao");
    }
%>
<%
    String para_p = request.getParameter("p");
    int now_page = 1;
    try {
        now_page = (para_p != null) ? Math.max(1, Integer.parseInt(para_p)) : 1;
    }catch (Exception ignore){}

    String user_id = request.getParameter("u");
    JSONArray imgs;
    if (user_id!=null && !user_id.equals("")){
    }else{
        user_id = "";
    }
    imgs = imgDao.getSomeImg((now_page-1)*ONE_PAGE_COUNT, ONE_PAGE_COUNT, user_id);
%>
<style>
    #upload-div{
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        width: 100%;
        margin: 0;
        padding: 0;
    }
    #upload-div button{
        margin: 50px 0;
        background: rgb(169, 0, 255);
        color: white;
        font-size: 1.2rem;
        padding: 0.2rem 0.5rem;
        border: 1px solid black;
    }
    #upload{
        display: flex;
        align-items: center;
    }
    #upload > input{
        padding: 4px;
        margin: 0 10px;
    }
    #get{
        width: 100%;
        display: flex;
        justify-content: center;
    }
    #get table{
        width: 90%;
        border: 3px solid;
        border-collapse: collapse;
    }
    #get th{
        background: rgb(255, 205, 156);
        padding: 0.8rem 0;
    }
    #get td{
        border: 1px solid;
        text-align: center;
    }
    #get img{
        height: 150px;
        object-fit: contain;
    }
</style>
<div id="upload-div">
    <div id="upload">
        <label>
            选择图片<input type="file" accept="image/*"/>
        </label>
        <button>提交</button>
        <input/>
    </div>
    <div id="get">
        <table>
            <tr>
                <th>图片</th>
                <th>用户</th>
                <th>路径</th>
                <th>操作</th>
            </tr>
            <%
                for (Object i: imgs){
                    Map<String, Object> img = (Map<String, Object>) i;
            %>
            <tr>
                <td><img src="${pageContext.request.contextPath}/static/img/sundry<%= img.get("path") %>" /></td>
                <td data-id="<%= img.get("user_") %>"><%= img.get("user_") %></td>
                <td><%= img.get("path") %></td>
                <td><button data-i="<%= img.get("id") %>">删除</button></td>
            </tr>
            <% } %>
        </table>
    </div>
    <jsp:include page="/WEB-INF/views/pendant/turnPage.jsp">
        <jsp:param name="p" value="<%= now_page %>"/>
        <jsp:param name="c" value="<%= imgDao.getImgCount() %>"/>
        <jsp:param name="o" value="<%= ONE_PAGE_COUNT %>"/>
        <jsp:param name="f" value="turn_upd_page"/>
    </jsp:include>
</div>
<script>
    function turn_upd_page(p){
        location.href = '${pageContext.request.contextPath}/backstage?c=upload&p='+p+'&u=<%= user_id %>';
    }
    $('#upload > button').click(function () {
        let inp = this.parentElement.querySelector('label input');
        if (inp.files.length === 0){
            alert('请选择图片');
            return
        }
        let form = new FormData();
        form.append('type', 'upload');
        form.append('f', inp.files[0]);
        $.ajax({
            success: function (r) {
                if (r !== 0){
                    alert('成功');
                    $('#upload > input').val(r);
                }
            }, error: function (e) {
                alert(e.state() + ' 服务器错误')
            },
            url: '${pageContext.request.contextPath}/manage', type: 'POST', timeoutSeconds: 10,
            data: form, processData: false, contentType: false
        })
    });
    $('#get td button').click(function () {
        let id = this.getAttribute("data-i");
        $.ajax({
            success: function () {
                location.reload()
            },
            url: '${pageContext.request.contextPath}/manage', type: 'POST', timeoutSeconds: 10,
            data: {'type': 'del_img', 'id': id}
        })
    });
    $('#get td[data-id]').click(function () {
        location.href = '${pageContext.request.contextPath}/backstage?c=upload&p=<%= now_page %>&u='+this.innerText;
    })
</script>
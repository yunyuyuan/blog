<%@ page import="org.springframework.jdbc.core.JdbcTemplate" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%!
    private JdbcTemplate jdbcTemplate;
    public void jspInit(){
        jdbcTemplate = (JdbcTemplate) WebApplicationContextUtils.getWebApplicationContext(getServletConfig().getServletContext()).getBean("jdbcTemplate");
    }
%>
<%
    Map<String, Object> row = jdbcTemplate.queryForMap("select * from onerow where id=0");
%>
<style>
    #onerow > button{
        padding: 5px 10px;
        background: rgb(143, 203, 255);
        outline: none;
    }
    #onerow li{
        padding: 10px 0;
        border-bottom: 1px solid;
    }
    #onerow b{
        width: 100px;
        display: inline-block;
    }
    #onerow textarea{
        width: 400px;
        height: 100px;
    }
</style>
<div id="onerow">
    <ul>
        <% for(String k: row.keySet()){ %>
        <li>
            <b><%= k %></b>
            <textarea><%= row.get(k) %></textarea>
        </li>
        <% } %>
    </ul>
    <button>提交</button>
</div>
<script>
    document.querySelector('#onerow > button').addEventListener('click', function () {
        let data = {'type': 'onerow'};
        document.querySelectorAll('#onerow li').forEach(function (e) {
            data[e.querySelector('b').innerHTML] = e.querySelector('textarea').value;
        });
        $.ajax({
            success: function () {
                location.reload()
            },
            url: '${pageContext.request.contextPath}/manage', type: 'POST', timeoutSeconds: 10,
            data: data
        })
    })
</script>
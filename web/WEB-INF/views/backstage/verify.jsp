<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%
    if (request.getMethod().toLowerCase().equals("post")){
        String pwd = request.getParameter("pwd");
        if (pwd.equals("111")){
            session.setAttribute("is_manager", "true");
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>验证</title>
    <jsp:include page="/WEB-INF/views/backstage/publicHead.jsp"/>
</head>
<body>
    <script>
        $(document).ready(function(){
            let pwd = prompt("输入管理密码", "");
            $.ajax({
                complete: function () {
                    location.href='${pageContext.request.contextPath}/backstage'
                },
                url: '${pageContext.request.contextPath}/verify_manager', type: 'POST', timeoutSeconds: 10,
                data: {'pwd': pwd}
            })
        });
    </script>
</body>
</html>

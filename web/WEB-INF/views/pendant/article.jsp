<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@page pageEncoding="UTF-8" %>
<a class="-article" href="${param.get("href")}" data-singleload >
    <img class="lazy-img" onerror="this.onerror='';this.src='${pageContext.request.contextPath}/static/img/constant/error.jpg'" src="${pageContext.request.contextPath}/static/img/constant/loading.gif" data-s="${param.get("cover")}" alt="cover">
    <div class="-article-detail">
        <b>${param.get("title")}</b>
        <span>${param.get("dcb")}</span>
    </div>
    <div class="-article-foot">
        <span>${param.get("time")}</span>
        <span>${param.get("view")}</span>
        <span>${param.get("cmt")}</span>
    </div>
</a>
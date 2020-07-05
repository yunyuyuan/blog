<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<script src="${pageContext.request.contextPath}/static/js/plugin/cmt.js"></script>
<link href="${pageContext.request.contextPath}/static/css/public/cmt.css" rel="stylesheet"/>

<div ${param.get("div_id")} class="cmt" data-to="main" data-ref="">
    <label class="cmt-input">
        <span>来一发评论吧!(还可以输入<b>${param.get('maxlength')}</b>字)</span>
        <textarea oninput="cmt_update_textarea(this)" maxlength="${param.get('maxlength')}"></textarea>
    </label>
    <div class="cmt-rich">
        <span title="添加表情" onclick="cmt_stk(this)"></span>
        <span title="添加图片" onclick="cmt_img(this)"></span>
        <span title="添加超链" onclick="cmt_url(this)"></span>
        <span title="添加代码" onclick="cmt_code(this)"></span>
    </div>
    <div class="cmt-go">
        <img title="刷新" onclick="flush_img(this)" src="${pageContext.request.contextPath}/static/img/constant/get_code.png" alt="code"/>
        <input onkeydown="if(event.which===13) this.nextElementSibling.click();" maxlength="4" placeholder="输入验证码"/>
        <button onclick="cmt_submit(this, ${param.get("callback")})" class="ico-submit"></button>
    </div>
</div>

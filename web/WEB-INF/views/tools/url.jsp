<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<style>
    #tool-container{
        width: 100%;
    }
    .generate{
        width: 100%;
        display: flex;
        flex-direction: column;
        align-items: center;
    }
    .generate textarea, .generate input{
        width: 75%;
        border: 1px solid;
        padding: 0.3rem;
        margin: 1.2rem 0;
    }
    .generate textarea{
        height: 8rem;
    }
    .generate input{
        padding: 1rem;
        border-radius: 0.4rem;
    }
    .generate b{
        width: 100%;
        color: red;
        height: 1rem;
        text-align: center;
        margin-bottom: 2rem;
    }
</style>
<div id="tool-container">
<% if(request.getParameter("has_login").equals("true")){ %>
    <div class="generate">
        <textarea placeholder="请输入待处理URL" maxlength="2048"></textarea>
        <button class="make ico-submit"></button>
        <b></b>
        <input class="copy-src" placeholder="结果"/>
        <button class="copy-all">复制</button>
    </div>
    <div id="tool-service_num">
        <span>已累计生成<b>${param.get("count")}</b>条短链</span>
    </div>
    <script>
        $(document).ready(function() {
            let state = $('.generate b');
            $('.make').click(function () {
                let val = $('.generate textarea').val();
                if (val.length < 1 && val.length > 2048) {
                    alert("URL长度在1-2048内");
                } else {
                    state.text("处理中...");
                    $.ajax({
                        success: function (re) {
                            if (re.length === 0){
                                state.text('失败')
                            }else{
                                state.text('成功');
                                $('.generate input').val(re);
                            }
                        }, error: function (e) {
                            state.text(e.state() + " 服务器错误");
                        }, complete: function () {
                            setTimeout(function(){state.text('')}, 2500);
                        },
                        url: $('#-head-container').attr('data-path')+'/publicAction', type: 'POST', timeoutSeconds: 10,
                        data: {'type': 'generate-url', 'url': val}
                    });
                }
            });
        })
    </script>
<% }else{ %>
    <span style="color: black;font-size: 1.2rem;margin: 1.4rem">请先<b style="cursor: pointer;color: red" onclick="$('#-head-login > img').click()">登录</b>后再使用此工具</span>
<% } %>
</div>
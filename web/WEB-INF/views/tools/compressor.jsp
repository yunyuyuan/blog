<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<style>
    #tool-container{
        flex-direction: column;
        width: 100%;
    }
    #tool-container textarea{
        width: 80%;
        height: 10rem;
    }
    #input, #output{
        width: calc(100% - 3rem);
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 1rem;
    }
    #input span, #output span{
        color: black;
        font-size: 1.2rem;
        margin-bottom: 0.7rem;
    }
    #choose-lang{
        display: flex;
        align-items: center;
        justify-content: center;
        width: 100%;
        padding: 1.7rem 0;
        border-bottom: 1px solid black;
    }
    #choose-lang b{
        color: black;
        font-size: 1.1rem
    }
    #choose-lang span{
        font-size: 1rem;
        background: white;
        border: 1px solid black;
        padding: 0.5rem;
        margin: 0 1rem;
        cursor: pointer;
        border-radius: 0.2rem;
    }
    #choose-lang .active{
        background: rgb(134, 70, 255);
        color: white;
        font-weight: bold;
    }
</style>
<div id="tool-container">
    <div id="choose-lang">
        <b>选择代码语言</b>
        <span class="active">js</span>
        <span>css</span>
    </div>
    <div id="input">
        <span>输入 <em>js</em> 代码</span>
        <textarea></textarea>
    </div>
    <button id="submit" class="ico-submit"></button>
    <div id="output">
        <span>结果</span>
        <textarea class="copy-src"></textarea>
        <button class="copy-all">复制</button>
    </div>
</div>
<div id="tool-service_num">
    <span>已累计压缩<b>${param.get("count")}</b>次代码</span>
</div>
<div id="tool-about">
    <span>Powered by <a target="_blank" href="https://github.com/yui/yuicompressor">YUI compressor</a></span>
</div>
<script>
    domready(function() {
        $('#choose-lang span').click(function () {
            $('#choose-lang span').each(function () {
                this.className = "";
            });
            this.className = "active";
            $('#input em').text(this.innerText);
        });
        let input = $('#input textarea');
        let output = $('#output textarea');
        let submit = $('#submit');
        submit.click(function () {
            let val = input.val();
            if (val.length === 0){
                alert('不能为空!');
                return;
            }
            submit.attr('disabled', 'true');
            $.ajax({
                success: function (re) {
                    output.val(re);
                }, complete: function () {
                    submit.removeAttr('disabled');
                },
                url: '${pageContext.request.contextPath}/compress', type: 'POST', timeoutSeconds: 10,
                data: {'type': $('#choose-lang .active').text(), 'val': val}, contentType: 'application/x-www-form-urlencoded;charset=utf-8'
            })
        });
    });
</script>
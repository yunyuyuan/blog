<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<script src="${pageContext.request.contextPath}/static/js/lib/md5.js"></script>
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
    .generate textarea{
        width: 75%;
        border: 1px solid;
        padding: 0.3rem;
        margin: 1.4rem 0;
        height: 10rem;
    }
    .generate > div{
        display: flex;
        align-items: center;
        width: 100%;
        justify-content: center;
    }
    .generate div button{
        border: 1px solid;
        border-radius: 0.2rem;
        background: rgb(170, 162, 255);
        padding: 0.2rem 0.4rem;
        font-size: 1rem;
        margin: 0 0.7rem;
    }
</style>
<div id="tool-container">
    <div class="generate">
        <textarea placeholder="请输入待处理字符串"></textarea>
        <div>
            <button>Hex</button>
            <button>B64</button>
            <button>Str</button>
        </div>
        <b></b>
        <textarea class="copy-src" placeholder="结果"></textarea>
        <button class="copy-all">复制</button>
    </div>
</div>
<div id="tool-about">
    <span>Powered by <a target="_blank" href="http://pajhome.org.uk/crypt/md5">MD5.js</a></span>
</div>
<script>
    $(document).ready(function() {
        let input = $('.generate textarea:first');
        let result = $('.generate textarea:last');
        $('.generate button').click(function () {
            let val = input.val();
            if (val.length === 0){
                alert('不能为空!');
                return;
            }
            let btn = $(this);
            if (btn.text() === 'Hex'){
                result.val(hex_md5(val));
            }else if (btn.text() === 'B64'){
                result.val(b64_md5(val));
            }else if (btn.text() === 'Str'){
                result.val(str_md5(val));
            }
        });
    })
</script>
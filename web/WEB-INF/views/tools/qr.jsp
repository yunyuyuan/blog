<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<style>
    #tool-container{
        width: 100%;
    }
    #input-text{
        display: flex;
        flex-direction: column;
        margin: 1rem 0;
        width: 60%;
    }
    #input-text span{
        font-size: 1rem;
        color: black;
        margin-bottom: 1rem;
    }
    #input-text textarea{
        font-size: 1rem;
        height: 6rem;
    }
    #qr-result{
        border-radius: 1.5rem;
        border: 1px solid black;
        width: 20rem;
        height: 20rem;
        padding: 1rem;
        background: white;
        margin: 1.5rem 0;
    }
</style>
<script src="${pageContext.request.contextPath}/static/js/lib/qrcode.min.js"></script>
<div id="tool-container">
    <label id="input-text">
        <span>输入文本或链接等</span>
        <textarea></textarea>
    </label>
    <button id="generate-qr" class="ico-submit"></button>
    <div id="qr-result"></div>
    <div id="tool-about">
        <span>Powered by <a target="_blank" href="https://github.com/davidshimjs/qrcodejs">qrcodejs</a></span>
    </div>
    <script>
        $(document).ready(function() {
            let qr_div = document.getElementById('qr-result');
            gen("你还真扫我啊");
            $('#generate-qr').click(function () {
                let text = $('#input-text textarea').val();
                if (text.length === 0){
                    alert('不能为空!');
                    return
                }
                gen(text);
            });
            function gen(text) {
                $(qr_div).empty();
                try {
                    new QRCode(qr_div, {
                        width: qr_div.scrollWidth * 0.9,
                        height: qr_div.scrollHeight * 0.9,
                        text: text,
                    });
                }catch (e) {
                    alert('啊噢，好像出错了→_→ '+e);
                    gen("你还真扫我啊");
                }
            }
        })
    </script>
</div>
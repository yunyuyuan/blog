<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<style>
    #tool-container{
        margin: 1.2rem 0;
        flex-wrap: wrap;
        flex-direction:  row;
    }
    #tool-container > div{
        margin: 0.8rem;
    }
    #tool-container > input{
        display: none;
    }
    #tool-img-div{
        width: 18rem;
        height: 18rem;
        order: 0;
        overflow: hidden;
        border-radius: 1rem;
        border: 3px dotted black;
        cursor: pointer;
    }
    #tool-img-div img{
        object-fit: contain;
        width: 100%;
        height: 100%;
        display: none;
    }
    #tool-img-div > div{
        width: 100%;
        height: 100%;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
    }
    #tool-img-div > div a{
        margin-top: 0.8rem;
        color: black;
        font-size: 1rem
    }
    #tool-mid-div{
        width: 4rem;
        display: flex;
        flex-direction: column;
        align-items: center;
        order: 1;
    }
    @keyframes rotate {
        0%{
            transform: rotate(0);
        }100%{
            transform: rotate(360deg);
         }
    }
    #tool-mid-div span{
        font-family: var(--ico-font);
        color: black;
        font-size: 2rem;
        cursor: pointer;
        margin-bottom: 1rem;
    }
    #tool-mid-div span:before{
        content: var(--ico-switch);
    }
    #tool-mid-div button:disabled{
        background: rgb(136, 136, 136);
    }
    #tool-str-div{
        display: flex;
        flex-direction: column;
        align-items: center;
        width: 20rem;
        height: 20rem;
        order: 2;
    }
    #tool-str-div textarea{
        width: 100%;
        height: 100%;
        border-radius: 1rem;
    }

    @media screen and (max-width: 1200px) and (min-height: 900px){
        #tool-mid-div{
            width: 100%;
        }
    }
</style>
<div id="tool-container">
    <input type="file" accept="image/*"/>
    <div id="tool-img-div">
        <img />
        <div>
            <span id="tool-choose-img"></span>
            <a>选择图片,可拖入(小于5M)</a>
        </div>
    </div>
    <div id="tool-mid-div">
        <span title="对调"></span>
        <button class="ico-submit"></button>
    </div>
    <div id="tool-str-div">
        <textarea class="copy-src"></textarea>
        <button class="copy-all">复制</button>
    </div>
</div>
<script>
    domready(function () {
        let wait_img = undefined;
        let img_type = '';

        let img_div = $('#tool-img-div');
        let img_input = $('#tool-container > input');
        let img_div_img = $('#tool-img-div img');
        let choose_img_a = $('#tool-img-div a');
        let switch_ = $('#tool-mid-div span');
        let go = $('#tool-mid-div button');
        let str_div = $('#tool-str-div');
        let b64_input = $('#tool-str-div textarea');
        img_div.on('dragover', function(e){
            e.preventDefault();
            e.stopPropagation();
        });
        img_div[0].addEventListener('drop', function(e){
            e.preventDefault();
            e.stopPropagation();
            if (e.dataTransfer.files) {
                if (e.dataTransfer.files.length === 1) {
                    let f = e.dataTransfer.files[0];
                    process_input(f);
                }else{
                    alert("请选择一张图片!");
                }
            }
        });
        img_div.click(function () {
            if (parseInt(img_div.css('order')) === 0){
                img_input.click();
            }
        });
        img_input.change(function(){process_input(img_input[0].files[0])});
        function process_input(file) {
            if (file === undefined) return;
            if (file.size/1024 < 5120){
                choose_img_a.text("处理中...");
                img_input.attr('disabled', 'disabled');
                let reader = new FileReader();
                reader.readAsDataURL(file);
                reader.onload = function () {
                    let data_url = this.result;
                    let mid_img = new Image();
                    mid_img.src = data_url;
                    mid_img.onload = function(){
                        wait_img = mid_img;
                        img_type = file.type;
                        img_div_img.attr('src', data_url);
                        img_div_img[0].onload = function () {
                            choose_img_a.text("选择图片,可拖入(小于5M)");
                            img_input.removeAttr('disabled');
                        };
                        img_div_img.css('display', 'unset');
                    };
                };
            }else{
                alert("请选择5M以下的图片!");
            }
        }
        switch_.click(function () {
            if (this.getAttribute('data-g') !== 'f') {
                if (parseInt(img_div.css('order')) === 0) {
                    img_div.css('order', '2');
                    str_div.css('order', '0');
                    choose_img_a.css('display', 'none');
                    img_div_img.css('display', 'none');
                    img_div_img.removeAttr('src');
                    b64_input.val('');
                    b64_input.attr('placeholder', '请输入base64字符串(需要前缀)');
                } else {
                    img_div.css('order', '0');
                    str_div.css('order', '2');
                    choose_img_a.css('display', 'unset');
                    img_div_img.css('display', 'none');
                    img_div_img.removeAttr('src');
                    b64_input.val('');
                    b64_input.attr('placeholder', '等待输出结果');
                }
            }
        });
        go.click(function () {
            go.attr('disabled', 'disabled');
            switch_.css('animation', 'rotate 1s linear infinite');
            switch_.attr('data-g', 'f');
            if (parseInt(img_div.css('order')) === 0) {
                if (wait_img !== undefined) {
                    $('#tool-str-div textarea').val(img_div_img.attr('src'));
                }else{
                    go.removeAttr('disabled');
                    switch_.css('animation', 'none');
                    switch_.attr('data-g', 't');
                    alert('请选择图片!');
                    return;
                }
            }else{
                let input_data = b64_input.val();
                img_div_img.css('display', 'unset');
                img_div_img.attr('src', input_data);
            }
            go.removeAttr('disabled');
            switch_.css('animation', 'none');
            switch_.attr('data-g', 't');
        });
    });
</script>
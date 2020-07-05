<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<style>
    #tool-container{
        margin: 1.2rem 0;
        flex-wrap: wrap;
    }
    #tool-container > input{
        display: none;
    }
    #input{
        width: 18rem;
        height: 18rem;
        order: 0;
        overflow: hidden;
        border-radius: 1rem;
        border: 3px dotted black;
        cursor: pointer;
    }
    #input img{
        width: 100%;
        height: 100%;
        object-fit: contain;
        display: none;
    }
    #input div{
        width: 100%;
        height: 100%;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
    }
    #input a{
        color: black;
    }
    #operate{
        width: calc(100% - 2.4rem);
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 1.2rem;
        font-size: 1.2rem
    }
    #operate label{
        color: black;
    }
    #operate select{
        font-size: 0.9em;
    }
    #operate button{
        margin-left: 0.7rem;
    }
    .result-img{
        width: 7rem;
        height: 7rem;
    }
    #tool-container > b{
        width: 100%;
        height: 1.5rem;
        font-size: 0.9rem;
        color: rgb(255, 40, 42);
        text-align: center;
    }
</style>
<div id="tool-container">
    <input type="file" accept="image/*"/>
    <div id="input">
        <img />
        <div>
            <span id="tool-choose-img"></span>
            <a>选择图片,可拖入(小于5M)</a>
        </div>
    </div>
    <div id="operate">
        <label>
            选择尺寸
            <select disabled>
                <option value="16">16*16</option>
                <option value="32">32*32</option>
                <option value="64">64*64</option>
                <option value="128">128*128</option>
            </select>
        </label>
        <button disabled class="ico-submit"></button>
    </div>
    <b></b>
    <img class="result-img" style="display: none" alt="result"/>
    <div id="tool-service_num">
        <span>已累计转换<b>${param.get("count")}</b>次图片</span>
    </div>
    <div id="tool-about">
        <span>Powered by <a target="_blank" href="https://github.com/imcdonagh/image4j">Image4j</a></span>
    </div>
    <script>
    domready(function () {
        let temp_img = new Image();
        let img_blob = '';

        let img_input = $('#tool-container > input');
        let input_div = $('#input');
        let img_show = $('#input img');
        let submit = $('#operate button');
        let status = $('#tool-container > b');
        input_div.click(function () {
            img_input.click();
        });
        input_div.on('dragover', function(e){
            e.preventDefault();
            e.stopPropagation();
        });
        input_div[0].addEventListener('drop', function(e){
            e.preventDefault();
            e.stopPropagation();
            if (e.dataTransfer.files) {
                if (e.dataTransfer.files.length === 1) {
                    process_img(e.dataTransfer.files[0]);
                }else{
                    alert("请选择且仅选择一张图片!");
                }
            }
        });
        let select_size = $('#tool-container select');
        select_size.change(draw_img);
        function draw_img() {
            let size = select_size.val();
            let canvas = document.createElement('canvas');
            let ctx = canvas.getContext('2d');
            canvas.setAttribute('width', size);
            canvas.setAttribute('height', size);
            ctx.drawImage(temp_img, 0, 0, size, size);
            canvas.toBlob(function(blob){
                img_blob = blob;
            }, 'image/png', 1);
        }
        img_input.change(function (){process_img(img_input[0].files[0])});
        function process_img(file) {
            if (file === undefined) return;
            if (file.size/1024 < 5120) {
                let reader = new FileReader();
                reader.readAsDataURL(file);
                reader.onload = function () {
                    let url = this.result;
                    img_show.attr('src', url);
                    img_show.css('display', 'unset');
                    temp_img.src = url;
                    temp_img.onload = function () {
                        draw_img();
                        submit.removeAttr('disabled');
                        $('#tool-container select').removeAttr('disabled');
                    }
                }
            }else{
                alert("请选择5M以下的图片!");
            }
        }
        submit.click(function () {
            if (img_blob === ''){
                alert('请选择图片');
            }else{
                update_img();
            }
        });
        let img = $('.result-img');
        function update_img() {
            img.css('display', 'unset');
            img.attr('src', path+'/static/img/constant/loading.gif');
            let form_data = new FormData();
            form_data.append('img', img_blob);
            let xml = new XMLHttpRequest();
            xml.responseType = 'arraybuffer';
            submit.attr('disabled', 'true');
            select_size.attr('disabled', 'true');
            status.text('处理中...');
            xml.open('POST', '${pageContext.request.contextPath}/genico', true);
            xml.send(form_data);
            xml.onreadystatechange = function(){
                if (xml.status === 200) {
                    img.attr('src', (window.URL || window.webkitURL).createObjectURL(new Blob([xml.response], {type: xml.getResponseHeader('Content-Type')})));
                    status.text('成功!请右键另存图片');
                    submit.removeAttr('disabled');
                    select_size.removeAttr('disabled');
                }
                else{
                    img.css('display', 'none');
                }
            };
        }
    })
    </script>
</div>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<style>
    .zoom-img{
        cursor: zoom-in;
    }
    #zoom-div{
        display: none;
        z-index: 1001;
        position: fixed;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.9);
    }
    #zoom-wrap{
        width: 100%;
        height: 100%;
        display: flex;
        flex-direction: column;
    }
    #zoom-wrap > div{
        display: flex;
        align-items: center;
        justify-content: center;
    }
    #zoom-head{
        height: 4rem;
    }
    #zoom-head label{
        display: flex;
        align-items: center;
        justify-content: center;
        flex: 1 0 auto;
    }
    #zoom-head label b{
        color: white;
        font-size: 1.2rem;
    }
    #zoom-head label input{
        background: linear-gradient(to right, rgb(255, 177, 0), rgb(255, 0, 165));
    }
    #zoom-head label a{
        color: rgb(86, 255, 0);
        font-weight: bold;
        font-size: 1.2rem;
        width: 3rem;
    }
    #zoom-head span{
        transition: transform .2s linear;
        margin: 0 0.5rem;
        cursor: pointer;
    }
    #zoom-head span:after{
        font-family: var(--ico-font);
        font-weight: bold;
        font-size: 2rem;
        background: white;
        padding: 0.6rem;
        border-radius: 50%;
    }
    #zoom-head span:first-of-type:after{
        content: var(--ico-save);
        color: rgb(0, 93, 255);
    }
    #zoom-head span:last-of-type:after{
        content: var(--ico-close);
        color: red;
    }
    #zoom-head span:first-of-type:hover{
        transform: scale(1.08);
    }
    #zoom-head span:last-of-type:hover{
        transform: rotate(180deg);
    }
    #zoom-body{
        height: calc(100% - 12rem);
    }
    #zoom-show{
        border: 0.1rem solid white;
        width: 80%;
        height: 90%;
        overflow: hidden;
        display: flex;
        justify-content: center;
        background: rgba(0, 0, 0, 0.6);
        cursor: grab;
    }
    #zoom-show:active{
        cursor: grabbing;
    }
    #zoom-show img{
        object-fit: contain;
        position: relative;
        left: 0;
        top: 0;
    }
    div#zoom-list{
        height: 8rem;
        width: 100%;
        overflow: auto;
        display: flex;
        justify-content: center;
        position: relative;
    }
    div#zoom-list > div{
        height: 100%;
        min-width: 100%;
        display: flex;
        justify-content: center;
        flex-wrap: nowrap;
        align-items: flex-end;
        position: absolute;
        left: 0;
    }
    #zoom-list span{
        width: 10rem;
        height: 80%;
        margin: 0 0.5rem;
        border: 0.1rem solid transparent;
        cursor: pointer;
        position: relative;
    }
    #zoom-list span.active{
        border: 0.1rem solid white;
        display: flex;
        justify-content: center;
    }
    #zoom-list span.active:before{
        font-family: var(--ico-font);
        content: var(--ico-tri);
        color: rgb(255, 132, 0);
        font-size: 2rem;
        transform: rotate(180deg);
        position: absolute;
        top: -1.8rem;
    }
    #zoom-list img{
        height: 100%;
        width: 100%;
        object-fit: contain;
    }
    @media screen and (max-width: 1200px) and (min-height: 900px){
        #zoom-show{
            width: 98%;
        }
    }
</style>
<div id="zoom-div">
    <div id="zoom-wrap">
        <div id="zoom-head">
            <span title="保存" onclick="zoom_download()"></span>
            <label>
                <b>缩放:</b>
                <input type="range" min="50" max="300" value="100" />
                <a>100%</a>
            </label>
            <span title="关闭" onclick="$('#zoom-div').fadeOut(100)"></span>
        </div>
        <div id="zoom-body">
            <div id="zoom-show"></div>
        </div>
        <div id="zoom-list">
            <div></div>
        </div>
    </div>
</div>
<script>
    document.querySelector('#zoom-head input').addEventListener('input', zoom_scale_change);
    function zoom_scale_change(){
        let input = document.querySelector('#zoom-head input');
        input.nextElementSibling.innerText = input.value + '%';
        let img = document.querySelector('#zoom-show img');
        if (img !== null && img !== undefined){
            img.style.transform = 'scale('+input.value/100+')';
        }
    }
    document.querySelector('#zoom-show').addEventListener('mousewheel', function (e) {
        e.preventDefault();
        e.stopPropagation();
        let img = document.querySelector('#zoom-show img');
        let input = document.querySelector('#zoom-head input');
        if (img !== null && img !== undefined){
            input.value = parseInt(input.value)+((e.deltaY>0)?-10:10);
        }
        zoom_scale_change();
    });
    function zoom_download() {
        let im = document.querySelector('#zoom-show img');
        let s = im.src;
        if (im.getAttribute('data-o') !== null){
            s = im.getAttribute("data-o");
        }
        let a = document.createElement('a');
        a.href = s;
        a.download = '';
        a.target = '_blank';
        a.click()
    }
</script>
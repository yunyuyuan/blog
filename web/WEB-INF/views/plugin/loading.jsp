<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<style>
    #loading{
        width: 100%;
        height: 100%;
        position: fixed;
        display: none;
        background: rgba(255, 255, 255, 0.95);
        z-index: 999;
    }
    #loading > div{
        width: 100%;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    #loading-wrap{
        width: 12rem;
        height: 12rem;
        position: relative;
        overflow: hidden;
    }
    .loading-line{
        width: 80%;
        height: 80%;
        position: absolute;
        background: transparent;
        top: 0;
        left: 0;
        border-left-width: 0.75rem;
        border-left-style: solid;
        border-radius: 50%;
        z-index: 1000;
    }
    @keyframes loading-atom1 {
        100% {
            transform: rotateZ(120deg) rotateX(66deg) rotateZ(360deg);
        }
    }
    @keyframes loading-atom2 {
        100% {
            transform: rotateZ(240deg) rotateX(66deg) rotateZ(360deg);
        }
    }
    @keyframes loading-atom3 {
        100% {
            transform: rotateZ(360deg) rotateX(66deg) rotateZ(360deg);
        }
    }
    .loading-1{
        border-left-color: rgb(240, 162, 0);
        transform: rotate(120deg) rotateX(66deg) rotate(0deg);
        animation: loading-atom1 1s linear infinite;
    }
    .loading-2{
        border-left-color: rgb(255, 0, 228);
        transform: rotate(240deg) rotateX(66deg) rotate(0deg);
        animation: loading-atom2 1s linear infinite;
    }
    .loading-3{
        border-left-color: rgb(5, 50, 237);
        transform: rotate(1turn) rotateX(66deg) rotate(0deg);
        animation: loading-atom3 1s linear infinite;
    }
</style>
<div id="loading">
    <div>
        <div id="loading-wrap">
            <div class="loading-line loading-1"></div>
            <div class="loading-line loading-2"></div>
            <div class="loading-line loading-3"></div>
        </div>
    </div>
</div>
<script>
    function show_loading() {
        $('#loading').fadeIn(200, 'linear', function(){document.querySelector('#container').style.overflowX = 'hidden'});
    }
    function hide_loading() {
        // 延迟显示
        setTimeout(function () {
            $('#loading').fadeOut(200, 'linear', function(){document.querySelector('#container').style.overflowX = 'unset'});
        });
    }
</script>
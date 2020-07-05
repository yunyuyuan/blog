<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<style>
    footer{
        width: 100%;
        background: rgba(233, 233, 233, 0.88);
        margin-top: auto;
    }
    footer .about-site{
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
    }
    footer .about-site p{
        font-weight: bold;
        font-size: 1rem;
        line-height: 2rem;
        letter-spacing: 0.05rem;
        background: rgba(159, 255, 224, 0.8);
        width: 100%;
        margin-bottom: 0.6rem;
        box-shadow: 0 0 10px rgb(214, 214, 214);
        display: flex;
        flex-direction: column;
        align-items: center;
    }
    footer .about-site p:after{
        content: ' ';
        width: 100%;
        height: 0.1rem;
        background: repeating-linear-gradient(45deg, rgb(255, 147, 35), rgb(255, 147, 35) 3rem, rgb(157, 27, 255) 3rem, rgb(157, 27, 255) 6rem);
    }
    footer .footer-column{
        margin: 0 2.5rem;
    }
    footer .footer-column > span{
        font-size: 0.9rem;
        color: rgb(68, 68, 68);
        margin: 0.8rem 0;
    }
    footer .href-row{
        display: flex;
        align-items: center;
        margin: 0.3rem 0;
        cursor: pointer;
    }
    footer .href-row img{
        width: 1.8rem;
        height: 1.8rem;
        margin-right: 10px;
        object-fit:  contain;
    }
    footer .href-row span{
        font-size: 0.8rem;
        color: rgb(17, 17, 17);
        text-decoration: underline;
    }
    footer .href-row:hover span{
        color: red;
    }
    footer .beian{
        width: 100%;
        height: 2.4rem;
        justify-content: center;
        display: flex;
        align-items: center;
        overflow: hidden;
    }
    footer .beian span{
        font-family: var(--ico-font);
        color: red;
        font-size: 1.6rem;
        margin-right: 10px;
    }
    footer .beian span:before{
        content: var(--ico-beian);
    }
    footer .beian a{
        font-size: 0.85rem
    }
</style>
<footer>
    <div class="about-site">
        <p><a>yunyuyuan的小站</a></p>
        <div class="footer-column">
            <span>本站相关</span>
            <a class="href-row" target="_blank" href='http://blog.phyer.cn'>
                <img src="https://blog.phyer.cn/static/img/favicon.png" alt="blog"/>
                <span>博客</span>
            </a>
            <a class="href-row" target="_blank" href='http://shop.phyer.cn'>
                <img src="https://shop.phyer.cn/static/img/favicon.png" alt="book"/>
                <span>购书</span>
            </a>
        </div>
        <div class="footer-column">
            <span>其他</span>
            <a class="href-row" target="_blank" href='https://github.com/yunyuyuan'>
                <img src="https://github.com/favicon.ico" alt="github"/>
                <span>github</span>
            </a>
            <a class="href-row" target="_blank" href='https://space.bilibili.com/204446485'>
                <img src="https://www.bilibili.com/favicon.ico" alt="bilibili"/>
                <span>bilibili</span>
            </a>
        </div>
    </div>
    <div class="beian">
        <span></span>
        <a target="_blank" href="http://beian.miit.gov.cn/">鄂ICP备19031393号</a>
    </div>
</footer>
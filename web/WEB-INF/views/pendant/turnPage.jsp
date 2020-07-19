<%@ page import="java.util.List" %>
<%@ page import="static cn.phyer.blog.tool.calcPageInfo" %>
<%@ page import="static cn.phyer.blog.tool.calcPageCount" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%
    int now_page = Integer.parseInt(request.getParameter("p"));
    int count = Integer.parseInt(request.getParameter("c"));
    int one_page_count = Integer.parseInt(request.getParameter("o"));
    String callback = request.getParameter("f");
    List<Integer> page_info = calcPageInfo(now_page, calcPageCount(one_page_count, count));
%>
<style>
    #turn-page{
        display: flex;
        align-items: center;
        justify-content: center;
        width: 100%;
        height: 3rem;
        margin: 1.3rem 0;
    }
    #turn-page > span{
        display: flex;
        align-items: center;
    }
    #turn-page svg{
        width: 2.8rem;
        height: 2.8rem;
        cursor: pointer;
    }
    #turn-page svg path{
        transition: fill .15s linear;
    }
    #turn-page svg:hover path:first-of-type{
        fill: rgb(46, 161, 255);
    }
    #turn-page a{
        width: 2rem;
        height: 1.8rem;
        background: rgb(144, 245, 255);
        margin: 0 0.3rem;
        text-align: center;
        line-height: 1.8rem;
        border-radius: 0.3rem;
        cursor: pointer;
        text-decoration: none;
        transition: background .12s linear, color .12s linear, box-shadow .12s linear;
    }
    #turn-page a.active{
        background: rgb(174, 74, 255);
        color: white;
    }
    #turn-page a:hover{
        box-shadow: 0 0 8px 1px white;
        background: rgb(101, 98, 255);
        color: white;
    }
    #turn-page b{
        width: 4rem;
        height: 1.6rem;
        color: white;
        text-align: center;
        line-height: 1rem;
        letter-spacing: 0.3rem;
        margin-left: 0.3rem;
    }
</style>
<div id="turn-page">
    <span title="上一页">
        <svg onclick="try{$('#turn-page .active')[0].previousElementSibling.click()}catch (e){}" class="turn-to-pre" viewBox="0 0 1024 1024" style="transform: rotate(180deg)">
            <path d="M512 929.959184c-230.4 0-417.959184-187.559184-417.959184-417.959184s187.559184-417.959184 417.959184-417.959184 417.959184 187.559184 417.959184 417.959184-187.559184 417.959184-417.959184 417.959184z" fill="#956ff6"></path><path d="M444.081633 689.632653c-5.22449 0-10.44898-2.089796-14.628572-6.269388-8.359184-8.359184-8.359184-21.420408 0-29.779592l156.734694-156.734693c8.359184-8.359184 21.420408-8.359184 29.779592 0 8.359184 8.359184 8.359184 21.420408 0 29.779591l-156.734694 156.734694c-4.702041 4.179592-9.926531 6.269388-15.15102 6.269388z" fill="#ffffff"></path><path d="M600.816327 532.897959c-5.22449 0-10.44898-2.089796-14.628572-6.269388l-156.734694-156.734693c-8.359184-8.359184-8.359184-21.420408 0-29.779592 8.359184-8.359184 21.420408-8.359184 29.779592 0l156.734694 156.734694c8.359184 8.359184 8.359184 21.420408 0 29.779591-4.702041 4.179592-9.926531 6.269388-15.15102 6.269388z" fill="#ffffff"></path>
        </svg>
    </span>
    <% for (int p: page_info){
        if (p == now_page){ %>
        <a title="第<%= p %>页" onclick="<%= callback %>(<%= p %>)" class='active'><%=p%></a>
        <% }else if(p!=0){ %>
        <a title="第<%= p %>页" onclick="<%= callback %>(<%= p %>)"><%=p%></a>
        <% }else{ %>
        <b>......</b>
        <% }
    } %>
    <span title="下一页">
        <svg onclick="try{$('#turn-page .active')[0].nextElementSibling.click()}catch (e){}" class="turn-to-next" viewBox="0 0 1024 1024">
            <path d="M512 929.959184c-230.4 0-417.959184-187.559184-417.959184-417.959184s187.559184-417.959184 417.959184-417.959184 417.959184 187.559184 417.959184 417.959184-187.559184 417.959184-417.959184 417.959184z" fill="#956ff6"></path><path d="M444.081633 689.632653c-5.22449 0-10.44898-2.089796-14.628572-6.269388-8.359184-8.359184-8.359184-21.420408 0-29.779592l156.734694-156.734693c8.359184-8.359184 21.420408-8.359184 29.779592 0 8.359184 8.359184 8.359184 21.420408 0 29.779591l-156.734694 156.734694c-4.702041 4.179592-9.926531 6.269388-15.15102 6.269388z" fill="#ffffff"></path><path d="M600.816327 532.897959c-5.22449 0-10.44898-2.089796-14.628572-6.269388l-156.734694-156.734693c-8.359184-8.359184-8.359184-21.420408 0-29.779592 8.359184-8.359184 21.420408-8.359184 29.779592 0l156.734694 156.734694c8.359184 8.359184 8.359184 21.420408 0 29.779591-4.702041 4.179592-9.926531 6.269388-15.15102 6.269388z" fill="#ffffff"></path>
        </svg>
    </span>
</div>
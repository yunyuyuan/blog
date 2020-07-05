domready(function () {
    add_archer();
    gen_code_block();
    get_comment(undefined, 'false');
    page_load();
});

// 产生二维码
function gen_qr(s) {
    let qr_div = s.nextElementSibling;
    s.style.display = 'none';
    qr_div.style.display = 'flex';
    new QRCode(qr_div, {
        width: qr_div.scrollWidth * 0.85,
        height: qr_div.scrollHeight * 0.85,
        text: location.href,
    });
}
// 添加锚点
function add_archer() {
    let root = $(document.documentElement);
    // 添加文章锚点
    let md = $('.mark-container');
    if (root.css('--is-phone') === 'f'){
        let archer_list = [];
        let archer_str = '';
        md.find('a[href^=\\#]').each(function () {
            archer_str += '<div><span></span><a href="'+this.getAttribute('href')+'">'+this.innerHTML+'</a></div>';
            archer_list[archer_list.length] = this.getAttribute('href');
        });
        if (archer_list.length > 0) {
            $('#show-wrap').removeAttr('style');
            let div = "<div id='md-archer'><div>" + archer_str + "</div></div>";
            let parent = document.getElementById('blog-content');
            parent.innerHTML = parent.innerHTML + div;
            let div_e = $('#md-archer');
            div_e.css('top', 'calc(50% - ' + div_e[0].offsetHeight / 2 + 'px)');

            window.removeEventListener('scroll', check_archer);
            window.addEventListener('scroll', check_archer);

            // 节流
            let archer_clock=true;
            function check_archer() {
                if (!archer_clock) {
                    return
                }
                archer_clock = false;
                setTimeout(function () {
                    for (let i = archer_list.length - 1; i >= 0; i--) {
                        let archer = archer_list[i];
                        if (typeof $(archer)[0] !== 'undefined' && $(archer)[0].getBoundingClientRect().y <= 1) {
                            div_e.find('> div div').each(function () {
                                let div = $(this);
                                if (div.find('a').attr('href') === archer) {
                                    if (!div.hasClass('active')) {
                                        div.addClass('active');
                                    }
                                } else {
                                    div.removeClass('active');
                                }
                            });
                            break;
                        }
                    }
                    archer_clock = true
                }, 50);
            }
            check_archer();
        }else{
            $('#show-wrap').css('margin-right', '0')
        }
    }
    // 平滑锚点跳转
    $("a[href^=\\#]").click(function(){
        if (location.pathname.replace(/^\//, '') === this.pathname.replace(/^\//, '') && location.hostname === this.hostname) {
            let href = decodeURI(this.hash);
            let target = $(href);
            target = target.length && target || $('[name=' + href.slice(1) + ']');
            if (target.length) {
                let targetOffset = target.offset().top;
                $('html,body').stop().animate({scrollTop: targetOffset},400);
                return false;
            }
        }
    });
    bind_singleload()
}
function turn_cmt_page(p){
    $('#comment-ul').attr('data-p', parseInt(p));
    get_comment(function () {$('html,body').animate({scrollTop: document.getElementById('comment-ul').offsetTop},200)});
}
// 获取评论
function get_comment(callback, sync){
    let comment_ul = $('#comment-ul');
    $.ajax({
        success: function (re) {
            let count = re[2].length;
            comment_ul.empty();
            show_page_info(re[1]);
            has_add_err = [];
            for (let i=0;i<count;i++){
                set_row_comment(re[0]-(parseInt(comment_ul.attr('data-p'))-1)*8-i, re[2][i]);
            }
            init_zoom();
            document.querySelectorAll('#comment-ul pre > code').forEach((e) => {
                gen_code_block(e);
            });
        },complete: function(){
            if (typeof sync === 'undefined') {
            }
            if ((typeof callback)!=="undefined"){
                callback();
            }
        },
        url: path+'/commentAction', type: 'POST', timeoutSeconds: 10,
        data: {'type': 'get', 'blog_id': location.href.replace(/.*\/(\d*)\??.*?$/, '$1'), "p": comment_ul.attr('data-p')}, dataType: 'json'
    })
}
// 页码信息
function show_page_info(info) {
    let div = document.getElementById('turn-page');
    let now_page = parseInt($('#comment-ul').attr('data-p'));
    $('#turn-page a, #turn-page b').each(function () {
        this.remove();
    });
    for (let i=0;i<info.length;i++){
        let p = parseInt(info[i]);
        if (p === 0){
            let b = document.createElement('b');
            b.innerText = '......';
            div.insertBefore(b, div.lastElementChild);
        }else {
            let a = document.createElement('a');
            a.setAttribute('onclick', 'turn_cmt_page(' + p + ')');
            a.innerText = p.toString();
            if (p === now_page) {
                a.className = 'active';
            }
            div.insertBefore(a, div.lastElementChild);
        }
    }
}
// 挨个设置评论
function set_row_comment(idx, row){
    let comment_ul = $('#comment-ul');
    let d = row[0],
        nickname = row[1],
        avatar = row[2],
        content = row[3],
        create_time = row[4],
        children = row[5];

    let li = document.createElement('li');

    let f_i;
    if ((has_add_err.indexOf(d) !== -1)){
        f_i = "src='"+avatar+"' data-need='"+d+"'";
    }else{
        f_i = "src='"+avatar+"' onerror='gen_err_avatar(this, \""+nickname[0]+"\", \""+d+"\")'";
    }
    let s = "<div class='comment-head'>" +
            "<img " + f_i + " alt='"+nickname+"'>" +
            "   <div>" +
            "       <a"+((d===0)?' data-m="t"':'')+">"+nickname +
            "           <span>"+create_time+"</span>" +
            "       </a>" +
            "       <strong>#"+idx+"</strong>" +
            "   </div>" +
            "</div>" +
            "<div class='comment-body'>" +
            "   <span>"+content+"</span>" +
            "   <button onclick='reply(this)' data-n='' data-d='"+d+"' data-i='"+idx+"'>回复</button>" +
            "</div>";
    has_add_err.push(d);
    if (children.length > 0) {
        s +="<div class='comment-children'>";
        for (let i = 0; i < children.length; i++) {
            let child_info = children[i];
            let f_i;
            if ((has_add_err.indexOf(child_info[0]) !== -1)){
                f_i = "src='"+child_info[2]+"' data-need='"+child_info[0]+"'";
            }else{
                f_i = "src='"+child_info[2]+"' onerror='gen_err_avatar(this, \""+child_info[1][0]+"\", \""+child_info[0]+"\")'";
            }
            s +="<div class='comment-child'>" +
                "   <div>" +
                "       <img " + f_i +" alt='"+child_info[1]+"'>" +
                "       <a"+((child_info[0]===0)?' data-m="t"':'')+">"+child_info[1] +
                "           <span>"+child_info[4]+"</span>" +
                "       </a>" +
                "       <span>"+((child_info[0]===0)?'&nbsp;&nbsp;&nbsp;&nbsp;':'')+child_info[3]+"</span>" +
                "   </div>" +
                "   <div>" +
                "       <button onclick='reply(this)' data-n='"+child_info[1]+"' data-d='"+child_info[0]+"' data-i='"+idx+"'>回复</button>" +
                "   </div>" +
                " </div>";
            has_add_err.push(child_info[0])
        }
        s += "</div>";

    }
    li.innerHTML = s;
    comment_ul[0].append(li);
}

// 生成文字头像
function gen_err_avatar(i, s, d) {
    let size = [i.offsetWidth, i.offsetHeight];

    let e = document.createElement('img');
    e.src = gen_text_img(size, s);
    i.parentElement.insertBefore($(e).clone()[0], i);
    i.remove();

    $("#comment-ul img[data-need='"+d+"']").each(function () {
        let c = $(e).clone();
        this.parentElement.insertBefore(c[0], this);
        this.remove();
    });
}
// 提交评论
function comment_submit(re, div) {
    $.ajax({
        success: function (r) {
            if (r === 1) {
                get_comment();
                clear_comment_div();
                div.find('.cmt-input textarea').val('');
            } else if (r === 0) {
                alert('验证码错误');
            }
        },
        url: path + '/commentAction', type: 'POST', timeoutSeconds: 10, dataType: 'json',
        data: {'type': 'set', 'c': re['code'], 'blog_id': location.href.replace(/.*\/(\d*)\??.*?$/, '$1'),
               'content': re['content'], 'to': re['to'], 'ref': re['ref'], 'rd': re['rd']}
    });
}
// 回复楼层
function reply(e){
    if (document.getElementById('comment-to-blog') !== null) {
        let btn = $(e);
        let nm = btn.attr('data-n'),
            d = btn.attr('data-d'),
            idx = btn.attr('data-i');
        let li = btn.parents('li');
        clear_comment_div();
        btn.addClass('cancel')
           .text('取消')
           .attr('onclick', 'cancel_reply(this)');

        let cmt_to_people_div = document.createElement('div');
        cmt_to_people_div.className = 'cmt';
        cmt_to_people_div.innerHTML = document.querySelector('#comment-to-blog').innerHTML.replace(/(<img title="刷新".*?src=").*? /, '$1'+path+'/static/img/constant/get_code.png" ');
        let cmt_to_people = $(cmt_to_people_div);
        cmt_to_people.attr('id', 'comment-to-people')
                     .attr('data-to', Math.floor(idx/8)+li.index())
                     .attr('data-d', d);

        if (nm !== "" && typeof nm !== 'undefined'){
            cmt_to_people.find('textarea').attr('placeholder', '回复@'+nm);
            cmt_to_people.attr('data-ref', nm);
        }
        // 清除code和输入
        let text = cmt_to_people.find('textarea');
        cmt_to_people.find('.cmt-input b').text(text.attr('maxlength'));
        text.val('');
        cmt_to_people.find('.cmt-go input').val('');
        li[0].append(cmt_to_people_div);
        $('body,html').animate({scrollTop: cmt_to_people[0].offsetTop - (document.body.clientHeight-2*cmt_to_people[0].scrollHeight)}, 100);
        cmt_to_people.css('display', 'none');
        cmt_to_people.slideDown(200, function () {
            this.style.display = 'flex';
        });
    }else{
        alert('请登录后回复');
    }
}
// 取消回复
function cancel_reply(e) {
    let btn = $(e);
    btn.removeClass('cancel')
       .text('回复')
       .attr('onclick', 'reply(this)');
    $('#comment-to-people').slideUp(150, function () {
        this.remove();
    });
}
// 清除回复框
function clear_comment_div() {
    $('#comment-ul button').each(function () {
        this.className='';
        this.innerText='回复';
        this.setAttribute('onclick', 'reply(this)');
    });
    $('#comment-to-people').remove();
}
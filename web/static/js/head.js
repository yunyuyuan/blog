domready(function () {
    phone_handle();
    // menu按钮
    let menu = document.querySelector('#-head-menu');
    menu.onclick = function(){
        let head_main = this.parentElement;
        if (head_main.getAttribute('data-tog') === 'up'){
            tag_hide_show(true);
            setTimeout(function () {
                win_blur(head_main, function (e) {
                    if (e.getAttribute('data-tog') === 'down') {
                        tag_hide_show(false)
                    }
                }, '.-head-tag');
            }, 200)
        }else{
            tag_hide_show(false)
        }
    };

   // ----------------------------------------- //

    let state = $('#login-wrap > b');
    // 显示登录框
    $('#-head-login').click(function () {
        $('#login-div').fadeIn(200, function () {
            win_blur(this.firstElementChild.children[0], function (e) {
                $(e).parent().parent().fadeOut(200);
            }, '#login-div .login-close');
        });
    });
    // 显示设置框
    $('#-head-other span[title="设置"]').click(function () {
        $('#-head-set').fadeIn(150, function () {
            win_blur(this.firstElementChild.firstElementChild, function (e) {
                $(e).parent().parent().fadeOut(150);
            }, '#-head-set .set-head > span')
        })
    });

    // 登出
    $('#login-wrap > button').click(function () {
        $.ajax({
            success: function () {
                location.reload();
            },
            url: path+'/publicAction', type: 'POST', timeoutSeconds: 10,
            data: {'type': 'logout'}
        })
    });
    // 修改邮箱
    let e_input = $('#input_e');
    let check_mail_s = '^[A-Za-z\\d]+([-_.][A-Za-z\\d]+)*@([A-Za-z\\d]+[-.])+[A-Za-z\\d]{2,4}$';
    $('#change_email').click(function () {
        let v = e_input.val();
        if (v==='' || v.search(check_mail_s)===0){
            state.text('处理中...');
            $.ajax({
                success: function (r) {
                    if (r===1){
                        state.text('成功');
                    }else{
                        state.text('失败');
                    }
                }, complete: function () {
                    setTimeout(function () {state.text('')}, 2500)
                },
                url: path+'/publicAction', type: 'POST', timeoutSeconds: 10, dataType: 'json',
                data: {'type': 'change_email', 'v': v}, contentType: 'application/x-www-form-urlencoded;charset=utf-8'
            });
        }else{
            alert('格式错误!');
        }
    });

    // -----服务器产生随机代码,保证非滥用-------
    $('#login-main > img').click(function () {
        let p = this.alt;
        if (p === 'github'){
            login_ajax("https://github.com/login/oauth/authorize?client_id=Iv1.588e073872ef9d4d&redirect_uri=http://blog.phyer.cn/githubbind&state=");
        }else if (p === 'qq'){
            alert('抱歉，换了新域名qq还在审核');
            // login_ajax("https://graph.qq.com/oauth2.0/authorize?response_type=code&client_id=101845070&redirect_uri=http://blog.phyer.cn/qqbind&state=");
        }else if (p === 'ms'){
            login_ajax("https://login.microsoftonline.com/common/oauth2/v2.0/authorize?" +
                            "client_id=ccdd662b-a101-4323-9204-80fcea77ff21" +
                            "&response_type=code" +
                            "&redirect_uri=https%3A%2F%2Fblog.phyer.cn%2Fmsbind" +
                            "&response_mode=query" +
                            "&scope=openid%20offline_access%20https%3A%2F%2Fgraph.microsoft.com%2FUser.Read" +
                            "&state=")
        }
    });
    // 公共oauth2登录操作
    function login_ajax(url){
        let temp_win = window.open('_blank');
        $.ajax({
            success: function (r) {
                if (r.length !== 0){
                    temp_win.location.href = url+r;
                }else{
                    state.text('处理失败')
                }
            }, error: function (e) {
                state.text(e.state()+' 服务器错误')
            }, complete: function () {
                setTimeout(function(){state.text('')}, 2500);
            },
            url: path+'/publicAction', type: 'POST', timeoutSeconds: 10,
            data: {'type': 'get-bind-code'}
        });
    }

    // 回到顶部,节流
    let totop_clock = true;
    listen_scroll();
    $(window).scroll(listen_scroll);
    function listen_scroll() {
        if (!totop_clock) return;
        totop_clock = false;
        setTimeout(function () {
            if ((document.body.scrollTop||document.documentElement.scrollTop) > document.body.clientHeight){
                $("#to-top-img").stop(false, false, true).fadeIn(200);
            }else{
                $("#to-top-img").stop(false, false, true).fadeOut(200);
            }
            totop_clock = true;
        }, 50);
    }
});


// 错误头像
function err_avatar(e) {
    let w = Math.max(e.offsetWidth,e.offsetHeight);
    e.src = gen_text_img([w, w], e.getAttribute('data-s'));
}
// 设置手机屏幕
function phone_handle() {
    let root = document.querySelector(':root');
    let view = root.ownerDocument.defaultView;
    if (!view || !view.opener) {
        view = window;
    }
    if (view.getComputedStyle(root).getPropertyValue('--is-phone') === 't'){
        // 禁止缩放
        document.documentElement.addEventListener('touchstart', function (event) {
            if (event.touches.length > 1) {
                event.preventDefault();
            }
        }, false);
        let lastTouchEnd = 0;
        document.documentElement.addEventListener('touchend', function (event) {
            const now = Date.now();
            if (now - lastTouchEnd <= 300) {
                event.preventDefault();
            }
            lastTouchEnd = now;
        }, false);
    }
}
function tag_hide_show(what) {
    let head_main = document.querySelector('#-head-main');
    let tag_ctn = head_main.querySelector('div');
    if (what){
        head_main.setAttribute('data-tog', 'down');
        tag_ctn.style.height = 'unset';
        head_main.querySelectorAll('.-head-tag').forEach(function (e, i) {
            setTimeout(function () {
                $(e).animate({left: '0'}, 200, 'linear')
            }, i*100);
        });
    }else{
        head_main.setAttribute('data-tog', 'up');
        let tags = head_main.querySelectorAll('.-head-tag');
        tags.forEach(function (e, i) {
            setTimeout(function () {
                $(e).animate({left: '-100%'}, 200, 'linear')
            }, (tags.length-1-i)*100);
        });
        setTimeout(function(){tag_ctn.style.height = '0px';}, (tags.length-1)*100+200)
    }
}
function slide_other() {
    let other = $('#-head-other > div');
    if (other.attr('data-s') === 'f'){
        other.attr('data-s', 'l');
        other.animate({height: other[0].scrollHeight}, 200, 'linear', function () {
            win_blur(other[0].parentElement, function () {
                other.animate({height: 0}, 200, 'linear', function () {
                    other.attr('data-s', 'f')
                })
            }, '#-head-other div span')
        })
    }else{
        other.animate({height: 0}, 200, 'linear', function () {
            other.attr('data-s', 'f')
        })
    }
}
let path;
let ignore_head = ['share.js', 'jquery.min.js', 'headroom.min.js', 'head.js', 'all_need.css', 'head.css'];
// 加载错误头像
let has_add_err = [];
// 小表情
let stk_info = {
    "al": ['阿鲁', 143, 3.5],
    "xrt": ['小贱萌', 74, 3.5],
    "ka": ['emoji', 93, 3.5]
};
domready(function () {
    path = document.getElementById('-head-container').getAttribute('data-path');
    let root = $(document.documentElement);
    let head_height = parseInt(root.css('--head-height').replace('px'));
    // 设置headroom
    let my_headroom = new Headroom(document.querySelector('#-head-container'), {
        offset : head_height,
        tolerance : 1,
    });
    my_headroom.init();
    // 改变颜色
    $('.set-color span').click(function () {
        let root = $(document.documentElement);
        let mode = this.title.toLowerCase();
        root.css('--c-c', 'var(--' + mode + '-c)');
        root.css('--f-c', 'var(--' + mode + '-f)');
        document.body.className = mode + '-mod';
        let that = this;
        $('.set-color span').each(function () {
            this.setAttribute('data-c', (that === this) ? 't' : '');
        });
        localStorage.setItem('color_mod', mode);
    });
    // 图片懒加载，节流
    let has_do_load = false;
    $(window).scroll(function () {
        if (!has_do_load){
            load_lazy();
            setTimeout(function () {
                has_do_load = false;
            }, 50);
            has_do_load = true;
        }
    });
    // 绑定popState
    if (window.history) {
        window.addEventListener('popstate', function (e) {
            e.preventDefault();
            ajax_url(location.href)
        })
    }
    console.log('代码改变世界(●ˇ∀ˇ●)');
});


// 生成文字图片
function gen_text_img(size, s) {
    let colors = [
        "rgb(239,150,26)", 'rgb(255,58,201)', "rgb(111,75,255)", "rgb(36,174,34)", "rgb(80,80,80)"
    ];
    let cvs = document.createElement("canvas");
    cvs.setAttribute('width', size[0]);
    cvs.setAttribute('height', size[1]);
    let ctx = cvs.getContext("2d");
    ctx.fillStyle = colors[Math.floor(Math.random()*(colors.length))];
    ctx.fillRect(0, 0, size[0], size[1]);
    ctx.fillStyle = 'rgb(255,255,255)';
    ctx.font = size[0]*0.6+"px Arial";
    ctx.textBaseline = "middle";
    ctx.textAlign = "center";
    ctx.fillText(s,size[0]/2,size[1]/2);

    return  cvs.toDataURL('image/jpeg', 1);
}
// 懒加载
function load_lazy() {
    $('.lazy-img:not([data-l])').each(function () {
        let y = this.getBoundingClientRect().top;
        if ((y+this.offsetHeight >= 0 && y <= document.body.clientHeight) || this.getAttribute('data-main') === 't') {
            this.src = this.getAttribute('data-s');
            this.setAttribute('data-l', '');
        }
    });
}
// 图片放大
function init_zoom() {
    $('.zoom-img').each(function () {
        let img = this;
        if (!(img.getAttribute('onclick') !== null && img.getAttribute('onclick') !== undefined)){
            img.setAttribute('onclick', 'zoom_this(this)');
        }
    })
}
// 放大
function zoom_this(img) {
    $('#zoom-div').fadeIn(100, 'linear');
    set_zoom_img(img);
    // 添加其余的
    let all_div = $('#zoom-list > div');
    all_div.empty();
    $('.zoom-img').each(function () {
        let span = document.createElement('span');
        let im = new Image();
        if (this === img){
            span.className = 'active';
        }
        if (this.className.search('lazy-img') !== -1){
            im.src = this.getAttribute('data-s');
        }else{
            im.src = this.src;
        }
        im.setAttribute('onerror', `this.onerror="";this.src="${path}/static/img/constant/error.jpg"`);
        im.setAttribute('onclick', 'set_zoom_img(this);document.querySelectorAll("#zoom-list span").forEach(function(i){i.className=""});this.parentElement.className="active"');
        span.append(im);
        all_div[0].append(span);
    })
}
// 添加zoom
function set_zoom_img(img) {
    $('#zoom-head input').val(100);
    $('#zoom-head a').text('100%');
    let im = new Image();
    im.src = img.src;
    if (img.getAttribute("data-s") !== null){
        im.setAttribute('data-o', img.getAttribute("data-s"));
    }
    // 清除并添加
    let show_div = document.querySelector('#zoom-show');
    $(show_div).empty();
    show_div.append(im);
    // 拖动
    let pos = [0, 0];
    let old_pos = [0, 0];
    let last_pos = [0, 0];
    let grabed = false;
    im.ondragstart = function (e) {e.preventDefault()};
    show_div.onmousedown = show_div.ontouchstart = function (e) {
        e.stopPropagation();
        e.preventDefault();
        pos = [e.pageX, e.pageY];
        if (typeof e.pageX === "undefined"){
            pos = [e.touches[0].clientX, e.touches[0].clientY];
        }
        grabed =true;
        document.onmouseup = document.ontouchend = function () {
            grabed = false;
            old_pos = [last_pos[0], last_pos[1]];
        };
        document.onmousemove = document.ontouchmove = function (e) {
            if (!grabed) return;
            let n_pos = [e.pageX, e.pageY];
            if (typeof e.pageX === "undefined"){
                n_pos = [e.touches[0].clientX, e.touches[0].clientY];
            }
            last_pos = [old_pos[0] + n_pos[0] - pos[0], old_pos[1] + n_pos[1] - pos[1]];
            im.style.left = last_pos[0] + 'px';
            im.style.top = last_pos[1] + 'px';
        };
    };
}
// 到顶
function to_top() {
    $('body,html').animate({scrollTop: 0}, 300);
}
// blur
function win_blur(element, callback, close_btn) {
    function fire(e){
        let elem = e.target;
        while (elem) {
            if (elem === element) {
                return;
            }
            elem = elem.parentElement;
        }
        $(document).unbind('click', fire);
        callback(element);
    }
    $(document).bind('click', fire);
    if (close_btn !== undefined) {
        $(close_btn).click(function () {
            $(document).unbind('click', fire);
            callback(element);
        });
    }
}
// 代码块
function gen_code_block(e) {
    if (typeof e != 'undefined'){
        do_it(e);
        return
    }
    e = 'pre > code:not(.code-tabled)';
    $(e).each(function () {
        do_it(this)
    });
    function do_it(e) {
        let s = e.innerText;
        let num_ul = '<ul class="num-ul code-ul">',
            code_div = '<div class="code-main '+e.className+'"><ul class="content-ul code-ul">';
        let matchs = s.match(/[^\n]*?\n/g);
        matchs.forEach(function (s, i) {
            s = $('<span/>').text(s).html();
            num_ul += `<li>${i+1}</li>`;
            code_div += `<li>${s}</li>`;
        });
        e.innerHTML = `<div class="code-div">${num_ul}</ul>${code_div}</ul></div></div>`;
        let code = $(e);
        code.addClass('code-tabled');
        hljs.highlightBlock(e.querySelector('.code-main'));
    }
}
// 绑定无刷新跳转
function bind_singleload() {
    if (window.history) {
        $('a[data-singleload]').each(function () {
            this.removeEventListener('click', _bind_singlaload);
            this.addEventListener('click', _bind_singlaload);
        })
    }
}
function _bind_singlaload(e) {
    e.preventDefault();
    let a = this;
    ajax_url(a.href, function () {
        window.history.pushState('', 'none', a.href)
    })
}
function ajax_url(u, callback) {
    show_loading();
    $.ajax({
        success: function (r) {
            let html = document.createElement('html');
            html.innerHTML = r;
            // title
            document.title = html.querySelector('head title').innerText;
            // keyword
            document.querySelector('head meta[name="description"]').content = html.querySelector('head meta[name="description"]').content;
            // content
            $('#show-wrap').html(html.querySelector('#show-wrap').innerHTML);
            setTimeout(function () {
                load_lazy()
            }, 1000);
            // css
            document.querySelectorAll('head link[rel="stylesheet"]').forEach(function (e) {
                if (ignore_head.indexOf(e.href.replace(/.*\/(.*?\.css)/, '$1')) === -1){
                    e.remove();
                }
            });
            html.querySelectorAll('head link[rel="stylesheet"]').forEach(function (e) {
                let s = document.createElement('link');
                s.rel = 'stylesheet';
                s.href = e.href;
                s.onload = function(){
                };
                document.head.append(s);
            });
            if (typeof callback !== 'undefined') callback();
            // script
            document.querySelectorAll('head script').forEach(function (e) {
                if (ignore_head.indexOf(e.src.replace(/.*\/(.*?\.js)/, '$1')) === -1){
                    e.remove();
                }
            });
            // js同步加载防止错位
            download_js();
            function download_js(){
                let e = html.querySelector('head script');
                if (typeof e !== 'undefined' && e !== null) {
                    let s = document.createElement('script');
                    s.src = e.src;
                    e.remove();
                    document.head.append(s);
                    if (e.getAttribute('onerror') !== null){
                        s.onerror = function () {
                            exchange(s, e.getAttribute('onerror').replace(/^.*?(\/.*\.js).*/, '$1'), download_js);
                        }
                    }
                    s.onload = download_js;
                }
            }
        },
        beforeSend: function (xhr) {
            xhr.setRequestHeader('x-single', 't');
        },
        url: u, type: 'GET', timeoutSeconds: 10
    });
}
// 拼接参数
function splice_para() {
    return location.search.replace(/[?&]p=\d*/, '').replace(/^[?&]/, '&');
}
// 初始化
function page_load() {
    bind_singleload();
    hide_loading();
    load_lazy();
    init_zoom();
}
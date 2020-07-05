// 实时更新字数
function cmt_update_textarea(e) {
    e.previousElementSibling.children[0].innerText = parseInt(e.getAttribute('maxlength')) - e.value.length;
}
// 刷新验证码
function flush_img(e) {
    if (e.src !== path+'/static/img/constant/loading.gif') {
        // 清除已有的
        $('.cmt-go img').each(function () {
            if (e !== this) {
                this.src = path + '/static/img/constant/get_code.png';
            }
        });
        let code = $(e);
        code.attr('src', path + '/static/img/constant/loading.gif');
        $.ajax({
            success: function (re) {
                if (re.search('data:img/jpg;base64,') === 0) {
                    code.attr('src', re);
                }
            }, error: function () {
                code.attr('src', path + '/static/img/constant/get_code.png');
            },
            url: path + "/publicAction", type: 'POST', timeoutSeconds: 10,
            dataType: 'text', data: {'type': 'get-code'}
        })
    }
}
function cmt_submit(btn, callback) {
    let div = $(btn).parents('.cmt');
    let re = {};
    let code_input = div.find('.cmt-go input');
    re['code'] = code_input.val();
    if (re['code'].length !== 4) {
        alert('请输入4位验证码!');
        return
    }
    let content_input = div.find('.cmt-input textarea');
    re['content'] = content_input.val();
    if(re['content'].length === 0) {
        alert('不能为空');
        return;
    }
    re['to'] = div.attr('data-to');
    re['ref'] = div.attr('data-ref');
    re['rd'] = div.attr('data-d');
    // 删除验证码
    code_input.val('');
    div.find('.cmt-go img').attr('src', path+'/static/img/constant/get_code.png');
    callback(re, div);
}

// 表情
function cmt_stk(span) {
    html_cmt_ric(span, '.cmt_stk_div', function () {
        let divide = 100/Object.keys(stk_info).length;

        let cate_spans='',
            cate_divs='';
        let index = 0;
        for (let key in stk_info) {
            let info = stk_info[key];
            cate_spans +=`<span title='${info[0]}' onclick='swip_stk(this, ${index})'>${info[0]}</span>`;
            cate_divs += `<div style='width: ${divide}%'>`;
            for (let i = 1; i <= info[1]; i++) {
                cate_divs += `<img onclick='insert_stk(this)' data-k='${key+'/'+i}' src='${path}/static/img/constant/loading.gif' data-s='${path}/static/img/sticker/${key+'/'+i}.png' style='width: ${info[2]}rem; height: ${info[2]}rem;' alt='${key}'>`;
            }
            cate_divs += "</div>";
            index += 1;
        }
        return  "<div class='cmt_stk_div'><div>" +
                "   <div class='cmt_stk_swc'>" +
                "       <a></a>" +
                "       <div>" +
                cate_spans +
                "       </div>" +
                "   </div>" +
                "   <div class='cmt_stk_cnt'>" +
                "       <div class='cmt_stk_wp'>" +
                cate_divs +
                "       </div>" +
                "   </div>" +
                "</div></div>";
    }, function (e) {
        $(e).find('.cmt_stk_wp img').each(function () {
            this.src = this.getAttribute('data-s');
        })
    });
}
function swip_stk(s, e) {
    let left = parseInt(e);
    let span = $(s);
    span.parent().siblings('a').css('left', left*s.offsetWidth + 'px');
    span.parents('.cmt_stk_swc').next().css('left', left * -100 + 100 + '%');
}
function insert_stk(i) {
    insert_cm_rich('  ${emoji}'+ i.getAttribute('data-k')+'￥{emoji}  ', i);
}
// 图片
function cmt_img(span) {
    html_cmt_ric(span, '.cmt_img_div', function () {
        return  "<div class='cmt_img_div'><div>" +
            "   <div>" +
            "       <a class='active' onclick='swc_cmt_img(this, \"i\")'>上传图片</a>" +
            "       <a onclick='swc_cmt_img(this, \"u\")'>输入链接</a>" +
            "   </div>" +
            "   <div data-t='i'>" +
            "       <input type='file' accept='image/*' onchange='$(this).siblings(\"span\").text(this.files[0].name)'/>" +
            "       <span onclick='this.previousElementSibling.click()'>选择图片</span>" +
            "       <button onclick='sm_ms_upload(this)'>上传</button>" +
            "   </div>" +
            "   <button style='display: none' onclick='insert_img(this)' class='ico-submit ico-submit-b'></button>" +
            "</div></div>";
    }, function () {
    })
}
// 切换
function swc_cmt_img(e, w) {
    let d = e.parentElement.nextElementSibling;
    let s;
    e.className = 'active';
    if (w === 'u'){
        e.previousElementSibling.className = '';
        s = "<input type='url' placeholder='输入图片链接'/>";
        d.parentElement.querySelector('.ico-submit').style.display = 'unset';
    }else{
        e.nextElementSibling.className = '';
        s = "<input type='file' accept='image/*' onchange='$(this).siblings(\"span\").text(this.files[0].name)'/>" +
            "<span onclick='this.previousElementSibling.click()'>选择图片</span>" +
            "<button onclick='sm_ms_upload(this)'>上传</button>";
        d.parentElement.querySelector('.ico-submit').style.display = 'none';
    }
    d.innerHTML = s;
    d.setAttribute('data-t', w);
}
// 上传
function sm_ms_upload(btn) {
    let d = btn.parentElement;
    let s = d.querySelector('input');
    if (s.files.length === 0){
        alert("请选择图片");
        return;
    }
    let f = s.files[0];
    if (f.size/1024 >= 2048){
        alert('2M以下!');
        return;
    }
    d.querySelector('span').innerText = f.name;
    btn.setAttribute('disabled', 'disabled');
    btn.innerText = '上传中';
    let form = new FormData();
    form.append('f', f);
    $.ajax({
        success: function (r) {
            if (r === -1) {
                alert('每天最多发送2M以下图片20张!')
            } else if (r === 0) {
                alert('发送失败')
            } else {
                insert_cm_rich('  ${img}' + r[0] + '￥{img}  ', d)
            }
        }, error: function (e) {
            alert(e.state()+'上传错误');
        }, complete: function(){
            btn.removeAttribute('disabled');
            btn.innerText = '上传';
        },
        url: path+'/imgUpload', type: 'POST', timeoutSeconds: 10,
        data: form, dataType: 'json', processData: false, contentType: false
    })
}
function insert_img(btn) {
    let v = btn.parentElement.querySelector('input').value;
    if (v.search(/https?:\/\//) === -1){
        alert('请输入正确的url!');
        return
    }
    insert_cm_rich(`  \${img}${v}￥{img}  `, btn)
}

// 链接
function cmt_url(span) {
    html_cmt_ric(span, '.cmt_url_div', function () {
        return  "<div class='cmt_url_div'><div>" +
                "   <input placeholder='文字'/>" +
                "   <textarea placeholder='链接'></textarea>" +
                "   <button onclick='insert_url(this)' class='ico-submit ico-submit-b'></button>" +
                "</div></div>";
    }, function () {

    })
}
function insert_url(btn) {
    let p = btn.parentElement;
    let t = p.querySelector('input').value;
    let u = p.querySelector("textarea").value;
    if (t.length === 0 || u.length === 0){
        alert('不能为空!');
    }else if (u.search(/https?:\/\//) === -1){
        alert('请输入正确的url!')
    }else {
        insert_cm_rich(`  \${url}[${t}]${u}\n￥{url}  `, btn)
    }
}
// 代码
function cmt_code(span) {
    html_cmt_ric(span, '.cmt_code_div', function () {
        let langs = "Apache|Bash|C#|C++|CSS|CoffeeScript|Diff|Go|HTML|XML|HTTP|JSON|Java|JavaScript|Kotlin|Less|Lua|Makefile|Markdown|Nginx|Objective-C|PHP|Perl|Properties|Python|Ruby|Rust|SCSS|SQL|Shell|Session|Swift|TOML|TypeScript|YAML|plaintext".split("|");
        let l = "";
        for (let i=0;i<langs.length;i++){
            l += `<option value='${langs[i]}'>${langs[i]}</option>`;
        }
        return  "<div class='cmt_code_div'><div>" +
                `   <select>${l}</select>` +
                "   <textarea placeholder='代码'></textarea>" +
                "   <button onclick='insert_code(this)' class='ico-submit ico-submit-b'></button>" +
                "</div></div>";
    }, function () {

    })
}
function insert_code(btn) {
    let p = btn.parentElement;
    let t = p.querySelector('select').value;
    let u = p.querySelector("textarea").value;
    if (u.length === 0){
        alert('不能为空!');
    }else{
        insert_cm_rich(`  \${code}[${t}]${u}\n￥{code}  `, btn)
    }
}

// ----------------------------------------------------------
// 获取光标位置
function get_cursor_pos(el) {
    let pos = 0;
    if ('selectionStart' in el) {
        pos = el.selectionStart;
    } else if ('selection' in document) {
        el.focus();
        let Sel = document.selection.createRange();
        let SelLength = document.selection.createRange().text.length;
        Sel.moveStart('character', -el.value.length);
        pos = Sel.text.length - SelLength;
    }
    return pos;
}
function insert_cm_rich(s, e) {
    let t = $(e).parents('.cmt').find('.cmt-input textarea')[0];
    let cs_i = get_cursor_pos(t);
    let old = t.value;
    t.value = (old.substring(0, cs_i) + s + old.substring(cs_i));
    cmt_update_textarea(t);
}
function slide_cmt_rich(div, callback) {
    $(document).unbind('click');
    $(div.parentElement).find(' > div').each(function () {
        this.style.display = 'none';
    });
    $(div).stop().slideDown(200, function () {
        win_blur(div, function (e) {
            $(e).stop().slideUp(200);
        });
        if (typeof callback !== 'undefined') {
            callback(div);
        }
    });
}
function html_cmt_ric(span, what, gen_s, callback) {
    let rich = span.parentElement;
    // 收起已显示的
    if (rich.querySelector(what) === null) {
        let s = gen_s();
        rich.innerHTML = rich.innerHTML + s;
        let div = rich.querySelector(what);
        slide_cmt_rich(div, callback);
    } else {
        let div = rich.querySelector(what);
        slide_cmt_rich(div);
    }
}
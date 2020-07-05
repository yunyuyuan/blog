$(document).ready(function () {
    let path = $('#-head-container').attr('data-path');

    let cover_input = $('#input-cover');
    let title_input = $('#input-title');
    let content_input = $('#input-content');
    let left_input = $('#left-input');
    let right_show = $('#right-show');
    $('#body textarea').bind('input propertychange', function(){show_result()});

    // 实时显示效果
    function show_result() {
        let old_top = document.body.scrollTop||document.documentElement.scrollTop;
        title_input[0].style.height = 'auto';
        title_input[0].style.height = title_input[0].scrollHeight + 'px';
        content_input[0].style.height = 'auto';
        content_input[0].style.height = content_input[0].scrollHeight + 'px';
        right_show.css('height', left_input.css('height'));
        right_show.find('.blog-title > span').html(title_input.val());
        right_show.find('.blog-content > .mark-container').html(content_input.val());
        document.documentElement.scrollTop = old_top;
    }

    // 切换左右显示
    $('#manipulate div').click(function () {
        let span = this.children[0];
        let class_ = span.className;
        if (class_ === 'show-whole'){
            span.className='show-left';
            right_show.css({'width': '1px'});
            left_input.css({'width': '100%', 'margin-right': '0'});
        }else if (class_ === 'show-left'){
            span.className='show-right';
            right_show.css({'width': '100%'});
            left_input.css({'width': '1px'});
        }else{
            span.className='show-whole';
            right_show.css({'width': '49%'});
            left_input.css({'width': '49%', 'margin-right': '2%'});
        }
    });
    let tag_input = $('#top-input input');
    // 搜索
    $('#manipulate .search').click(function () {
        $.ajax({
            success: function(re){
                if (re === -1) {
                    pwd = prompt("输入密码", "");
                    enter_manage(pwd);
                }else{
                    cover_input.val(re['cover']);
                    title_input.val(re['title']);
                    content_input.val(re['content']);
                    tag_input.val(re['tag']);
                    show_result();
                }
            },
            url: path+'/manage', type: 'POST', timeoutSeconds: 10, dataType: 'json',
            data: {"type": "get_blog", "id": $('#manipulate input').val()}
        });
    });
    // 提交
    $('#manipulate .submit').click(function () {
        process_({"type": "add_blog", "cover": cover_input.val(), "title": title_input.val(), "content": content_input.val(), "tag": tag_input.val()});
    });
    // 修改
    $('#manipulate .modify').click(function () {
        process_({"type": "modify_blog", "cover": cover_input.val(), "title": title_input.val(), "content": content_input.val(), "tag": tag_input.val(), "id": $('#manipulate input').val()});
    });
    // 删除
    $('#manipulate .delete').click(function () {
        process_({"type": "delete_blog", "id": $('#manipulate input').val()});
    });
    // 处理结果
    function process_(dict) {
        $.ajax({
            success: function(re){
                re = parseInt(re);
                if (re === -1) {
                    pwd = prompt("输入密码", "");
                    enter_manage(pwd);
                }else if (re === 1){
                    alert("成功!");
                }else if (re === 0){
                    alert("失败!");
                }
            },
            url: path+'/manage', type: 'POST', timeoutSeconds: 10,
            data: dict
        });
    }
});
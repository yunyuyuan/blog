$(document).ready(function () {
    let path = $('#-head-container').attr('data-path');

    let input = $('#record-body textarea');
    input.on('input propertychange', function () {
        input.css('height', 'auto');
        input.css('height', input[0].scrollHeight+'px')
    });
    $('#record-choose-color span').click(function () {
        $('#record-choose-color span').each(function () {
            this.className = '';
        });
        this.className = 'active';
        input.css('background', this.style.background);
    });
    // 搜索
    let id_input = $('#record-top input');
    $('.search').click(function () {
        $.ajax({
            success: function (r) {
                if (r.length !== 0) {
                    input.val(r['content']);
                    $('#record-choose-color span').each(function () {
                        if (this.style.background === r['color']){
                            this.click();
                        }
                    })
                }
            },
            url: path+'/manage', type: 'POST', timeoutSeconds: 10,
            data: {'type': 'get_record', 'id': id_input.val()}, dataType: 'json'
        })
    });
    // 添加
    $('.submit').click(function () {
        $.ajax({
            success: function (r) {
                process_re(r);
            },
            url: path+'/manage', type: 'POST', timeoutSeconds: 10,
            data: {'type': 'set_record', 'content': input.val(), 'color': $('#record-choose-color .active').css('background-color')}
        })
    });
    // 修改
    $('.modify').click(function () {
        $.ajax({
            success: function (r) {
                process_re(r);
            },
            url: path+'/manage', type: 'POST', timeoutSeconds: 10,
            data: {'type': 'modify_record', 'id': id_input.val(), 'content': input.val(), 'color': $('#record-choose-color .active').css('background-color')}
        })
    });
    // 删除
    $('.delete').click(function () {
        $.ajax({
            success: function (r) {
                process_re(r);
            },
            url: path+'/manage', type: 'POST', timeoutSeconds: 10,
            data: {'type': 'delete_record', 'id': id_input.val()}
        })
    });
    function process_re(r) {
        r = parseInt(r);
        if (r === 1){
            alert('成功');
        }else if (r === -1){
            enter_manage(prompt('输入密码', ''));
        }else if (r === 0){
            alert('失败');
        }
    }
});
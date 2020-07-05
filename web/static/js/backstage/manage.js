// 请求管理员
function enter_manage(pwd, callback) {
    $.ajax({
        complete: function () {
            if (typeof callback === "function"){
                callback();
            }
        },
        url: $('#-head-container').attr('data-path')+'/verify_manager', type: 'POST', timeoutSeconds: 10,
        data: {'pwd': pwd}
    })
}
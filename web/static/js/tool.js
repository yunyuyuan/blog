domready(function () {
    $('.copy-all').click(function () {
        let textarea = $('.copy-src');
        if (textarea.val() === ''){
            return;
        }
        textarea[0].select();
        document.execCommand('copy');
        alert('复制成功');
    });
    phone_handle2tool();
    page_load();
});
function phone_handle2tool() {
    let div = document.getElementById('left-list');
    if (typeof div === "undefined") return;
    let ul = div.querySelector('ul');
    let toggler = document.createElement('span');
    div.insertBefore(toggler, ul);
    toggler.addEventListener('click', function () {
        $(ul).stop().slideDown(200, function () {
            win_blur(ul, function () {
                $(ul).stop().slideUp(200);
            });
        });
    });
}
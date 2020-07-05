domready(function () {
    $('#timeline-slide').click(function () {
        if (this.innerText === '收起'){
            this.innerText = '展开';
            $(this).next().find('.timeline-year-li').each(function () {
                year_slide(false, $(this));
            })
        }else{
            this.innerText = '收起';
            $(this).next().find('.timeline-year-li').each(function () {
                year_slide(true, $(this));
            })
        }
    });
    $('.timeline-year-li > span').click(function () {
        let year_li = $(this.parentElement);
        if (year_li.attr('data-down') !== undefined){
            year_slide(false, year_li);
        }else{
            year_slide(true, year_li);
        }
    });
    function year_slide(down, year_li) {
        if (!down){
            year_li.removeAttr('data-down');
            year_li.find('>ul').stop().slideUp(100, 'linear')
        }else{
            year_li.attr('data-down', '');
            year_li.find('>ul').stop().slideDown(100, 'linear')
        }
    }
    page_load();
});
function turn_atc_page(p) {
    let url = location.pathname+'?p='+p+splice_para();
    ajax_url(url, function () {
        window.history.pushState('', '', url)
    });
}
domready(function () {
    page_load();
});
function turn_rcd_page(p) {
    let url = location.pathname+'?p='+p+splice_para();
    ajax_url(url, function () {
        window.history.pushState('', '', url)
    });
}
function exchange(e, s, callback){
    let new_s = document.createElement('script');
    new_s.src = s;
    if (typeof callback!=='undefined') {
        new_s.onload = callback;
    }
    document.head.insertBefore(new_s, e);
    e.remove();
}
function domready(callback) {
    if (document.readyState !== 'loading') {
        callback();
    } else {
        let c = function () {
            callback();
            document.removeEventListener('DOMContentLoaded', c);
        };
        document.addEventListener('DOMContentLoaded', c);
    }
}
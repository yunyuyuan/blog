package cn.phyer.blog;

import cn.phyer.blog.dao.BlogDao;

import static cn.phyer.blog.tool.sendMail;

public class mailSender implements Runnable {
    private String rd;
    private BlogDao blogDao;
    private String blog_id;
    private String host;
    boolean send_to_user;

    public mailSender() {}
    public mailSender(String rd, BlogDao blogDao, String host, String blog_id, boolean send_to_user) {
        this.rd = rd;
        this.blogDao = blogDao;
        this.host = host;
        this.blog_id = blog_id;
        this.send_to_user = send_to_user;
    }

    @Override
    public void run() {
        try {
            sendMail("326178275@qq.com", "博客有人回复", "<a style='font-size:larger;color: purple' href='http://" + host + "/article/" + blog_id + "'>文章</a>");
            if (send_to_user){
                String addr = blogDao.getAddr(Integer.parseInt(rd));
                if (addr != null && !addr.equals("")) {
                    sendMail(addr, "回复提醒", "你好,你在<a style='font-size: large;color: blue;' href='http://" + host + "'>yunyuyuan的小站</a>上的评论有人回复了<br>详情:<a style='font-size:larger;color: purple' href='http://" + host + "/article/" + blog_id + "'>文章</a>");
                }
            }
        }catch (Exception ignore){}
    }
}

package cn.phyer.blog.sqlAjax;

import cn.phyer.blog.mailSender;
import com.alibaba.fastjson.JSONArray;
import org.springframework.web.context.support.WebApplicationContextUtils;
import cn.phyer.blog.dao.BlogDao;
import cn.phyer.blog.dao.UserDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

import static cn.phyer.blog.tool.*;

@WebServlet(name = "CommentAction")
public class CommentAction extends HttpServlet {
    private BlogDao blogDao;
    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        super.init();
        blogDao = (BlogDao) WebApplicationContextUtils.getWebApplicationContext(getServletContext()).getBean("blogDao");
        userDao = (UserDao) WebApplicationContextUtils.getWebApplicationContext(getServletContext()).getBean("userDao");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String type = request.getParameter("type");
        HttpSession session = request.getSession();
        response.setContentType("text/json;charset=utf-8");
        PrintWriter out = response.getWriter();
        String blog_id = request.getParameter("blog_id");
        switch (type){
            case "get":
                int p = 1;
                String page = request.getParameter("p");
                try{
                    p = Math.max(1, Integer.parseInt(page));
                }catch (Exception ignore){}
                JSONArray ret = new JSONArray();
                int all_count = blogDao.getCommentCount(blog_id);
                List<Integer> page_inf = calcPageInfo(p, calcPageCount(8, all_count));
                ret.add(all_count);
                ret.add(page_inf);

                String comment_str = blogDao.getSomeComment(blog_id, (p-1)*8, 8);
                JSONArray wrapped = new JSONArray();
                if (comment_str != null) {
                    JSONArray comments = JSONArray.parseArray(comment_str);
                    Map<Integer, List<String>> id_info = count_info(comments);
                    for (Object one: comments){
                        JSONArray raw_one = (JSONArray) one;
                        JSONArray child = (JSONArray) raw_one.get(3);
                        JSONArray wrapped_child = new JSONArray();
                        for (Object child_one: child){
                            JSONArray raw_child_one = (JSONArray) child_one;
                            wrapped_child.add(addInfo(id_info, raw_child_one));
                        }
                        JSONArray row = addInfo(id_info, raw_one);
                        row.add(wrapped_child);
                        wrapped.add(row);
                    }
                }
                ret.add(wrapped);
                out.print(ret.toJSONString());
                break;
            case "set":
                try {
                    int login_id = (int) session.getAttribute("login_id");
                    String src_code = (String) session.getAttribute("code");
                    String para_code = request.getParameter("c");
                    if (para_code != null && para_code.toLowerCase().equals(src_code)) {
                        String comment = handle_cmt_str(request.getParameter("content"), request.getContextPath());
                        String to = request.getParameter("to");
                        String ref = request.getParameter("ref");
                        if (to != null && comment.length() > 0 && comment.length() <= 2048) {
                            if (!to.equals("main") && ref!=null && !ref.equals("")) {
                                comment = "回复<span>@"+ref+"</span>:" + comment;
                            }
                            blogDao.setComment(blog_id, login_id, to, comment);
                            // 删除验证码
                            session.removeAttribute("code");
                            out.print(1);
                            // 发送提醒
                            mailSender sender_to_me = new mailSender(request.getParameter("rd"), blogDao, request.getHeader("Host"), blog_id, !to.equals("main"));
                            new Thread(sender_to_me).start();
                        }else {
                            out.print(-1);
                        }
                    } else {
                        out.print(0);
                    }
                }catch (Exception e){
                    out.print(-1);
                }
        }
    }


    private Map<Integer, List<String>> count_info(JSONArray comments){
        Map<Integer, List<String>> result = new HashMap<>();
        Set<Integer> all_id = new HashSet<>();
        for (Object one: comments){
            JSONArray raw_one = (JSONArray) one;
            all_id.add((int) ((JSONArray) one).get(0));
            JSONArray child = (JSONArray) raw_one.get(3);
            for (Object child_one: child){
                all_id.add((int) ((JSONArray) child_one).get(0));
            }
        }
        for (int id: all_id){
            Map<String, Object> id_info = userDao.getNameAvatar(id);
            result.put(id, Arrays.asList((String) id_info.get("nickname"), (String) id_info.get("avatar_url")));
        }

        return result;
    }

    private JSONArray addInfo(Map<Integer, List<String>> id_info, JSONArray raw_child_one){
        JSONArray result = new JSONArray();
        int u_id = (int) raw_child_one.get(0);
        result.add(u_id);
        result.addAll(id_info.get(u_id));
        result.add(raw_child_one.get(1));
        result.add(raw_child_one.get(2));
        return result;
    }

    // 处理评论中的特殊字符
    public static String handle_cmt_str(String s, String path){
        // 先转义尖括号
        s = escapeBrackets(s);
        // emoji
        s = s.replaceAll("\\s*\\$\\{emoji}([a-z]*)/(\\d*)￥\\{emoji}\\s*", "<img class='cmtrich-stk-$1' src='"+path+"/static/img/sticker/$1/$2.png'/>");
        // img
        s = s.replaceAll("\\s*\\$\\{img}([\\s\\S]*?)￥\\{img}\\s*", "<img class='lazy-img cmtrich-img zoom-img' src='"+path+"/static/img/constant/loading.gif' data-s='$1' onerror='this.onerror=\"\";this.src=\""+path+"/static/img/constant/error.jpg\"' />");
        // url
        s = s.replaceAll("\\s*\\$\\{url}\\[(.*?)]([\\s\\S]*?)￥\\{url}\\s*", "<a class='cmtrich-a' href='$2' target='_blank'>$1</a>");
        // code
        s = s.replaceAll("\\s*\\$\\{code}\\[(Apache|Bash|C#|C\\+\\+|CSS|CoffeeScript|Diff|Go|HTML|XML|HTTP|JSON|Java|JavaScript|Kotlin|Less|Lua|Makefile|Markdown|Nginx|Objective-C|PHP|Perl|Properties|Python|Ruby|Rust|SCSS|SQL|Shell|Session|Swift|TOML|TypeScript|YAML|plaintext)]([\\s\\S]*?)￥\\{code}\\s*", "<pre><code class=\"$1\">$2</code></pre>");
        return s;
    }
}

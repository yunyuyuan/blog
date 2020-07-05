package qiang.blog.sqlAjax;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import qiang.blog.dao.BlogDao;
import qiang.blog.dao.ImgDao;
import qiang.blog.dao.RecordDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.*;
import java.util.*;


@MultipartConfig
@WebServlet(name = "Manage")
public class Manage extends HttpServlet {
    private static String path;
    private BlogDao blogDao;
    private RecordDao recordDao;
    private ImgDao imgDao;
    private JdbcTemplate jdbcTemplate;

    @Override
    public void init() throws ServletException {
        super.init();
        path = getServletContext().getRealPath("/").replace("\\", "/").replaceFirst("/$", "");
        WebApplicationContext app = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        blogDao = (BlogDao) app.getBean("blogDao");
        recordDao = (RecordDao) app.getBean("recordDao");
        imgDao = (ImgDao) app.getBean("imgDao");
        jdbcTemplate = (JdbcTemplate) app.getBean("jdbcTemplate");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("text/plain;charset=UTF-8");
        String is_manage = (String) request.getSession().getAttribute("is_manager");
        PrintWriter out = response.getWriter();
        if (is_manage!=null && is_manage.equals("true")){
            String type = request.getParameter("type");
            String contextPath = request.getContextPath();
            String unique_id, cover, title, content, dcb;
            JSONArray all_cate;
            switch (type){
                case "add_blog":
                    cover = request.getParameter("cover");
                    title = request.getParameter("title");
                    content = request.getParameter("content");
                    dcb = request.getParameter("dcb");
                    all_cate = new JSONArray();
                    all_cate.addAll(Arrays.asList(request.getParameter("tag").split(",")));
                    blogDao.setOneBlog(cover, title, dcb, process_article(content, contextPath), all_cate);
                    out.print(1);
                    break;
                case "get_blog":
                    unique_id = request.getParameter("id");
                    JSONObject result = blogDao.getBlogForModify(unique_id);
                    if (result != null){
                        result.put("tag", result.get("tag").toString().replaceAll("[\\[\\]\"\\s]", ""));
                        out.print(result.toJSONString());
                    }else{
                        out.print("[]");
                    }
                    break;
                case "modify_blog":
                    unique_id = request.getParameter("id");
                    cover = request.getParameter("cover");
                    title = request.getParameter("title");
                    content = request.getParameter("content");
                    dcb = request.getParameter("dcb");
                    all_cate = new JSONArray();
                    all_cate.addAll(Arrays.asList(request.getParameter("tag").split(",")));
                    out.print(blogDao.ModifyOneBlog(cover, title, dcb, process_article(content, contextPath), all_cate, unique_id));
                    break;
                case "delete_blog":
                    unique_id = request.getParameter("id");
                    out.print(blogDao.DeleteOneBlog(unique_id));
                    break;
                case "get_record":
                    try {
                        out.print(recordDao.getOneRecord(request.getParameter("id")).toJSONString());
                    }catch (Exception e){
                        out.print("[]");
                    }
                    break;
                case "set_record":
                    out.print(recordDao.setOneRecord(request.getParameter("content"), request.getParameter("color")));
                    break;
                case "modify_record":
                    out.print(recordDao.modifyOneRecord(request.getParameter("id"), request.getParameter("content"), request.getParameter("color")));
                    break;
                case "delete_record":
                    out.print(recordDao.deleteOneRecord(request.getParameter("id")));
                    break;
                case "upload":
                    Part f = request.getPart("f");
                    if (f != null) {
                        String t = f.getContentType().trim();
                        if (t.indexOf("image/") == 0) {
                            String end = (new Date().getTime())+"."+t.replace("image/", "");
                            String file = "/static/img/sundry/blog/"+end;
                            try (FileOutputStream outputStream = new FileOutputStream(new File(getServletContext().getRealPath("/").replace("\\", "/").replaceFirst("/$", "") + file));
                                 InputStream reader = f.getInputStream()) {
                                byte[] b = new byte[1024];
                                while (reader.read(b, 0, 1024) > 0) {
                                    outputStream.write(b);
                                }
                                imgDao.addImg(0, "/blog/"+end);
                                out.print(file);
                            }catch (Exception ignore){
                                out.print(0);
                            }
                        }
                    }
                    break;
                case "del_img":
                    int img_id = Integer.parseInt(request.getParameter("id"));
                    String img_path = imgDao.getImgPath(img_id);
                    new File(path+"/static/img/sundry"+img_path).delete();
                    imgDao.delImg(img_id);
                    break;
                case "onerow":
                    Enumeration<String> paras = request.getParameterNames();
                    while (paras.hasMoreElements()){
                        String v = paras.nextElement();
                        if (!v.equals("type")){
                            jdbcTemplate.update("update onerow set "+v+"=? where id=0", request.getParameter(v));
                        }
                    }
                    break;
            }
        }else{
            out.print(-1);
        }
    }

    private String process_article(String s, String path){
        // sticker
        for (String regx: Arrays.asList("<img src=['\"]([a-z]*)/(\\d*)['\"] alt=['\"]stk-img['\"] ?/?>", "<img alt=['\"]stk-img['\"] src=['\"]([a-z]*)/(\\d*)['\"] ?/?>")){
            s = s.replaceAll(regx, "<img class='cmtrich-stk-$1' src='"+path+"/static/img/sticker/$1/$2.png' alt='stk-img' />");
        }
        // img
        for (String regx: Arrays.asList("<img src=['\"](\\S*?)['\"] alt=['\"]lazy-img['\"] ?/?>", "<img alt=['\"]lazy-img['\"] src=['\"](\\S*?)['\"] ?/?>")){
            // lazy onerror zoom
            s = s.replaceAll(regx, "<img class='lazy-img zoom-img' src='"+path+"/static/img/constant/loading.gif' data-s='"+path+"$1' onerror='this.onerror=\"\";this.src=\""+path+"/static/img/constant/error.jpg\"' />");
        }
        return s;
    }
}

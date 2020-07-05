package qiang.blog.toolAjax;

import org.springframework.web.context.support.WebApplicationContextUtils;
import qiang.blog.dao.ImgDao;
import qiang.blog.dao.UserDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;

@MultipartConfig
public class ImgUpload extends HttpServlet {
    private static String path;
    private static UserDao userDao;
    private ImgDao imgDao;
    private static final SimpleDateFormat formater = new SimpleDateFormat("dd");

    @Override
    public void init() throws ServletException {
        super.init();
        path = getServletContext().getRealPath("/").replace("\\", "/").replaceFirst("/$", "");
        userDao = (UserDao) WebApplicationContextUtils.getWebApplicationContext(getServletConfig().getServletContext()).getBean("userDao");
        imgDao = (ImgDao) WebApplicationContextUtils.getWebApplicationContext(getServletContext()).getBean("imgDao");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        PrintWriter out = response.getWriter();
        try {
            int id = (int) session.getAttribute("login_id");
            String day = formater.format(new Date());
            String has_send = userDao.getImgNum(id);
            String[] info = has_send.split("-");
            int n;
            if (has_send.equals("0") || !info[0].equals(day)){
                n = 0;
            }else{
                n = Integer.parseInt(info[1]);
            }
            if (n < 20){
                String s = day + "-" + (n + 1);
                Part f = request.getPart("f");
                if (f != null && f.getSize()/1024 < 2048) {
                    String type = f.getContentType().trim();
                    if (type.indexOf("image/") == 0) {
                        String end = id+"-"+s+"."+type.replace("image/", "");
                        String file = "/static/img/sundry/"+end;
                        try (FileOutputStream outputStream = new FileOutputStream(new File(path + file));
                             InputStream reader = f.getInputStream()) {
                            byte[] b = new byte[1024];
                            while (reader.read(b, 0, 1024) > 0) {
                                outputStream.write(b);
                            }
                            imgDao.addImg(id, "/"+end);
                            out.print("[\""+file+"\"]");
                        }catch (Exception e){
                            e.printStackTrace();
                            out.print(0);
                        }
                        userDao.setImgNum(id, s);
                    }
                }
            }else{
                out.print(-1);
            }
        }catch (Exception ignore){}
    }
}

package cn.phyer.blog.plugin;

import org.springframework.web.context.support.WebApplicationContextUtils;
import cn.phyer.blog.dao.UserDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "UrlRedirect")
public class UrlRedirect extends HttpServlet {
    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        super.init();
        userDao = (UserDao) WebApplicationContextUtils.getWebApplicationContext(getServletConfig().getServletContext()).getBean("userDao");    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String url_id = request.getRequestURI().substring(1).replaceFirst("\\.r$", "");
        try{
            int id = Integer.parseInt(url_id);
            response.sendRedirect(userDao.getUrl(id));
        }catch (Exception e){
            response.getWriter().print("illegal url!");
        }
    }
}

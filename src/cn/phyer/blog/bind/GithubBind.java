package cn.phyer.blog.bind;

import cn.phyer.blog.tool;
import com.alibaba.fastjson.JSONObject;
import org.springframework.web.context.support.WebApplicationContextUtils;
import cn.phyer.blog.dao.UserDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet(name = "GithubBind")
public class GithubBind extends HttpServlet {
    private static final Pattern token_pattern = Pattern.compile("access_token=(.*?)&");
    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        super.init();
        userDao = (UserDao) WebApplicationContextUtils.getWebApplicationContext(getServletConfig().getServletContext()).getBean("userDao");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/plain;charset=utf-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        String code = request.getParameter("code");
        String state = request.getParameter("state");
        String state_code = (String) session.getAttribute("bind_code");
        if (state_code!=null && state_code.equals(state)){
            String token = getAccessToken(code, state);
            Matcher matcher = token_pattern.matcher(token);
            if (matcher.find()) {
                String info = getUserInfo(matcher.group(1));
                try {
                    JSONObject user_info = JSONObject.parseObject(info);
                    String github_id = user_info.getString("login");
                    int sql_id = userDao.updateUserInfo("github", github_id, github_id, user_info.getString("avatar_url"));
                    session.setAttribute("login_id", sql_id);
                    response.sendRedirect("/");
                }catch (Exception e){
                    out.print("获取用户信息失败");
                }
            }else{
                out.print("获取token失败");
            }
        }
    }

    private String getAccessToken(String code, String state) throws IOException {
        String paras = "client_id=Iv1.588e073872ef9d4d&client_secret=111&code=" + code + "&state=" + state;
        URL url = new URL("https://github.com/login/oauth/access_token");

        return tool.get_string_from_response(tool.oauthPost(url, paras));
    }

    private String getUserInfo(String token) throws IOException {
        URL url_get_info = new URL("https://api.github.com/user?access_token=" + token);
        HttpURLConnection connection = (HttpURLConnection) url_get_info.openConnection();
        connection.setRequestMethod("GET");
        connection.setConnectTimeout(10000);
        connection.setReadTimeout(10000);

        return tool.get_string_from_response(connection);
    }
}

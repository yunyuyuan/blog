package qiang.blog.bind;

import com.alibaba.fastjson.JSONObject;
import org.springframework.web.context.support.WebApplicationContextUtils;
import qiang.blog.dao.UserDao;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static qiang.blog.tool.get_string_from_response;

public class QqBind extends HttpServlet {
    private static final Pattern token_pattern = Pattern.compile("access_token=(.*?)&");
    private static final Pattern id_pattern = Pattern.compile("\"openid\":\"(.*?)\"");
    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        super.init();
        userDao = (UserDao) WebApplicationContextUtils.getWebApplicationContext(getServletConfig().getServletContext()).getBean("userDao");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/plain;charset=utf-8");
        PrintWriter out = response.getWriter();

        String authorization_code = request.getParameter("code");
        String state = request.getParameter("state");
        HttpSession session = request.getSession();
        String state_code = (String) session.getAttribute("bind_code");
        if (state_code!=null && state_code.equals(state)) {
            String token_str = getAccessToken(authorization_code);

            Matcher matcher = token_pattern.matcher(token_str);
            if (matcher.find()){
                String token = matcher.group(1);
                String info = getOpenId(token);
                Matcher info_matcher = id_pattern.matcher(info);
                if (info_matcher.find()) {
                    String open_id = info_matcher.group(1);
                    try {
                        JSONObject user_info = JSONObject.parseObject(getUserInfo(token, open_id));
                        int sql_id = userDao.updateUserInfo("qq", open_id, user_info.getString("nickname"), user_info.getString("figureurl_2").replaceFirst("^http:", "https:"));
                        session.setAttribute("login_id", sql_id);
                        response.sendRedirect("/");
                    }catch (Exception e){
                        out.print("获取用户信息失败");
                    }
                }else{
                    out.print("获取open_id失败");
                }
            }else{
                out.print("token错误");
            }
        }
    }
    private String getAccessToken(String authorization_code) throws IOException {
        URL url = new URL("https://graph.qq.com/oauth2.0/token?grant_type=authorization_code&client_id=101845070&client_secret=111&redirect_uri=http://blog.phyer.cn&code=" + authorization_code);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");
        connection.setConnectTimeout(10000);
        connection.setReadTimeout(10000);

        return get_string_from_response(connection);
    }

    public String getOpenId(String token) throws IOException {
        URL get_info_url = new URL("https://graph.qq.com/oauth2.0/me?access_token=" + token);
        HttpURLConnection connection = (HttpURLConnection) get_info_url.openConnection();
        connection.setRequestMethod("GET");
        connection.setConnectTimeout(10000);
        connection.setReadTimeout(10000);

        return get_string_from_response(connection);
    }

    public String getUserInfo(String token, String open_id) throws IOException {
        URL url = new URL("https://graph.qq.com/user/get_user_info?access_token=" + token + "&oauth_consumer_key=101845070&openid=" + open_id);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");
        connection.setConnectTimeout(10000);
        connection.setReadTimeout(10000);

        return get_string_from_response(connection);
    }
}

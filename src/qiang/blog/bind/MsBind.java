package qiang.blog.bind;

import com.alibaba.fastjson.JSONObject;
import org.apache.http.HttpEntity;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.springframework.web.context.support.WebApplicationContextUtils;
import qiang.blog.dao.UserDao;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URL;

import static qiang.blog.tool.get_string_from_response;
import static qiang.blog.tool.oauthPost;

public class MsBind extends HttpServlet {
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
            try {
                JSONObject access_info = JSONObject.parseObject(getAccessToken(code));
                if (access_info != null && access_info.containsKey("access_token")) {
                    String info = getUserInfo(access_info.getString("access_token"));
                    try {
                        JSONObject user_info = JSONObject.parseObject(info);
                        String ms_id = user_info.getString("id");
                        String ms_nm = user_info.getString("displayName");
                        int sql_id = userDao.updateUserInfo("ms", ms_id, ms_nm, "unknown");
                        session.setAttribute("login_id", sql_id);
                        response.sendRedirect("/");
                    } catch (Exception e) {
                        out.print("获取用户信息失败");
                    }
                } else {
                    out.print("获取token失败");
                }
            }catch (Exception ignore){
                out.print("获取token错误");
            }
        }
    }

    private String getAccessToken(String code) throws IOException {
        String paras = "client_id=111&grant_type=authorization_code&client_secret=111XK=QcRr:O" +
                "&redirect_uri=https%3A%2F%2Fblog.phyer.cn%2Fmsbind" +
                "&scope=openid%20offline_access%20https%3A%2F%2Fgraph.microsoft.com%2FUser.Read&code=" + code;
        URL url = new URL("https://login.microsoftonline.com/common/oauth2/v2.0/token");

        return get_string_from_response(oauthPost(url, paras));
    }

    private String getUserInfo(String token) throws IOException {
        CloseableHttpClient client = HttpClients.createDefault();
        HttpGet httpGet = new HttpGet("https://graph.microsoft.com/v1.0/me");

        httpGet.setConfig(RequestConfig.custom()
                        .setConnectTimeout(10000)
                        .setConnectionRequestTimeout(10000)
                        .build());
        httpGet.setHeader("Authorization", "Bearer "+token);
        CloseableHttpResponse response = client.execute(httpGet);
        HttpEntity entity = response.getEntity();
        return EntityUtils.toString(entity);
    }
}

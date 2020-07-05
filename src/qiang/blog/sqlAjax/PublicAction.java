package qiang.blog.sqlAjax;

import org.springframework.web.context.support.WebApplicationContextUtils;
import qiang.blog.dao.UserDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static qiang.blog.tool.createB64;

@WebServlet(name = "PublicAction")
public class PublicAction extends HttpServlet {
    private static final List<String> all_color_mod = Arrays.asList("white", "black");
    private static final String[] letter_list = {"Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M"};
    private static final Pattern domain_pattern = Pattern.compile("(https?://[^/]*)");
    private static final Pattern check_mail_s = Pattern.compile("^[A-Za-z\\d]+([-_.][A-Za-z\\d]+)*@([A-Za-z\\d]+[-.])+[A-Za-z\\d]{2,4}$");

    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        super.init();
        userDao = (UserDao) WebApplicationContextUtils.getWebApplicationContext(getServletConfig().getServletContext()).getBean("userDao");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String type = request.getParameter("type");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        switch (type){
            case "logout":
                session.removeAttribute("login_id");
                break;
            case "get-code":
                if (session.getAttribute("login_id") != null) {
                    List<String> letters = new ArrayList<>();
                    StringBuilder dest = new StringBuilder();
                    for (int i = 0; i < 4; i++) {
                        String l = letter_list[(int) (Math.random() * 25)];
                        dest.append(l);
                        letters.add(l);
                    }
                    out.print(createB64(letters));
                    session.setAttribute("code", dest.toString().toLowerCase());
                }
                break;
            case "get-bind-code":
                StringBuilder git_code = new StringBuilder();
                for (int i=0;i<4;i++){
                    git_code.append(letter_list[(int) (Math.random() * 25)]);
                }
                String str_code = git_code.toString();
                out.print(str_code);
                session.setAttribute("bind_code", str_code);
                break;
            case "generate-url":
                if (session.getAttribute("login_id") != null) {
                    String src_url = request.getParameter("url");
                    if (src_url != null && src_url.length() > 0 && src_url.length() < 2048) {
                        int url_id = userDao.generateUrl(src_url);
                        Matcher matcher = domain_pattern.matcher(request.getRequestURL());
                        if (matcher.find()) {
                            out.print(matcher.group(0) + "/" + url_id + ".r");
                        }
                    }
                }
                break;
            case "change_email":
                String v = request.getParameter("v");
                try {
                    int sql_id = (int) session.getAttribute("login_id");
                    if (v.equals("") || check_mail_s.matcher(v).find()) {
                        out.print(userDao.setEmail(sql_id, v));
                    }
                }catch (Exception e){
                    out.print(-1);
                }
                break;
        }
    }
}

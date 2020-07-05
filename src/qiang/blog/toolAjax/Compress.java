package qiang.blog.toolAjax;

import com.yahoo.platform.yui.compressor.CssCompressor;
import com.yahoo.platform.yui.compressor.JavaScriptCompressor;
import org.mozilla.javascript.ErrorReporter;
import org.mozilla.javascript.EvaluatorException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.StringReader;

public class Compress extends HttpServlet {
    private JdbcTemplate jdbcTemplate;

    @Override
    public void init() throws ServletException {
        super.init();
        jdbcTemplate = (JdbcTemplate) WebApplicationContextUtils.getWebApplicationContext(getServletConfig().getServletContext()).getBean("jdbcTemplate");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String type = request.getParameter("type");
        String str_input = request.getParameter("val");
        Reader reader =  new StringReader(str_input);
        response.setContentType("text/plain;charset=utf-8");
        PrintWriter out = response.getWriter();
        switch (type){
            case "js":
                final String[] errorReport = {""};
                try {
                    JavaScriptCompressor compressor = new JavaScriptCompressor(reader, new ErrorReporter() {
                        @Override
                        public void warning(String s, String s1, int i, String s2, int i1) {
                        }

                        @Override
                        public void error(String s, String s1, int i, String s2, int i1) {
                            errorReport[0] = "错误信息:" + s + "\n。第" + i + "行, 第" + i1 + "列:" + s2;
                        }

                        @Override
                        public EvaluatorException runtimeError(String s, String s1, int i, String s2, int i1) {
                            return null;
                        }
                    });
                    compressor.compress(out, 1000, false, false, false, false);
                    jdbcTemplate.update("update num_count set num=num+1 where name='cps'");
                }catch (NullPointerException e){
                    out.print(errorReport[0]);
                }
                break;
            case "css":
                CssCompressor cssCompressor = new CssCompressor(reader);
                cssCompressor.compress(out, 1000);
                break;
        }

    }
}

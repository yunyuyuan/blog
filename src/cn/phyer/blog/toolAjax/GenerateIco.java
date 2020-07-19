package cn.phyer.blog.toolAjax;

import net.sf.image4j.codec.ico.ICOEncoder;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.awt.image.BufferedImage;
import java.io.IOException;

@MultipartConfig
@WebServlet(name = "GenerateIco")
public class GenerateIco extends HttpServlet {
    private JdbcTemplate jdbcTemplate;

    @Override
    public void init() throws ServletException {
        super.init();
        jdbcTemplate = (JdbcTemplate) WebApplicationContextUtils.getWebApplicationContext(getServletConfig().getServletContext()).getBean("jdbcTemplate");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Part img = request.getPart("img");
        if (img.getSize() / 1024 < 5120) {
            BufferedImage buffer = ImageIO.read(img.getInputStream());
            response.setContentType("image/icon");
            ICOEncoder.write(buffer, response.getOutputStream());
            jdbcTemplate.update("update num_count set num=num+1 where name='ico'");
        }
    }
}

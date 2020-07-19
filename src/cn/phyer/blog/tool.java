package cn.phyer.blog;

import javax.imageio.ImageIO;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.xml.bind.DatatypeConverter;
import java.awt.*;
import java.awt.geom.AffineTransform;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.*;

public class tool {
    private static final Font font = new Font("heiti", Font.BOLD, 25);
    private static final List<Color> all_color = Arrays.asList(Color.red, Color.green, Color.blue, Color.black, Color.pink, new Color(247, 50, 255));

    // 字母转验证码图片
    public static String createB64(List<String> letters) throws IOException {
        BufferedImage verify_code = new BufferedImage(120, 50, BufferedImage.TYPE_INT_RGB);
        Graphics2D graphics = (Graphics2D) verify_code.getGraphics();
        graphics.setFont(font);
        graphics.setColor(Color.white);
        graphics.fillRect(0, 0, 120, 50);
        graphics.setColor(Color.black);
        for(int i=0;i<3;i++) {
            graphics.drawLine((int) (Math.random() * 60), (int) (Math.random() * 50), (int) (Math.random() * 60)+60, (int) (Math.random() * 50));
        }
        int idx=10;
        for (String letter: letters){
            AffineTransform old = graphics.getTransform();
            double angle = Math.toRadians(Math.random()*30*(int)Math.ceil(Math.random()-0.5));
            graphics.setColor(choice(all_color));
            graphics.rotate(angle, idx, 32);
            graphics.drawString(letter, idx, 32);
            graphics.setTransform(old);
            idx += 24;
        }
        ByteArrayOutputStream os = new ByteArrayOutputStream();
        ImageIO.write(verify_code, "jpg", os);
        return "data:img/jpg;base64," + DatatypeConverter.printBase64Binary(os.toByteArray());
    }

    // 随机字母
    private static <T>T choice(List<T> list){
        return list.get((int) (Math.random()*list.size()));
    }

    // 根据数量计算页数
    public static int calcPageCount(int interval, int count){
        return (int) Math.ceil((double) count/interval);
    }

    // 计算页码信息
    public static List<Integer> calcPageInfo(int p, int end){
        if (p > end || p <= 0) {
            return new ArrayList<>();
        }
        List<Integer> return_list = new ArrayList<>();
        if (end < 10) {
            for (int i = 1;i < end+1; i++){
                return_list.add(i);
            }
            return return_list;
        }
        // 1-3页
        if (p < 3) {
            for (int i = 1; i < Math.min(4, end + 1); i++) {
                return_list.add(i);
            }
        }
        // 4-6页
        if (3 <= p && p <= 6){
            for (int i = 1; i < p+2; i++) {
                return_list.add(i);
            }
        }
        // 7-(end-3)页
        else if (6 < p && p < end-3) {
            return_list.addAll(Arrays.asList(1, 2, 3, 0, p - 1, p, p + 1));
        }
        else if (p >= end-3) {
            return_list.addAll(Arrays.asList(11, 2, 3, 0));
        }

        if (p+4 == end) {
            for (int i = Math.min(p+2,end-2); i < end + 1; i++) {
                return_list.add(i);
            }
        } else if (p+4 > end) {
            for (int i = Math.min(p-2,end-2); i < end + 1; i++) {
                return_list.add(i);
            }
        } else {
            return_list.addAll(Arrays.asList(0, end - 2, end - 1, end));
        }
        return return_list;
    }

    // 转义尖括号
    public static String escapeBrackets(String s){
        return s.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
    }


    // POST
    public static HttpURLConnection oauthPost(URL url, String paras) throws IOException {
        byte[] para_bytes = paras.getBytes(StandardCharsets.UTF_8);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("POST");
        connection.setConnectTimeout(10000);
        connection.setReadTimeout(10000);
        connection.setDoOutput(true);
        connection.getOutputStream().write(para_bytes);

        return connection;
    }

    // 从connection中获取string结果
    public static String get_string_from_response(HttpURLConnection connection) throws IOException {
        if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
            InputStreamReader result_reader = new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8);
            StringBuilder result = new StringBuilder();
            for (int c; (c = result_reader.read()) >= 0; ) {
                result.append((char) c);
            }
            result_reader.close();
            connection.disconnect();
            return result.toString();
        }else{
            connection.disconnect();
            return null;
        }
    }

    // 发送邮件
    public static void sendMail(String addr, String title, String content) throws MessagingException {
        Properties para = new Properties();
        para.put("mail.transport.protocol","smtp");//协议
        para.put("mail.smtp.host","smtp.exmail.qq.com");
        para.put("mail.smtp.port",465);//端口号
        para.put("mail.smtp.auth","true");
        para.put("mail.smtp.ssl.enable","true");//设置ssl安全连接

        javax.mail.Session session = javax.mail.Session.getInstance(para);
        Message message = new MimeMessage(session);

        message.setFrom(new InternetAddress("admin@phyer.cn"));
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(addr));
        message.setSubject(title);
        message.setContent(content, "text/html;charset=utf-8");

        Transport transport = session.getTransport();
        transport.connect("admin@phyer.cn", "111");
        transport.sendMessage(message, message.getAllRecipients());
        transport.close();
    }

}

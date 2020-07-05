package qiang.blog.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

import static qiang.blog.tool.escapeBrackets;

@Service("userDao")
public class UserDao {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public int updateUserInfo(String platform, String open_id, String nickname, String avatar_url){
        nickname = escapeBrackets((nickname.length() == 0)? "Unknown":nickname);
        if (jdbcTemplate.queryForObject("select count(*) from users where open_id=? and platform=?", new Object[]{open_id, platform}, Integer.class) == 0) {
            jdbcTemplate.update("insert into users (platform, open_id, nickname, avatar_url, email, send_img) values (?, ?, ?, ?, '', '0');", platform, open_id, nickname, avatar_url);
            return jdbcTemplate.queryForObject("select last_insert_id()", Integer.class);
        }else{
            jdbcTemplate.update("update users set nickname=?, avatar_url=? where open_id=? and platform=?", nickname, avatar_url, open_id, platform);
            return jdbcTemplate.queryForObject("select id from users where open_id=? and platform=?", new Object[]{open_id, platform}, Integer.class);
        }
    }

    public Map<String, Object> getNameAvatar(int sql_id){
        try {
            return jdbcTemplate.queryForMap("select nickname, avatar_url from users where id=?", sql_id);
        }catch (EmptyResultDataAccessException e){
            Map<String, Object> result = new HashMap<>();
            result.put("nickname", "未知");
            result.put("avatar_url", "");
            return result;
        }
    }

    public String getEmail(int sql_id){
        return jdbcTemplate.queryForObject("select email from users where id=?", new Object[]{sql_id}, String.class);
    }

    public int setEmail(int sql_id, String v){
        return jdbcTemplate.update("update users set email=? where id=?", v, sql_id);
    }

    public String getImgNum(int sql_id){
        return jdbcTemplate.queryForObject("select send_img from users where id=?", new Object[]{sql_id}, String.class);
    }

    public int setImgNum(int sql_id, String s){
        return jdbcTemplate.update("update users set send_img=? where id=?", s, sql_id);
    }

//  -----------------  url  -------------------
    public int generateUrl(String src_url){
        jdbcTemplate.update("insert into urls(url) values(?)", src_url);
        int id = jdbcTemplate.queryForObject("select last_insert_id()", Integer.class);
        jdbcTemplate.update("update num_count set num=num+1 where name='url'");
        return id;
    }

    public String getUrl(int id){
        return jdbcTemplate.queryForObject("select url from urls where id=?",new Object[]{id} , String.class);
    }
}

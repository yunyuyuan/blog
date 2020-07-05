package qiang.blog.dao;

import com.alibaba.fastjson.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository("imgDao")
public class ImgDao {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public void addImg(int user_id, String path){
        jdbcTemplate.update("insert into img_save(user_, path) VALUES(?, ?)", user_id, path);
    }

    public void delImg(int id){
        jdbcTemplate.update("delete from img_save where id=?", id);
    }

    public String getImgPath(int id){
        return jdbcTemplate.queryForObject("select path from img_save where id=?", new Object[]{id}, String.class);
    }

    public int getImgCount(){
        return jdbcTemplate.queryForObject("select count(*) from img_save", Integer.class);
    }

    public JSONArray getSomeImg(int start, int num, String user_id){
        String state = "";
        if (!user_id.equals("")){
            state = " where user_="+user_id;
        }
        JSONArray re = new JSONArray();
        try {
            re.addAll(jdbcTemplate.queryForList("select * from img_save "+state+" order by id desc limit ?,?", start, num));
        }catch (Exception ignore){}
        return re;
    }
}

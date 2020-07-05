package qiang.blog.dao;

import com.alibaba.fastjson.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service("recordDao")
public class RecordDao {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public JSONObject getOneRecord(String id){
        JSONObject ret = new JSONObject();
        ret.putAll(jdbcTemplate.queryForMap("select content, color from record where id=?", Integer.parseInt(id)));
        return (ret.size()!=0)? ret: null;
    }

    public List<Map<String, Object>> getSomeRecord(int page, int num){
        return jdbcTemplate.queryForList("select * from record order by id desc limit ?,?", page, num);
    }

    public int getRecordCount(){
        return jdbcTemplate.queryForObject("select count(*) from record", Integer.class);
    }

    public int setOneRecord(String content, String color){
        return jdbcTemplate.update("insert into record(create_time, content, color) values (?, ?, ?)", new Date().getTime(), content, color);
    }

    public int modifyOneRecord(String id, String content, String color){
        return jdbcTemplate.update("update record set content=?, color=? where id=?", content, color, id);
    }

    public int deleteOneRecord(String id){
        return jdbcTemplate.update("delete from record where id=?", id);
    }
}

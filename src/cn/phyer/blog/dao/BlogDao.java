package cn.phyer.blog.dao;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;


@Service("blogDao")
public class BlogDao{
    @Autowired
    private JdbcTemplate jdbcTemplate;
    private static final Random random = new Random();
    private static final SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    private static final SimpleDateFormat year_format = new SimpleDateFormat("yyyy");

    public BlogEntity getOneBlog(String open_id){
        RowMapper<BlogEntity> mapper = new BeanPropertyRowMapper<>(BlogEntity.class);
        try {
            return jdbcTemplate.queryForObject("select * from blogs where open_id=?", mapper, open_id);
        }catch (EmptyResultDataAccessException e){
            return null;
        }
    }

    public List<Map<String, Object>> getTimeLine(){
        return jdbcTemplate.queryForList("select open_id, title, create_time from blogs order by create_time desc ");
    }

    public List<Map<String, Object>> getLastNext(String open_id){
        List<Map<String, Object>> re = new ArrayList<>();
        try {
            re.add(jdbcTemplate.queryForMap("select open_id, title from blogs where create_time=(select create_time from blogs where create_time<(select create_time from blogs where open_id=?) order by id desc limit 1)", open_id));
        }catch (EmptyResultDataAccessException e){
            re.add(null);
        }
        try {
            re.add(jdbcTemplate.queryForMap("select open_id, title from blogs where create_time=(select create_time from blogs where create_time>(select create_time from blogs where open_id=?) order by id limit 1)", open_id));
        }catch (EmptyResultDataAccessException e){
            re.add(null);
        }
        return re;
    }

    public JSONObject getBlogForModify(String open_id){
        JSONObject ret = new JSONObject();
        ret.putAll(jdbcTemplate.queryForMap("select cover, title, dcb, content, tag from blogs where open_id=?", open_id));
        return (ret.size()!=0)? ret: null;
    }

    public List<BlogEntity> getSomeBlogs(int page, int num, String tag, boolean is_time_tag){
        RowMapper<BlogEntity> blogs = new BeanPropertyRowMapper<>(BlogEntity.class);
        if (!tag.equals("")) {
            if (is_time_tag){
                String[] year_stamp = cal_year_interval(tag);
                return jdbcTemplate.query("select * from blogs where create_time>=? and create_time<? order by id desc limit ?, ?", new Object[]{year_stamp[0], year_stamp[1], page, num}, blogs);
            }
            return jdbcTemplate.query("select * from blogs where json_contains(tag, json_quote(?), '$') order by id desc limit ?, ?", new Object[]{tag, page, num}, blogs);
        }else{
            return jdbcTemplate.query("select * from blogs order by id desc limit ?, ?", new Object[]{page, num}, blogs);
        }
    }

    public int getBlogCount(String tag, boolean is_time_tag){
        if (!tag.equals("")) {
            if (is_time_tag){
                String[] year_stamp = cal_year_interval(tag);
                return jdbcTemplate.queryForObject("select count(*) from blogs where create_time>=? and create_time<?", new Object[]{year_stamp[0], year_stamp[1]}, Integer.class);
            }
            return jdbcTemplate.queryForObject("select count(*) from blogs where json_contains(tag, json_quote(?), '$')", new Object[]{tag}, Integer.class);
        }else{
            return jdbcTemplate.queryForObject("select count(*) from blogs", Integer.class);
        }
    }

    public static String[] cal_year_interval(String start){
        try {
            String s = String.valueOf(year_format.parse(start).getTime());
            String e = String.valueOf(year_format.parse(String.valueOf(Integer.parseInt(start) + 1)).getTime());
            return new String[]{s, e};
        }catch (ParseException ignore){
            return new String[]{"", ""};
        }
    }

    public void setOneBlog(String cover, String title, String dcb, String content, JSONArray tag){
        int i;
        do {
            i = random.nextInt(9000) + 1000;
        } while (jdbcTemplate.queryForObject("select count(*) from blogs where open_id=?", new Object[]{i}, Integer.class) != 0);
        String date = String.valueOf(new Date().getTime());
        jdbcTemplate.update("insert into blogs(open_id, title, dcb, content, cover, tag, create_time, update_time, views, comments, comments_num) values(?, ?, ?, ?, ?, ?, ?, ?, 0, '[]', 0)", String.valueOf(i), title, dcb, content, cover, tag.toJSONString(), date, date);
        for (Object t: tag) {
            jdbcTemplate.update("update onerow set all_cate=json_array_append(all_cate, '$', ?) where json_contains(all_cate, json_quote(?), '$')=0", t, t);
        }
    }

    public int ModifyOneBlog(String cover, String title, String dcb, String content, JSONArray tag, String open_id){
        JSONArray all_cate = getRemoveOldTag(open_id);
        // 添加新的标签
        for (Object t: tag) {
            if (!all_cate.contains(t)){
                all_cate.add(t);
            }
        }
        jdbcTemplate.update("update onerow set all_cate=? where id=0", all_cate.toJSONString());
        return jdbcTemplate.update("update blogs set cover=?, title=?, dcb=?, content=?, tag=?, update_time=? where open_id=?", cover, title, dcb, content, tag.toJSONString(), String.valueOf(new Date().getTime()), open_id);
    }

    public int DeleteOneBlog(String open_id) {
        jdbcTemplate.update("update onerow set all_cate=? where id=0", getRemoveOldTag(open_id).toJSONString());
        return jdbcTemplate.update("delete from blogs where open_id=?", open_id);
    }

    // 删除不存在引用的老标签
    private JSONArray getRemoveOldTag(String open_id){
        JSONArray old_tag = JSONArray.parseArray(jdbcTemplate.queryForObject("select tag from blogs where open_id=?", new Object[]{open_id}, String.class));
        jdbcTemplate.update("update blogs set tag='[]' where open_id=?", open_id);
        JSONArray all_cate = JSONArray.parseArray(jdbcTemplate.queryForObject("select all_cate from onerow where id=0", String.class));
        // 删除不存在引用的老标签
        for (Object t: old_tag) {
            if (jdbcTemplate.queryForObject("select count(*) from blogs where json_contains(tag, json_quote(?), '$')=1 limit 1", new Object[]{t}, Integer.class) == 0){
                all_cate.remove(t);
            }
        }
        return all_cate;
    }

    public String getSomeComment(String open_id, int page, int num){
        return jdbcTemplate.queryForObject("select json_extract(comments, '$[" + page + " to " + (page+num-1) + "]') from blogs where open_id=?", new Object[]{open_id}, String.class);
    }

    public int getCommentCount(String open_id){
        return jdbcTemplate.queryForObject("select json_length(comments) from blogs where open_id=?", new Object[]{open_id}, Integer.class);
    }

    public String getAddr(int user_id){
        return jdbcTemplate.queryForObject("select email from users where id=?", new Object[]{user_id}, String.class);
    }

    public void setComment(String open_id, int id, String to, String comment) {
        try {
            int floor = Integer.parseInt(to);
            jdbcTemplate.update("update blogs set comments=json_array_insert(comments, '$["+floor+"][3][0]', json_array(?, ?, ?)), comments_num=comments_num+1 where open_id=?", id, comment, formater.format(new Date()), open_id);
        }catch (NumberFormatException e){
            jdbcTemplate.update("update blogs set comments=json_array_insert(comments, '$[0]', json_array(?, ?, ?, json_array())), comments_num=comments_num+1 where open_id=?", id, comment, formater.format(new Date()), open_id);
        }
    }

    public void addView(String open_id){
        jdbcTemplate.update("update blogs set views=views+1 where open_id=?", open_id);
    }
}

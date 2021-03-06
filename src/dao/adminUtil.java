package dao;

import model.admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @auther: Liu Zedi.
 * @date: Create in 2018/12/2  20:21
 * @package: dao
 * @project: javaweb
 */
public class adminUtil {

    public admin getAdmin(String adminname){

        Connection conn=new getConn().getConn();
        admin admin=null;
        ResultSet set=null;
        String sql="select * from admin where adminname=?; ";
        try {
            try (PreparedStatement pstat = conn.prepareStatement(sql)) {
                pstat.setString(1, adminname);
                set = pstat.executeQuery();

                if (set.next()) {
                    String idS = String.valueOf(set.getInt(1));
                    String adminnameS = set.getString(2);
                    String passwordS = set.getString(3);
                    admin = new admin(idS, adminnameS, passwordS);

                }
            }
            conn.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return admin;
    }
}

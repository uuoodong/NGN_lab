package test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Database {
	String url = "jdbc:mysql://localhost:3306/testdb";
	String id = "root";
	String password = "root";
	Connection con = null;
	PreparedStatement pstmt = null;

	public Connection makeConnection(){

		try{
			Class.forName("org.mariadb.jdbc.Driver");
			System.out.println("드라이버 적재 성공");
			con = DriverManager.getConnection(url, id, password);
			System.out.println("DB연결 성공");
		} catch(ClassNotFoundException e){
			System.out.println("드라이버 못찾음");
		} catch(SQLException e){
			System.out.println("연결 실패");
			e.printStackTrace();
		}
		return con;
	}

	public void InsertMotion(String value) throws SQLException{
		String event = "Alarm_begi";
		String sql = "insert into logvalue(event) values (?)";
		try{
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, event);
			pstmt.executeUpdate();
			pstmt.close();
			//        con.close();
		} catch(SQLException e) {
			System.out.println(e.getMessage());
		} finally {
			pstmt.close();
//			con.close();
		}
	} 
	
	public void InsertCamera(String value) throws SQLException{
		String event = "Alarm_over";
		String sql = "insert into logvalue(event) values (?)";
		try{
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, event);
			pstmt.executeUpdate();
			pstmt.close();
			//        con.close();
		} catch(SQLException e) {
			System.out.println(e.getMessage());
		} finally {
			pstmt.close();
			con.close();
		}
	} 

}

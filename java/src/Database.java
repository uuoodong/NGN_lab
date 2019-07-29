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
			System.out.println("����̹� ���� ����");
			con = DriverManager.getConnection(url, id, password);
			System.out.println("DB���� ����");
		} catch(ClassNotFoundException e){
			System.out.println("����̹� ��ã��");
		} catch(SQLException e){
			System.out.println("���� ����");
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

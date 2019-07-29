<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.sql.* "%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=500% , initial-scale=1"/>
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/button.css">
<title>로그인</title>
<%
String total = (request.getParameter("userPassword")==null)?"":request.getParameter("userPassword");
int password=0;
if(total!=null){
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/testdb";
	String id = "root";
	String pass = "root";
	try {
		Connection conn = DriverManager.getConnection(url, id, pass);
		Statement stmt = conn.createStatement();
		String sqlList = "select * from password where " + total;
		ResultSet rs = stmt.executeQuery(sqlList);
		while (rs.next()) {
			password = rs.getInt("password");
		}
		rs.close();
		stmt.close();
		conn.close();
		if(String.valueOf(password).equals(total)){
			response.sendRedirect("Main.jsp");
		}else{
			out.println("<script>alert('비밀번호가 틀렸습니다');</script>");
			out.println("<script>alert("+password+");</script>");
			out.println("<script>alert("+total+");</script>");
		}
	}catch (SQLException e) {
		e.printStackTrace();
	}
}
%>
</head>
<body>
	<br>
	<br>
	<div class="container">
		<div class="col-lg-4"></div>
		<div class="col-lg-4">
			<div align="center" class="jumbotron" style="padding-top: 20px">
				<h3 style="text-align: center;">로그인 화면</h3>
				<form action="Login.jsp" method="post">
					<div class="form-group">
						<input type="password" class="form-control"
							placeholder="비밀번호 (숫자6자리)" name="userPassword" maxlength="20">
					</div>
					<a><input type="submit" class="b01_log" value="로그인" /></a>
				</form>
			</div>
		</div>
		<div class="col-lg-4"></div>
	</div>
</body>
</html>
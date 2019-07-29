<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.sql.* "%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=500% , initial-scale=1"/>
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/button.css">
<title>비밀번호변경</title>
</head>
<body>
<%
String Bfus = (request.getParameter("BfuserPassword")==null)?"":request.getParameter("BfuserPassword");
String Afus = (request.getParameter("AfuserPassword")==null)?"":request.getParameter("AfuserPassword");
String AfusCh = (request.getParameter("AfuserPasswordCheck")==null)?"":request.getParameter("AfuserPasswordCheck");
int password=0;
int flag = 0;
	if (Bfus != "" && Afus != "" && AfusCh != "" && Afus.length() == 6) {
		Class.forName("org.mariadb.jdbc.Driver");
		String url = "jdbc:mariadb://localhost:3306/testdb";
		String id = "root";
		String pass = "root";
		try {
			Connection conn = DriverManager.getConnection(url, id, pass);
			Statement stmt = conn.createStatement();
			String sqlList = "select * from password";
			ResultSet rs = stmt.executeQuery(sqlList);
			while (rs.next()) {
				password = rs.getInt("password");
			}
			if (!String.valueOf(password).equals(Bfus)) {
				out.println("<script>alert('비밀번호가 틀렸습니다');</script>");
				flag = 1;
			} else if (Afus.equals(AfusCh)) {
				sqlList = "update password set password='" + AfusCh + "'";
				int r = stmt.executeUpdate(sqlList);
				flag = 2;
				if (r == 1) {
					out.println("<script>alert('성공적으로 비밀번호를 변경하였습니다');</script>");
				} else {
					out.println("<script>alert('업데이트에 오류가있습니다. 다시 시도해주십시오');</script>");
				}
			} else {
				out.println("<script>alert('비밀번호를 다시한번 확인해주세요');</script>");
				flag = 1;
			}
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	} else if(Afus.length() != 6 && Afus!=""){
		out.println("<script>alert('6자리 비밀번호를 적어주세요');</script>");
		flag = 1;
	}
%>
<script>
var Fl = <%=flag%>;
if(Fl==1){
	location.href = "Update.jsp";
}else if(Fl==2){
	location.href = "Main.jsp";
}
</script>
<br>
	<div class="container">
		<div class="col-lg-4"></div>
		<div class="col-lg-4">
			<div align="center" class="jumbotron" style="padding-top: 20px">
				<form id = "reset" action = "Update.jsp"method="post">
					<h3 style="text-align: center;">비밀번호 변경</h3>
					<div class="form-group">
						<input type="password" class="form-control"	placeholder="기존 비밀번호 (숫자6자리)" 
							name="BfuserPassword" maxlength="20">
						<input type="password" class="form-control" placeholder="변경 비밀번호 (숫자6자리)"
							name="AfuserPassword" maxlength="20"> 
						<input type="password" class="form-control" placeholder="변경 비밀번호 확인  (숫자6자리)" 
							name="AfuserPasswordCheck" maxlength="20">
					</div>
					<a><input type="button" class="b01_log" value="변경"
						onclick="document.getElementById('reset').submit();" /></a>
				</form>
			</div>
		</div>
		<div class="col-lg-4"></div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.* , java.io.*"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.io.IOException"%>
<%@ page import= "java.io.InputStreamReader"%>
<%@ page import= "java.io.BufferedReader"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>삭제</title>
<%! 
public class CommandInsertion {
	public String exec(String cmd[]) {
		String result = "";
		try {
			Process p = Runtime.getRuntime().exec(cmd);
			BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream()));
			result = (br.readLine()).toString();
			br.close();

			return result;
		} catch (IOException e) {
			e.printStackTrace();
			return "0";
		}
	}
}
%>
<%
	String[] test = {""};
	String[] deletevideo = (request.getParameterValues("deletevideo[]")==null)?test:request.getParameterValues("deletevideo[]");
	String[] deletevideoFile = new String[10];
	
		for(int i=0; i<deletevideo.length;i++){
			if(!deletevideo[i].equals("")){
				deletevideoFile[i] = deletevideo[i].substring(0, 10) +"_"+ deletevideo[i].substring(11, 13)+"-"+ deletevideo[i].substring(14, 16);
			}
		}
	
	CommandInsertion command = new CommandInsertion();
%>

</head>
<body>
	<%System.out.println(deletevideo);
		Class.forName("org.mariadb.jdbc.Driver");
		String url = "jdbc:mariadb://localhost:3306/testdb";
		String id = "root";
		String pass = "root";

		try {
			if (deletevideo!=test) {

				Connection conn = DriverManager.getConnection(url, id, pass);
				Statement stmt = conn.createStatement();
				for (int i = 0; i < deletevideo.length; i++) {
					String sqlCount = "delete from logvalue where monitoringTime='" + deletevideo[i] + "'";
					stmt.executeUpdate(sqlCount);
				}
				for (int i = 0; i < deletevideo.length; i++) {
					String[] Tcommand = {"/bin/sh", "-c", "sudo rm /usr/local/tomcat9/webapps/TheftPrevention/video/"+deletevideoFile[i]+".mp4"};
					command.exec(Tcommand);
					String[] Tcommand2 = {"/bin/sh", "-c", "sudo rm /usr/local/tomcat9/webapps/TheftPrevention/video/"+deletevideoFile[i]+"_2.mp4"};
					command.exec(Tcommand2);
				}
				stmt.close();
				conn.close();
				%>
	<script type="text/javascript">
		self.window.alert("삭제하였습니다");
	</script>
	<%} else {
	%>

	<script type="text/javascript">
		self.window.alert("삭제할 영상의 체크박스를 확인해주세요");
	</script>
	<%
		}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (IOException ie){
			ie.printStackTrace();
			%>
	<script type="text/javascript">
		self.window.alert("삭제하였습니다");
	</script>
	<%
		} catch (Exception e2){
			e2.printStackTrace();
		}
	%>
	<script type="text/javascript">
		location.href = "Video.jsp";
	</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.io.*, java.util.*, java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>시스템명령어전송</title>

<%!public String exec(String cmd[]) {
		String result = "";
		try {
			String line = null;
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
%>
</head>
<body>
<%
	String hour = (request.getParameter("newhour") == null) ? "0" : request.getParameter("newhour");
	String minute = (request.getParameter("newminute") == null) ? "0" : request.getParameter("newminute");
	String second = (request.getParameter("newsecond") == null) ? "0" : request.getParameter("newsecond");
	String Tvolume = "0";
	String[] Tcommand = {"/bin/sh", "-c", "sudo date -s "+hour+":"+minute+":"+second};
	Tvolume = exec(Tcommand);
%>
<script type="text/javascript">
		alert("시스템 시간 수정이 완료되었습니다");
		location.href = "Main.jsp";
</script>
</body>
</html>
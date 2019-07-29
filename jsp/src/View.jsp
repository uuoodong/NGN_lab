<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=500% , initial-scale=1"/>
<link rel="stylesheet" type="text/css" href="css/button.css">
<link rel="stylesheet" href="css/bootstrap.css">
<title>View</title>
<% request.setCharacterEncoding("UTF-8");
String videoall = request.getParameter("videoall");
String videotitle = videoall.substring(0,19);
String videoW = videotitle.substring(0, 10) +"_"+ videotitle.substring(11, 13)+"-"+ videotitle.substring(14, 16);
videoW = videoW.trim();
%>
</head>
<body>
	<nav class="navbar navbar-default">
	<div class="navbar-header">
		<button type="button" class="navbar-toggle collapsed"
			data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
			aria-expanded="false">
			<span class="icon-bar"></span> <span class="icon-bar"></span> <span
				class="icon-bar"></span>
		</button>
	</div>
	<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">										
		<ul class="nav navbar-nav">
			<li><a href="Main.jsp">메인화면</a></li>
			<li class="active"><a href="Video.jsp">영상관리</a></li>
		</ul>
		<ul class="nav navbar-nav navbar-right">
			<li class="dropdown"><a href="#" class="dropdown-toggle"
				data-toggle="dropdown" role="button" aria-haspopup="true"
				aria-expanded="false">나의 정보<span class="caret"></span></a>
				<ul class="dropdown-menu">
					<li><a href="Login.jsp">로그아웃</a></li>
					<li><a href="Update.jsp">패스워드 변경</a></li>
				</ul></li>
		</ul>
	</div>
	</nav>
	<div class="container">
		<div class="row">
			<div align="center">
				<h3><%=videotitle %> 영상입니다</h3> <%=videoall %>  <%=videoW%>
			</div>
			<br>
			<div align="center">
				<video source src="video/<%=videoW%>.mp4"
					width="100%" loop autoplay> </video>
				<video source src="video/<%=videoW%>_2.mp4"
					width="100%" loop autoplay> </video>
			</div>
			<div align="center">
				<form>
					<a href="Video.jsp"><input type="button" class="b01_log"
						value="돌아가기"></a> <a href="DeleteCheck.jsp?deletevideo[]=<%=videoall %>"><button type="button" class="b01_end"
						value="삭제하기">삭제하기</button></a>
				</form>
			</div>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>
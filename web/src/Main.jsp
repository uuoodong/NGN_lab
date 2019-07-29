<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.util.*, java.text.SimpleDateFormat"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=500%">

<link rel="stylesheet" type="text/css" href="css/button.css">
<link rel="stylesheet" href="css/bootstrap.css">
<title>Main</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<style>
input:focus::-webkit-input-placeholder, 
textarea:focus::-webkit-input-placeholder{
	color: transparent;
}
</style>
<%
	String volume = "0";
	String Tvolume = "0";
	String[] command = {"/bin/sh", "-c",
			"df -P | grep -v ^Filesystem | awk '{sum += $3} END {print sum/1024/1024}'"};
	String[] Tcommand = {"/bin/sh", "-c", "sudo date +%H%M%S"};
	volume = exec(command);
	Tvolume = exec(Tcommand);
%>
<script type="text/javascript">
	
	function printClock() { //시계 자바스크립트
		var time = "<%=Tvolume%>";
		var clock = document.getElementById("clock"); // 출력할 장소 선택
		var array_word = new Array();
		for (i = 0; i < 6; i++) {
			array_word[i] = time.charAt(i);
		}
		var hour = array_word[0] + array_word[1];
		var minute = array_word[2] + array_word[3];
		var second = array_word[4] + array_word[5];
		var amPm = 'AM'; // 초기값 AM
		hour = addZeros(hour, 2);
		minute = addZeros(minute, 2);
		second = addZeros(second, 2);
		if (hour >= 12) { // 시간이 12보다 클 때 PM으로 세팅, 12를 빼줌
			amPm = 'PM';
			hour = addZeros(hour - 12, 2);
		}
		clock.innerHTML = hour + ":" + minute + ":" + second
				+ " <span style='font-size:50px;'>" + amPm + "</span>"; //날짜를 출력해 줌

		//setTimeout("printClock()", 1000); // 1초마다 printClock() 함수 호출
	}
	function addZeros(num, digit) { // 자릿수 맞춰주기 자바스크립트
		var zero = '';
		num = num.toString();
		if (num.length < digit) {
			for (i = 0; i < digit - num.length; i++) {
				zero += '0';
			}
		}
		return zero + num;
	}
	
	function clockupdate() { //시간 수정
		var update = document.getElementById("updatediv");
		var newclock = document.getElementById("newclock");
		
		
		if (update.style.display == 'none' && newclock.style.display == 'block') {
			document.getElementById("updatediv").style.display = "block";
			document.getElementById("newclock").style.display = "none";
		} else {
			document.getElementById("updatediv").style.display = "none";
			document.getElementById("newclock").style.display = "block";
		}
		
	}

	function clickchange(x, s){
		
		if(s=="start"){
			x.style.background="red";
		}else if(s=="0stop"){
			x.style.background="red";
		}
	}
	function changebar(becolor){
		document.getElementByName('bar').style.color = becolor;
	}
	
</script>

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
	
	public String UseVolume(String returnUseV) {
		if (returnUseV == "0") {
			return returnUseV;
		}
		float changeV = Float.parseFloat(returnUseV);
		String a = String.format("%.2f", (changeV / 24) * 100);
		return a;
	}%>

</head>
<body onload="printClock()">
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
			<li class="active"><a href="Main.jsp">메인화면</a></li>
			<li><a href="Video.jsp">영상관리</a></li>
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
	<div align="center">
		<br> <img src="images/Logo.JPG" width="250"><br>
		<div id="updatediv" style="display: block">
			<h2
				style="border: 1px solid #dedede; width: 300px; height: 125px; line-height: 125px; color: #666; font-size: 50px; text-align: center;"
				id="clock"></h2><h2><button type="button" class="b01_log" onclick="clockupdate();">시간 수정</button></h2>
		</div>
		<form id="go" action="SendtoSystem.jsp" method="POST">
		<div id="newclock" style="display: none">
			<h2
				style="border: 1px solid #dedede; width: 300px; height: 125px; line-height: 125px; color: #666; font-size: 50px; text-align: center;">
				<table>
					<td><input name="newhour" class="form-control" max="24"
						min="0" type="number" placeholder="24"
						style="ime-mode: disabled; width: 100px; height: 125px; font-size: 50px; text-align: center;"></td>
					<td><input name="newminute" class="form-control" max="59"
						min="0" type="number" placeholder="59"
						style="ime-mode: disabled; width: 100px; height: 125px; font-size: 50px; text-align: center;"></td>
					<td><input name="newsecond" class="form-control" max="59"
						min="0" type="number" placeholder="59"
						style="ime-mode: disabled; width: 100px; height: 125px; font-size: 50px; text-align: center;"></td>
				</table>
			</h2>
			<h2>
				<button type="submit" onclick="clockupdate();">수정 완료</button>
			</h2>
		</div>
		</form>
		<hr width="100%" color="#1C3D62">
		<h3>사용 용량</h3>
		<script>
			$(function() {
				var a = <%=UseVolume(volume)%>;
				var gAction = $('.gAction');
				if(a>=99){
					gAction.css('background', '#FF0040');
					gAction.css('border', ':1px solid #FF0040');
				}else if(a>=95&&a<99){
					gAction.css('background', '#FF8000');
					gAction.css('border', ':1px solid #FF8000');	
				}
			})
		</script>

		<p>
			<span class="iGraph"> <span class="gBar" align="left"><span
					class="gAction" style="width:<%=UseVolume(volume)%>%"></span></span><br> 현재 사용중인
				용량은<span class="gPercent"><strong>
						<%=UseVolume(volume)%></strong>%</span>
			</span> 입니다.
		</p>
	</div>
	<hr width="100%" color="#1C3D62">
	<div align="center">
		<br>현재 도난 방지 시스템이 작동 중입니다<br> <br> 종료 버튼을 클릭하시면 시스템이
		종료됩니다<br> <br>
		<!--버튼 클릭시 작동/작동하지 않습니다 라고 구분하는 기능 추가-->
		<table>
			<tr>
				<td><form id="sta" action="hello" method="post">
						<input type="hidden" name="h_field" value="1">
						<button name="start" type="button" class="b01_start" value="start"
							onclick="document.getElementById('sta').submit();">시작</button>
					</form></td>
				<td><form id="sto" action="hello" method="post">
						<input type="hidden" name="h_field" value="0">
						<button name="stop" type="button" class="b01_end" value="stop"
							onclick="document.getElementById('sto').submit();">종료</button>
					</form></td>
			</tr>
		</table>
	</div>
	<hr width="100%" color="#1C3D62">
	
	<script src="js/bootstrap.js"></script>
</body>
</html>
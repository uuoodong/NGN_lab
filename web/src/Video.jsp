<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.sql.* "%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=500% , initial-scale=1"/>
<link rel="stylesheet" type="text/css" href="css/button.css">
<link rel="stylesheet" href="css/bootstrap.css">
<script src="js/calendar_beans_v2.2.js" type="text/javascript" charset="utf-8"></script>
<script src="js/jquery.min.js" type="text/javascript" charset="utf-8"></script>
<script src="js/jquery.mask.min.js" type="text/javascript" charset="utf-8"></script>
<title>Video</title>
<%!//페이징 변수 선언부
int FlagNumber = 1;
int searchFlag = 0;
int pageno=1;
int total_record; //총 레코드 수
int page_per_record_cnt; //페이지 당 레코드 수
int group_per_page_cnt; //페이지 당 보여줄 번호 수[1],[2],[3],[4],[5]											
int record_end_no;
int record_start_no;
int total_page;
int group_no;
int page_eno;
int page_sno;
int prev_pageno; // <<  *[이전]* [21],[22],[23]... [30] [다음]  >>
//	이전 페이지 번호	= 현재 그룹 시작 번호 - 페이지당 보여줄 번호수	
//	ex)	46 = 51 - 5				
int next_pageno;
public Integer toInt(String x){
	int a = 0;
	try{
		a = Integer.parseInt(x);
	}catch(Exception e){}
	return a;
}
%>

<script type="text/javascript">
	var check = false;
	function CheckAll() {
		var chk = document.getElementsByName("deletevideo[]");
		if (check == false) {
			check = true;
			for (var i = 0; i < chk.length; i++) {
				chk[i].checked = true; //모두 체크
			}
		} else {
			check = false;
			for (var i = 0; i < chk.length; i++) {
				chk[i].checked = false; //모두 해제
			}
		}
	}
</script>

<% 
String clickFlag = (request.getParameter("flag")==null)?"":request.getParameter("flag");
String starthour = (request.getParameter("start")==null)?"":request.getParameter("start");
String endhour = (request.getParameter("end")==null)?"":request.getParameter("end");
%>

</head>
<body>
<%
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/testdb";
	String id = "root";
	String pass = "root";
	int total = 0;
	
	try {
		Connection conn = DriverManager.getConnection(url, id, pass);
		Statement stmt = conn.createStatement();
		String sqlCount = "SELECT COUNT(*) FROM logvalue";
		ResultSet rs = stmt.executeQuery(sqlCount);

		if (rs.next()) {
	total = rs.getInt(1);
		}
		rs.close();
		if(total!=0){
		pageno = toInt(request.getParameter("pageno"));
		if(pageno==0){
			FlagNumber=1;
		}else{
			FlagNumber=((pageno-1)*10)+1;
		}
		
		if (pageno < 1) {//현재 페이지
	pageno = 1;
		}
		total_record = total; //총 레코드 수
		page_per_record_cnt = 10; //페이지 당 레코드 수
		group_per_page_cnt = 5; //페이지 당 보여줄 번호 수[1],[2],[3],[4],[5]
		//					  									  [6],[7],[8],[9],[10]											

		record_end_no = pageno * page_per_record_cnt;
		record_start_no = record_end_no - (page_per_record_cnt - 1);
		if (record_end_no > total_record) {
	record_end_no = total_record;
		}

		total_page = total_record / page_per_record_cnt + (total_record % page_per_record_cnt > 0 ? 1 : 0);
		if (pageno > total_page) {
	pageno = total_page;
		}

		// 	현재 페이지(정수) / 한페이지 당 보여줄 페지 번호 수(정수) + (그룹 번호는 현제 페이지(정수) % 한페이지 당 보여줄 페지 번호 수(정수)>0 ? 1 : 0)
		group_no = pageno / group_per_page_cnt + (pageno % group_per_page_cnt > 0 ? 1 : 0);
		//		현재 그룹번호 = 현재페이지 / 페이지당 보여줄 번호수 (현재 페이지 % 페이지당 보여줄 번호 수 >0 ? 1:0)	
		//	ex) 	14		=	13(몫)		=	 (66 / 5)		1	(1(나머지) =66 % 5)			  

		page_eno = group_no * group_per_page_cnt;
		//		현재 그룹 끝 번호 = 현재 그룹번호 * 페이지당 보여줄 번호 
		//	ex) 	70		=	14	*	5
		page_sno = page_eno - (group_per_page_cnt - 1);
		// 		현재 그룹 시작 번호 = 현재 그룹 끝 번호 - (페이지당 보여줄 번호 수 -1)
		//	ex) 	66	=	70 - 	4 (5 -1)

		if (page_eno > total_page) {
	//	   현재 그룹 끝 번호가 전체페이지 수 보다 클 경우		
	page_eno = total_page;
	//	   현재 그룹 끝 번호와 = 전체페이지 수를 같게
		}

		prev_pageno = page_sno - group_per_page_cnt; // <<  *[이전]* [21],[22],[23]... [30] [다음]  >>
		//		이전 페이지 번호	= 현재 그룹 시작 번호 - 페이지당 보여줄 번호수	
		//	ex)		46		=	51 - 5				
		next_pageno = page_sno + group_per_page_cnt; // <<  [이전] [21],[22],[23]... [30] *[다음]*  >>
		//		다음 페이지 번호 = 현재 그룹 시작 번호 + 페이지당 보여줄 번호수
		//	ex)		56		=	51 - 5
		if (prev_pageno < 1) {
	//		이전 페이지 번호가 1보다 작을 경우		
	prev_pageno = 1;
	//		이전 페이지를 1로
		}
		if (next_pageno > total_page) {
	//		다음 페이지보다 전체페이지 수보가 클경우		
	next_pageno = total_page / group_per_page_cnt * group_per_page_cnt + 1;
	//		next_pageno=total_page
	//		다음 페이지 = 전체페이지수 / 페이지당 보여줄 번호수 * 페이지당 보여줄 번호수 + 1 
	//	ex)			   = 	76 / 5 * 5 + 1	???????? 		
		}

		// [1][2][3].[10]
		// [11][12]
		//sqlCount = "SELECT event, monitoringTime from logvalue order by monitoringTime asc";
		//rs = stmt.executeQuery(sqlCount); 
		
		sqlCount = "SELECT @rownum:=@rownum+1, logvalue.* FROM logvalue  WHERE (@rownum:=0)=0 order by monitoringTime desc Limit "
				+ ((pageno - 1) * 10) + ", " + page_per_record_cnt;
		rs = stmt.executeQuery(sqlCount);
		
		if (clickFlag.equals("")) {
			//String sqlList = "SELECT event, monitoringTime from logvalue order by monitoringTime asc";
			//rs = stmt.executeQuery(sqlList);
		} else {
			String sqlList = "select * from logvalue where monitoringTime between'" + starthour + "' AND '"
					+ endhour + "'";
			rs = stmt.executeQuery(sqlList);
		}
		}
%>
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
				<h3>영상 조회</h3>
			</div>
			<hr width="100%" color="#1C3D62">
			<form id = "search" action="Video.jsp" method="post">
			<div class="wrap" id="d">
				<h4>기간 선택</h4>
				시작 날짜 : <input type="text" name="start" id="cal1"> <select
					name="starthour" id="starthour" onchange="selectStart(this.value)"
					style="width: 50px; height: 30px">
					<option value="">시간</option>
				</select> &nbsp; &nbsp; ─ &nbsp; &nbsp;<br> 
				종료 날짜 : <input type="text"
					name="end" id="cal2"> <select name="endhour" id="endhour"
					onchange="selectStart(this.value)"
					style="width: 50px; height: 30px">
					<option value="">시간</option>
				</select> <input type ="hidden" name="flag" value="1"/>
				<button type="button" onclick="document.getElementById('search').submit();">검색</button>

				<script type="text/javascript">
					initCal({
						id : "cal1",
						type : "day",
						today : "y"
					});
					initCal({
						id : "cal2",
						type : "day",
						today : "y"
					});
				</script>
				<hr width="100%" color="#1C3D62">
				<%
			out.print("총 게시물 : " + total + "개");
			%>
			</div>
			</form>
			
			<form action="DeleteCheck.jsp" method="Post">
			<table class="table table-striped"
				style="text-align: center; board: 1px solid #dddddd">
				<tr>
					<td style="background-color: #eeeeee;"><input type="checkbox"
						name="gender" value="check" OnClick="CheckAll()" style="width: 20px; height: 20px"></td>
					<th style="background-color: #eeeeee; text-align: center;">번호</th>
					<th style="background-color: #eeeeee; text-align: center;">이름</th>
					<th style="background-color: #eeeeee; text-align: center;">시작시간</th>
				</tr>
				
				<%
					if (total == 0) {
				%>
				
				<tr align="center" bgcolor="#FFFFFF" height="30">
					<td colspan="6">등록된 글이 없습니다.</td>
				</tr>
				
				<%
					} else {

							while (rs.next()) {
								String time = rs.getString("monitoringTime");
								String[] Array = new String[6];
								String event = rs.getString("event");
								String str=rs.getString("monitoringTime");
								String year = str.split("-")[0];
								String month = str.split("-")[1];
								String day = (str.split("-")[2]).split(" ")[0];
								String hour= (str.split(":")[0]).split(" ")[1];
								String minute = str.split(":")[1];
								String second = (str.split(":")[2]).substring(0,2);
								String all = month+day+hour+minute;
								
				%>
				
					<tr>
						<input type="hidden" name="videoall" value="<%=all%>" />
						<td style="background-color: #eeeeee;"><input type="checkbox"
							name="deletevideo[]" value="<%=time %>" style="width: 20px; height: 20px"></td>
						<td style="background-color: #eeeeee; text-align: center;"><%=FlagNumber%></td>
						<td style="background-color: #eeeeee; text-align: center;"><a
							href="View.jsp?videoall=<%=time %>"><%=all%>_<%=event%></a></td>
						<td style="background-color: #eeeeee; text-align: center;"><%=month%>월
							<%=day%>일 <%=hour%>시 <%=minute%>분</td>
					</tr>
					<tr height="1" bgcolor="#D2D2D2">
						<td colspan="6"></td>
					</tr>
					<%
						FlagNumber++;
									}
									
								}
								rs.close();
								stmt.close();
								conn.close();
							} catch (SQLException e) {
								out.println(e.toString() + "woodong");
							}
						
					%>
					</tbody>
			</table>
				<nav align="center" aria-label="Page navigation example">
				<ul class="pagination">
					<li class="page-item"><a class="page-link" href="Video.jsp?pageno=1">맨앞으로</a></li>
					<li class="page-item"><a class="page-link" href="Video.jsp?pageno=<%=prev_pageno%>">이전</a></li>
					<%
						for (int i = page_sno; i <= page_eno; i++) {
					%>
					<li class="page-item"><a class="page-link" href="Video.jsp?pageno=<%=i%>"><%=i %></a></li><%} %>
					<li class="page-item"><a class="page-link" href="Video.jsp?pageno=<%=next_pageno%>">다음</a></li>
					<li class="page-item"><a class="page-link" href="Video.jsp?pageno=<%=total_page%>">맨뒤로</a></li>
					</ul>
				</nav>
				<div align="center">
				<input name="alldelete" type="submit" class="b02_end" value="삭제">
			</div>
			</form>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>
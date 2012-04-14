<%Option Explicit
' This Source Code Form is subject to the terms of the Mozilla Public
' License, v. 2.0. If a copy of the MPL was not distributed with this file,
' You can obtain one at http://mozilla.org/MPL/2.0/.

%>
<!--#include virtual="/DB/config.asp"-->
<!--#include virtual="/DB/adovbs.asp"-->
<!--#include virtual="/DB/utils.asp"-->
<!--#include virtual="/DB/debug.asp"-->
<!--#include virtual="/DB/database.asp"-->
<!--#include virtual="/DB/quizdata.asp"-->
<!--#include virtual="/DB/quiz.asp"-->
<%
Function Search(s)
	Dim db
	Dim rs
	Dim sql
	Dim sortField
	sortField = "Nummer"
	if Req("sort")<>"" then
		sortField = Req("sort")
	end if
	if s<>"" then
		set db = new Database
		db.serverName = config.dbserver
		db.dbname = config.dbname
		sql = "SELECT * FROM Students "
		sql = sql & "WHERE FirstName LIKE @q "
		sql = sql & "OR LastName LIKE @q "
		sql = sql & "OR Class LIKE @q "
		sql = sql & "OR Id LIKE @q "
		sql = sql & "ORDER BY " & sortField
		sql = replace(sql, "@q", sq("%" & s & "%") )
		'print sql
		set rs = db.getRs(sql, 1, 3)
		set Search = rs
	else
		set Search = nothing
	end if

End Function

Function ImageLink(id, size)
	Dim strFilePath
	Dim strImgPath

	strFilePath = nvl(rs("StudentId")) & ".jpg"
	strImgPath = "/students/" & strFilePath
	if not FileExists(strImgPath) then
		strImgPath = "/students/avatar.gif"
	end if
	ImageLink = anchor(strImgPath, img(strImgPath, size), "lightbox")
End Function

Dim term
Dim rs
Dim count
Dim sp

sp = Req("showpictures")
if sp="" then
	sp = "false"
end if

term = Trim(Req("q"))
set rs = Search(term)
if not rs is nothing then
	count = rs.recordCount
end if
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>Schoogle - Student Search Engine</title>
	<style>
	#main { text-align:center; margin: 0 auto; display: block; width: 40em; margin-top: 150px; }
	#searchForm button,	#searchForm input { font-size:2em; }
	#searchForm img { margin-bottom:0px; margin-right:8px; }
	body { font: .76em arial; margin:1em; }
	td, th { border:1px solid silver; padding:.2em }
	th { cursor:pointer;}
	table { border-collapse:collapse; margin:1em auto; width:440px;	margin-bottom:2em; }
	tr:nth-child(odd) { background-color: #e2f7f7; }
	dl { margin: 0;	padding: 0; }
	dt { margin: 0;  padding: 0; font-weight: bold; }
	dd { margin: 0 0 1em 0;	padding: 0; }
	</style>
	<script type="text/javascript">
	function togglePictures() {
		var sp = document.getElementById("showpictures");
		sp.value = !(String(true) == sp.value);
		sp.form.submit();
	}
	function setSort(f) {
		var sortField = document.getElementById("sort");
		sortField.value = f;
		sortField.form.submit();
	}
	</script>
</head>

<body>
<div id="main">
	<h1><a href="/students/index.asp"><img border="0" src="Schoogle.gif" width="349" height="110" alt="Schoogle" /></a></h1>
	<form id="searchForm" method="get">
		<img border="0" title="toggle student pictures" class="sp" src="avatar<%if sp then print "-on"%>.gif" width="40" height="30" alt="toggle student pictures" onclick="togglePictures()" />
		<input type="text" value="<%=term%>" id="q" name="q" />
		<input type="hidden" value="<%=sp%>" id="showpictures" name="showpictures" />
		<input type="hidden" value="Nummer" id="sort" name="sort" />
		<button type="submit" id="submitbutton" >Search</button>
	</form>
	<div id="results">
		<%
		if not rs is nothing then
			%><p><%=rs.recordCount%> student records found</p><%
		end if
		%>
		<table>
		<tr>
			<%if not rs is nothing then
				if Req("showpictures")="true" then%>
				<th>Foto</th>
				<%end if%>
			<th title="sort by Id" onclick="setSort('Id')">Id</th>
			<th title="sort by Last Name" onclick="setSort('LastName)">Last Name</th>
			<th title="sort by First Name" onclick="setSort('FirstName')">First Name</th>
			<th title="sort by Class" onclick="setSort('Class')">Class</th>
			<%end if%>
		</tr>
		<%
		if not rs is nothing then
			do until rs.eof
				%>
				<tr>
				<%if Req("showpictures") then%>
				<%=td(imageLink(rs("StudentId"), 60))%>
				<%end if%>
				<td><a href="/report/showStudent.asp?id=<%=rs("StudentId")%>"><%=UCase(rs("StudentId"))%></td>
				<%=td(rs("LastName"))%>
				<%=td(rs("FirstName"))%>
				<%=UCase(td(rs("Class")))%></tr><%
				rs.moveNext
			loop
		end if
		%>
		</table>
	</div>
</div>
</body>
</html>
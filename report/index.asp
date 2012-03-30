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

sub showLinks
	Dim db
	Dim rs
	Dim c

	set db = new Database
	db.serverName = config.dbserver
	db.dbname = config.dbname
	c = ","
	set rs = db.getRs("SELECT * FROM Quiz ORDER BY quizname", adOpenForwardOnly, adLockReadOnly)
	%>
	<table>
		<tr>
			<th>name</th>
			<th><a href="showScores.asp">scores</a></th>
			<th><a href="showScores.asp?details=true">details</a></th>
	<%do until rs.eof
		%><tr><td><% print rs("quizname")%></td><%
		%><td><a href="showScores.asp?view=true&id=<%=rs("id")%>">view</a> <a href="showScores.asp?id=<%=rs("id")%>">download</a></td><%
		%><td><a href="showScores.asp?view=true&details=true&id=<%=rs("id")%>">view<a/> <a href="showScores.asp?details=true&id=<%=rs("id")%>">download</a></td></tr><%
		rs.MoveNext
	loop
	%></table><%
	rs.close
	db.CloseConn
	set rs = nothing
	set db = nothing
end sub

Sub showClass
	Dim db
	Dim rs
	Dim c
	Dim sql

	set db = new Database
	db.serverName = config.dbserver
	db.dbname = config.dbname
	c = ","
	sql = "SELECT DISTINCT Unit, Klas FROM vwSummary WHERE Klas IS NOT NULL ORDER BY Unit, Klas"

	set rs = db.getRs(sql, adOpenForwardOnly, adLockReadOnly)
	%>
	<table>
		<tr>
			<th>Unit</th>
			<th>Klas</th>
		<%do until rs.eof
		%><tr><td><% print rs("Unit")%></td><%
		%><td><a href="showScores.asp?view=true&style=list&class=<%=rs("Klas")%>"%><% print rs("Klas")%></a></td></tr><%
		rs.MoveNext
	loop
	%></table><%
	rs.close
	db.CloseConn
	set rs = nothing
	set db = nothing
End Sub
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US">

<head profile="http://gmpg.org/xfn/11">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<title>Elektronische toetsen</title>
<style>
body { font: .76em arial; margin:1em; }
td, th {border:1px solid silver; padding:.2em}
table {border-collapse:collapse}
tr:nth-child(odd) { background-color: #e2f7f7;}
</style>
</head>
<body>
<img src="logoEPI.png" width="200"/>
<h1>Elektronische toetsen</h1>
<%showLinks%>
<p>&nbsp;</p>
<%showClass%>

</body>
</html>

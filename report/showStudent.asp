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
Dim oQuiz
Dim nl
Dim c
Dim br

c = ","
nl = vbNewLine
br = "<br/>"
set oQuiz = new Quiz

Sub displayScores
	Dim db
	Dim rs
	Dim sql
	Dim quizName
	Dim strImagePath

	' init db connection
	set db = oQuiz.getDB()

	' get scores
	sql = "SELECT * FROM vwSummary WHERE Nummer=" & sq(Req("id")) & " ORDER BY lastmodified DESC"
	set rs = db.getRs(sql, adOpenForwardOnly, adLockReadOnly)
	if rs.EOF then
		%><p>Deze student heeft nog geen toetsen afgelegd.</p><%
	else

		strImagePath = getImagePath(rs)
		%>

		<h2>Scores voor student: <strong><%=Req("id")%></strong></h2>

		<%=anchor(strImagePath, img(strImagePath, 120), "lightbox")%>
		<dl>
			<dt>ID</dt><dd><%=rs("Nummer")%></dd>
			<dt>Student</dt><dd><%=rs("Achternaam")%>, <%=rs("Voornaam")%></dd>
			<dt>Klas</dt><dd><%=rs("Klas")%></dd>
		</dl>

		<%
		ShowScoresList rs
	end if

	rs.close
	db.CloseConn
	set rs = nothing
	set db = nothing
End Sub

Sub ShowScoresList(rs)
	Dim strImagePath
	Dim oQuiz

	set oQuiz = new Quiz
	%>
	<table>
	<tr>
		<th>quiz</th>
		<th>status</th>
		<th>score</th>
		<th>time</th>
		<th>view</th>
		<th>delete</th>
	</tr>
	<%
	do until rs.eof
		strImagePath = getImagePath(rs)

		print "<tr>"
		print td(oQuiz.GetName(rs("quiz_id"))) & nl
		print td(rs("status")) & nl
		print td(rs("raw_score")) & nl
		print td(rs("time"))
		%><td><a href="showScores.asp?view=true&details=true&id=<% print rs("quiz_id")%>&student=<%print rs("Nummer")%>">view<a/></td><%
		print vbNewLine
		%><td><a onclick="return confirm('You are about to delete id <%=rs("id")%> for <%=rs("Nummer")%>. Continue?')" href="showScores.asp?action=delete&id=<% print rs("id")%>&student=<%print rs("Nummer")%>">delete<a/></td><%
		print "</tr>"
		rs.MoveNext
	loop
	%></table><%
End Sub

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US">

<head profile="http://gmpg.org/xfn/11">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<title>Resultaten <%=Req("id")%></title>
<link rel="stylesheet" type="text/css" href="/report/lightbox/css/jquery.lightbox-0.5.css" media="screen" />
<link rel="stylesheet" type="text/css" href="tooltips.css" media="screen" />
<link rel="stylesheet" type="text/css" href="report.css" media="screen" />

<script type="text/javascript" src="/DB/jquery.min.js"></script>
<script type="text/javascript" src="/report/lightbox/js/jquery.lightbox-0.5.js"></script>

<script>
$(function() {
	$('a.lightbox').lightBox();
});
</script>
</head>
<body>
<p id="credits"><a href="http://about.me/michiel">Help<span class="tooltip"><span></span>Vragen? Email Michiel van der Blonk : pmvanderblonk@epiaruba.com</span></a></p>
<a href="/report/"><img src="/DB/logo.png" width="200"/></a>
<h1>Resultaten</h1>
<%
displayScores
%>

</body>
</html>

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
Dim days
Dim action
Dim quizVisible

c = ","
nl = vbNewLine
br = "<br/>"
set oQuiz = new Quiz

' Main

action=Req("action")
select case LCase(action)
	case "delete"
	deleteQuizResult Int(Req("id"))
case "export"
	exportResults Req("class")
	case "history"
		days = Req("n")
		if days="" then
			days=1
		end if
		quizVisible = "quizVisible"
	case else
	if Req("view")="" then
		if Req("details")="true" then
			saveDetails
		else
			saveScores
		end if
	end if
end select

' Routines
Sub showHistory(days)
	Dim db
	Dim rs
	Dim sql
	Dim quizName

	REM init db connection
	set db = oQuiz.getDB()

	if Req("id")<>"" then
		quizName = oQuiz.GetName(Req("id"))
end if

	' get scores
	sql = "SELECT * FROM vwSummary"
	sql = sql & " WHERE lastmodified >= DATEADD(day, -" & days &  ", GETDATE())"
	sql = sql & " ORDER BY lastmodified DESC"

	set rs = db.getRs(sql, adOpenForwardOnly, adLockReadOnly)
	showScoresList rs
End Sub

Sub deleteQuizResult(id)
	Dim db
	Dim rs
	Dim sql

	' init db connection
	set db = oQuiz.getDB()

	'  get details
	sql = "DELETE FROM Quiz_Summary WHERE ID=" & id
	db.execute(sql)
	sql = "DELETE FROM Quiz_Detail WHERE summary_id=" & id
	db.execute(sql)
	db.CloseConn
	set rs = nothing
	set db = nothing
End Sub

Sub displayDetails
	Dim db
	Dim rs
	Dim sql
	Dim quizName
	Dim strImagePath

	' init db connection
	set db = oQuiz.getDB()

	quizName = oQuiz.GetName(Req("id"))

	'  get details
	sql = "SELECT * FROM vwDetails "
	sql = sql & "WHERE quizId=" & Req("id") & " "
	if Req("student")<>"" then
		sql = sql & "AND Nummer=" & sq(Req("student")) & " "
	end if
	sql = sql & "ORDER BY timestamp DESC"
	set rs = db.getRs(sql, adOpenForwardOnly, adLockReadOnly)

	strImagePath = getImagePath(rs)

	%>
	<h2>Scores voor quiz: <strong><%=quizname%></strong></h2>
	<%=anchor(strImagePath, img(strImagePath, 120), "lightbox")%>

	<dl>
		<dt>ID</dt><dd><%=rs("Nummer")%></dd>
		<dt>Student</dt><dd><%=rs("Achternaam")%>, <%=rs("Voornaam")%></dd>
		<dt>Klas</dt><dd><%=rs("Klas")%></dd>
		<dt>Percentage</dt><dd><%=rs("raw_score")%>%</dd>
	</dl>
	<table>
	<tr>
		<th>questionNum</th>
		<th>question</th>
		<th>response</th>
		<th>result</th>
		<th>score</th>
		<th>type</th>
	</tr>
	<%
	do until rs.eof
		print "<tr>"
		print td(rs("questionNum")) & nl
		print td(rs("question")) & nl
		print td(rs("student_response")) & nl
		print td(rs("result")) & nl
		print td(rs("score")) & nl
		print td(rs("interaction_type")) & nl
		print "</tr>"
		rs.MoveNext
	loop
	%></table><%
	rs.close
	db.CloseConn
	set rs = nothing
	set db = nothing
End Sub

Sub exportResults(klas)
	Dim db
	Dim rs
	Dim sql
	Dim quizName
	Dim url
	Dim html
	Dim curdir

	REM init db connection
	set db = oQuiz.getDB()

	if Req("id")<>"" then
		quizName = oQuiz.GetName(Req("id"))
	end if

	' get scores
	sql = "SELECT * FROM vwSummary"
	If klas <> "" Then
		sql = sql & " WHERE Klas=" & sq(klas)
		sql = sql & " ORDER BY Klas, Achternaam"
	Else
		sql = sql & " WHERE quiz_id=" & Req("id")
		sql = sql & " ORDER BY lastmodified DESC"
	End If

	curdir=Server.MapPath("/students/")
	set rs = db.getRs(sql, adOpenForwardOnly, adLockReadOnly)
	do until rs.eof
		url = "http://" & Request.ServerVariables("SERVER_NAME") & "/report/showScores.asp?view=true&details=true&id=" & rs("quiz_id") & "&student=" & rs("Nummer")
		html = getHtml(url)
		writeToFile curdir & "\output\" & rs("Nummer") & ".html", html, false
		rs.moveNext
	loop
End Sub

Sub displayScores(klas)
	Dim db
	Dim rs
	Dim sql
	Dim quizName

	REM init db connection
	set db = oQuiz.getDB()

	if Req("id")<>"" then
		quizName = oQuiz.GetName(Req("id"))
	end if

	' get scores
	sql = "SELECT * FROM vwSummary"
	If klas <> "" Then
		sql = sql & " WHERE CurrentClass=" & sq(klas)
		sql = sql & " ORDER BY Klas, Achternaam"
	Else
		sql = sql & " WHERE quiz_id=" & Req("id")
		sql = sql & " ORDER BY lastmodified DESC"
	End If

	set rs = db.getRs(sql, adOpenForwardOnly, adLockReadOnly)

	%>
	<h2>Scores voor quiz: <strong><%=quizname%></strong></h2>

	<%
	if klas<>"" then
		ShowScoresClass rs, klas
	else
		If LCase(Req("style")) = "pictures" Then
			ShowScoresPictures rs
		Else
			ShowScoresList rs
		End If
	end if
	rs.close
	db.CloseConn
	set rs = nothing
	set db = nothing
End Sub

Sub ShowScoresClass(rs, klas)
	Dim strImagePath
	Dim studentId

	do until rs.eof
		if studentId<>rs("Nummer") and studentId<>"" then
			%></table><%
		end if
		if studentId<>rs("Nummer") then
			%><h2><%=rs("Achternaam")%>, <%=rs("Voornaam")%></h2><%
			studentId = rs("Nummer")
			strImagePath = getImagePath(rs)
			%><%=anchor(strImagePath, img(strImagePath, 120), "lightbox")%>

			<dl>
				<dt>ID</dt><dd><a href="showStudent.asp?id=<%print rs("Nummer")%>"><%=rs("Nummer")%><a/></dd>
				<dt>Student</dt><dd><%=rs("Achternaam")%>, <%=rs("Voornaam")%></dd>
				<dt>Klas</dt><dd><%=rs("CurrentClass")%></dd>
			</dl>
			<table>
				<tr>
					<th>quiz</th>
					<th>status</th>
					<th>score</th>
					<th>grade</th>
					<th>time</th>
					<th>view</th>
				</tr>
		<%
		End If

			print "<tr>"
			print td(nvl(rs("quizname"))) & nl
			print td(rs("status")) & nl
			print td(rs("raw_score")) & nl
			print td(round(rs("raw_score")/100*9+1,1)) & nl
			print td(rs("time"))
			%><td><a href="showScores.asp?view=true&details=true&id=<% print rs("quiz_id")%>&student=<%print rs("Nummer")%>">view<a/></td><%
			print vbNewLine
			print "</tr>"
			rs.MoveNext
		loop
End Sub

Sub ShowScoresList(rs)
	Dim strImagePath
	%>
	<table>
	<tr>
		<th class="<%=quizVisible%>">quiz</th>
		<th>photo</th>
		<th>voornaam</th>
		<th>achternaam</th>
		<th>klas</th>
		<th>student</th>
		<th>status</th>
		<th>score</th>
		<th>grade</th>
		<th>time</th>
		<th>view</th>
		<th>delete</th>
	</tr>
	<%
	do until rs.eof
		strImagePath = getImagePath(rs)

		print "<tr>"
		%><td class="<%=quizVisible%>""><%=rs("quizname")%></td><%
		print td(anchor(strImagePath, img(strImagePath, 60), "lightbox")) & nl
		print td(rs("Voornaam")) & nl
		print td(rs("Achternaam")) & nl
		print td(rs("CurrentClass")) & nl
		%><td><a href="showStudent.asp?id=<%print rs("Nummer")%>"><%=rs("Nummer")%><a/></td><%
		print td(rs("status")) & nl
		print td(rs("raw_score")) & nl
		print td(round(rs("raw_score")/100*9+1,1)) & nl
		print td(rs("time"))
		%><td><a href="showScores.asp?view=true&details=true&id=<% print rs("quiz_id")%>&student=<%print rs("Nummer")%>">view<a/></td><%
		%><td><a onclick="return confirm('You are about to delete id <%=rs("id")%> for <%=rs("Nummer")%>. Continue?')" href="showScores.asp?action=delete&id=<% print rs("id")%>&student=<%print rs("Nummer")%>">delete<a/></td><%
		print vbNewLine
		print "</tr>"
		rs.MoveNext
	loop
	%></table><%
End Sub

Sub showScoresPictures(rs)
	Dim strImagePath
	Dim strTitle

	%>
	<div id="photobook">
	<%
	do until rs.eof
		strImagePath = getImagePath(rs)

		%><div><%
		print anchor(strImagePath, img(strImagePath, 120), "lightbox") & nl
		%><dl class="tooltip"><%
		print dt(rs("quiz_id")) & nl
		print dt("Voornaam") & dd(rs("Voornaam")) & nl
		print dt("Achternaam") & dd(rs("Achternaam")) & nl
		print dt("Klas") & dd(rs("Klas")) & nl
		print dt("Nummer") & dd(rs("Nummer")) & nl
		print dt("Status") & dd(rs("status")) & nl
		print dt("Score") & dd(rs("raw_score")) & nl
		print dt("Grade") & dd(round(rs("raw_score")/100*9+1,1)) & nl

		strTitle = rs("Voornaam") & " " & rs("Achternaam") & br
		strTitle = strTitle & "Klas: " & rs("CurrentClass") & br
		strTitle = strTitle & "Nummer: " & rs("Nummer") & br
		strTitle = strTitle & "Status: " & rs("status") & br
		strTitle = strTitle & "Score: " & rs("raw_score") & br
		%></dl>

		<p><a href="showScores.asp?view=true&details=true&id=<% print rs("quiz_id")%>&student=<%print rs("Nummer")%>">details<span class="tooltip"><span></span><%=strTitle%></span><a/></p><%
		print vbNewLine
		print "</div>"
		rs.MoveNext
	loop
	%></table><%
End Sub

Sub saveScores()
	Dim db
	Dim rs
	Dim sql

	Response.ContentType = "text/csv"
	Response.AddHeader "Content-Disposition","attachment; filename=scores.csv"

	set db = oQuiz.getDB()

	sql = "SELECT * FROM vwSummary "
	if Req("id")<>"" Then
		sql = sql & " WHERE quiz_id=" & Req("id")
	end if
	sql = sql & " ORDER BY lastmodified DESC"
	set rs = db.getRs(sql, adOpenForwardOnly, adLockReadOnly)
	print "id,quizname,voornaam,achternaam,klas,student,status,score,time" & vbNewline
	do until rs.eof
		print q(rs("quiz_id")) & c
		print q(nvl(rs("quizname"))) & c
		print q(nvl(rs("Voornaam"))) & c
		print q(nvl(rs("Achternaam"))) & c
		print q(nvl(rs("CurrentClass"))) & c
		print q(rs("Nummer")) & c
		print q(nvl(rs("status"))) & c
		print q(rs("raw_score")) & c
		print q(rs("time"))
		print vbNewLine
		rs.MoveNext
	loop
	rs.close
	db.CloseConn
	set rs = nothing
	set db = nothing
	response.end
end sub

sub saveDetails
	Dim db
	Dim rs
	Dim sql

	Response.ContentType = "text/csv"
	Response.AddHeader "Content-Disposition","attachment; filename=details.csv"

	set db = oQuiz.getDB()

	sql = "SELECT * FROM vwDetails "
	if Req("id")<>"" Then
		sql = sql & " WHERE quizId=" & Req("id")
	end if
	sql = sql & " ORDER BY timestamp DESC"
	set rs = db.getRs(sql, adOpenForwardOnly, adLockReadOnly)
	print "quizid,quizname,student,question_number,question,response,result,score,percentage,type,last,first,class" & vbNewLine
	do until rs.eof
		print q(rs("quizId")) & c
		print q(rs("quizname")) & c
		print q(rs("Nummer")) & c
		print q(rs("questionNum")) & c
		print q(rs("question")) & c
		print q(rs("student_response")) & c
		print q(rs("result")) & c
		print q(rs("score")) & c
		print q(rs("raw_score")) & c
		print q(rs("interaction_type")) & c
		print q(rs("Achternaam")) & c
		print q(rs("Voornaam")) & c
		print q(nvl(rs("CurrentClass")))
		print vbNewLine
		rs.MoveNext
	loop
	rs.close
	db.CloseConn
	set rs = nothing
	set db = nothing
	response.end
End Sub

Sub cleanup()
	Dim db
	Dim rs
	Dim sql

	set db = oQuiz.getDB()

	sql = "SELECT * FROM Quiz_Summary WHERE status=''"
	set rs = db.getRs(sql, adOpenForwardOnly, adLockReadOnly)
	do until rs.eof
		sql = "DELETE FROM Quiz_Detail WHERE summary_id=" & int(rs("ID"))
		db.execute(sql)
		sql = "DELETE FROM Quiz_Summary WHERE ID=" & int(rs("ID"))
		db.execute(sql)
		rs.MoveNext
	loop
	sql = "DELETE FROM Quiz WHERE quizname = ''"
	db.execute(sql)
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

<title>Resultaten</title>
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
<h1>Resultaten
<%if days<>"" then
	if days = 1 then print " vandaag"
	if days > 1 then print " laatste " & days & " dagen"
end if
%>
</h1>
<%
cleanup()

if Req("action")="delete" then
	%>
	<p>Record <%=Req("id")%> for student <a href="showStudent.asp?id=<%=Req("student")%>"><%=Req("student")%><a/> has been deleted.</p>
	<%
else
if Req("view")="true" then
	if Req("class") <> "" then
		displayScores Req("class")
	else
		if Req("details")="true" then
			displayDetails
		else
			%>
			<form name="style" method="get">
			<input type="hidden" name="view" value="<%=Req("view")%>" />
			<input type="hidden" name="id" value="<%=Req("id")%>" />
			<button type="submit" name="style" value="pictures">Pictures</button>
			<button type="submit" name="style" value="list">List</button>
			<button type="submit" name="action" value="export">Export</button>
			</form>
			<%
			displayScores ""
			end if
			end if
	else
		if action="history" then
			showHistory days
		end if
	end if
end if
%>

</body>
</html>

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

Sub ShowClass(klas)
	Dim db
	Dim rs
	Dim sql
	Dim quizName
	Dim strImagePath
	Dim strTitle

	' init db connection
	set db = oQuiz.getDB()

	' get scores
	sql = "SELECT * FROM Students WHERE Klas=" & sq(Req("klas")) & " ORDER BY Achternaam ASC"
' print sql
	set rs = db.getRs(sql, adOpenForwardOnly, adLockReadOnly)
	if rs.EOF then
		%><p>Geen studenten gevonden in klas <%=Req("klas")%>.</p><%
	end if

	%>
	<div id="photobook">
	<%
	do until rs.eof
		strImagePath = getImagePath(rs)

		%><div><%
		print anchor(strImagePath, img(strImagePath, 120), "lightbox") & nl
		%><dl class="tooltip"><%
		print dt("First Name") & dd(rs("FirstName")) & nl
		print dt("Last Name") & dd(rs("LastName")) & nl
		print dt("Class") & dd(rs("Class")) & nl
		print dt("Id") & dd(rs("StudentId")) & nl

		strTitle = rs("FirstName") & " " & rs("LastName") & br
		strTitle = strTitle & "Class: " & rs("Class") & br
		strTitle = strTitle & "Id: " & rs("StudentId") & br
		%></dl>

		<p><a href="showScores.asp?view=true&details=true&student=<%print rs("StudentId")%>"><%=rs("FirstName")%><br/><%=rs("LastName")%><span class="tooltip"><span></span><%=strTitle%></span><a/></p><%
		print vbNewLine
		print "</div>"
		rs.MoveNext
	loop
	%></table><%
End Sub

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US">

<head profile="http://gmpg.org/xfn/11">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<title>Klas <%=Req("klas")%></title>
<link rel="stylesheet" type="text/css" href="/report/lightbox/css/jquery.lightbox-0.5.css" media="screen" />
<link rel="stylesheet" type="text/css" href="tooltips.css" media="screen,print" />
<link rel="stylesheet" type="text/css" href="report.css" media="screen,print" />
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
<a href="/report/"><img id="logo" src="/DB/logo.png" width="200"/></a>
<h1>Klas <%=Req("klas")%></h1>
<%
showClass Req("klas")
%>

</body>
</html>

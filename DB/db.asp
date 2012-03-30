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

Set oQuiz = new Quiz
oQuiz.save
%>
<html>
<body>
<p>Data was saved for <%=oQuiz.options.username%></p>
</body>
</html>
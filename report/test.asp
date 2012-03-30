<%Option Explicit%>
<!--#include file="adovbs.asp"-->
<!--#include file="utils.asp"-->
<!--#include file="debug.asp"-->
<!--#include file="database.asp"-->
<!--#include file="quizdata.asp"-->
<!--#include file="quiz.asp"-->
<%


Sub testConn()
	Dim db
	Dim rs

	set db = new Database
	db.serverName = "SQLEXPRESS"
	db.dbname = "Toets"

show "test start"
show "open conn"
	set rs = db.getRs("SELECT * FROM quiz", adOpenKeyset, adLockOptimistic)
show "query done"
if rs.eof then show "empty"
	do until rs.eof
		show rs("quizname")
		rs.MoveNext
show "record"
	loop
show "done"
	rs.close
	db.CloseConn
	set rs = nothing
	set db = nothing
end sub

sub testUserName()
		dim username

		username = Request.ServerVariables("LOGON_USER")
		show "logon user : " & username
		show "req user : " & Req("quiz[oOptions][strName]")
		show "session user : " & Session.SessionID
end sub

testConn
testUserName
%>
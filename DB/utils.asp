<%
' This Source Code Form is subject to the terms of the Mozilla Public
' License, v. 2.0. If a copy of the MPL was not distributed with this file,
' You can obtain one at http://mozilla.org/MPL/2.0/.

Function Req(s)
	Dim out

	out = ""
	If Request.QueryString(s)<>"" then
		out = Request.QueryString(s)
	End If
	If Request.Form(s)<>"" then
		out = Request.Form(s)
	End If

	Req = out
End Function

Function q(s)
	Dim t
	t = replace(s, chr(34), "'")
	q = chr(34) & t & chr(34)
End Function

Function sq(s)
	sq = "'" & s & "'"
End Function

Function td(s)
	td = "<td>" & s & "</td>"
End Function

Function dt(s)
	dt = "<dt>" & s & "</dt>"
End Function

Function dd(s)
	dd = "<dd>" & s & "</dd>"
End Function

Function img(s, width)
	img = "<img border=" & q(0) & " width=" & q(width) & " src=" & q(s) & "/>"
End Function

Function anchor(link, text, className)
	anchor = "<a class=" & q(className) & " href=" & q(link) & ">" & text & "</a>"
End Function

Function FileExists(f)
	dim fs
	set fs=Server.CreateObject("Scripting.FileSystemObject")
	FileExists = fs.FileExists(Server.MapPath("/") & f)
	set fs=nothing
End Function

Function nvl(s)
	if isnull(s) then
		nvl=""
	else
		nvl = s
	end if
End Function

Function toNumber(s)
	if s="" then
		toNumber=0
	elseif isnumeric(s) then
		toNumber = CDbl(s)
	else
		toNumber = s
	end if
End Function

Function getImagePath(rs)
	Dim strFilePath
	Dim strImagePath
	Dim recordFound

	recordFound = true
	if rs is nothing then
		recordFound = false
	else
		if rs.EOF then
			recordFound = false
		end if
	end if

	if recordFound then
		' get filepath
		if nvl(rs("Photo"))<>"" then
			strFilePath = nvl(rs("Photo"))
		else
			strFilePath = nvl(rs("StudentId")) & ".jpg"
		end if
	end if

	strFilePath = "\students\" & strFilePath
	if not FileExists(strFilePath) then
		strImagePath = "/students/avatar.gif"
	else
		strImagePath = replace(strFilePath, "\", "/")
	end if
	getImagePath = strImagePath
End Function

Function getHTML (strUrl)
	Dim xmlHttp
	
    Set xmlHttp = Server.Createobject("MSXML2.ServerXMLHTTP")
    xmlHttp.Open "GET", strUrl, False
    xmlHttp.setRequestHeader "User-Agent", "asp httprequest"
    xmlHttp.setRequestHeader "content-type", "application/x-www-form-urlencoded"
    xmlHttp.Send
    getHTML = xmlHttp.responseText
    xmlHttp.abort()
    set xmlHttp = Nothing   
End Function

function WriteToFile(FileName, Contents, Append)
	'on error resume next

	Dim oFS
	Dim oTextFile
	Dim iMode
	
	if Append = true then
	   	iMode = 8
	else 
	   	iMode = 2
	end if
	set oFs = server.createobject("Scripting.FileSystemObject")
	set oTextFile = oFs.OpenTextFile(FileName, iMode, True)
	oTextFile.Write Contents
	oTextFile.Close
	set oTextFile = nothing
	set oFS = nothing

end function
%>
<%
' This Source Code Form is subject to the terms of the Mozilla Public
' License, v. 2.0. If a copy of the MPL was not distributed with this file,
' You can obtain one at http://mozilla.org/MPL/2.0/.

Class Database
	Public appName ' as String
	Public dbname ' as String
	Public serverName ' as String
	Public oConn ' as ADODB.Connection

	Sub OpenConn()
		Dim strDBPath
		Dim strConn
		Dim errItem
		Dim dbserver

		dbname = config.dbname
		serverName = config.dbserver

		If dbname = "" Then
			Err.Raise 1, "Toets app: no database name given"
		End If
		If serverName = "" Then
			Err.Raise 1, "Toets app: no server name given"
		End If

		dbserver = replace(serverName, ".\", "")
		strConn = "Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;User ID=;Password=;Initial Catalog=" & dbName & ";Data Source=" & dbserver
		strConn = "Provider=SQLOLEDB.1;SERVER=.\" & serverName & ";DATABASE=" & dbname & ";Initial Catalog=" & dbname & ";UID=web;PWD=P@ssw0rd;"

		If Not IsEmpty(oConn) Then
			If oConn.State = adStateOpen Then
				Exit Sub
			End If
		End If
		Set oConn = Server.CreateObject("ADODB.Connection")
		' Show "db open conn " & strConn
		On Error Resume Next
		oConn.Open strConn
		If oConn.State = adStateClosed Then
			print "database connection cannot be opened: " & Err.Description
			response.end
		End If

		If oConn.Errors.Count <> 0 Then
			For Each errItem In oConn.Errors
				If errItem.NativeError <> 5701 Then
					Response.Write "<br>NativeError = " & errItem.NativeError
					Response.Write "<br>Description = " & errItem.Description
					Response.Write "<br>SQLState	= " & errItem.SqlState
					Response.Write "<br>Source	  = " & errItem.Source
				End If
			Next
		End If
	End Sub

	Sub CloseConn()
		If TypeName(oConn) <> "Nothing" Then
			oConn.Close
			Set oConn = Nothing
		End If
	End Sub

	Function getRs(sQuery, intCursorType, intLockType)
		OpenConn

		Dim rs
		Set rs = Server.CreateObject("ADODB.Recordset")
		rs.Open sQuery, oConn, intCursorType, intLockType
		Set getRs = rs
	End Function


	Function getRsReadOnly(sQuery)
		OpenConn

		Dim rs
		Set rs = Server.CreateObject("ADODB.Recordset")
		rs.Open sQuery, oConn, adOpenForwardOnly, adLockReadOnly
		Set getRsReadOnly = rs
	End Function

	Function execute(sQuery)
		OpenConn

		oConn.execute sQuery
	End Function

	Function getRs2(sQuery, intCursorType, intLockType)
		OpenConn

		Dim rs
		Set rs = Server.CreateObject("ADODB.Recordset")
		rs.Open sQuery, oConn, intCursorType, intLockType
		Set getRsReadOnly = rs
	End Function

	Function quote(sText) ' As String
		If IsNull(sText) Then
			quote = ""
		Else
			quote = "'" & sText & "'"
		End If
	End Function

	Function getRecordAsText(strTable, strKey, id)
		Dim oRs				 ' As ADODB.Recordset

		Set oRs = oConn.Execute("SELECT * FROM " & strTable & " WHERE " & strKey & " = " & id)
		getRecordAsText = oRs.GetString(adClipString, , vbNewLine)
		oRs.Close
	End Function

	Function DeleteRows(strTable, strKey, selectedRows)
		Dim oRs				 ' As ADODB.Recordset
		Dim strSQL		  ' As String
		Dim bOK				 ' As Boolean

		OpenConn

		bOK = True

		If selectedRows <> "" Then
			strSQL = "SELECT * FROM " & strTable & " WHERE " & strKey & " IN (" & selectedRows & ")"
			Set oRs = getRsReadOnly(strSQL)
			If oRs.EOF Then
				bOK = False
			Else
				strSQL = Replace(strSQL, "SELECT", "DELETE")
				On Error Resume Next
				oConn.Errors.Clear
				oConn.Execute strSQL
				If oConn.Errors.Count > 0 Then
					bOK = False
				End If
			End If
		End If
		oRs.Close
		CloseConn

		DeleteRows = bOK
	End Function

	Function UpdateRow(strTable, strKey, id)
		Dim oRs				 ' As ADODB.Recordset
		Dim strSQL		  ' As String
		Dim bOK				 ' As Boolean
		Dim oField		  ' As ADODB.Field

		OpenConn

		bOK = True

		' make sure we have a valid id
		If id = "" Then
			id = -1
		End If
		strSQL = "SELECT * FROM " & strTable & " WHERE " & strKey & " = " & id

		Set oRs = getRs(strSQL, 0, 0)
		' in new mode (no record found), we need to add a record
		If oRs.EOF Then
			oRs.AddNew
		End If
		' loop through rs
		For Each oField In oRs.Fields
			' do not update the primary key
			If oField.name <> strKey Then
				oField.Value = request(oField.name)
			End If
		Next
		On Error Resume Next
		oConn.Errors.Clear
		oRs.Update
		If oConn.Errors.Count > 0 Then
			bOK = False
		End If

		oRs.Close
		CloseConn

		UpdateRow = bOK
	End Function

	Function NVL(oRs, strField)
		If oRs.EOF Then
			NVL = ""
		Else
			NVL = oRs(strField).Value
		End If
	End Function

End Class
%>
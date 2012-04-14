<%
' This Source Code Form is subject to the terms of the Mozilla Public
' License, v. 2.0. If a copy of the MPL was not distributed with this file,
' You can obtain one at http://mozilla.org/MPL/2.0/.

sub Assert( boolExpr, strOnFail )
	 if not boolExpr then
		Response.Write("Error -> " & Err.Number - vbObjectError)
		Response.write("<BR>Error Source -> " & Err.Source)
		Response.Write("<BR>Error Desc   -> " & Err.Description)
		Err.Raise vbObjectError + 1, "Toets app", strOnFail
		Err.Clear
	end if
end sub

sub print(var)
	response.write var
end sub
    
sub show(var)
	response.write "<pre class=""debug"">" & vbNewline
	response.write var & vbNewline
	response.write "</pre>"
end sub

sub warning(var)
	response.write "<pre class=""warning"">" & vbNewline
	response.write var & vbNewline
	response.write "</pre>"
end sub

sub showerror(var)
	response.write "<div style=""color:red;font-weight:bold"">" & vbNewline
	Err.Raise 1,,var
	response.write "</pre>"	
end sub

sub showhtml(out)
		out = Server.HTMLEncode(out)
		out = replace(out, vbNewline, "<br>")
		response.write out
end sub
	
sub showrequest()
	response.write "<pre class=""debug"">" & vbNewline
	response.write "REQUEST:<br>" & vbNewline
	for each key in Request.QueryString
		response.write key & "=" & Request(key) & "<br>"				
	next
	response.write "</pre>"
end sub

sub showpost()
	response.write "<pre class=""debug"">" & vbNewline
	response.write "POST:<br>" & vbNewline
	for each key in Request.Form
		response.write key & "=" & Request(key) & "<br>"
	next
	response.write "</pre>"
end sub

sub showcookies()
	response.write "<pre class=""debug"">" & vbNewline
	response.write "COOKIES:<br>" & vbNewline
	for each key in Response.Cookies
		response.write key & "=" & Request.Cookies(key) & "<br>"
	next
	response.write "</pre>"
end sub

sub showsession()
	response.write "<pre class=""debug"">" & vbNewline
	response.write "SESSION:<br>" & vbNewline
	for each key in Session.Contents
		response.write key & "=" & Session(key) & "<br>"
	next
	response.write "</pre>"
end sub

sub showenv()
	response.write "<pre class=""debug"">" & vbNewline
  response.write "ENV:<br>" & vbNewline
	response.write "</pre>"
end sub

sub showserver()
	response.write "<pre class=""debug"">" & vbNewline
	response.write "SERVER:<br>" & vbNewline
	for each key in Request.ServerVariables
		response.write key & "=" & Request.ServerVariables(key) & "<br>"
	next
	response.write "</pre>"
end sub

sub showglobals()
	response.write "<pre class=""debug"">" & vbNewline
	response.write "GLOBALS:<br>" & vbNewline
	response.write "</pre>"
end sub

sub showarray(rij)
	response.write "<pre style=""background:SpringGreen"">" & vbNewline
	response.write "Array:<br>" & vbNewline
	for each key in rij	
		response.write key & "=" & rij(key) & "<br>" & vbNewline
	next
	response.write "</pre>"
end sub
	
sub showrecordset(rs)
	Dim f
	
	response.write "<pre style=""background:SpringGreen"">" & vbNewline
	response.write "Recordset:<br>" & vbNewline
	showrsfields rs
	do until rs.eof
		%><tr><%
		for each f in rs.fields
			%><td style="border:1px solid black"><%=left(f.value,12)%></td><%
		next
		%></tr><%
		rs.movenext		
	loop
	%></table><%
	response.write "</pre>"
end sub

sub showrsfields(rs)
	Dim f
	response.write "<pre style=""background:SpringGreen"">" & vbNewline
	%><table><%
	%><tr><%
	for each f in rs.fields
		%><th style="border:1px solid black"><%=left(f.name,12)%></th><%
	next
	%></tr><%
end sub

sub showdict(d)
	dim key
	
	if not isobject(d) then
		exit sub
	end if
	response.write "<br>Dictionary:<br>" & vbNewline
	%><table class="debug" ><%
	for each key in d	
		%><tr><td style="border:1px solid black"><%
		if isObject(d(key)) then
			response.write key 
			%></td><td style="border:1px solid black"><%
			showdict d(key)
		else
			response.write key 
			%></td><td style="border:1px solid black"><%
			response.write d(key) & "<br>" & vbNewline
		end if		
		%></td></tr><%
	next
	%></table><%
end sub		 

sub showpage(p)
	response.write "<br>Page:<br>" & vbNewline
	%><table class="debug">
			<tr><td>table</td>				<td><%=p.table%></td></tr>
			<tr><td>primarykey</td>		<td><%=p.primarykey%></td></tr>
			<tr><td>sql</td>					<td><%=p.sql%></td></tr>
			<tr><td>fields</td>				
				<td>
					<%
					for each key in p.fields
						set field = p.fields(key)
						response.write field.name
						if field.name <> p.fields(p.fields.count-1).name then
							response.write ", "
						end if
					next
					%>
				</td>
			</tr>
			<tr><td>page_size</td>		<td><%=p.page_size%></td></tr>
			<tr><td>page_number</td>	<td><%=p.page_number%></td></tr>
			<tr><td>url</td>					<td><%=p.url%></td></tr>
			<tr><td>querystring</td>	<td><%=p.querystring%></td></tr>
	</table><%
end sub

sub showfield(f)
	response.write "<br>Field:<br>" & vbNewline
	%><table class="debug">
			<tr><td>name</td>					<td><%=f.name%></td></tr>
			<tr><td>datatype</td>			<td><%=f.datatype%></td></tr>
			<tr><td>displaytype</td>	<td><%=f.displaytype%></td></tr>
			<tr><td>islookup</td>			<td><%=f.islookup%></td></tr>
			<tr><td>values</td>				<td><%showdict f.lookup.values%></td></tr>
			<tr><td>isnumber</td>			<td><%=f.isnumber%></td></tr>
			<tr><td>isboolean</td>		<td><%=f.isboolean%></td></tr>
			<tr><td>iskey</td>				<td><%=f.iskey%></td></tr>
			<tr><td>formatting</td>		<td><%=f.formatting%></td></tr>
			<tr><td>decimals</td>			<td><%=f.decimals%></td></tr>
			<tr><td>default</td>			<td><%=f.default%></td></tr>
	</table><%
end sub

sub showlookup(l)
	response.write "<br>Lookup:<br>" & vbNewline
	%><table class="debug">
			<tr><td>Table</td>			<td><%=l.Table%></td></tr>
			<tr><td>Field</td>			<td><%=l.Field%></td></tr>
			<tr><td>Key</td>				<td><%=l.Key%></td></tr>
			<tr><td>Values</td>			<td><%showdict l.values%></td></tr>
	</table><%
end sub

%>

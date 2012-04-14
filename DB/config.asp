<%
' This Source Code Form is subject to the terms of the Mozilla Public
' License, v. 2.0. If a copy of the MPL was not distributed with this file,
' You can obtain one at http://mozilla.org/MPL/2.0/.

Class Configuration
	public dbname
	public dbserver
	public dbtype
	public dbfile
	public useDomain
	public domain

	public mail_ssl
	public smtp_ssl
	public smtp_port
	public smtp_server
	public smtp_user
	public smtp_pass
	public smtp_auth

End Class

Dim config
set config = new Configuration
config.dbname = "Toets"
config.dbserver = "SQLEXPRESS"
config.dbtype = "MS Access" ' MSSQL or MS Access
config.dbfile = "/DB/quizbaker.mdb"
config.useDomain = false
config.domain = "DOMAIN"

config.smtp_ssl	= True
config.smtp_port = 465
config.smtp_server = "smtp.example.com"
config.smtp_user = "user"
config.smtp_pass = "password"
config.smtp_auth = 1
%>
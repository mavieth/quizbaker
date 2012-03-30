<%
' This Source Code Form is subject to the terms of the Mozilla Public
' License, v. 2.0. If a copy of the MPL was not distributed with this file,
' You can obtain one at http://mozilla.org/MPL/2.0/.

Class Configuration
	public dbname
	public dbserver
End Class

Dim config
set config = new Configuration
config.dbname = "Toets"
config.dbserver = "SQLEXPRESS"
%>
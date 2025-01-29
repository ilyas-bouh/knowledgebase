//%attributes = {}
#DECLARE()->$token : Text

var $force : Boolean
If (Count parameters:C259=1)
	$force:=$1
End if 
If (Storage:C1525.creds.token#Null:C1517) & Not:C34($force)
	$token:=Storage:C1525.creds.token
Else 
	var $response : Object
	var $url; $body : Text
	ARRAY TEXT:C222($headerNames; 0)
	ARRAY TEXT:C222($headerValues; 0)
	APPEND TO ARRAY:C911($headerNames; "Content-Type")
	APPEND TO ARRAY:C911($headerValues; "application/x-www-form-urlencoded")
	$url:="https://login.microsoftonline.com//oauth2/v2.0/token"
	$body:="grant_type=client_credentials&client_id=&client_secret=&scope=https%3A%2F%2Fgraph.microsoft.com%2F.default"
	$res:=HTTP Request:C1158(HTTP POST method:K71:2; $url; $body; $response; $headerNames; $headerValues)
	If ($res=200)
		$token:=$response.access_token
	Else 
		TRACE:C157
	End if 
	Use (Storage:C1525)
		Storage:C1525.creds:=New shared object:C1526()
		Use (Storage:C1525.creds)
			Storage:C1525.creds.token:=$token
		End use 
	End use 
End if 


//%attributes = {}




#DECLARE($path : Text)->$sharepointBlob : Blob


//$Drives:=getDrives()

//$docDrive:=$Drives[3]


//$path:="2024/hi.png"


var $response : Object
var $body : Text
var $drives : Collection
var $driveOBJ : Object

ARRAY TEXT:C222($headerNames; 0)
ARRAY TEXT:C222($headerValues; 0)
APPEND TO ARRAY:C911($headerNames; "authorization")
APPEND TO ARRAY:C911($headerValues; "Bearer "+GraphAPI_getToken())

APPEND TO ARRAY:C911($headerNames; "Content-Type")
APPEND TO ARRAY:C911($headerValues; "application/x-www-form-urlencoded")

$siteId:="569bf4ea-b183-43df-9594-32fe75b8db8b"
$driveId:=$docDrive.id
$getFileURL:="https://graph.microsoft.com/v1.0/sites/"+$siteId+"/drives/"+$driveId+"/root:/2024/"+$path+":/content"

$res:=HTTP Request:C1158(HTTP GET method:K71:1; $getFileURL; $body; $response; $headerNames; $headerValues)



If ($res=200)
	$sharepointBlob:=$response
	
Else 
	TRACE:C157
End if 












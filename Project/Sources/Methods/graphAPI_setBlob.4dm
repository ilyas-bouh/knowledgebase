//%attributes = {}
#DECLARE($sharepointBlob : Blob; $uuid : Text)->$path : Text

var $response : Object
var $body : Blob
var $drives : Collection
var $driveOBJ : Object
ARRAY TEXT:C222($headerNames; 0)
ARRAY TEXT:C222($headerValues; 0)


APPEND TO ARRAY:C911($headerNames; "authorization")
APPEND TO ARRAY:C911($headerValues; "Bearer "+GraphAPI_getToken())
APPEND TO ARRAY:C911($headerNames; "Content-Type")
APPEND TO ARRAY:C911($headerValues; "application/x-www-form-urlencoded")


$siteId:=""
$driveId:=""  //$docDrive.id
$getFileURL:="https://graph.microsoft.com/v1.0/sites/"+$siteId+"/drives/"+$driveId+"/root:/2024/"+$uuid+":/content"


$body:=$sharepointBlob
$res:=HTTP Request:C1158(HTTP PUT method:K71:6; $getFileURL; $body; $response; $headerNames; $headerValues)

If (($res=200) | ($res=201))
	$path:=$uuid
Else 
	TRACE:C157
End if 












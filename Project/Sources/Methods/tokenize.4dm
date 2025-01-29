//%attributes = {}
C_LONGINT:C283($i)
C_TEXT:C284($code)

ARRAY TEXT:C222($_name; 0)
METHOD GET NAMES:C1166($_name)


For ($i; 1; Size of array:C274($_name))
	
	METHOD GET CODE:C1190($_name{$i}; $code; Code with tokens:K72:18)
	METHOD SET CODE:C1194($_name{$i}; $code)
	
End for 
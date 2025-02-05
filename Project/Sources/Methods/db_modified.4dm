//%attributes = {}
//Method: DB_ModifiedRecord
//Description
// Find if any field in current record has been modified
// may not work yet with Object fields
// Parameters
// $0 : $ResultObject
//       .Modified : True|False
//       .FieldPtrs : array of field pointers
//       .FieldNames : array of field names
//       .AllFieldNames : All field names separated by ";"
// $1 : $TblPtr
// ${2} : $fldToSkip_ptr - optional 
// ----------------------------------------------------
If (False:C215)
	// ----------------------------------------------------
	//User name (OS): Costas Manousakis
	//User (4D) : Designer
	//Created : 
	//Date and time: Mar 14, 2023, 17:38:33
	Mods_2023_03
	// ----------------------------------------------------
	
	C_OBJECT:C1216(DB_ModifiedRecord; $0)
	C_POINTER:C301(DB_ModifiedRecord; $1)
	C_POINTER:C301(DB_ModifiedRecord; ${2})
	
End if 
//
C_OBJECT:C1216($0)
C_POINTER:C301($1)

C_LONGINT:C283($TblNum_L; $FldNum_L)
$TblNum_L:=Table:C252($1)
C_LONGINT:C283($numParams_L; $pLoop_L; $numFlds_L; $fLoop_L; $Pos_L; $FldType_L; $FldLen_L)
ARRAY POINTER:C280($FldsToSkip_aptr; 0)
$numParams_L:=Count parameters:C259
If ($numParams_L>1)
	C_POINTER:C301(${2})
	For ($pLoop_L; 2; $numParams_L)
		APPEND TO ARRAY:C911($FldsToSkip_aptr; ${$pLoop_L})
	End for 
	
End if 
ARRAY POINTER:C280($ChangedFlds_aptr; 0)
ARRAY TEXT:C222($ChangedFlds_atxt; 0)
C_COLLECTION:C1488($ChangedFldPtrs_c; $ChangedFldNames_c; $OldData_c; $NewData_c)
$ChangedFldPtrs_c:=New collection:C1472
$ChangedFldNames_c:=New collection:C1472
$OldData_c:=New collection:C1472
$NewData_c:=New collection:C1472

C_TEXT:C284($AllChangedFlds_txt)
$numFlds_L:=Get last field number:C255($1)
C_POINTER:C301($fld_ptr)
For ($fLoop_L; 1; $numFlds_L)
	If (Is field number valid:C1000($TblNum_L; $fLoop_L))
		$fld_ptr:=Field:C253($TblNum_L; $fLoop_L)
		If (Find in array:C230($FldsToSkip_aptr; $fld_ptr)>0)
			
		Else 
			GET FIELD PROPERTIES:C258($fld_ptr; $FldType_L; $FldLen_L)
			Case of 
				: (Type:C295($fld_ptr->)=Is subtable:K8:11)
					// will not do this one - should not be any subtables in db anyway
				: (Type:C295($fld_ptr->)=Is object:K8:27)
					// can't check this now
					
				: (Type:C295($fld_ptr->)=Is picture:K8:10)
					C_LONGINT:C283($newSize; $oldSize)
					$newSize:=Picture size:C356($fld_ptr->)
					$oldSize:=Picture size:C356(Old:C35($fld_ptr->))
					Case of 
						: ($newSize=0) & ($oldSize=0)
							//both blank
						: ($newSize#$oldSize)
							//not same size
							$ChangedFldPtrs_c.push($fld_ptr)
							$ChangedFldNames_c.push(Field name:C257($fld_ptr))
							$OldData_c.push("Pic size:"+String:C10($oldSize))
							$NewData_c.push("Pic Size:"+String:C10($newSize))
							$AllChangedFlds_txt:=$AllChangedFlds_txt+Field name:C257($fld_ptr)+"(pic size:"+String:C10($oldSize)+"-"+String:C10($newSize)+");"
						Else 
							C_PICTURE:C286($mask_)
							If (Equal pictures:C1196($fld_ptr->; Old:C35($fld_ptr->); $mask_))
							Else 
								$ChangedFldPtrs_c.push($fld_ptr)
								$ChangedFldNames_c.push(Field name:C257($fld_ptr))
								$OldData_c.push("Pic size:"+String:C10($oldSize))
								$NewData_c.push("Pic Size:"+String:C10($newSize))
								$AllChangedFlds_txt:=$AllChangedFlds_txt+Field name:C257($fld_ptr)+"(pic size:"+String:C10($oldSize)+"-"+String:C10($newSize)+");"
							End if 
							
					End case 
					
				: (Type:C295($fld_ptr->)=Is BLOB:K8:12)
					C_BLOB:C604($t_x)
					$t_x:=Old:C35($fld_ptr->)
					
					Case of 
						: (BLOB size:C605($fld_ptr->)=0) & (BLOB size:C605($t_x)=0)
							
						: (BLOB size:C605($fld_ptr->)#BLOB size:C605($t_x))
							$ChangedFldPtrs_c.push($fld_ptr)
							$ChangedFldNames_c.push(Field name:C257($fld_ptr))
							$OldData_c.push("Blob size:"+String:C10(BLOB size:C605($t_x)))
							$NewData_c.push("Blob Size:"+String:C10(BLOB size:C605($fld_ptr->)))
							$AllChangedFlds_txt:=$AllChangedFlds_txt+Field name:C257($fld_ptr)+"(Blob size:"+String:C10(BLOB size:C605($t_x))+"-"+String:C10(BLOB size:C605($fld_ptr->))+");"
						Else 
							C_LONGINT:C283($BlobLen; $byte)
							$BlobLen:=BLOB size:C605($fld_ptr->)
							C_BLOB:C604($tO_x)
							$tO_x:=$fld_ptr->
							For ($byte; 0; $BlobLen-1)
								If ($t_x{$byte}#$tO_x{$byte})
									$ChangedFldPtrs_c.push($fld_ptr)
									$ChangedFldNames_c.push(Field name:C257($fld_ptr))
									$OldData_c.push("Blob size:"+String:C10(BLOB size:C605($t_x)))
									$NewData_c.push("Blob Size:"+String:C10(BLOB size:C605($fld_ptr->)))
									$AllChangedFlds_txt:=$AllChangedFlds_txt+Field name:C257($fld_ptr)+"(Blob size:"+String:C10(BLOB size:C605($t_x))+"-"+String:C10(BLOB size:C605($fld_ptr->))+");"
									$byte:=$BlobLen+1
								End if 
							End for 
							
					End case 
					
				: (Type:C295($fld_ptr->)=Is text:K8:3) | (Type:C295($fld_ptr->)=Is alpha field:K8:1)
					If (Length:C16($fld_ptr->)=Length:C16(Old:C35($fld_ptr->)))
						If (Length:C16($fld_ptr->)>0)  // if both are blank no need to push anything
							$Pos_L:=Position:C15($fld_ptr->; Old:C35($fld_ptr->); *)
							If ($Pos_L=0)
								$ChangedFldPtrs_c.push($fld_ptr)
								$ChangedFldNames_c.push(Field name:C257($fld_ptr))
								$OldData_c.push(Old:C35($fld_ptr->))
								$NewData_c.push($fld_ptr->)
								$AllChangedFlds_txt:=$AllChangedFlds_txt+Field name:C257($fld_ptr)+":["+Substring:C12(Old:C35($fld_ptr->); 1; 100)+"]->["+Substring:C12($fld_ptr->; 1; 100)+"] ;"
							End if 
						End if 
					Else 
						//not same length
						$ChangedFldPtrs_c.push($fld_ptr)
						$ChangedFldNames_c.push(Field name:C257($fld_ptr))
						$OldData_c.push(Old:C35($fld_ptr->))
						$NewData_c.push($fld_ptr->)
						$AllChangedFlds_txt:=$AllChangedFlds_txt+Field name:C257($fld_ptr)+":["+Substring:C12(Old:C35($fld_ptr->); 1; 100)+"]->["+Substring:C12($fld_ptr->; 1; 100)+"] ;"
					End if 
					
				Else 
					
					// for other field types (except object)
					If (($fld_ptr->)#Old:C35($fld_ptr->))
						$ChangedFldPtrs_c.push($fld_ptr)
						$ChangedFldNames_c.push(Field name:C257($fld_ptr))
						$OldData_c.push(Old:C35($fld_ptr->))
						$NewData_c.push($fld_ptr->)
						$AllChangedFlds_txt:=$AllChangedFlds_txt+Field name:C257($fld_ptr)+":["+String:C10(Old:C35($fld_ptr->))+"]->["+String:C10($fld_ptr->)+"] ;"
					End if 
			End case 
			
		End if 
	End if 
End for 

If ($ChangedFldPtrs_c.length>0)
	OB SET:C1220($0; "Modified"; True:C214; \
		"FieldPtrs"; $ChangedFldPtrs_c; \
		"FieldNames"; $ChangedFldNames_c; \
		"OldData"; $OldData_c; \
		"NewData"; $NewData_c; \
		"AllFieldNames"; $AllChangedFlds_txt)
Else 
	OB SET:C1220($0; "Modified"; False:C215)
End if 
//End DB_ModifiedRecord   
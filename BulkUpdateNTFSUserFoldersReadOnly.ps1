##specify folder path here
$folderlist = Get-Content -Path C:\Users\administrator.ivantisinc\desktop\UserFolders.txt
##iterate through each line of the specific file for path
foreach ($folder in $folderlist)
{
$path = $folder
##define control properties on each folder
$InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
$PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None
$objType = [System.Security.AccessControl.AccessControlType]::Allow 
$acl = Get-Acl $path
##splits folder name based on \ character and takes last part of array resulting in username
$identity = $path.split("\")[-1]
$permission = $identity,"Read", $InheritanceFlag, $PropagationFlag, $objType
##applies new permissions to folder
$newacl = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
$acl.SetAccessRule($newacl)
Set-Acl $path $acl
}

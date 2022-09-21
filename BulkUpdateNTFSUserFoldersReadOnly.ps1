# use case: each AD user has their own user folder stored on file server with folder name matching their samaccountname
# each user is set with explicit NTFS permissions for RW to only their own folder
# script is to quickly go through all folders and change permissions to R 

# specify folder path here
$folderlist = Get-Content -Path C:\Users\administrator.ivantisinc\desktop\UserFolders.txt # this list was populated with PS get-childitem -dir then saved to file. Could also pipe directly 
# iterate through each line of the specific file for path
foreach ($folder in $folderlist)
{
$path = $folder
# define control properties on each folder
$InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit # https://learn.microsoft.com/en-us/dotnet/api/system.security.accesscontrol.inheritanceflags?view=net-6.0
$PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None
$objType = [System.Security.AccessControl.AccessControlType]::Allow 
$acl = Get-Acl $path
# splits folder name based on \ character and takes last part of array resulting in username
$identity = $path.split("\")[-1]
$permission = $identity,"Read", $InheritanceFlag, $PropagationFlag, $objType
# applies new permissions to folder
$newacl = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
$acl.SetAccessRule($newacl)
Set-Acl $path $acl
}

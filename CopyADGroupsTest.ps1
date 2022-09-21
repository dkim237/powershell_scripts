$currentuser = Read-Host -Prompt 'Input existing user to copy from:'
$newuser = Read-Host -Prompt 'Input new user to copy to:'
Get-AdUser -Filter "name -like '*$currentuser*'" -Properties memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -Members -Filter "name -like '*$newuser*'"

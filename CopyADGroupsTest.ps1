# Script to quickly copy AD group memberships from one user to another

# Prompts user for original we are copying from, and user we are copying to
$currentuser = Read-Host -Prompt 'Input existing user to copy from:'
$newuser = Read-Host -Prompt 'Input new user to copy to:'
# Locates user based on filtering, selects memberof attribute, then applies this to our target user
Get-AdUser -Filter "name -like '*$currentuser*'" -Properties memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -Members -Filter "name -like '*$newuser*'"

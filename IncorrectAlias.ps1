#

$users = Import-CSV -path "C:\Powershell\UserAlias\Test.csv"
$CompleteReport=@()
foreach ($user in $users) {
    $firstname = $user.first
    $lastname = $user.last
    $fullusername =  ("{0}.{1}@domain.com" -f $firstname,$lastname)
    $aduser = Get-ADUser -filter * | where UserPrincipalName -notlike "$fullusername"
    $CompleteReport = $CompleteReport+$aduser
}
$CompleteReport | Export-CSV "C:\Powershell\UserAlias\correctalias.csv -NoTypeInformation

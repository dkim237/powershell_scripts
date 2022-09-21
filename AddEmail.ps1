$users = import-csv -path C:\userlist.csv
foreach ($user in $users){
    Get-ADUser -Filter "SamAccountName -eq '$($user.samaccountname)'" | Set-ADUser -EmailAddress $($user.samaccountname + '@ivantisinc.com')
    }

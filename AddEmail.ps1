# defines user list based on CSV file
$users = import-csv -path C:\userlist.csv
# iterates through each user in CSV, locates matching user based on samAccountName, pipes this to command to define email address field in AD
foreach ($user in $users){
    Get-ADUser -Filter "SamAccountName -eq '$($user.samaccountname)'" | Set-ADUser -EmailAddress $($user.samaccountname + '@domain.com')
    }

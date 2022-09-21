# Script to generate an organized report on the status of MFA enforcement across an entire O365/AAD tenant

Write-Host "Finding Azure Active Directory Accounts..." # simple message indicating current action
$Users = Get-MsolUser -All | ? { $_.UserType -ne "Guest" } # stores all AAD users excluding any guest accounts in object Users
$Report = [System.Collections.Generic.List[Object]]::new() # Creates formatted table output file
Write-Host "Processing" $Users.Count "accounts..." # notifies user of total number of user objects discovered stored in Users variable
ForEach ($User in $Users) { # iterating through each user object 
    $MFAMethods = $User.StrongAuthenticationMethods.MethodType # stores the type of MFA method utilized, defined below
    $MFAEnforced = $User.StrongAuthenticationRequirements.State # stores whether MFA is enforced/enabled for the user
    $MFAPhone = $User.StrongAuthenticationUserDetails.PhoneNumber # stores if user has MFA phone number registered
    $DefaultMFAMethod = ($User.StrongAuthenticationMethods | ? { $_.IsDefault -eq "True" }).MethodType # stores MFA method if current is default option
    If (($MFAEnforced -eq "Enforced") -or ($MFAEnforced -eq "Enabled")) { # checks if value stored in MFAMethods is either enforced or enabled
        Switch ($DefaultMFAMethod) { # switch statement to evaluate series of parameters for which mfa method is utilized
            "OneWaySMS" { $MethodUsed = "One-way SMS" } # if SMS is used, stored as defined
            "TwoWayVoiceMobile" { $MethodUsed = "Phone call verification" } # if phone call option is used, stored as defined
            "PhoneAppOTP" { $MethodUsed = "Hardware token or authenticator app" } # OTP used, stored as defined
            "PhoneAppNotification" { $MethodUsed = "Authenticator app" } # OTP + push notification, stored as defined
        }
    }
    Else { # if MFAEnforced is neither enabled or enforced, stored as not enabled and not used
        $MFAEnforced = "Not Enabled"
        $MethodUsed = "MFA Not Used" 
    }
  
    $ReportLine = [PSCustomObject] @{ # stores below variables in a single line to be added to final report
        User        = $User.UserPrincipalName # user displayed as UPN (email format)
        Name        = $User.DisplayName # Display Name (full name of user)
        MFAUsed     = $MFAEnforced # whether MFA is enforced, enabled, or not enabled
        MFAMethod   = $MethodUsed # type of MFA used which is either sms, call, otp, or push notif
        PhoneNumber = $MFAPhone # phone number used for MFA
    }
                 
    $Report.Add($ReportLine) # adds each line generated into one larger table
}

Write-Host "Report is in c:\temp\MFAUsers.CSV" # notifies user where report is being saved in csv format
$Report | Select Name, MFAUsed, MFAMethod, PhoneNumber | Sort Name | Out-GridView # selects all items and outputs in table display with column headers
$Report | Sort Name | Export-CSV -NoTypeInformation c:\temp\MFAUsers.csv # generates and saves report to location here

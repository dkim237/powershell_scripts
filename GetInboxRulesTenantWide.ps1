# simple script to pull a list of all server side inbox rules for mail users through EXOP

# first command lists all available mailboxes in EO
get-mailbox -resultsize unlimited |
foreach { # iterates through each mailbox
    Write-Verbose "Checking $($_.alias)..." -Verbose
    $inboxrule = get-inboxrule -Mailbox $_.alias # defines variable inboxrule
    if ($inboxrule) { # if inboxrule is not null, proceeds with another for loop
        foreach ($rule in $inboxrule) { # for every rule listed in inboxrule, stored in object formatted to display the following
        [PSCustomObject]@{
            Mailbox = $_.alias # name of mailbox owner
            Rulename = $rule.name # name of the rule
            Rulepriority = $rule.priority # priority level of the rule starting with 0 as highest
            Ruledescription = $rule.description # description of rule if present
            MovedToFolder = $rule.MoveToFolder # specifies the move action, syntax is "mailboxID:\ParentFolder[\subfolder]"
        }
    }
    }
} |
# after iterating through all above, exports to current users desktop titled "export.csv"
Export-csv "$env:userprofile\desktop\export.csv" -NoTypeInformation

# Prompt the user for admin credentials
$creds = Get-Credential -Message "Enter domain admin credentials"

# Specify the server
$domain_controller = "*insert domain controller FQDN here*"

# Loop to copy group memberships for multiple source and target users
while ($true) {
    # Prompt the user for the source (person A) and target (person B) user names
    $sourceUser = Read-Host "Enter the source user name, or type 'exit' to quit"
    
    # Exit the loop if the user types 'exit'
    if ($sourceUser -eq 'exit') {
        break
    }

    $targetUser = Read-Host "Enter the target user name"

    # Get the group memberships of the source user
    $groupMemberships = Get-ADUser -Identity $sourceUser -Server $domain_controller -Properties memberof -Credential $creds | Select-Object -ExpandProperty memberof

    # Add the target user to each group
    foreach ($group in $groupMemberships) {
        Add-ADGroupMember -Identity $group -Members $targetUser -Server $domain_controller -Credential $creds
    }

    Write-Host "Group memberships copied from $sourceUser to $targetUser."
}

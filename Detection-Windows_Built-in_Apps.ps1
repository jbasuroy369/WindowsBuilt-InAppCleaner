try 
{
    # Array of built-in apps to remove
    $UninstallPackages = @(
	    "Microsoft.549981C3F5F10",
	    "Microsoft.BingNews",
	    "Microsoft.GamingApp",
	    "Microsoft.GetHelp",
	    "Microsoft.Getstarted",
	    "Microsoft.MicrosoftOfficeHub",
	    "Microsoft.MicrosoftSolitaireCollection",
	    "Microsoft.People",
	    "Microsoft.WindowsCommunicationsApps",
	    "Microsoft.Xbox.TCUI",
	    "Microsoft.XboxGameOverlay",
	    "Microsoft.XboxGamingOverlay",
	    "Microsoft.XboxIdentityProvider",
	    "Microsoft.XboxSpeechToTextOverlay",
	    "Microsoft.YourPhone",
	    "MicrosoftTeams",
	    "Microsoft.WindowsFeedbackHub"
        )

    $InstalledPackages = Get-AppxPackage -AllUsers | Where {($UninstallPackages -contains $_.Name)}
    $ProvisionedPackages = Get-AppxProvisionedPackage -Online | Where {($UninstallPackages -contains $_.DisplayName)}

    if($InstalledPackages -eq $null -and $ProvisionedPackages -eq $null){
        Write-Host "Remediation not needed"
        Exit 0
    }
    else
    {
        Write-Host "Remediation needed"
        Exit 1
    }
}
catch{
    $errMsg = $_.Exception.Message
    Write-Host $errMsg
    Exit 1
}


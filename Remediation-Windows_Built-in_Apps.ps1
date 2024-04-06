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

# Remove provisioned packages first
ForEach ($ProvPackage in $ProvisionedPackages) {
    Try {
        $Null = Remove-AppxProvisionedPackage -PackageName $ProvPackage.PackageName -Online -ErrorAction Stop
    }
    Catch {Write-Warning -Message "Failed to remove provisioned package: [$($ProvPackage.DisplayName)]"}
}

# Remove appx packages
ForEach ($AppxPackage in $InstalledPackages) {
    Try {
        $Null = Remove-AppxPackage -Package $AppxPackage.PackageFullName -AllUsers -ErrorAction Stop
    }
    Catch {Write-Warning -Message "Failed to remove Appx package: [$($AppxPackage.Name)]"}
}
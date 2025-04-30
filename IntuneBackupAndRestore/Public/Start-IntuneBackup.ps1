function Start-IntuneBackup() {
    <#
    .SYNOPSIS
    Backup Intune Configuration

    .DESCRIPTION
    Backup Intune Configuration

    .PARAMETER Path
    Path to store backup (JSON) files.

    .EXAMPLE
    Start-IntuneBackup -Path C:\temp

    .NOTES
    Requires the MSGraph SDK PowerShell Module

    Connect to MSGraph first, using the 'connect-mggraph' cmdlet and the scopes: 'DeviceManagementApps.Read.All, DeviceManagementConfiguration.Read.All, DeviceManagementServiceConfig.Read.All, DeviceManagementManagedDevices.Read.All'.
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    [PSCustomObject]@{
        "Action" = "Backup"
        "Type"   = "Intune Backup and Restore Action"
        "Name"   = "IntuneBackupAndRestore - Start Intune Backup Config and Assignments"
        "Path"   = $Path
    }

    #Connect to MS-Graph if required
    if ($null -eq (Get-MgContext)) {
        Connect-MgGraphClixml -secureFilePath "$env:APPDATA\CredentialIntuneBackup.xml"
    } else {
        Write-Host "MS-Graph already connected, checking scopes"
        $scopes = Get-MgContext | Select-Object -ExpandProperty Scopes
        $IncorrectScopes = $false
        if ($scopes -notcontains "DeviceManagementApps.Read.All") {$IncorrectScopes = $true}
        if ($scopes -notcontains "DeviceManagementConfiguration.Read.All") {$IncorrectScopes = $true}
        if ($scopes -notcontains "DeviceManagementServiceConfig.Read.All") {$IncorrectScopes = $true}
        if ($scopes -notcontains "DeviceManagementManagedDevices.Read.All") {$IncorrectScopes = $true}
        if ($IncorrectScopes) {
            Write-Warning "Incorrect scopes, please sign in again"
            Connect-MgGraphClixml -secureFilePath "$env:APPDATA\CredentialIntuneBackup.xml" 
             
        }else{
            Write-Host "MS-Graph scopes are correct"
        }
		Write-Host ""
    }

    Write-Host "IntuneBackupAutopilotDeploymentProfile"
    Invoke-IntuneBackupAutopilotDeploymentProfile -Path $Path

    Write-Host "IntuneBackupAutopilotDeploymentProfileAssignment"
    Invoke-IntuneBackupAutopilotDeploymentProfileAssignment -Path $Path
    
    Write-Host "IntuneBackupClientApp"
    Invoke-IntuneBackupClientApp -Path $Path

    Write-Host "IntuneBackupClientAppAssignment"
    Invoke-IntuneBackupClientAppAssignment -Path $Path

    Write-Host "IntuneBackupConfigurationPolicy"
    Invoke-IntuneBackupConfigurationPolicy -Path $Path

    Write-Host "IntuneBackupConfigurationPolicyAssignment"
    Invoke-IntuneBackupConfigurationPolicyAssignment -Path $Path

    Write-Host "IntuneBackupDeviceCompliancePolicy"
    Invoke-IntuneBackupDeviceCompliancePolicy -Path $Path

    Write-Host "IntuneBackupDeviceCompliancePolicyAssignment"
    Invoke-IntuneBackupDeviceCompliancePolicyAssignment -Path $Path

    Write-Host "IntuneBackupDeviceConfiguration"
    Invoke-IntuneBackupDeviceConfiguration -Path $Path

    Write-Host "IntuneBackupDeviceConfigurationAssignment"
    Invoke-IntuneBackupDeviceConfigurationAssignment -Path $Path

    Write-Host "IntuneBackupDeviceHealthScript"
    Invoke-IntuneBackupDeviceHealthScript -Path $Path

    Write-Host "IntuneBackupDeviceHealthScriptAssignment"
    Invoke-IntuneBackupDeviceHealthScriptAssignment -Path $Path

    Write-Host "IntuneBackupDeviceManagementScript"
    Invoke-IntuneBackupDeviceManagementScript -Path $Path

    Write-Host "IntuneBackupDeviceManagementScriptAssignment"
    Invoke-IntuneBackupDeviceManagementScriptAssignment -Path $Path

    Write-Host "IntuneBackupGroupPolicyConfiguration"
    Invoke-IntuneBackupGroupPolicyConfiguration -Path $Path

    Write-Host "IntuneBackupGroupPolicyConfigurationAssignment"
    Invoke-IntuneBackupGroupPolicyConfigurationAssignment -Path $Path

    Write-Host "IntuneBackupDeviceManagementIntent"
    Invoke-IntuneBackupDeviceManagementIntent -Path $Path

    Write-Host "IntuneBackupAppProtectionPolicy"
    Invoke-IntuneBackupAppProtectionPolicy -Path $Path

    #Write-Host "IntuneBackupDeviceHealthScript"
    #Invoke-IntuneBackupDeviceHealthScript -Path $Path
    #Invoke-IntuneBackupDeviceHealthScriptAssignment -Path $Path
}

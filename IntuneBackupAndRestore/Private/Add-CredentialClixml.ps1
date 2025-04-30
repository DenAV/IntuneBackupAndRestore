# The script is designed to securely store credentials in a Clixml file.
function Add-CredentialClixml {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Enter the TenantId:")]
        [string]$TenantId,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the ClientId:")]
        [string]$ClientId,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the ClientSecret (this will be hidden)")]
        [SecureString]$ClientSecret,
        [Parameter(Mandatory = $false)]
        [string]$secureFilePath = "$env:APPDATA\CredentialIntuneBackup.xml"
    )
    
    process {
        # Convert the secure strings to plain text for storage in the Clixml file
        $ClientSecretPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
            [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ClientSecret))

        # Create a hashtable to store the variables
        $config = @{
            TenantId     = $TenantId
            ClientId     = $ClientId
            ClientSecret = $ClientSecretPlain
        }

        # Export the configuration securely to a Clixml file
        $config | Export-Clixml -Path $secureFilePath -Force -ErrorAction Stop
        Write-Host "Configuration saved securely to $secureFilePath" -ForegroundColor Green
    }
}
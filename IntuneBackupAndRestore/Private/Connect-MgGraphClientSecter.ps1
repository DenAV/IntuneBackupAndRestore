# The following script is a PowerShell function that connects to the Microsoft Graph API using a secure method.
# It retrieves the necessary credentials from a Clixml file and uses them to authenticate the connection.
function Connect-MgGraphClixml {
    <#
    .SYNOPSIS
    Connects to the Microsoft Graph API using a secure method.

    .DESCRIPTION
    This function establishes a connection to the Microsoft Graph API by securely authenticating the client. 
    It ensures that the connection is properly configured for subsequent API calls.

    .PARAMETER secureFilePath
    The path to the secure Clixml file containing the credentials.

    .EXAMPLE
    PS C:\> Connect-MgGraphClientSecter

    This example demonstrates how to call the function to connect to the Microsoft Graph API.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$secureFilePath = "$env:APPDATA\CredentialIntuneBackup.xml" # Define the path to the secure Clixml file
    )
    
    begin {
        # Check if the file exists, if not
        if (-not (Test-Path -Path $secureFilePath -PathType Leaf)) {
            Write-Error "The credential file does not exist. Please run the Add-CredentialClixml function to create it."
            return
        }
        # Import the configuration file
        $config = Import-Clixml -Path $secureFilePath
    
        if (-not $config) {
            Write-Error "Error: Unable to import the configuration file. Please check the file path and format."
            return
        } else {
            $tenantID       = $config.TenantId
            $clientID       = $config.clientID
            $clientSecret   = $config.clientSecret
        }
    }
    process {
        if ($tenantID -and $clientID -and $clientSecret) {
            # Set the body for the token request
            $connect_Body =  @{
                Grant_Type    = "client_credentials"
                Scope         = "https://graph.microsoft.com/.default"
                Client_Id     = $clientID
                Client_Secret = $clientSecret
            }
            try {
                # Connect to Microsoft Graph using Client Secret
                $Connection = Invoke-RestMethod `
                    -Uri https://login.microsoftonline.com/$tenantID/oauth2/v2.0/token `
                    -Method POST `
                    -Body $connect_Body
                
                # Connect to Microsoft Graph using the access token
                Connect-MgGraph -AccessToken ($Connection.access_token | ConvertTo-SecureString -AsPlainText -Force)  -NoWelcome
            } catch {
                Write-Error "Error: Unable to connect to Microsoft Graph. Please check your credentials."
                return
            }
        } else {
            Write-Error "Error: Missing required parameters. Please provide TenantId, ClientId, and ClientSecret."
            return
        }
    }
} # End of Connect-MgGraphClixml function

# Example usage:
# $Path = "C:\Path\To\Your\ClixmlFile.xml"
# Connect-MgGraphClixml -Path $Path
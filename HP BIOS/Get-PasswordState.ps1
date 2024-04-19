Function Get-PasswordState {
<#
.Synopsis
    Get the current state of the BIOS password
.Description
    Get the current state of the BIOS password for HP systems from WMI
    Requires existence of the root\HP\InstrumentedBIOS WMI Namespace and the HP_BIOSPassword WMI Class
.Outputs
    Output is the full contents of the "Setup Password" WMI property
.Example
    Get-PasswordState
    Returns full contents of the "Setup Password" WMI property
.Notes
    Author: Jeroen Bakker
    Version: 1.0
    Date: 27-06-2017
#>

[CmdletBinding()]
Param()

Process{
    $WMINameSpace = "root\HP\InstrumentedBIOS"
    $WMIClass = "HP_BIOSPassword"

    $PropertyName = "Setup Password"

    Write-Verbose -Message "Connecting to WMI Namespace $WMINameSpace and Class $WmiClass."
    Write-Verbose -Message "Getting content of the $Propertyname instance of Class $WmiClass."

    Get-WmiObject -Namespace $WMINameSpace -Class $WMIClass -Filter "Name = 'Setup Password'"
    }

}


# Get the current state for the Bios Password
$PasswordState = Get-PasswordState


If ($PasswordState.IsSet -eq 0){
    #Password not configured
    $State = "Not Configured"
    }
Else {
    # A BIOS password is set
    $State = "Configured"
    }


Write-Host $State
<#
Discover-IntelNic-LegacySwitchMode.ps1

Discover if the legacy switch mode is enabled for network adapters which require this setting

Version: 2.0
Author: Jeroen Bakker

To be used as an discovery script within a SCCM Configuration Item (with application settings)
Output:
* Legacy switch mode enabled --> "Enabled"
* Legacy switch mode disabled --> "Disabled"

Related registry values:
1 = Legacy switch mode disabled (default)
2 = Legacy switch mode enabled


Version history
---------------
Version 1.0: 03-02-2017: Initial production version
Version 2.0: 16-04-2024: Generalized script for reuse and distributionn

#>

# Set registry path to Network Adapter class
$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}"

#Create a hash table with all supported LAN network adapters and their series
#e1d = Intel I217 /218 /219 series
#e1c = Intel 82579 series

$Adapters = @{
    "Intel(R) Ethernet Connection I217-LM"="e1d";
    "Intel(R) Ethernet Connection I217-V"="e1d";
    "Intel(R) Ethernet Connection I218-LM"="e1d";
    "Intel(R) Ethernet Connection I218-V"="e1d";
    "Intel(R) Ethernet Connection (2) I218-LM"="e1d";
    "Intel(R) Ethernet Connection (2) I218-V"="e1d";
    "Intel(R) Ethernet Connection (3) I218-LM"="e1d";
    "Intel(R) Ethernet Connection (3) I218-V"="e1d";
    "Intel(R) Ethernet Connection I219-LM"="e1d";
    "Intel(R) Ethernet Connection I219-V"="e1d";
    "Intel(R) Ethernet Connection (2) I219-LM"="e1d";
    "Intel(R) Ethernet Connection (2) I219-V"="e1d";
    "Intel(R) 82579LM Gigabit Network Connection"="e1c";
    "Intel(R) 82579V Gigabit Network Connection"="e1c"
}


# Walk through all sub-keys to find the LAN network adapter
Get-ChildItem -Path $RegPath -Exclude "Properties","Configuration"|ForEach {

    # Verify if the adpater is listed as a supported NIC
    If ($Adapters.ContainsKey((Get-ItemProperty -Path Registry::$_ -name DriverDesc).DriverDesc)){

        
        # Set registry value name and value data for legacy switch mode based on adapter type
        switch ($Adapters.get_item((Get-ItemProperty -Path Registry::$_ -name DriverDesc).DriverDesc))
        {
        e1c {<# Legacy switch mode option not available#>}
        e1d {$SwitchModeName = "LinkNegotiationProcess"; $SwitchModeValue = 2}
        }
        
        # Test if the network adapter requires legacy switch mode configuration
        If ($SwitchModeName){
            
            # Test if the legacy switch mode is enabled
            If ((Get-ItemProperty -Path Registry::$_ -name $SwitchModeName).$SwitchModeName -ne $SwitchModeValue){
                # legacy switch mode is not enabled
                Write-Host "Disabled"
            }
            Else {
                # legacy switch mode is enabled
                Write-Host "Enabled"
            }
        }
    }
}
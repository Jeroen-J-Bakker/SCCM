<#
Remediate-IntelNic-SpeedDuplex.ps1

Enable 100Mbps full duplex
Change the $Duplexvalue variable on lines 61 and 62 for other speed/ duplex settings

Version: 2.0
Author: Jeroen Bakker

To be used as remediation script within a SCCM Configuration Item (with application settings)

Related Link speed and Duplex mode registry values (tested for e1d adapter type, may differ for e1c)
0 = Auto Negotiate
1 = 10 Mbps Half Duplex
2 = 10 Mbps Full Duplex
3 = 100 Mbps Half Duplex
4 = 100 Mbps Full Duplex
6 = 1.0 Gbps Full Duplex

Version history
---------------
Version 1.0: 03-02-2017: Initial production version
Version 2.0: 16-04-2024: Generalized script for reuse and distribution

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

        # Set registry value name and value data for 100Mbps full duplex based on adapter type
        switch ($Adapters.get_item((Get-ItemProperty -Path Registry::$_ -name DriverDesc).DriverDesc))
        {
        e1c {$DuplexName = "*SpeedDuplex"; $DuplexValue = 4}
        e1d {$DuplexName = "*SpeedDuplex"; $DuplexValue = 4}
        }
        
        # Test if the network adapter is configured at 100 Mbps full duplex
        If ((Get-ItemProperty -Path Registry::$_ -name $DuplexName).$DuplexName -ne $DuplexValue){
            
            #Change adpater settings to 100Mbps full duplex
            Set-ItemProperty -Path Registry::$_ -name $DuplexName -Value $DuplexValue
        }
    }
}
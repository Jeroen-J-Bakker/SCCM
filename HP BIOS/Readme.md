**HP BIOS mananagement WMI scripts**

These scripts and functions can be used for managing HP BIOS settings through WMI.
They were orriginally created both to verify the state of individual HP BIOS settings and to correct their values.
They were used in SCCM detection and remediation scripts but can easily be adapted for use in Intune Remediations or in Intune/ SCCM applications.
If the BIOS password is configured on managed devices, changing of BIOS settings requires useof the password in the scripts; I had my methods to do this at the time but I will not publish those as they are inherently insecure.

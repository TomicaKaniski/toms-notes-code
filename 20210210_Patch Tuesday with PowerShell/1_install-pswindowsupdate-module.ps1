### script helps you install and use the PSWindowsUpdate module

# check if you have PSGallery under your PowerShell repositories (and check the installation policy)
# if it's not, you can easily register it with "Register-PSRepository -Default"
Get-PSRepository
# Name                      InstallationPolicy   SourceLocation
# ----                      ------------------   --------------
# PSGallery                 Untrusted            https://www.powershellgallery.com/api/v2

# NuGet package provider is required - if not present, you'll be asked to install it
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
# Name                           Version          Source           Summary
# ----                           -------          ------           -------
# nuget                          2.8.5.208        https://onege... NuGet provider for the OneGet meta-package manager

# mark PSGallery as trusted (optional)
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

# are we ready?
Get-PSRepository
# Name                      InstallationPolicy   SourceLocation
# ----                      ------------------   --------------
# PSGallery                 Trusted              https://www.powershellgallery.com/api/v2

# install the PSWindowsUpdate module (from PSGallery)
Install-Module PSWindowsUpdate

# check what's available
Get-Command -Module PSWindowsUpdate
# CommandType     Name                                               Version    Source
# -----------     ----                                               -------    ------
# Alias           Clear-WUJob                                        2.2.0.2    PSWindowsUpdate
# Alias           Download-WindowsUpdate                             2.2.0.2    PSWindowsUpdate
# Alias           Get-WUInstall                                      2.2.0.2    PSWindowsUpdate
# Alias           Get-WUList                                         2.2.0.2    PSWindowsUpdate
# Alias           Hide-WindowsUpdate                                 2.2.0.2    PSWindowsUpdate
# Alias           Install-WindowsUpdate                              2.2.0.2    PSWindowsUpdate
# Alias           Show-WindowsUpdate                                 2.2.0.2    PSWindowsUpdate
# Alias           UnHide-WindowsUpdate                               2.2.0.2    PSWindowsUpdate
# Alias           Uninstall-WindowsUpdate                            2.2.0.2    PSWindowsUpdate
# Cmdlet          Add-WUServiceManager                               2.2.0.2    PSWindowsUpdate
# Cmdlet          Enable-WURemoting                                  2.2.0.2    PSWindowsUpdate
# Cmdlet          Get-WindowsUpdate                                  2.2.0.2    PSWindowsUpdate
# Cmdlet          Get-WUApiVersion                                   2.2.0.2    PSWindowsUpdate
# Cmdlet          Get-WUHistory                                      2.2.0.2    PSWindowsUpdate
# Cmdlet          Get-WUInstallerStatus                              2.2.0.2    PSWindowsUpdate
# Cmdlet          Get-WUJob                                          2.2.0.2    PSWindowsUpdate
# Cmdlet          Get-WULastResults                                  2.2.0.2    PSWindowsUpdate
# Cmdlet          Get-WUOfflineMSU                                   2.2.0.2    PSWindowsUpdate
# Cmdlet          Get-WURebootStatus                                 2.2.0.2    PSWindowsUpdate
# Cmdlet          Get-WUServiceManager                               2.2.0.2    PSWindowsUpdate
# Cmdlet          Get-WUSettings                                     2.2.0.2    PSWindowsUpdate
# Cmdlet          Invoke-WUJob                                       2.2.0.2    PSWindowsUpdate
# Cmdlet          Remove-WindowsUpdate                               2.2.0.2    PSWindowsUpdate
# Cmdlet          Remove-WUServiceManager                            2.2.0.2    PSWindowsUpdate
# Cmdlet          Reset-WUComponents                                 2.2.0.2    PSWindowsUpdate
# Cmdlet          Set-PSWUSettings                                   2.2.0.2    PSWindowsUpdate
# Cmdlet          Set-WUSettings                                     2.2.0.2    PSWindowsUpdate
# Cmdlet          Update-WUModule                                    2.2.0.2    PSWindowsUpdate

# check which update sources you have installed in your system 
Get-WUServiceManager
# ServiceID                            IsManaged IsDefault Name
# ---------                            --------- --------- ----
# 7971f918-a847-4430-9279-4a52d1efe18d False     True      Microsoft Update
# 8b24b027-1dee-babb-9a95-3517dfb9c552 False     False     DCat Flighting Prod
# 855e8a7c-ecb4-4ca3-b045-1dfa50104289 False     False     Windows Store (DCat Prod)
# 9482f4b4-e343-43b6-b170-9a65bc822c77 False     False     Windows Update

# install everything that's available via Microsoft Update
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -Verbose
# VERBOSE: N1 (10.2.2021. 8:31:41): Connecting to Microsoft Update server. Please wait...
# VERBOSE: Found [9] Updates in pre search criteria
# VERBOSE: Found [9] Updates in post search criteria

# X ComputerName Result     KB          Size Title
# - ------------ ------     --          ---- -----
# 1 N1           Accepted   KB4481252   13MB Microsoft Silverlight (KB4481252)
# 1 N1           Accepted   KB4598459  126MB 2021-02 .NET Core 3.1.12 Security Update for x64 Client
# 1 N1           Accepted   KB890830    33MB Windows Malicious Software Removal Tool x64 - v5.86 (KB890830)
# 1 N1           Accepted   KB4601050   65MB 2021-02 Cumulative Update for .NET Framework 3.5 and 4.8 for Windows 10, ...
# 1 N1           Accepted   KB4052623    6MB Update for Microsoft Defender Antivirus antimalware platform - KB4052623 ...
# 1 N1           Accepted   KB2267602  697MB Security Intelligence Update for Microsoft Defender Antivirus - KB2267602...
# 1 N1           Accepted   KB2267602  697MB Security Intelligence Update for Microsoft Defender Antivirus - KB2267602...
# 1 N1           Accepted                2MB Hewlett-Packard Development Company, L.P. - Keyboard - Standard 101/102-K...
# 1 N1           Accepted   KB4601319  103GB 2021-02 Cumulative Update for Windows 10 Version 20H2 for x64-based Syste...
# VERBOSE: Accepted [9] Updates ready to Download
# 2 N1           Downloaded KB4481252   13MB Microsoft Silverlight (KB4481252)
# 2 N1           Downloaded KB4598459  126MB 2021-02 .NET Core 3.1.12 Security Update for x64 Client
# 2 N1           Downloaded KB890830    33MB Windows Malicious Software Removal Tool x64 - v5.86 (KB890830)
# 2 N1           Downloaded KB4601050   65MB 2021-02 Cumulative Update for .NET Framework 3.5 and 4.8 for Windows 10, ...
# 2 N1           Downloaded KB4052623    6MB Update for Microsoft Defender Antivirus antimalware platform - KB4052623 ...
# 2 N1           Downloaded KB2267602  697MB Security Intelligence Update for Microsoft Defender Antivirus - KB2267602...
# 2 N1           Downloaded KB2267602  697MB Security Intelligence Update for Microsoft Defender Antivirus - KB2267602...
# 2 N1           Downloaded              2MB Hewlett-Packard Development Company, L.P. - Keyboard - Standard 101/102-K...
# 2 N1           Downloaded KB4601319  103GB 2021-02 Cumulative Update for Windows 10 Version 20H2 for x64-based Syste...
# VERBOSE: Downloaded [9] Updates ready to Install
# 3 N1           Installed  KB4481252   13MB Microsoft Silverlight (KB4481252)
# 3 N1           Installed  KB4598459  126MB 2021-02 .NET Core 3.1.12 Security Update for x64 Client
# 3 N1           Installed  KB890830    33MB Windows Malicious Software Removal Tool x64 - v5.86 (KB890830)
# 3 N1           Installed  KB4601050   65MB 2021-02 Cumulative Update for .NET Framework 3.5 and 4.8 for Windows 10, ...
# 3 N1           Installed  KB4052623    6MB Update for Microsoft Defender Antivirus antimalware platform - KB4052623 ...
# 3 N1           Installed  KB2267602  697MB Security Intelligence Update for Microsoft Defender Antivirus - KB2267602...
# 3 N1           Installed  KB2267602  697MB Security Intelligence Update for Microsoft Defender Antivirus - KB2267602...
# 3 N1           Installed               2MB Hewlett-Packard Development Company, L.P. - Keyboard - Standard 101/102-K...
# 3 N1           Installed  KB4601319  103GB 2021-02 Cumulative Update for Windows 10 Version 20H2 for x64-based Syste...
# VERBOSE: Installed [9] Updates
# Reboot is required. Do it now? [Y / N] (default is 'N')

$targetInstaller = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "Workspace ONE Intelligent Hub Installer" }

$IdentifyingNumber=$targetInstaller.IdentifyingNumber
# Define the basic registry path to recover
$basePath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"

# Create a root path if it does not exist
if (-not (Test-Path $basePath)) {
    New-Item -Path $basePath -Force
}

$appPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$IdentifyingNumber"

# Example Create an application registry key
if (-not (Test-Path $appPath)) {
    New-Item -Path $appPath -Force
}
$DisplayVersion=$targetInstaller.Version

#Use -split to split the version number by dot
$versionParts = $DisplayVersion -split '\.'

#Gets the property values for each part
$VersionMajor = [int]$versionParts[0]
$VersionMinor = [int]$versionParts[1]
$build = [int]$versionParts[2]
$revision = [int]$versionParts[3]
$Version = ($VersionMajor -shl 24) -bor ($VersionMinor -shl 16) -bor ($revision -shl 8) -bor $build
$InstallDate=$targetInstaller.InstallDate
$InstallLocation=$targetInstaller.InstallLocation
$InstallSource=$targetInstaller.InstallSource
$Language=$targetInstaller.Language

# Add some common registry properties and values
New-ItemProperty -Path $appPath -Name "AuthorizedCDFPrefix"
New-ItemProperty -Path $appPath -Name "Comments"
New-ItemProperty -Path $appPath -Name "Contact"
New-ItemProperty -Path $appPath -Name "DisplayName" -Value "Workspace ONE Intelligent Hub Installer" -PropertyType String -Force
New-ItemProperty -Path $appPath -Name "DisplayVersion" -Value "$DisplayVersion" -PropertyType String -Force
New-ItemProperty -Path $appPath -Name "EstimatedSize" -Value "" -PropertyType DWord -Force
New-ItemProperty -Path $appPath -Name "HelpLink"
New-ItemProperty -Path $appPath -Name "HelpTelephone"
New-ItemProperty -Path $appPath -Name "InstallDate" -Value "$InstallDate" -PropertyType String -Force
New-ItemProperty -Path $appPath -Name "InstallLocation" -Value "$InstallLocation" -PropertyType String -Force
New-ItemProperty -Path $appPath -Name "InstallSource" -Value "$InstallSource" -PropertyType String -Force
New-ItemProperty -Path $appPath -Name "Language" -Value "$Language" -PropertyType DWord -Force
New-ItemProperty -Path $appPath -Name "ModifyPath" -Value "MsiExec.exe /X$IdentifyingNumber" -PropertyType ExpandString -Force
New-ItemProperty -Path $appPath -Name "NoModify" -Value "1" -PropertyType DWord -Force
New-ItemProperty -Path $appPath -Name "Publisher" -Value "VMware, Inc." -PropertyType String -Force
New-ItemProperty -Path $appPath -Name "Readme"
New-ItemProperty -Path $appPath -Name "Size"
New-ItemProperty -Path $appPath -Name "UninstallString" -Value "MsiExec.exe /X$IdentifyingNumber" -PropertyType ExpandString -Force
New-ItemProperty -Path $appPath -Name "URLInfoAbout"
New-ItemProperty -Path $appPath -Name "URLUpdateInfo"
New-ItemProperty -Path $appPath -Name "Version" -Value "$Version" -PropertyType DWord -Force
New-ItemProperty -Path $appPath -Name "VersionMajor" -Value "$VersionMajor" -PropertyType DWord -Force
New-ItemProperty -Path $appPath -Name "VersionMinor" -Value "$VersionMinor" -PropertyType DWord -Force
New-ItemProperty -Path $appPath -Name "WindowsInstaller" -Value "1" -PropertyType DWord -Force



Write-Host "基本的Uninstall注册表项已恢复，并添加了示例应用信息。"

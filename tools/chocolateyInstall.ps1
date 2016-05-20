$packageName = 'DotNetCoreSDK'
$fileType = 'exe'
$silentArgs = '/quiet'
$url = 'https://go.microsoft.com/fwlink/?LinkID=798398'
$version = '1.0.0.RC2'

function Test-RegistryValue {

param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]$Path,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]$Value
)

try {

    if (Test-Path -Path $Path) {
        Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
        return $true
    }
}

catch {
    return $false
}

}

function CheckDotNetCliInstalled {

    $registryPath = 'HKLM:\SOFTWARE\Wow6432Node\dotnet\Setup\InstalledVersions\x64\sharedfx\Microsoft.NETCore.App'
    if (Test-RegistryValue -Path $registryPath -Value 1.0.0-rc2) {
        return $true
    }
}

if (CheckDotNetCliInstalled) {
    Write-Host "Microsoft .Net Core SDK is already installed on your machine."
}
elseif (Get-ProcessorBits(32)){
    throw "32 bit Microsoft .Net Core SDK is not available."
}
else {
	Install-ChocolateyPackage $packageName $fileType $silentArgs '' $url
}


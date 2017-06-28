$script           = $MyInvocation.MyCommand.Definition
$packageArgs      = @{
    packageName     = 'DotNetCoreSDK'
    fileType        = 'exe'
    url             = 'https://download.microsoft.com/download/B/9/F/B9F1AF57-C14A-4670-9973-CDF47209B5BF/dotnet-dev-win-x64.1.0.4.exe'
    softwareName    = 'DotNetCoreSDK*'
    checksum        = 'a8b2a928e66eac6ccb939916d55d2d181b8f1433fc1fbf0d894713e8c86c7303'
    checksumType    = 'sha256'
    silentArgs      = '/quiet'
    validExitCodes  = @(0, 3010, 1641)
}

function CheckDotNetCliInstalled($value) {
    $registryPath = 'HKLM:\SOFTWARE\Wow6432Node\dotnet\Setup\InstalledVersions\x64\sdk'

    if (Test-RegistryValue -Path $registryPath -Value $value) {
        return $true
    }
}

function Test-RegistryValue {
    param (
        [parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()] $Path,
        [parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()] $Value
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

if (CheckDotNetCliInstalled($version)) {
    Write-Host "Microsoft .NET Core SDK is already installed on your machine."
}
else {
    Install-ChocolateyPackage @packageArgs
}
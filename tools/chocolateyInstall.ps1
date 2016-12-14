$script           = $MyInvocation.MyCommand.Definition
$packageArgs      = @{
    packageName     = 'DotNetCoreSDK'
    fileType        = 'exe'
    url             = 'https://go.microsoft.com/fwlink/?LinkID=827524'
    softwareName    = 'DotNetCoreSDK*'
    checksum        = '27DFA0EA2D2AAA80F76D77D8747E9E2C1178F40592C3650FBD3BCFB512144132'
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
param([string]$packageName)

# Set the Current directory path into the $workingDir variable
$workingDir=(Get-Item -Path ".\").FullName

if (-Not ($packageName)){
	# Set the Current directory name into the $packageName variable
	$packageName=(Get-Item -Path ".\").Name
}

# Export GitHub Environment variables
if ($ENV:GITHUB_ENV) {
	"PKGNAME=$packageName" | Out-File -FilePath $env:GITHUB_ENV -Encoding utf8 -Append
	"REPO_PKGNAME=Jlw.Utilities.WebApiUtility" | Out-File -FilePath $env:GITHUB_ENV -Encoding utf8 -Append
	"CURRENTDIR=$workingDir" | Out-File -FilePath $env:GITHUB_ENV -Encoding utf8 -Append
	"DOTNET_NOLOGO=1" | Out-File -FilePath $env:GITHUB_ENV -Encoding utf8 -Append
    "DOTNET_CLI_TELEMETRY_OPTOUT=1" | Out-File -FilePath $env:GITHUB_ENV -Encoding utf8 -Append
    "DOTNET_MULTILEVEL_LOOKUP=1" | Out-File -FilePath $env:GITHUB_ENV -Encoding utf8 -Append
    "BUILD_VERSION=$vPrefix$vSuffix" | Out-File -FilePath $env:GITHUB_ENV -Encoding utf8 -Append
    "BUILD_VERSION_PREFIX=$vPrefix" | Out-File -FilePath $env:GITHUB_ENV -Encoding utf8 -Append
    "BUILD_VERSION_SUFFIX=$vSuffix" | Out-File -FilePath $env:GITHUB_ENV -Encoding utf8 -Append
    "PKGVERSION=$vPrefix$vSuffix" | Out-File -FilePath $env:GITHUB_ENV -Encoding utf8 -Append
}

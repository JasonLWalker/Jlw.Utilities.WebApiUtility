param([string]$packageName)

# Set the Current directory path into the $workingDir variable
$workingDir=(Get-Item -Path ".\").FullName

if (-Not ($packageName)){
	# Set the Current directory name into the $packageName variable
	$packageName=(Get-Item -Path ".\").Name
}

# Export GitHub Environment variables
if ($ENV:GITHUB_ENV) {
	"PKGNAME=$packageName" | Add-Content -Path $ENV:GITHUB_ENV
	"CURRENTDIR=$workingDir" | Add-Content -Path $ENV:GITHUB_ENV
	"DOTNET_NOLOGO=1" | Add-Content -Path $ENV:GITHUB_ENV
    "DOTNET_CLI_TELEMETRY_OPTOUT=1" | Add-Content -Path $ENV:GITHUB_ENV
    "DOTNET_MULTILEVEL_LOOKUP=1" | Add-Content -Path $ENV:GITHUB_ENV

}

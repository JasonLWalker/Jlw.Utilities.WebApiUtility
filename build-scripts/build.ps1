param([string]$packageName, [string]$buildType = "Release", [string]$versionSuffix = "", [string]$versionPrefix = "")

# Set the Current directory path into the $workingDir variable
$workingDir=(Get-Item -Path ".\").FullName

if (-Not ($packageName)){
	# Set the Current directory name into the $packageName variable
	$packageName=(Get-Item -Path ".\").Name
}

if (-Not ($versionPrefix)){
	$versionPrefix="1.5.$([System.TimeSpan]::FromTicks($([System.DateTime]::UtcNow.Ticks)).Subtract($([System.TimeSpan]::FromTicks(630822816000000000))).TotalDays.ToString().SubString(0,9))"
}

# Build with dotnet
dotnet build -p:VersionPrefix=$versionPrefix --version-suffix=$versionSuffix --configuration $buildType

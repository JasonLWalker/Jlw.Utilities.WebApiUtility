param([string]$packageName="", [string]$buildType="Release", [string]$versionSuffix="", [string]$versionPrefix="")

# Set the Current directory path into the $workingDir variable
$workingDir=(Get-Item -Path ".\").FullName

if (-Not ($packageName)){
	# Set the Current directory name into the $packageName variable
	$packageName=(Get-Item -Path ".\").Name
}

if (-Not ($versionPrefix)){
	$versionPrefix="1.6.$([System.TimeSpan]::FromTicks($([System.DateTime]::UtcNow.Ticks)).Subtract($([System.TimeSpan]::FromTicks(630822816000000000))).TotalDays.ToString().SubString(0,9))"
}

# Install dependencies
#dotnet restore

# Build/Pack with dotnet
if (-Not ($versionSuffix)){
dotnet build -p:VersionPrefix=$versionPrefix -p:Configuration=$buildType
} else {
dotnet build -p:VersionPrefix=$versionPrefix -p:VersionSuffix=$versionSuffix -p:Configuration=$buildType
}

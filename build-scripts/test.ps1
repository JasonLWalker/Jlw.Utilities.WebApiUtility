param([string]$packageName, [string]$buildType = "Release", [bool] $restorePackages = $false)

# Set the Current directory path into the $workingDir variable
$workingDir=(Get-Item -Path ".\").FullName

if (-Not ($packageName)){
	# Set the Current directory name into the $packageName variable
	$packageName=(Get-Item -Path ".\").Name + ".Tests"
}

# Install dependencies
if ($restorePackages) {
	dotnet restore
}

# test package
dotnet test --no-build --configuration $buildType --verbosity normal "${packageName}"

param([string]$packageName, [string]$buildType = "Release")

# Set the Current directory path into the $workingDir variable
$workingDir=(Get-Item -Path ".\").FullName

if (-Not ($packageName)){
	# Set the Current directory name into the $packageName variable
	$packageName=(Get-Item -Path ".\").Name
}

# Install dependencies
dotnet tool install -g XMLDoc2Markdown

dotnet restore

# Build with dotnet
dotnet build --version-suffix=$versionSuffix --configuration $buildType --no-restore

dotnet publish --no-build --configuration $buildType --verbosity normal "${packageName}"

xmldoc2md .\$packageName\bin\$buildType\netstandard2.0\publish\$packageName.dll .\Help --github-pages --back-button --index-page-name home


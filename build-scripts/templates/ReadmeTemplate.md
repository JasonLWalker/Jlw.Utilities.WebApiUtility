<!-- $(
	## Add Poweshell template variables Here ##
	$projectName = "Jlw.Utilities.WebApiUtility"
) -->
# $projectName

## Pipeline Status

| Release |
|-----|-----|-----|-----|
| [![Build and Deploy](https://github.com/JasonLWalker/$($projectName)/actions/workflows/build-deploy.yml/badge.svg)](https://github.com/JasonLWalker/$($projectName)/actions/workflows/build-deploy.yml) 

# Web Api Utility
<!-- $( 
	$projectName = "Jlw.Utilities.WebApiUtility"
	$projectPath = "$($buildPath)**\$($projectName).csproj"
) -->
[![Nuget](https://img.shields.io/nuget/v/$($projectName)?label=$($projectName)%20%28release%29)](https://www.nuget.org/packages/$($projectName)/#versions-body-tab) [![Nuget (with prereleases)](https://img.shields.io/nuget/vpre/$($projectName)?label=$($projectName)%20%28preview%29)](https://www.nuget.org/packages/$($projectName)/#versions-body-tab)

## Information / Requirements
$(Get-ProjectInfoTable $projectName $projectPath)

## Dependencies

$(Get-ProjectDependencyTable $projectPath)


############################################################################
# ReadmeGenerationUtilities.psm1
# 
# A powershell library module to read code/metadata from various sources and 
# automatically generate a README file during CI/CD operations
#
# Copyright (c)2021-2023 Jason L Walker
# Released under the MIT open-source license
#
############################################################################

$globalPackageFolder = $(dotnet nuget locals -l global-packages) -replace "^global-packages:\s+", ""

function Get-PipelineBadge {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,Position=0)]
        [string]$label, 
        [Parameter(Mandatory,Position=1)]
        [string]$pipeline,
        [Parameter(Position=2)]
        [string]$branchName = ""
    )

    return "[![$label]($($env:System_CollectionUri)$($env:System_TeamProject)/_apis/build/status/$($pipeline)?label=$label&branchName=$branchName)]($($env:System_CollectionUri)$($env:System_TeamProject)/_build/latest?definitionId=$($pipeline)&branchName=$branchName)"
}

function Get-ProjectInfoTable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,Position=0)]
        [string]$projectName, 
        [Parameter(Mandatory,Position=1)]
        [string]$projectPath
    )

    $items = Get-ChildItem -Path "**\$($projectName).dll" -Recurse -Force
    if (@($items).Length -lt 1) {
        return ""
    }

    if (!$AssemblyVersion) {
	    $assemblyPath = @($items)[0]
	    $fileVersionInfo = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($assemblyPath);
        $AssemblyVersion = $fileVersionInfo.ProductVersion;
    }
    $xmlProject = [XML](Get-Content -Path $projectPath)

    $tableString = "|||`r`n|-----|-----|`r`n"
    $tableString += "|Namespace|$($xmlProject.SelectSingleNode("//PackageId[1]").InnerText)|`r`n"
    $tableString += "|Target Framework|$($xmlProject.SelectSingleNode("//TargetFramework[1]").InnerText)|`r`n"
    $tableString += "|Author(s)|$($xmlProject.SelectSingleNode("//Authors[1]").InnerText)|`r`n"
    $tableString += "|Copyright|$($xmlProject.SelectSingleNode("//Copyright[1]").InnerText)|`r`n"
    $tableString += "|Version|$AssemblyVersion|`r`n"

    return $tableString
}

function Get-ProjectDependencyTable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,Position=0)]
        [string]$projectPath,
        [Parameter()]
        [hashtable]$purposes = @{}
    )

    if (!$(Test-Path -Path $projectPath) ) {
        return ""
    }

    $xmlProject = [XML](Get-Content -Path $projectPath)

    $tableString = "|Dependency|Version|License|Purpose|`r`n|-----|-----|-----|-----|`r`n"

    $xmlProject.SelectNodes("//ItemGroup/PackageReference").ForEach( {
	    $packageLower = $_.Include.ToLower()
	    $packagePath = "$globalPackageFolder$packageLower\$($_.Version)\$packageLower*.nuspec"
	    $xmlPackage = [XML](Get-Content -Path $packagePath)
	    $packageId = $xmlPackage.package.metadata.id;
	    if ($xmlPackage.package.metadata.projectUrl) {
		    $packageIdLink = "[$packageId]($($xmlPackage.package.metadata.projectUrl))"
	    } else {
            $packageIdLink = $packageId
        }

	    $packageVersion = $xmlPackage.package.metadata.version
	    $packageLicense = $xmlPackage.package.metadata.license.InnerText
        $packageDescription = $xmlPackage.package.metadata.description
        if ($purposes)
        {
            if ($purposes[$packageId]){
                $packageDescription = $purposes[$packageId]
            }
        }
        if (!$packageDescription) {
            $packageDescription = " "
        }

	    if (!$packageLicense -and $xmlPackage.package.metadata.licenseUrl) {
		    $packageLicense = "..."
	    }
	    if ($xmlPackage.package.metadata.licenseUrl) {
		    $packageLicense = "[$packageLicense]($($xmlPackage.package.metadata.licenseUrl))"
	    }

    	$tableString += "|{0}|{1}|{2}|{3}|`r`n" -f $packageIdLink, $packageVersion, $packageLicense, $packageDescription.split("`n")[0].replace("`n", '').replace("`r", '')
    })
    return $tableString
}

function Get-LibmanDependencyTable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,Position=0)]
        [string]$projectPath,
        [Parameter()]
        [hashtable]$purposes = @{}
    )

    $jsonFile = "$projectPath\libman.json"
    #Write-Host "==== $jsonFile ===="

    $jsonProject = (Get-Content $jsonFile -Raw) | ConvertFrom-Json
    [XML]$xmlProject = ConvertTo-Xml -Depth 1000 -InputObject @jsonProject -NoTypeInformation
    $defaultProvider = $jsonProject.defaultProvider
    if ($defaultProvider -eq '') { $defaultProvider = 'cdnjs' }

    $libraries = $($jsonProject.libraries) | Sort-Object -Property library

    $tableString = "|Dependency|Version|License|Purpose|`r`n|-----|-----|-----|-----|"
    #$tableString = "|Dependency|Purpose|`r`n|-----|-----|-----|-----|`r`n"
    foreach($lib in $libraries){

        $provider =$lib.provider
        if (!$provider) {
            $provider = $defaultProvider
        }

        #Write-Host "Library: $($lib.library), $provider"
        try {
            $libInfo = $(Get-LibmanLibraryData $provider $lib.library)
        } catch {
            # do nothing on error
        }

	    $packageVersion = $libInfo.CurrentVersion
	    $packageName = $libInfo.Name
        $packageBadge = "![$packageName]($($libInfo.PackageBadge))"
        $packageDescription = $libInfo.Description
        if ($purposes) {
            if ($purposes[$packageName]){
                $packageDescription = $purposes[$packageName]
            }
        }
        if (!$packageDescription) {
            $packageDescription = " "
        }

	    if ($libInfo.ProjectUrl) {
		    $packageBadge = "[$packageBadge]($($libInfo.ProjectUrl))"
	    }
        $licenseBadge = "![$($libInfo.License)]($($libInfo.LicenseBadge))"
	    if ($libInfo.LicenseUrl) {
		    $licenseBadge = "[$licenseBadge]($($libInfo.LicenseUrl))"
	    }

        $license = $libInfo.License
	    if ($libInfo.LicenseUrl) {
		    $license = "[$license]($($libInfo.LicenseUrl))"
	    }

	    if ($libInfo.RepositoryUrl) {
		    $packageversion = "[$packageVersion]($($libInfo.RepositoryUrl))"
	    }
	    if ($libInfo.ProjectUrl) {
		    $packageName = "[$packageName]($($libInfo.ProjectUrl))"
	    }

    	$tableString += "`r`n|{0}|{1}|{2}|{3}|" -f "$packageName", "$packageVersion", "$license", $packageDescription.split("`n")[0].replace("`n", '').replace("`r", '')
    	#$tableString += "|{0}<br />{1}|{2}|`r`n" -f $packageBadge, $licenseBadge, $purposes[$libInfo.Name]

    }
    return $tableString
}

function Get-LibmanLibraryData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,Position=0)]
        [string]$provider,
        [Parameter(Mandatory,Position=1)]
        [string]$library
    )

    $name = $library
    $license = ""
    $repo = ""
    $repoType = ""
    $repoUrl = ""
    $url = ""
    $description = ""
    $currentVersion = ""
    #Write-Host "== $provider =="
    #Write-Host "==== Retrieving $($library) info from $provider ===="

    switch -Exact ($provider) {
        'cdnjs' {
            # specs for cdnjs api: https://cdnjs.com/api#library
            $name = $library -replace '\@[\w\d\.]+$', ''

            $request = "https://api.cdnjs.com/libraries/$($name)"
            #Write-Host "Request: $request"
            
            try {
                $jsonData = Invoke-RestMethod -Uri $request -Method Get -UseBasicParsing
            } catch {
                $jsonData = @{ Name = $name; }
                #Write-Host "Fail: $response"
            } finally {
                $name = $jsonData.name
                $license = $jsonData.license
                $repo = $jsonData.repository
                $url = $jsonData.homepage
                $currentVersion = $($library -replace '^.*\@([\w\d\.]+)$', '$1')
                $description = $jsonData.description
            }
        }
        'jsdelivr' {
            $name = $library -replace '\@[\w\d\.]+$', ''
            $currentVersion = $library -replace '^\@?[\w\d\.]+\@', ''
            $request = "https://data.jsdelivr.com/v1/package/npm/$($library)"
            try {
                # Retrieve repo info from jsdelivr API
                #Write-Host "==== Retrieving $($library) info from JSDelivr: $request ===="
                $jsonData = $(Invoke-RestMethod -Uri "$($request)" -Method 'Get' -UseBasicParsing)
                # get file Hash for package.json file
                #Write-Host "==== Generate Base64 hash ===="
                $base64 = $jsonData.files | where { $_.name -eq 'package.json'}  | Select -ExpandProperty hash
                $hash = [System.BitConverter]::ToString([Convert]::FromBase64String("$base64")) -replace "-"
                #Write-Host "==== Retrieving $($library) info from JSDelivr Hash: $hash ===="
                # Retrieve file info for package.json file
                $request = "https://data.jsdelivr.com/v1/lookup/hash/$($hash)"
                $jsonData = $(Invoke-RestMethod -Uri "$($request)" -Method Get -UseBasicParsing)

                # Retrieve package.json file from repository
                $request = "https://cdn.jsdelivr.net/npm/$($library)$($jsonData.file)"
                $jsonData = $(Invoke-RestMethod -Uri "$($request)" -Method Get -UseBasicParsing)
                #Write-Host "== $jsonData =="
            } catch {
                #Write-Host "==== Error occurred. Using Default data ===="
                $jsonData = @{ Name = $name; Version = $currentVersion; }
            } finally {
                $name = $jsonData.name
                $license = $jsonData.license
                $repo = $jsonData.repository
                $url = $jsonData.homepage
                $currentVersion = $jsonData.version
                $description = $jsonData.description
            }


        }
        'unpkg' {
            $request = "https://www.unpkg.com/$($library)/?meta"
            try {
                # Retrieve repo info from npm API
                $jsonData = $(Invoke-RestMethod -Uri "$($request)" -Method Get -UseBasicParsing)
                #Write-Host "== $jsonData =="
                $file = $jsonData.files | where { $_.path -eq '/package.json'} 
                #Write-Host "== $file =="

                # Retrieve package.json file from repository
                $request = "https://www.unpkg.com/$($library)$($file.path)"
                $jsonData = $(Invoke-RestMethod -Uri "$($request)" -Method Get -UseBasicParsing)
                #Write-Host "== $jsonData =="
            } catch {
                $jsonData = @{ Name = $library }
            } finally {
                $name = $jsonData.name
                $license = $jsonData.license
                $repo = $jsonData.repository
                $url = $jsonData.homepage
                $currentVersion = $jsonData.version
            }
        }
        # normalize data and return
    }

    try {
        if ($repo) {
            $repoType = $repo.type
            $repoUrl = $repo.url
        } else {
            $repoType = ''
            $repoUrl = ''
        }

        $badgePackage = "https://img.shields.io/badge/" + $($name.replace('-', '--')) + "-v" + $($currentVersion.replace('-', '--')) + "-informational"
        $badgeLicense = "https://img.shields.io/badge/license-" + $($license.replace('-', '--')) + "-success"
        $repoUrl = ($repoUrl -replace '^git\+http', 'http') -replace '^git://', 'https://'
    } catch {
        
    }

    return @{ Name = $name; License = $license; RepositoryUrl = $repoUrl; ProjectUrl = $url; CurrentVersion = $currentVersion; PackageBadge=$badgePackage; LicenseBadge=$badgeLicense; LicenseUrl=$licenseUrl; Description = $description }
}

function Get-SqlSchemaTable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,Position=0)]
        [string]$dbServer, 
        [Parameter(Mandatory,Position=1)]
        [string]$dbName, 
        [Parameter(Mandatory,Position=2)]
        [string]$filePath,
        [Parameter(Position=3)]
        [string]$basePath = ".",
        [Parameter(Position=4)]
        [string]$heading = "Name",
        [Parameter]
        [hashtable]$purposes = @{}
    )

    $path = "$basePath/$filePath/*"
    
    if (Test-Path -Path $path) {
        $files = Get-ChildItem -Path $path -Include *.sql

        foreach($file in $files){
            $purpose = $purposes[$file]
            
            if (!$purpose) {
                $filedata = [Io.File]::ReadAllText($file)
                
                $purpose = [regex]::match($filedata, '(?i)\s*--\s*description\s*:[ \t]*([^\n\r]+)').Groups[1].Value
            
                if (!$purpose) {
                    $purpose = [regex]::match($filedata, "(?im)^[^\n\r]+sp_addextendedproperty[^\n\r]+MS_Description[^\n\r]+@value[^\n\r'`"]+['`"]([^\n\r'`"]+)(?:(?!level2name).)*$").Groups[1].Value                
                }
            }
    	    $tableString += "|{0}|{1}|[{2}]($($env:System_CollectionUri)_git/$($env:System_TeamProject)/?path=$filePath/{2}.sql)|{3}|`r`n" -f $dbServer, $dbName, [System.IO.Path]::GetFileNameWithoutExtension($file), $purpose
        }
    }

    if (!$tableString) {
        return ""
    }

    $tableString = "## $($heading)s:`r`n`r`n|Server|Database|$heading|Purpose|`r`n|-----|-----|-----|-----|`r`n$tableString"

    return $tableString
}

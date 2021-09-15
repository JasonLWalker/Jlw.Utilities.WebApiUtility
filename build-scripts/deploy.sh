#!/bin/bash

while getopts p:d:v:u:t:b: flag
do
    case "${flag}" in
        p) packageName=${OPTARG};;
        d) workingDir=${OPTARG};;
        v) packageVersion=${OPTARG};;
        u) githubUser=${OPTARG};;
        t) githubToken=${OPTARG};;
        b) buildType==${OPTARG};;

    esac
done

if [ ! $buildType ]; then 
    export buildType="Release"
fi

if [ ! $packageName ]; then 
    export packageName="$(pwd | sed 's/.*\/\([^\/]*\)$/\1/')"
fi

if [ ! $workingDir ]; then 
    export workingDir="$(pwd)"
fi

if [ ! $packageVersion ]; then 
    export packageVersion="$(echo `ls ./$packageName/bin/$buildType/*.nupkg` | sed 's/[^0-9]*\([0-9.a-z\-]*\)\.nupkg/v\1/')"
fi


if [ $GITHUB_ENV ]; then 
    echo "PKGNAME=$packageName" >> $GITHUB_ENV
    echo "PKGVERSION=$packageVersion" >> $GITHUB_ENV
    echo "BUILDTYPE=$buildType" >> $GITHUB_ENV
fi

echo "Uploading package to Github"
for f in ./$packageName/bin/$buildType/*.nupkg
do
    echo "  Uploading package $f"
    curl -vX PUT -u "$githubUser:$githubToken" -F package=@$f https://nuget.pkg.github.com/$githubUser/
done

echo "";
echo "Creating Zip package : ${packageName}.${packageVersion}.zip";
zip -r "${packageName}.${packageVersion}.zip" ./${packageName}/bin/$buildType/* README.md LICENSE

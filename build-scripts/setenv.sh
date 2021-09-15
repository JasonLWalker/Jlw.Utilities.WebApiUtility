#!/bin/bash

while getopts p:d:v: flag
do
    case "${flag}" in
        p) packageName=${OPTARG};;
        d) workingDir=${OPTARG};;
        v) packageVersion=${OPTARG};;
    esac
done

if [ ! $packageName ]; then 
    packageName="$(pwd | sed 's/.*\/\([^\/]*\)$/\1/')"
fi

if [ ! $workingDir ]; then 
    workingDir="$(pwd)"
fi

if [ $GITHUB_ENV ]; then 
    packageName="$(pwd | sed 's/.*\/\([^\/]*\)$/\1/')"
    echo "PKGNAME=$packageName" >> $GITHUB_ENV
    echo "CURRENTDIR=$workingDir" >> $GITHUB_ENV
    echo "DOTNET_NOLOGO=1" >> $GITHUB_ENV
    echo "DOTNET_CLI_TELEMETRY_OPTOUT=1" >> $GITHUB_ENV
    echo "DOTNET_MULTILEVEL_LOOKUP=1" >> $GITHUB_ENV
fi


#ls -la $workingDir
#ls -la $workingDir/$packageName

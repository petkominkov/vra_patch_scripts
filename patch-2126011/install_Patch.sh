#!/bin/bash
# ReadMe: Make the script executable by 'chmode -R 755 <script_name>' and just execute it.
# The script will stop if an error arises.

GREEN='\033[0;32m'
ORANGE='\033[0;33m'

PatchFileName="advanced-designer-service.war"
BackUpFolder="/tmp/advanced-service-designer-backup"
InstallFolder="/usr/lib/vcac/server/webapps/advanced-designer-service"
WarCopyDestinationFolder="/usr/lib/vcac/server/webapps/"
PatchSourceFolder="/tmp/patch_2126011"

echo "Create BackUp folder"
if ! mkdir $BackUpFolder; then echo "Backup folder creation failed"; exit 1; fi

echo "=== Moving up the content to $BackUpFolder... but the src folder stays with rights. /* copies the content of a folder"
if ! mv $InstallFolder/* $BackUpFolder; then echo "Backup failed"; exit 1; fi
ls -la $WarCopyDestinationFolder
sleep 5

echo "=== Copy the new wars to installation folder..."
if ! cp $PatchSourceFolder/$PatchFileName $WarCopyDestinationFolder; then echo "war copy failed"; exit 1; fi
sleep 2 

echo "=== fix the war rights..."
if ! chmod -R 755 $WarCopyDestinationFolder/$PatchFileName; then echo "fix the war rights failed"; exit 1; fi
sleep 2

#echo "=== Make an installation folder..." use only if the folder is moved on step2 and not only the its content by /*
#if ! mkdir $InstallFolder; then echo "mkdir installation folder failed"; exit 1; fi
#sleep 2

echo "=== Extracting the wars..."
if ! unzip -qq $PatchSourceFolder/$PatchFileName -d $InstallFolder; then echo "Unarchival failed"; exit 1; fi
sleep 5

echo "=== fix folder rights..."
if ! chmod -R 755 $InstallFolder; then echo "fix the war rights failed"; exit 1; fi
sleep 2 

echo "=== deleting the wars..."
if ! rm $WarCopyDestinationFolder$PatchFileName; then echo "deleting the war failed"; exit 1; fi
sleep 5

echo -e "=== ${GREEN}The patch has been installed successfully!..."
echo -e "=== ${ORANGE}Don't forget to test it!..."

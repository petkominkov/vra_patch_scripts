#!/bin/bash
# ReadMe: Make the script executable by 'chmode -R 755 <script_name>' and just execute it.
# The script should stop if an error arises.

PATCH_LOCATION='/tmp/patch_52326/'
PATCH_BINARY_1='/tmp/patch_52326/vra-tests-host-1.0.4-SNAPSHOT20171205165412.noarch.rpm'
PATCH_BINARY_2='/tmp/patch_52326/health-broker-service-host-1.0.4-SNAPSHOT20171205165412.noarch.rpm'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'

echo "=== Copying the patch to $appliance12..."
if ! scp -r $PATCH_LOCATION  root@dsrv10vra12.sccloudinfra.net:/tmp/ ; then echo "Cannot ssh to host 12"; exit 1; fi
if ! scp -r $PATCH_LOCATION  root@dsrv10vra13.sccloudinfra.net:/tmp/ ; then echo "Cannot ssh to host 13"; exit 1; fi

echo "=== Stopping vrhb-service ..."
if ! service vrhb-service stop; then echo "Service stop failed"; exit 1; fi
sleep 15

echo "=== Remove the current sandbox folders..."
if ! rm -r /var/lib/vrhb/service-host/sandbox; then echo "Removing the sandbox folders failed"; exit 1; fi
if ! rm -r /var/lib/vrhb/vra-tests-host/sandbox; then echo "Removing the sandbox folders failed"; exit 1; fi
sleep 2

echo "=== Install the RPMs "
if ! rpm -Uvh $PATCH_BINARY_1; then echo "Install RPM1 failed"; exit 1; fi
if ! rpm -Uvh $PATCH_BINARY_1; then echo "Install RPM2 failed"; exit 1; fi
sleep 2

echo "=== Starting vrhb-service ..."
if ! service vrhb-service start; then echo "Service start failed"; exit 1; fi

echo -e "=== ${GREEN}The patch has been installed successfully!..."
echo -e "=== ${ORANGE}Don't forget to test it!..."

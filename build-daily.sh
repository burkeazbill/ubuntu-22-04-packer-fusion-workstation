#!/usr/bin/env bash -e
# Set your variables as desired here:
VM_BASE_NAME="jammy"
VM_HOSTNAME="jammy-daily"
# Specify where the ISO should download to (or where you already have downloaded it to)
DOWNLOADS_FOLDER="${HOME}/Downloads"
GUEST_USERNAME="vmadmin"
GUEST_PASSWORD="MyP@ssw0rd-22!"
# Caution: The Encrypted PW following - when you regenerate it, if it has a / in it, then the sed command I use down below doesn't work!
# You must escape each "/" with a "\" See the following example, then compare what is output into your user-data file
GUEST_ENCRYPTED_PW='$6$Da\/Bin6we2OOJCVD$HM00JdEP47D.cVfSYzwf71khVHPD8NqbYLGw\/iXPswndEqI2TNsMELWRCt0tA2.mVMPjFZlPI0B\/xOBO9OhF01'
# The Encrypted password above is created using the following command (NOTE: mkpasswd part of whois package in Ubuntu):
# echo 'MyP@ssw0rd-22!' | mkpasswd -m sha-512 --stdin
VM_SUFFIX=`date +"%Y-%m-%d"`
echo ${VM_SUFFIX}
BUILD_SUFFIX=`date +"%Y-%m-%d-%H-%M"`

# Backup the current config files:
cp ubuntu-2204-daily.pkr.hcl ubuntu-2204-daily.pkr.hcl.bak
cp http/user-data http/user-data.bak

# Let's make sure the ISO we're trying to use has the correct/current checksum:
DAILY_ISO_CHECKSUM=`curl https://cdimage.ubuntu.com/ubuntu-server/daily-live/current/SHA256SUMS | grep live-server-amd64.iso | awk '{print $1}'`
# Now do some search and replace to customize (I know this can be done with variables.pkrvars.hcl, but keeping things extra simple for now)
if [ `uname -s` == "Darwin" ]; then
  sed -i "" "s/iso_checksum = .*/iso_checksum = \"sha256:$DAILY_ISO_CHECKSUM\"/" "ubuntu-2204-daily.pkr.hcl"
  sed -i "" "s/vm_name       = .*/vm_name       = \"${VM_BASE_NAME}-${VM_SUFFIX}\"/" "ubuntu-2204-daily.pkr.hcl"
  sed -i "" "s/  ssh_username      = .*/  ssh_username      = \"${GUEST_USERNAME}\"/" "ubuntu-2204-daily.pkr.hcl"
  sed -i "" "s/  ssh_password      = .*/  ssh_password      = \"${GUEST_PASSWORD}\"/" "ubuntu-2204-daily.pkr.hcl"
  sed -i "" "s|/Users/bazbill/Downloads|${DOWNLOADS_FOLDER}|g" "ubuntu-2204-daily.pkr.hcl"
  sed -i "" "s/    hostname: .*/    hostname: ${VM_HOSTNAME}/g" "./http/user-data"
  sed -i "" "s/    username: .*/    username: ${GUEST_USERNAME}/g" "./http/user-data"
  sed -i "" "s/vmadmin/${GUEST_USERNAME}/g" "./http/user-data"
  sed -i "" "s/    password: .*/    password: ${GUEST_ENCRYPTED_PW}/g" "./http/user-data"
else
  sed -i "s/iso_checksum = .*/iso_checksum = \"sha256:$DAILY_ISO_CHECKSUM\"/" "ubuntu-2204-daily.pkr.hcl"
  sed -i "s/vm_name       = .*/vm_name       = \"${VM_BASE_NAME}-${VM_SUFFIX}\"/" "ubuntu-2204-daily.pkr.hcl"
  sed -i "s/  ssh_username      = .*/  ssh_username      = \"${GUEST_USERNAME}\"/" "ubuntu-2204-daily.pkr.hcl"
  sed -i "s/  ssh_password      = .*/  ssh_password      = \"${GUEST_PASSWORD}\"/" "ubuntu-2204-daily.pkr.hcl"
  sed -i "s|/Users/bazbill/Downloads|${DOWNLOADS_FOLDER}|g" "ubuntu-2204-daily.pkr.hcl"
  sed -i "s/    hostname: .*/    hostname: ${VM_HOSTNAME}/g" "./http/user-data"
  sed -i "s/    username: .*/    username: ${GUEST_USERNAME}/g" "./http/user-data"
  sed -i "s/vmadmin/${GUEST_USERNAME}/g" "./http/user-data"
  sed -i "s/    password: .*/    password: ${GUEST_ENCRYPTED_PW}/g" "./http/user-data"
fi

### Build an Ubuntu Server 22.04 LTS Template for VMware Fusion. ###
echo -e "\e[38;5;39m========================================================================#\e[0m"
echo -e "\e[38;5;39mBuilding an Ubuntu Server 22.04 LTS Daily Template for VMware Fusion... #\e[0m"
echo -e "\e[38;5;39m========================================================================#\e[0m"
PACKER_LOG=1 packer build -force "./"
### All done ###
cp ubuntu-2204-daily.pkr.hcl ubuntu-2204-daily.pkr.hcl-${BUILD_SUFFIX}.bak
cp http/user-data http/user-data-${BUILD_SUFFIX}.bak

mv ubuntu-2204-daily.pkr.hcl.bak ubuntu-2204-daily.pkr.hcl
mv http/user-data.bak http/user-data

echo -e "\e[38;5;39m========================================================================#\e[0m"
echo -e "\e[38;5;39m Done!..................................................................#\e[0m"
echo -e "\e[38;5;39m========================================================================#\e[0m"
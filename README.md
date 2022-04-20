My goal with the set of files in my repo is to provide something simple to understand. When I started my path to learning and understanding this stuff, I was overwhelmed by some of the other repos (like the above mentioned packer-examples-for-vsphere) due to their more advanced and powerful configuration options. I hope this repo is found to be useful for others as well!

## Prerequisites

You must have the following installed/available in order to make use of this repository as-is:
- VMware Fusion (Apple Users) or VMware Worksation (Windows/Linux users)
- Hashicorp Packer (Version 1.8.0 is current as of this article)
- Access to a machine capable of running the mkpasswd command (if you need to change the GUEST_PASSWORD)

## How to use this repository

### The quick way
If you wish, you can simply clone the repository and run the script provided to get a quick Server VM available.

Default username: vmadmin
Default password: MyP@ssw0rd-22!

### The right way
As with any software/OS containing credentials, you are highly encouraged to CHANGE settings to fit your preferences

1. Clone the repository
2. Edit the following values in the http/user-data file:
  - locale
  - layout
  - timezone
  - packages (optional)
3. Edit Lines 2-11 in the build-daily.sh to fit your preferences
  - NOTE: The GUEST_ENCRYPTED_PW must be updated if you change the GUEST_PASSWORD value (instructions to generate that string value are provided in the script)
4. Review the ubuntu-2204-daily.pkr.hcl file, lines 10-15 and update VM specs as desired (optional)
5. Once you have reviewed and edited the files to your liking, run the build-daily.sh script

## What does this script and Packer configuration do?

- Get the daily build of the Ubuntu 22.04 LTS Server ISO image
- Get the iso checksum of the file from the official site
- Update the config files with the ISO Checksum, Downloads Folder, Guest Username, Guest Password, and Guest Encrypted password.
- Build a new VM in VMware Fusion or Workstation (I've only tested with Fusion)
- Set the build/ssh user to allow sudo without prompting for password
- Resize the Logical Volume/Volume Group to use 100% of the specified disk size
- Install: openssh-server, open-fm-tools, cloud-init, whois, zsh, wget, tasksel

[[Youtube Video walk-through]](https://www.youtube.com/watch?v=HHaG_ra5QFw)

## Ubuntu Download Pages
- [Jammy Releases](http://releases.ubuntu.com/jammy/)
- [Daily Server Build](https://cdimage.ubuntu.com/ubuntu-server/daily-live/current/)
- [Daily Desktop Build](https://cdimage.ubuntu.com/daily-live/current/)

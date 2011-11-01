INSTALLATION INSTRUCTIONS

Author: Filip van Laenen <f.a.vanlaenen@ieee.org>

These are the installation instructions for SHA1CRK.

1. INSTALLATION

1.1 UBUNTU

* Install Ruby 1.9 or newer. SHA1CRK won't work with Ruby 1.8 or less.
* Unpack the bundle file, e.g. using the following command:
	tar -xzf crk-<version-number>.tar.gz
* Navigate into the root directory of the unpacked bundle, e.g. using the following command:
	cd crk-<version-number>
* Install the package by running the install.sh script with root privileges, e.g. by doing:
	sudo ./install.sh
  Notice that it will try to install the gem log4r if it isn't installed yet.
	
2. CONFIGURATION

* Initialize SHA1CRK using the following command, and following the instructions:
	sha1crk init
* Try to run SHA1CRK using the following command:
	sha1crk start
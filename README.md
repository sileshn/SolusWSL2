# SolusWSL2
Solus on WSL2 (Windows 10 FCU or later) based on [wsldl](https://github.com/yuk7/wsldl)

[![Screenshot-2023-08-04-032944.png](https://i.postimg.cc/28dP1Gx2/Screenshot-2023-08-04-032944.png)](https://postimg.cc/MvTs4yNQ)
[![Github All Releases](https://img.shields.io/github/downloads/sileshn/SolusWSL2/total.svg?style=flat-square)](https://github.com/sileshn/SolusWSL2/releases) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com) 
[![License](https://img.shields.io/github/license/sileshn/SolusWSL2.svg?style=flat-square)](https://raw.githubusercontent.com/sileshn/SolusWSL2/main/LICENSE)

## Features and important information
SolusWSL2 may display errors while installing packages. This is due to [usysconf](https://github.com/getsolus/packages/tree/main/packages/u/usysconf) running post installation triggers. It doesn't affect the normal functioning of SolusWSL2 afaik.

You need a kernel with apparmor support for proper functioning of SolusWSL2. The standard wsl kernel doesn't include apparmor. You can find more information on how to compile and load a custom kernel [here](https://github.com/Fubuchi/SolusWSL-usysconf-fix?tab=readme-ov-file#compile-wsl2-kernel-with-apparmor-enable).

SolusWSL2 has the following features during the installation stage.
* Increase virtual disk size from the default 256GB
* Create a new user and set the user as default
* Supports systemd natively if you are running wsl v0.67.6 (more details [here](https://devblogs.microsoft.com/commandline/systemd-support-is-now-available-in-wsl/)) and above. You will need the [store version of wsl](https://apps.microsoft.com/store/detail/windows-subsystem-for-linux-preview/9P9TQF7MRM4R) for native systemd support. For previous versions of wsl, systemd is supported using diddledani's [one-script-wsl2-systemd](https://github.com/diddledani/one-script-wsl2-systemd). This is done automatically during initial setup.

SolusWSL2 includes a wsl.conf file which only has [section headers](https://i.postimg.cc/MZ4DC1Fw/Screenshot-2022-02-02-071533.png). Users can use this file to configure the distro to their liking. You can read more about wsl.conf and its configuration settings [here](https://docs.microsoft.com/en-us/windows/wsl/wsl-config).

## Requirements
* For x64 systems: Version 1903 or higher, with Build 18362 or higher.
* For ARM64 systems: Version 2004 or higher, with Build 19041 or higher.
* Builds lower than 18362 do not support WSL 2.
* If you are running Windows 10 version 2004 or higher, you can install all components required to run wsl2 with a single command. This will install ubuntu by default. More details are available [here](https://devblogs.microsoft.com/commandline/install-wsl-with-a-single-command-now-available-in-windows-10-version-2004-and-higher/).
	```cmd
	wsl.exe --install
	```
* If you are running Windows 10 lower then version 2004, follow the steps below. For more details, check [this](https://docs.microsoft.com/en-us/windows/wsl/install-manual) microsoft document.
	* Enable Windows Subsystem for Linux feature.
	```cmd
	dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
	```
	* Enable Virtual Machine feature
	```cmd
	dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
	```
	* Download and install the latest Linux kernel update package from [here](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi).

## How to install
* Make sure all the steps mentioned under "Requirements" are completed.
* [Download](https://github.com/sileshn/SolusWSL2/releases/latest) installer zip
* Extract all files in zip file to same directory
* Set version 2 as default. Note that this step is required only for manual installation.
  ```dos
  wsl --set-default-version 2
  ```
* Run Solus.exe to extract rootfs and register to WSL

**Note:**
Exe filename is using the instance name to register. If you rename it you can register with a diffrent name and have multiple installs.

## How to setup
Open Solus.exe and run the following commands.
```dos
passwd
sed -i 's#\# %wheel ALL=(ALL) ALL#%wheel ALL=(ALL) ALL#g' /etc/sudoers
useradd -m -G wheel -s /bin/bash <username>
passwd <username>
exit
```
Execute the command below in a windows cmd terminal from the directory where Solus.exe is installed.
```dos
>Solus.exe config --default-user <username>
```

## How to use installed instance
#### exe Usage
```
Usage :
    <no args>
      - Open a new shell with your default settings.
        Inherit current directory (with exception that %%USERPROFILE%% is changed to $HOME).

    run <command line>
      - Run the given command line in that instance. Inherit current directory.

    runp <command line (includes windows path)>
      - Run the given command line in that instance after converting its path.

    config [setting [value]]
      - `--default-user <user>`: Set the default user of this instance to <user>.
      - `--default-uid <uid>`: Set the default user uid of this instance to <uid>.
      - `--append-path <true|false>`: Switch of Append Windows PATH to $PATH
      - `--mount-drive <true|false>`: Switch of Mount drives
      - `--wsl-version <1|2>`: Set the WSL version of this instance to <1 or 2>
      - `--default-term <default|wt|flute>`: Set default type of terminal window.

    get [setting [value]]
      - `--default-uid`: Get the default user uid in this instance.
      - `--append-path`: Get true/false status of Append Windows PATH to $PATH.
      - `--mount-drive`: Get true/false status of Mount drives.
      - `--wsl-version`: Get the version os the WSL (1/2) of this instance.
      - `--default-term`: Get Default Terminal type of this instance launcher.
      - `--wt-profile-name`: Get Profile Name from Windows Terminal
      - `--lxguid`: Get WSL GUID key for this instance.

    backup [file name]
      - `*.tar`: Output backup tar file.
      - `*.tar.gz`: Output backup tar.gz file.
      - `*.ext4.vhdx`: Output backup ext4.vhdx file. (WSL2 only)
      - `*.ext4.vhdx.gz`: Output backup ext4.vhdx.gz file. (WSL2 only)
      - `*.reg`: Output settings registry file.

    clean
      - Uninstall that instance.

    help
      - Print this usage message.
```

#### Just Run exe
```cmd
>Solus.exe
[root@PC-NAME user]#
```

#### Run with command line
```cmd
>Solus.exe run uname -r
4.4.0-43-Microsoft
```

#### Run with command line with path translation
```cmd
>Solus.exe runp echo C:\Windows\System32\cmd.exe
/mnt/c/Windows/System32/cmd.exe
```

#### Change Default User(id command required)
```cmd
>Solus.exe config --default-user user

>Solus.exe
[user@PC-NAME dir]$
```

#### Set "Windows Terminal" as default terminal
```cmd
>Solus.exe config --default-term wt
```

## How to uninstall instance
```dos
>Solus.exe clean

```

## How to backup instance
export to backup.tar.gz (WSL1 or 2)
```cmd
>Solus.exe backup backup.tar.gz
```
export to backup.ext4.vhdx.gz  (WSL2 only)
```cmd
>Solus.exe backup backup.ext4.vhdx.gz
```

## How to restore instance

There are 2 ways to do it. 

Rename the backup to rootfs.tar.gz and run Solus.exe

(or)

.tar(.gz)
```cmd
>Solus.exe install backup.tar.gz
```
.ext4.vhdx(.gz)
```cmd
>Solus.exe install backup.ext4.vhdx.gz
```

You may need to run the command below in some circumstances.
```cmd
>Solus.exe --default-uid 1000
```

## How to build
#### Prerequisites

Docker, tar, zip, unzip need to be installed.

If you want to build using solus unstable profile, checkout the unstable branch.
```dos
git clone git@gitlab.com:sileshn/SolusWSL2.git
cd SolusWSL2
make

```
Copy the Solus-main.zip file to a safe location and run the command below to clean.
```dos
make clean

```

## How to install & run docker in SolusWSL2 without using docker desktop
Install docker binaries. Note that installing docker from solus repos doesn't work as the latest version in solus is 19.03.14. We need 20.10 versions and above.
```dos
sudo eopkg it -y wget
wget https://download.docker.com/linux/static/stable/x86_64/docker-20.10.6.tgz
tar xzvf docker-20.10.6.tgz
sudo cp docker/* /usr/bin/

```
You can now delete the downloaded files if needed.
```dos
rm -rf docker
rm docker-20.10.6.tgz

```

To manage docker as a non-root user, create and add user to docker group. 
```dos
sudo groupadd docker
sudo usermod -aG docker $USER

```

Follow [this](https://blog.nillsf.com/index.php/2020/06/29/how-to-automatically-start-the-docker-daemon-on-wsl2/) blog post for further setup instructions.

[![Screenshot-2021-02-18-120518.png](https://i.postimg.cc/7YqVpBqP/Screenshot-2021-02-18-120518.png)](https://postimg.cc/V5HntWS2)

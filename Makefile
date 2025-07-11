OUT_ZIP=SolusWSL2.zip
LNCR_EXE=Solus.exe

DLR=curl
DLR_FLAGS=-L
LNCR_ZIP_URL=https://github.com/yuk7/wsldl/releases/download/`curl https://api.github.com/repos/yuk7/wsldl/releases/latest -s | jq .name -r`/icons.zip
LNCR_ZIP_EXE=Solus.exe

all: $(OUT_ZIP)

zip: $(OUT_ZIP)
$(OUT_ZIP): ziproot
	@echo -e '\e[1;31mBuilding $(OUT_ZIP)\e[m'
	cd ziproot; bsdtar -a -cf ../$(OUT_ZIP) *

ziproot: Launcher.exe rootfs.tar.gz
	@echo -e '\e[1;31mBuilding ziproot...\e[m'
	mkdir ziproot
	cp Launcher.exe ziproot/${LNCR_EXE}
	cp rootfs.tar.gz ziproot/

exe: Launcher.exe
Launcher.exe: icons.zip
	@echo -e '\e[1;31mExtracting Launcher.exe...\e[m'
	unzip icons.zip $(LNCR_ZIP_EXE)
	mv $(LNCR_ZIP_EXE) Launcher.exe

icons.zip:
	@echo -e '\e[1;31mDownloading icons.zip...\e[m'
	$(DLR) $(DLR_FLAGS) $(LNCR_ZIP_URL) -o icons.zip

rootfs.tar.gz: rootfs
	@echo -e '\e[1;31mBuilding rootfs.tar.gz...\e[m'
	cd rootfs; sudo tar -zcpf ../rootfs.tar.gz `sudo ls`
	sudo chown `id -un` rootfs.tar.gz

rootfs: base.tar
	@echo -e '\e[1;31mBuilding rootfs...\e[m'
	mkdir rootfs
	sudo tar -xpf base.tar -C rootfs
	@echo "# This file was automatically generated by WSL. To stop automatic generation of this file, remove this line." | sudo tee rootfs/etc/resolv.conf > /dev/null
	sudo cp wsl.conf rootfs/etc/wsl.conf
	sudo cp wsl-distribution.conf rootfs/etc/wsl-distribution.conf
	sudo cp solus.ico rootfs/usr/lib/wsl/solus.ico
	sudo cp bash_profile rootfs/root/.bash_profile
	sudo cp wslg-init.sh rootfs/usr/bin/wslg-init.sh
	sudo cp wslg-init.service rootfs/usr/lib/systemd/system/wslg-init.service
	sudo chmod +x rootfs

base.tar:
	@echo -e '\e[1;31mExporting base.tar using docker...\e[m'
	docker run --net=host --name soluswsl silkeh/solus:ypkg /bin/bash -c "eopkg up -y; eopkg it -y apparmor bzip2 cmake dialog dos2unix efivar elfutils elfutils-devel libelf-devel iptables iproute2 keychain lolcat openssh rsync socat sqlite3 wget xdg-utils; eopkg dc; mkdir -p /usr/local/bin; git clone https://github.com/cmatsuoka/figlet.git; cd figlet; make && make install; cd && rm -rf /figlet; git clone https://github.com/acmel/dwarves.git; cd dwarves; mkdir build && cd build; cmake -DCMAKE_INSTALL_PREFIX=/usr -D__LIB=lib ..; make install; cd && rm -rf dwarves; touch /usr/share/defaults/etc/profile.d/custom.sh; touch /etc/environment; rm /usr/share/defaults/etc/profile.d/10-path.sh; mkdir -p /usr/lib/wsl; systemctl mask systemd-firstboot"
	docker export --output=base.tar soluswsl
	docker rm -f soluswsl

clean:
	@echo -e '\e[1;31mCleaning files...\e[m'
	-rm ${OUT_ZIP}
	-rm -r ziproot
	-rm Launcher.exe
	-rm icons.zip
	-rm rootfs.tar.gz
	-sudo rm -r rootfs
	-rm base.tar
	-docker rmi silkeh/solus:ypkg -f

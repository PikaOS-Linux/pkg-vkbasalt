# Add dependent repositories
sudo dpkg --add-architecture i386
wget -q -O - https://ppa.pika-os.com/key.gpg | sudo apt-key add -
add-apt-repository https://ppa.pika-os.com
add-apt-repository ppa:pikaos/pika
add-apt-repository ppa:kubuntu-ppa/backports
# Clone Upstream
git clone https://github.com/DadSchoorse/vkBasalt.git -b v0.3.2.9
mv ./vkBasalt ./vkbasalt
cp -rvf ./debian ./vkbasalt
cd ./vkbasalt

# Get build deps
LOGNAME=root dh_make --createorig -y -l -p vkbasalt_0.3.2.9
ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
apt-get build-dep -y ./
debuild -S -uc -us
cd ../

apt-get install -y pbuilder debootstrap devscripts debhelper sbuild debhelper ubuntu-dev-tools piuparts

apt install -y debian-archive-keyring
cp -rvf ./pbuilderrc /etc/pbuilderrc
mkdir -p /var/cache/pbuilder/hook.d/
cp -rvf ./hooks/* /var/cache/pbuilder/hook.d/
rm -rf /var/cache/apt/
mkdir -p /pbuilder-results
DIST=lunar ARCH=i386 pbuilder create --distribution lunar --architecture i386 --debootstrapopts --include=ca-certificates
echo 'starting build'
DIST=lunar ARCH=i386 pbuilder build ./*.dsc --distribution lunar --architecture i386 --debootstrapopts --include=ca-certificates

# Move the debs to output
mkdir -p ./output
mv /var/cache/pbuilder/result/*.deb ./output/ || sudo mv ../*.deb ./output/

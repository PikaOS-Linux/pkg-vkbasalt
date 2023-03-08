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
apt-get install build-essential -y
apt-get install crossbuild-essential-i386 lib32gcc-11-dev -y
apt-get build-dep ./ -y -a i386
apt-get -y install meson pkg-config glslang-tools:i386 libx11-dev:i386 libvulkan-dev:i386 spirv-headers

# Build package
dpkg-buildpackage -a i386

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/


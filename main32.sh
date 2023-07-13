# Clone Upstream
git clone https://github.com/DadSchoorse/vkBasalt.git -b v0.3.2.10
mv ./vkBasalt ./vkbasalt
cp -rvf ./debian ./vkbasalt
cd ./vkbasalt

# Get build deps
apt-get build-dep ./ -y

# Build package
dpkg-buildpackage --no-sign

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/

#!/bin/bash
set -e

echo "=== Open Fodder Mobile Deploy ==="

# Clone repo
cd /tmp
rm -rf openfoddermobile
git clone -b claude/iphone-compatibility-t8SV0 https://github.com/itskevinb/openfoddermobile.git
cd openfoddermobile

# Get game data
mkdir -p Run && cd Run
curl -L -o /tmp/datapack.zip https://github.com/OpenFodder/data/releases/download/1.7.0/Data.pack.1.7.0.zip
unzip -o /tmp/datapack.zip
rm -f about.bmp
cd ..

# Install Emscripten
rm -rf /tmp/emsdk
git clone --depth 1 https://github.com/emscripten-core/emsdk.git /tmp/emsdk
cd /tmp/emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh

# Build
cd /tmp/openfoddermobile
mkdir -p build-ems && cd build-ems
emcmake cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)

# Serve
echo ""
echo "=== BUILD COMPLETE ==="
echo "Starting server on port 8080..."
echo "Open http://$(hostname -I | awk '{print $1}'):8080/OpenFodder.html on your iPhone"
echo ""
cd /tmp/openfoddermobile/RunE
python3 -m http.server 8080 --bind 0.0.0.0

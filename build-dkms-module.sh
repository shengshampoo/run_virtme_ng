#! /bin/bash

#set -e

mkdir -p /work/artifact

# linux xanmod kernel

apt update -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true
apt install --yes jq dkms lzip
wget -qO - https://gist.githubusercontent.com/shengshampoo/62d3a4f2f187927db933673cc715f8ef/raw/cec7264a320fad6027f78edc6296d75592d6e2a1/archive.key | gpg --dearmor -vo /etc/apt/keyrings/xanmod-archive-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-release.list
KRV=$(wget -qO-  "https://gitlab.com/api/v4/projects/51590166/repository/tags?order_by=updated&search=6.18" | jq -r '.[0].name'  | sed -e s/-.*//)-x64v3-xanmod1
KRW=$(wget -qO-  "https://gitlab.com/api/v4/projects/51590166/repository/tags?order_by=updated&search=rt" | jq -r '.[0].name'  | sed -e s/-x.*//)-x64v3-xanmod1
apt update -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true
apt install linux-image-$KRV linux-headers-$KRV linux-image-$KRW linux-headers-$KRW

# bcachefs dkms module
wget -qO- https://apt.bcachefs.org/apt.bcachefs.org.asc | tee /etc/apt/trusted.gpg.d/apt.bcachefs.org.asc
wget -qO- "https://gist.githubusercontent.com/shengshampoo/1d0a95c771a9be46a8ffba981ccf959b/raw/9b4e33dd2e2401a38e6595be951da68e21f43b66/apt.bcachefs.org.sources" | tee /etc/apt/sources.list.d/apt.bcachefs.org.sources
apt update
apt install --yes bcachefs-tools

cd /work/artifact
cp /lib/modules/$KRV/updates/dkms/bcachefs.ko .
tar -I 'lzip -9' --remove-files -vcf bcachefs.ko-$KRV.tlz ./bcachefs.ko
cp /lib/modules/$KRW/updates/dkms/bcachefs.ko .
tar -I 'lzip -9' --remove-files -vcf bcachefs.ko-$KRW.tlz ./bcachefs.ko

#!/bin/bash
recipe=$1

name=$(grep '^name:' $recipe | cut -d: -f2 | xargs)
repo=$(grep '^repo:' $recipe | cut -d: -f2- | xargs)
deps=$(awk '/^deps:/,/^[^ ]/ {if ($0 ~ /^  -/) print $2}' $recipe | tr '\n' ' ')

apt install -y $deps

git clone --recursive $repo src
cd src

build=$(awk '/^build: \|/,/^[^ ]/ {if (NR > 1 && $0 !~ /^[^ ]/) print}' $recipe)
eval "$build"

dpkg-deb --build pkg ../pool/main/${name}.deb
cd ..
rm -rf src

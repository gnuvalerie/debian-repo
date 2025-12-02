#!/bin/bash
recipe=$1
name=$(yq '.name' $recipe)
repo=$(yq '.repo' $recipe)
deps=$(yq '.deps[]' $recipe)

apt install -y $deps

git clone --recursive $repo src
cd src

eval "$(yq '.build' $recipe)"

dpkg-deb --build pkg ../pool/main/${name}.deb
cd ..
rm -rf src

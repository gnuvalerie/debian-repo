#!/bin/bash
recipe=$1
recipe_abs=$(realpath $recipe)

name=$(grep '^name:' $recipe_abs | cut -d: -f2 | xargs)
repo=$(grep '^repo:' $recipe_abs | cut -d: -f2- | xargs)
deps=$(awk '/^deps:/,/^build:/ {if ($0 ~ /^  - /) print $2}' $recipe_abs | tr '\n' ' ')

echo "Installing: $deps"
apt install -y $deps

git clone --recursive $repo src
cd src

build=$(awk '/^build: \|/,0 {if (NR > 1) print}' $recipe_abs | sed '1d')
eval "$build"

dpkg-deb --build pkg ../pool/main/${name}.deb
cd ..
rm -rf src

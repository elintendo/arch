#!/bin/bash
shopt -s extglob
path=$(pwd)

# ln -sf "$(pwd)"/!(script.sh) ~/.mozilla/firefox/*.default-release
ln -sf "$(pwd)"/chrome ~/.mozilla/firefox/*.default-release
cp "$(pwd)"/user.js ~/.mozilla/firefox/*.default-release
cp "$(pwd)"/places.sqlite ~/.mozilla/firefox/*.default-release

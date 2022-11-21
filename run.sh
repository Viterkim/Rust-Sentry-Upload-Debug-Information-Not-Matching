#!/bin/bash

# Check for vars
if [ "$#" -ne 3 ]; then
  echo "" 
  echo "Provide vars for 1. DSN 2. Org and 3. Project"
  echo "Example:"
  echo "./run.sh https://valid@sentry.io/85 real-org real-project"
  echo ""
  exit 1
fi  

DSN=$1
ORG=$2
PROJECT=$3

BIN_NAME=rust-sentry-upload

# Building & splitting
cargo clean && cargo build --release
cp ./target/release/"${BIN_NAME}" ./target/release/"${BIN_NAME}".full
objcopy --only-keep-debug ./target/release/"${BIN_NAME}" ./target/release/"${BIN_NAME}".debug

objcopy --strip-debug --strip-unneeded ./target/release/"${BIN_NAME}"
# OR THIS: strip -s ./target/release/"${BIN_NAME}"

# Add link
objcopy --add-gnu-debuglink=./target/release/"${BIN_NAME}".debug ./target/release/"${BIN_NAME}"

# Upload debug information to sentry
sentry-cli upload-dif --wait -o "${ORG}" -p "${PROJECT}" ./target/release/"${BIN_NAME}".debug

# To make sure we can't use the local one, and sentry has to use the one we upload
rm ./target/release/"${BIN_NAME}".debug

# # Run and upload
DSN="$DSN" ./target/release/"${BIN_NAME}"
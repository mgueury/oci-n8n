#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

sudo dnf module enable -y nodejs:20
sudo dnf install -y nodejs
sudo npm install n8n -g
#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR



export DB_USER="##DB_USER##"
export DB_PASSWORD="##DB_PASSWORD##"
export DB_URL="##DB_URL##"
source myenv/bin/activate
python app.py 2>&1 | tee app.log
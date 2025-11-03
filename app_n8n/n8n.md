# N8N
---
Doc: https://docs.public.content.oci.oraclecloud.com/en-us/iaas/Content/generative-ai/openai-models.htm
Doc: https://github.com/jin38324/OCI_GenAI_access_gateway
Doc: https://docs.n8n.io/hosting/installation/npm/

# 
sudo dnf module enable -y nodejs:20
sudo dnf install -y nodejs

sudo npm install n8n -g

# OCI_GenAI_access_gateway
git clone https://github.com/jin38324/OCI_GenAI_access_gateway.git
cd OCI_GenAI_access_gateway
sudo dnf install -y python3.12 python3.12-pip python3-devel
sudo update-alternatives --set python /usr/bin/python3.12
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install virtual env python_env
uv venv myenv
source myenv/bin/activate
uv pip install -r requirements.txt

cd app

# AUTH_TYPE
sed -i "s&AUTH_TYPE = \"API_KEY\"&AUTH_TYPE = \"INSTANCE_PRINCIPAL\"&" config.py

# REGION
sed -i "s&AUTH_TYPE = \"API_KEY\"&AUTH_TYPE = \"INSTANCE_PRINCIPAL\"&" config.py

# COMPARTMENT
sed -i '/^PORT =.*/i import os\n' config.py
sed -i "s&OCI_COMPARTMENT = \"ocid1.compartment.oc1..xxx\"&OCI_COMPARTMENT = os.environ['TF_VAR_compartment_ocid']&" config.py

# RUN
n8n

http://localhost:5678

demo.gueury@gmail.com
LiveLab__123

 sudo firewall-cmd --zone=public --add-port=8088/tcp --permanent

# 
#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/instance/ > /tmp/instance.json
export TF_VAR_compartment_ocid=`cat /tmp/instance.json | jq -r .compartmentId`
export TF_VAR_region=`cat /tmp/instance.json | jq -r .region`

source myenv/bin/activate
cd app
# python app.py
gunicorn app:app --workers 4 --worker-class uvicorn.workers.UvicornWorker --timeout 600 --bind 0.0.0.0:8088

Connection:
-----------
ocigenerativeai
http://0.0.0.0:8088/v1

or 

http://public-ip/app/v1

SSH
---
ssh -L5678:0.0.0.0:5678 opc@xxx

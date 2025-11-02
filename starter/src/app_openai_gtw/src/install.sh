# OCI_GenAI_access_gateway
sudo dnf install -y git
sudo dnf install -y python3.12 python3.12-pip python3-devel
sudo update-alternatives --set python /usr/bin/python3.12
curl -LsSf https://astral.sh/uv/install.sh | sh

git clone https://github.com/jin38324/OCI_GenAI_access_gateway.git
cd OCI_GenAI_access_gateway

# Install virtual env python_env
uv venv myenv
source myenv/bin/activate
uv pip install -r requirements.txt

cd app
# AUTH_TYPE
sed -i "s&AUTH_TYPE = \"API_KEY\"&AUTH_TYPE = \"INSTANCE_PRINCIPAL\"&" config.py

# REGION
# sed -i "s&AUTH_TYPE = \"API_KEY\"&AUTH_TYPE = \"INSTANCE_PRINCIPAL\"&" config.py

# COMPARTMENT
sed -i '/^PORT =.*/i import os\n' config.py
sed -i "s&OCI_COMPARTMENT = \"ocid1.compartment.oc1..xxx\"&OCI_COMPARTMENT = os.environ['TF_VAR_compartment_ocid']&" config.py

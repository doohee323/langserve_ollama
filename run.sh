#https://velog.io/@etimo/conda-jupyter-notebook-PyCharm-%EC%97%B0%EB%8F%99%ED%95%98%EA%B8%B0

ssh streamlit2.seerslab.io

sudo apt install build-essential libssl-dev zlib1g-dev libncurses5-dev libncursesw5-dev libreadline-dev libsqlite3-dev libgdbm-dev libdb5.3-dev libbz2-dev libexpat1-dev liblzma-dev tk-dev libffi-dev -y
PYTHON_VERSION=3.10.4
cd /tmp
wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
tar -xf Python-${PYTHON_VERSION}.tgz
cd Python-${PYTHON_VERSION}
./configure --enable-optimizations --with-ensurepip=install
make -j 8
#make install
make altinstall
python3 --version
cp python /usr/bin/python

git clone https://github.com/doohee323/langserve_ollama.git
cd langserve_ollama

sudo apt update -y
sudo apt install python3-pip -y
sudo apt-get install libgl1 -y
sudo apt-get install poppler-utils -y
sudo apt-get install tesseract-ocr -y
sudo apt install libtesseract-dev -y
sudo apt install python3-virtualenv -y

python -m pip config set global.break-system-packages true
python -m pip install --upgrade pip

pip install virtualenv
pip install setuptools
pip install --upgrade setuptools
virtualenv env --python=python3.10
source env/bin/activate

#pip3 freeze > requirements.txt
pip3 install --upgrade -r requirements.txt
pip3 install fastapi
pip3 install langchain
pip3 install langchain_community
pip3 install langchain_openai
pip3 install sse_starlette
pip3 install unstructured
pip3 install sentence-transformers
pip3 install langserve
pip3 install streamlit
pip3 install "unstructured[pdf]"
pip3 install faiss-cpu
#pip3 install setuptools
#pip3 install pillow
#python3 -m pip install setuptools

#bash Miniconda3-latest-MacOSX-x86_64.sh
#conda create -n langserve_ollama python=3.9
#conda activate langserve_ollama
#conda install jupyter

#cd app
#python3 server.py

cd example
#sudo apt install -y libsqlite3-dev

streamlit run main.py

============================================================================================================

echo '#!/usr/bin/env bash

if [[ "$1" == "stop" ]]; then
  kill -9 $(ps -ef | grep "streamlit run main.py" | grep -v "grep" | awk "{print $2}" | head -n 1)
  exit 0
fi

cd /home/ubuntu/langserve_ollama
source env/bin/activate
cd app
/usr/bin/nohup python3 server.py 2>&1 &
exit 0
' > /home/ubuntu/langserve_ollama/langserve.sh

chmod 777 /home/ubuntu/langserve_ollama/langserve.sh

sudo tee /etc/systemd/system/langserve.service <<"EOF"
[Unit]
Description=langserve service
After=network.target
After=systemd-user-sessions.service
After=network-online.target

[Service]
User=root
Type=forking
ExecStart=/home/ubuntu/langserve_ollama/langserve.sh
ExecStop=/home/ubuntu/langserve_ollama/langserve.sh stop
TimeoutSec=30
Restart=on-failure
RestartSec=30
StartLimitInterval=350
StartLimitBurst=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable langserve.service
service langserve start
#service langserve status
#service langserve stop

============================================================================================================

echo '#!/usr/bin/env bash

if [[ "$1" == "stop" ]]; then
  kill -9 $(ps -ef | grep "streamlit run main.py" | grep -v "grep" | awk "{print $2}" | head -n 1)
  exit 0
fi

cd /home/ubuntu/langserve_ollama
source env/bin/activate
cd example
/usr/bin/nohup streamlit run main.py 2>&1 &
exit 0
' > /home/ubuntu/langserve_ollama/example/streamlit.sh

chmod 777 /home/ubuntu/langserve_ollama/example/streamlit.sh

sudo tee /etc/systemd/system/streamlit.service <<"EOF"
[Unit]
Description=streamlit service
After=network.target
After=systemd-user-sessions.service
After=network-online.target

[Service]
User=root
Type=forking
ExecStart=/home/ubuntu/langserve_ollama/example/streamlit.sh
ExecStop=/home/ubuntu/langserve_ollama/example/streamlit.sh stop
TimeoutSec=30
Restart=on-failure
RestartSec=30
StartLimitInterval=350
StartLimitBurst=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable streamlit.service
service streamlit start
#service streamlit status
#service streamlit stop


============================================================================================================

sudo apt install nginx -y
sudo tee /etc/nginx/sites-available/default <<"EOF"
map $http_upgrade $connection_upgrade {
    default upgrade;
    '' close;
}
server {
  listen 80;
#  server_name streamlit2.seerslab.io;
  location / {
    proxy_pass http://localhost:8501;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
    proxy_set_header Host $host;
  }
}
EOF

sudo service nginx restart
#sudo service nginx start



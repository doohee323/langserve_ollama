#https://velog.io/@etimo/conda-jupyter-notebook-PyCharm-%EC%97%B0%EB%8F%99%ED%95%98%EA%B8%B0

#bash Miniconda3-latest-MacOSX-x86_64.sh
conda create -n langserve_ollama python=3.9
conda activate langserve_ollama
conda install jupyter

cd langserve_ollama

sudo apt install python3-virtualenv
virtualenv env
source env/bin/activate

pip3 install --upgrade -r requirements.txt
pip3 install fastapi
pip3 install langserve
pip3 install langchain_community
pip3 install langchain_openai
pip3 install sse_starlette

cd app
python3 server.py

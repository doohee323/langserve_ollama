#!/usr/bin/env bash

if [[ "$1" == "stop" ]]; then
  kill -9 $(ps -ef | grep "streamlit run main.py" | grep -v "grep" | awk "{print $2}" | head -n 1)
  exit 0
fi

cd /home/ubuntu/langserve_ollama
source env/bin/activate
cd example
/usr/bin/nohup streamlit run main.py 2>&1 &

exit 0
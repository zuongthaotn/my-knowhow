# Steps install mcp server (ver local) Ubuntu

1. install python 3.11

sudo apt install software-properties-common

sudo add-apt-repository ppa:deadsnakes/ppa

sudo apt update

sudo apt install python3.11 python3.11-venv python3.11-dev

2. git clone https://github.com/oraios/serena

3. cd serena

3.1. python3.11 -m venv venv

3.2. source venv/venv/activate 

3.3 pip install -e .

4. tích hợp serena vào claude

claude mcp add --transport stdio local_serena /path/to/your/venv/bin/serena start-mcp-server

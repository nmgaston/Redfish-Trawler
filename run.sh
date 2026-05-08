
if [ "$1" = "clean" ] ; then
    echo "Removing directory .venv"
    rm -r .venv
fi

if [ ! -d ".venv" ]; then
    echo "Creating virtual environment"
    python3 -m venv .venv 
    . .venv/bin/activate
    pip install -r requirements.txt
else
    echo "Entering virtual environment"
    . .venv/bin/activate
fi

python3 ./redfish_trawler.py
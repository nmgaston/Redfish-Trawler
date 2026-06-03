# enter directory
cd redfish-trawler-frontend

if [ "$1" = "clean" ] ; then
    echo "Removing directory node_modules"
    rm -r node_modules
fi

# check for npm (check version in future script)
if ! [ -x "$(command -v npm)" ]; then
  echo 'Command `npm` does not seem to be available' >&2
  exit 1
fi

if [ ! -d "node_modules" ]; then
  npm install
  if [ $? -eq 0 ]; then
      echo Installed NPM Packages.
  else
      echo NPM Install process exited unsuccessfully.
  fi
fi

npm run build
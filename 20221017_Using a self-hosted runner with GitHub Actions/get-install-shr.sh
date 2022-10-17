### get and install the runner application (script provided by GitHub)
## download the runner application
# create a runner folder
mkdir actions-runner && cd actions-runner

# download the latest runner package
curl -o actions-runner-linux-x64-2.298.2.tar.gz -L https://github.com/actions/runner/releases/download/v2.298.2/actions-runner-linux-x64-2.298.2.tar.gz

# (optional) validate the hash
echo "0bfd792196ce0ec6f1c65d2a9ad00215b2926ef2c416b8d97615265194477117  actions-runner-linux-x64-2.298.2.tar.gz" | shasum -a 256 -c

# extract the installer
tar xzf ./actions-runner-linux-x64-2.298.2.tar.gz


## configure the runner application
# create the runner and start the configuration experience
./config.sh --url https://github.com/TomicaKaniski/AzureIaCGH --token "<<--TOKEN_GOES_HERE!-->>"

# last step, run it! (we will actually run it via crontab at machine restart!)
# ./run.sh

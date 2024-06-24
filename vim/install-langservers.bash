#!/bin/bash

npm config set prefix '~/.local/'
npm install -g bash-language-server
pip3 install pyright --break-system-packages --user

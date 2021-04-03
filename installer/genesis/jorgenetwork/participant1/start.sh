#!/usr/bin/env bash

cd installer/genesis/jorgenetwork/participant1/
goal node start -d . -p "relay:4161"
carpenter -d .


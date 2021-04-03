#!/usr/bin/env bash

cd installer/genesis/jorgenetwork/participantGeneric/
goal node start -d . -p "relay:4161"
carpenter -d .

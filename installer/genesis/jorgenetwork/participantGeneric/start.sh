#!/usr/bin/env bash

cd installer/genesis/jorgenetwork/participantGeneric/
goal node start -d . -p "${BOOTSTRAP}:4161"
carpenter -d .

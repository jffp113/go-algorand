#!/bin/bash
# Name: start.sh
# Purpose: Run multiple sawtooth nodes on multiple machines
# ----------------------------------------------------

SERVERS=(51.83.75.29 51.83.75.29 51.83.75.29 51.83.75.29 51.83.75.29 )
SIGNERSNODES=(51.83.75.29 51.83.75.29 51.83.75.29 51.83.75.29 51.83.75.29)
COMPOSE_PATH="/home/jfp/sawtooth-core/docker/jorge/setup/config/first/sawtooth-first-5.yaml"

#Do not change bellow
ID=1
GROUPSIG=0 #Change this to on to validate group sigs
API_PORT=8008
SIGNER_PORT=7000


###Start launching first node

 CMD="bash -c '
    export ID=${ID} &&
    export GROUPSIG=${GROUPSIG}
    export PORT=${API_PORT} &&
    export SIGNERNODE=${SIGNERSNODES[ID - 1]}:${SIGNER_PORT} &&
    docker-compose -p ${ID} -f ${COMPOSE_PATH}/bootstrap.yml up --detach
    '
  "
  echo "- \"${SERVERS[ID - 1]}:${API_PORT}\"" > peers.txt
  echo $CMD
  echo $CMD | ssh -t jfp@${SERVERS[ID - 1]} bash

sleep 3

###Start launching a participant node for PPOS
  ID=$((ID + 1))
  HOST_PORT=$((HOST_PORT + 1))
  API_PORT=$((API_PORT + 1))
  SIGNER_PORT=$((SIGNER_PORT + 1))

 CMD="bash -c '
    export ID=${ID} &&
    export GROUPSIG=${GROUPSIG}
    export BOOTSTRAP=${SERVERS[0]}
    export PORT=${API_PORT} &&
    export SIGNERNODE=${SIGNERSNODES[ID - 1]}:${SIGNER_PORT} &&
    docker-compose -p ${ID} -f ${COMPOSE_PATH}/participant.yml up --detach
    '
  "
  echo "- \"${SERVERS[ID - 1]}:${API_PORT}\"" >> peers.txt
  echo $CMD
  echo $CMD | ssh -t jfp@${SERVERS[ID - 1]} bash

###Start the rest of the peers

for s in ${SERVERS[@]:2}
do
  ID=$((ID + 1))
  HOST_PORT=$((HOST_PORT + 1))
  API_PORT=$((API_PORT + 1))
  SIGNER_PORT=$((SIGNER_PORT + 1))

  #echo ${options}

  CMD="bash -c '
    export ID=${ID} &&
    export GROUPSIG=${GROUPSIG}
    export BOOTSTRAP=${SIGNERSNODES[0]}
    export PORT=${API_PORT} &&
    export SIGNERNODE=${SIGNERSNODES[ID - 1]}:${SIGNER_PORT} &&
    docker-compose -p ${ID} -f ${COMPOSE_PATH}/other.yml up --detach
    '
  "
  echo $CMD | ssh -t jfp@${s} bash
  echo "- \"${s}:${API_PORT}\"" >> peers.txt
done
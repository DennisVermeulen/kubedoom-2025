#!/bin/sh

if [ -z "${USERNAME}" ] || [ -z "${EMAIL}" ] ; then
  echo "Environment variable USERNAME and/or EMAIL are not set."
  exit 1
fi

echo "Good luck playing Doom ${USERNAME}!"
sleep 3600
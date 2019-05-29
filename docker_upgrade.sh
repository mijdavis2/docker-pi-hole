#!/bin/bash

################################################
# Upgrade pihole and cleanup old docker images #
#                                              #
# Meant to be run while a pihole is running so #
# dns works while fetching new pihole image    #
################################################

docker pull pihole/pihole

echo "Removing old pihole container..."
docker -l fatal stop pihole 
docker -l fatal rm pihole
echo "Ready to deploy new pihole container"

./docker_run.sh 2> /dev/null

echo "Removing old docker images..."
docker -l fatal rmi $(docker images --filter "dangling=true" -q --no-trunc) 2> /dev/null
docker -l fatal rmi $(docker images | grep "none" | awk '/ / { print $3 }') 2> /dev/null
echo "Cleanup complete"

#!/bin/bash

################################################
# Upgrade pihole and cleanup old docker images #
#                                              #
# Meant to be run while a pihole is running so #
# dns works while fetching new pihole image    #
################################################

docker pull pihole/pihole


echo -e "\n\nRemoving old pihole container..."
docker stop pihole
docker rm pihole

cat << EOF 

#####
Pihole is now temporarily down as well as DNS if there is no fallback.

Ignore following error when docker tries to pull the latest pihole image.
We already did that while the old pihole was running.
#####

EOF

./docker_run.sh

echo -e "\n\nStarting docker image cleanup, may ignore errors..."
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
docker rmi $(docker images | grep "none" | awk '/ / { print $3 }')
echo "Docker image cleanup complete"


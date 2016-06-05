# To actually delete files, use ./<scriptname> --delete-files

ARTIFACTORY_LINK="--link artifactory:artifactory"
ARTIFACTORY_LINK="" # delete this line to connect the container with local artifactory running in Docker
docker run $ARTIFACTORY_LINK -it cleanify_with_config $1

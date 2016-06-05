# To run cleanify using the no-config image. Automagically mounts the config file from the root of the project.
# To actually delete files, use: ./<scriptname>.sh --delete-files.

# copying in the config file for running then removing it is preferrable to keeping a duplicate in the docker folder
mkdir config
cp ../config/* config/

ARTIFACTORY_LINK="--link artifactory:artifactory"
ARTIFACTORY_LINK="" # delete this line to connect the container with local artifactory running in Docker
docker run $ARTIFACTORY_LINK -v `pwd`/config:/root/config -it cleanify ruby cleanify.rb $1

rm -rf config

# To run cleanify using the no-config image. Automagically mounts the config file from the root of the project.
# To actually delete files, use: ./<scriptname>.sh --delete-files.

# Copy in the config/keepers files. Better than keeping permanent duplicates in the docker folder.
cp -r ../config .
cp -r ../keepers .

ARTIFACTORY_LINK="--link artifactory:artifactory"
ARTIFACTORY_LINK="" # delete this line to connect the container with local artifactory running in Docker
docker run $ARTIFACTORY_LINK -v `pwd`/config:/root/config -v `pwd`/keepers:/root/keepers -it nauraushaun/cleanify ruby cleanify.rb $1

rm -rf config keepers

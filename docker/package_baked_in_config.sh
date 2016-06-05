# To build a complete docker image with the config baked in. Allows you to run anywhere, without a config file present on the host.
# To run the resulting image, use run script

BUILD_VERSION=${1-"latest"}
CLEANIFY_BAKED_CONFIG_IMAGE_NAME=cleanify_with_config:$BUILD_VERSION
DOCKERFILE=Dockerfile_baked_in_config
WD=$(pwd)

echo "Building cleanify child image, with config baked in"
# Can run with the docker-compose file, but lets build it into another image with the shine config baked in, that we can just run as-is
cp $DOCKERFILE ../
cd ../
docker build --file $DOCKERFILE -t $CLEANIFY_BAKED_CONFIG_IMAGE_NAME .
rm -rf $DOCKERFILE
cd $WD

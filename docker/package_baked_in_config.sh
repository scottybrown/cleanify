# To build a complete docker image with the config and keepers file baked in. Allows you to run anywhere, without requiring files to be present on the host.
# To run the resulting image, use run script

BUILD_VERSION=${1-"latest"}
CLEANIFY_BAKED_CONFIG_IMAGE_NAME=cleanify_with_config:$BUILD_VERSION
DOCKERFILE=Dockerfile_baked_in_config
WD=$(pwd)

echo "Building cleanify child image, with config baked in"
cp $DOCKERFILE ../
cd ../
docker build --file $DOCKERFILE -t $CLEANIFY_BAKED_CONFIG_IMAGE_NAME .
rm -rf $DOCKERFILE
cd $WD

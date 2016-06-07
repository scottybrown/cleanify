# To build a complete docker image with the config and keepers file baked in. Allows you to run anywhere, without requiring files to be present on the host.
# To run the resulting image, use run script

BUILD_VERSION=${1-"latest"}
CLEANIFY_BAKED_CONFIG_IMAGE_NAME=cleanify_with_config:$BUILD_VERSION
DOCKERFILE=Dockerfile_baked_in_config
WD=$(pwd)

echo "Building cleanify child image, with config baked in"
cd ../
# temporarily remove dockerignore file so we can include keepers and config
DOCKERIGNORE_CONTENTS=$(cat .dockerignore)
echo $DOCKERIGNORE_CONTENTS
rm -rf .dockerignore
docker build --file $DOCKERFILE -t $CLEANIFY_BAKED_CONFIG_IMAGE_NAME .
echo $DOCKERIGNORE_CONTENTS > .dockerignore

cd $WD

# To build a base docker image with no config in it. Allows you to mount the config file.
# To run the resulting image, use run_external_config.sh

BUILD_VERSION=${1-"latest"}
CLEANIFY_IMAGE_NAME=nauraushaun/cleanify:$BUILD_VERSION
DOCKERFILE=Dockerfile_external_config
WD=$(pwd)

echo "Building cleanify base image, no config"
cp $DOCKERFILE .dockerignore ../
cd ../
docker build -t $CLEANIFY_IMAGE_NAME --file $DOCKERFILE .
rm -rf $DOCKERFILE .dockerignore
cd $WD
echo ""

docker push $CLEANIFY_IMAGE_NAME

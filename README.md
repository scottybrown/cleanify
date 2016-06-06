# Cleanify

Lists and deletes Artifactory artifacts that haven't been downloaded for a while and aren’t in the exclusions file.

Based on (http://aleung.github.io/blog/2013/03/22/clean-aged-artifacts-from-artifactory/). Expanded with the keepers file, lots of refactoring, some output to make it more user friendly, read-only mode, and more!

## Docker Usage:
* In the docker folder there are some scripts to build docker images/containers of the code. See the README.md in there.

## Usage:
* Simply run as ./cleanify.rb - this will list artifacts uploaded or downloaded older than the age specified which aren’t in keepers.txt
* Add the —-delete-files parameter when running to perform actual file deletion of the listed files. Use caution when doing this. When a file is deleted its direct parent directory is also deleted along with any artifacts inside it. Isolating directories to avoid leaving empty folders laying around is tricky business, this is an attempt at partially solving this problem. 
* You may need to perform some maintance tasks such as empty trash in Artifactory if you want to see your cleaning results right away

## Configuration:
* The default configuration is set up to work with the artifactory docker image mentioned below. This should make it easy to get started. You'll need to delete a line in the run scripts to enable linking the cleanify container to the artifactory container.
* The file config_cleanify.rb holds a number of configurable options such as artifactory URL and port, which repo to list/delete from, age of artifacts to delete, name of keepers file and more
* The keepers file (keepers.txt by default) contains the name of artifacts that will not be deleted. Any file path that contains the value of a line in the keepers file will be kept. This file also trims spaces and allows a comment after each line beginning with #.

For example, if you have the following line in your keepers file:
nbv_951_36-demo # required for a client demo environment
The following artifacts will not be deleted:
artifactory/api/storage/libs-release-local/nbv_951_36-demo/config/configfile.txt
artifactory/api/storage/libs-release-local/nbv_951_36-demo/app.jar
artifactory/api/storage/libs-release-local/nbv_stuff/nbv_951_36-demo_info.txt
Anything not containing the phrase will be deleted.

## Testing
There's a great docker Artifactory image, simply:
docker run --name artifactory -p 8080:8080 -tid mattgruter/artifactory

## TODO:
* Add better recognition of folders in artifactory, such that deleting artifacts leaves no trace whatsoever
* Rake test runner. Measure coverage. Automatically run tests.
* Could add some more tests if I were so inclined.

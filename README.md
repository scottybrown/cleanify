# Cleanify

Lists and deletes Artifactory artifacts that haven't been downloaded for a while and aren’t in the exclusions file.

Based on (http://aleung.github.io/blog/2013/03/22/clean-aged-artifacts-from-artifactory/). Expanded with the keepers file, lots of refactoring, some output to make it more user friendly, read-only mode, and more!

## Docker Usage:
* docker run -v \`pwd\`/config:/root/config -it nauraushaun/cleanify ruby cleanify.rb
* Where the config folder contains a script called config_cleanify.rb. The basis for this script should be taken from the Github project (https://github.com/scottybrown/cleanify/blob/master/config/config_cleainfy.rb)
* The Github project also contains some scripts that build and run a container with config pre-baked in. These may be of interest to you. See README.md in the docker folder.

* Running will default to dry-run mode with no deletion. Add "--delete-files" when running to actually delete things, use caution here!
* You may need to perform some maintenance tasks such as empty trash in Artifactory if you want to see your cleaning results right away
* When a file is deleted its direct parent directory is also deleted along with any artifacts inside it. Isolating directories to avoid leaving empty folders laying around is tricky business, this is an attempt at partially solving this problem. 

## Non-Docker Usage:
* Run as ./cleanify.rb - this will list artifacts uploaded or downloaded older than the age specified which aren’t in keepers.txt

## Configuration:
* The default configuration is set up to work with the artifactory docker image mentioned below. This should make it easy to get started. You'll need to link your Cleanify container to your Artifactory container though, the run scripts in the Docker folder show how this is done.
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

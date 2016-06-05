#!/usr/bin/ruby

# This file contains some global variables used throughout the application. Some are public facing, some are less so.
# The values you might like to configure are listed at the top.

$age_days = 00 # Remove artifacts which were created before $age_days ago and haven't been downloaded in recent $age_days

$repo = 'libs-release-local' # The repository to be listed/deleted from
$host_url = 'artifactory'
$host_port = 8080
$artifactory_root_path = '/artifactory'
$artifactory_file_location = '/artifactory/data/filestore/'

# login details for artifactory
$user = 'admin'
$password = 'password'

$delete_files_parameter_name = "--delete-files"
$delete_files = ARGV[0] == $delete_files_parameter_name
$keepers_file_name = "keepers.txt"

# obtained from patorjk.com/software/taag/#p=display&h=0&v=0&f=Shadow&t=CLEANIFY
# replaced all back-slashes with double back-slashes so they aren't escaped
$cleanify_banner = "

  ___|   |       ____|      \\       \\  |  _ _|   ____|  \\ \\   / 
 |       |       __|       _ \\       \\ |    |    |       \\   /  
 |       |       |        ___ \\    |\\  |    |    __|        |   
\\____|  _____|  _____|  _/    _\\  _| \\_|  ___|  _|         _|   

=================================================================
=================================================================

"
$cleanify_separator = "\n=================================================================\n\n"

$float_rounding_for_output = 3

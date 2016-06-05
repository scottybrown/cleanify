#!/usr/bin/ruby

require_relative 'config/config_cleanify'
require_relative 'access_artifactory_cleanify'
require_relative 'utils_cleanify'
require_relative 'stubs_cleanify'
require_relative 'file_utils_cleanify'
require 'rubygems'
require 'net/http'
require 'json'

def retrieve_unused_artifacts()
  unused_artifacts_by_age = retrieve_unused_artifacts_by_age()

  unused_artifacts = filter_out_artifacts_to_keep(unused_artifacts_by_age, get_artifacts_to_keep())

  save_file(unused_artifacts)

  return unused_artifacts
end


def delete_unused_artifacts(unused_artifacts)
  "Deleting artifacts...\n\n"
  failed_counter = 0

  # if deleting files, need to count size in MB before any deletion occurs.
  # We delete parent folders, so once we've started we expect some artifacts to not be found. So, get the size before hand.
  total_size_in_mb = count_total_artifact_size_in_mb(unused_artifacts)

  unused_artifacts.each{ |artifact|
    artifact_name = get_artifact_name(artifact)

    if !delete_artifact(artifact_name)
      failed_counter = failed_counter + 1
    end
  }

  puts "\n"
  puts "Finished deleting artifacts. #{unused_artifacts.length} deleted, #{failed_counter} errored. Total size #{total_size_in_mb.round($float_rounding_for_output)}mb"
end

def list_unused_artifacts(unused_artifacts)
  "Listing artifacts...\n\n"
  failed_counter = 0
  total_size_in_mb = 0

  unused_artifacts.each{ |artifact|
    artifact_name = get_artifact_name(artifact)
    # if listing files, can count size as we go. And we want to do it here so we can get the checksum too for printing.
    artifact_details = get_artifact_details(artifact_name)
    checksum = artifact_details["checksums"]["sha1"]
    size_in_mb = artifact_details["size"].to_f / 1000 / 1000    
    total_size_in_mb = total_size_in_mb + size_in_mb

    puts artifact_name + ", #{$artifactory_file_location}#{checksum[0..1]}/#{checksum}, #{size_in_mb.round($float_rounding_for_output)}mb"
  }

  puts "\n"
  puts "Finished listing #{unused_artifacts.length} artifacts, total size #{total_size_in_mb.round($float_rounding_for_output)}mb. No deletion performed."
end

def delete_or_list_unused_artifacts(unused_artifacts)
  failed_counter = 0
  total_size_in_mb = 0

  if $delete_files
    delete_unused_artifacts(unused_artifacts)
  else
    list_unused_artifacts(unused_artifacts)
  end
end

def get_artifacts_to_keep
  artifacts_to_keep_from_file = get_artifacts_to_keep_from_file()
  stripped_artifacts_to_keep_from_file = strip_artifact_names(artifacts_to_keep_from_file)
end

def entry_point
  puts $cleanify_banner
  if !$delete_files
    puts "Running in read-only mode as argument #{$delete_files_parameter_name} was not given. \nFiles to be deleted will be displayed only, no files will be deleted."
  else
    puts "Running in deletion mode. Files will be deleted. Exercise caution."
  end

  puts $cleanify_separator
  unused_artifacts = retrieve_unused_artifacts()
  puts "Found #{unused_artifacts.length} artifacts older than #{$age_days} days and not in the keepers file (#{$keepers_file_name}). \nFiles will be #{($delete_files ? "deleted" : "listed only")}. Proceed?"
  if get_yes == true
    delete_or_list_unused_artifacts(unused_artifacts)
  else
    puts "Quitting. No action performed."
  end
end

entry_point

#!/usr/bin/ruby

require 'uri'

def delete_artifact(artifact_uri)
  #  %r|.*/#{$repo}/(.*)| =~ artifact_uri # delete artifacts only
  %r|.*/#{$repo}/(.*)/.*| =~ artifact_uri # delete artifacts and their parent directories
  url = URI.escape("#{$artifactory_root_path}/#{$repo}/#{$1}")

  http = Net::HTTP.new($host_url, $host_port)
  request = Net::HTTP::Delete.new(url)
  request.basic_auth($user, $password)
  response = http.request(request)

  succeeded = true
  if response.code == "404"
    # do nothing. Since we're deleting each artifact's folder, it's fairly common to try to delete an artifact only to find it's already been deleted.
    # Note that if the artifactory cannot be found an error will be thrown while retrieving artifacts, so this isn't masking that case.
    puts "Not found: #{artifact_uri}. Assuming already deleted, moving on"
  elsif response.code != "204"
    puts "Errored: #{artifact_uri}. Non-204 response received: #{get_pretty_error_from_http_response(response)}"
    succeeded = false
  else
    puts "Deleted: #{artifact_uri}"
  end

  succeeded
end

def get_artifact_details(artifact_uri)
  artifact_uri_spaces_handled = URI.escape(artifact_uri)
  http = Net::HTTP.new($host_url, $host_port)
  request = Net::HTTP::Get.new(artifact_uri_spaces_handled)
  request.basic_auth($user, $password)
  response = http.request(request)
  JSON.parse(response.body)
end

def retrieve_unused_artifacts_by_age()
  since = (Time.now - $age_days * 3600*24).to_i * 1000
  url = "#{$artifactory_root_path}/api/search/usage?notUsedSince=#{since}&createdBefore=#{since}&repos=#{$repo}"

  http = Net::HTTP.new($host_url, $host_port)
  http.read_timeout = 500
  request = Net::HTTP::Get.new(url)
  request.basic_auth($user, $password)
  response = http.request(request)

  if response.code == "404"
    puts "404 response received from Artifactory while retrieving artifacts: #{get_pretty_error_from_http_response(response)}"
    puts "Either artifact url or repo not found, or no artifacts found older than #{$age_days} days."
    exit!
  elsif response.code != "200"
    puts "Non-200 response received from Artifactory while retrieving artifacts: #{get_pretty_error_from_http_response(response)}"
    exit!
  end

  unused_artifacts_by_age = JSON.parse(response.body)["results"] # we want to spit out an array, so the rest of the code doesn’t have to handle a json body
  return unused_artifacts_by_age
end

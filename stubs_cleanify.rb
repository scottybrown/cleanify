#!/usr/bin/ruby
# Just some stubs I used before I had wiremock etc set up

def retrieve_unused_artifacts_by_age_test
  return [JSON.parse('{"uri": "keeper2"}'), JSON.parse('{"uri": "a1"}'), JSON.parse('{"uri": "keeper3"}'), JSON.parse('{"uri": "a2"}'), JSON.parse('{"uri": "a3"}'), JSON.parse('{"uri": "keeper1"}')]
end

def delete_artifact_test(artifact_uri)
  puts "Deleted: " + artifact_uri
end


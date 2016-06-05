#!/usr/bin/ruby

def strip_artifact_names(artifact_names)
  if artifact_names == nil
    return nil
  end

  return artifact_names.each { |artifact_name|
    if artifact_name != nil
      if artifact_name.include?("#")
        artifact_name.slice!(artifact_name.index("#")..artifact_name.length() - 1) # strip comment
      end
      artifact_name.strip! # trim spaces
      artifact_name.slice!("\n") # strip line ending
      artifact_name.slice!("\r") # strip other line ending
    end
  }
end

# The value stored in the keepers file
# Down the road we might change this from sha checksum to something else, like actual file name/path
def get_artifact_name(artifact)
  if artifact == nil || artifact.length == 0
    return nil
  end

  return artifact[get_artifact_name_key()]
end

def get_artifact_name_key
  return "uri"
end

def filter_out_artifacts_to_keep(artifacts, artifacts_to_keep)
  if artifacts == nil || artifacts_to_keep == nil
    return nil
  end

  unused_artifacts = artifacts.select { |artifact|
    artifact_contains_keeper = false
    artifacts_to_keep.each { |artifact_to_keep|
      if artifact_to_keep.length == 0
        next
      end

      artifact_contains_keeper = get_artifact_name(artifact).include?(artifact_to_keep)
      if artifact_contains_keeper
        break
      end
    }

    !artifact_contains_keeper
  }
  unused_artifacts
end

def get_yes
  answer = $stdin.gets.chomp # we're only reading from stdin - this allows us to pass arguments without interrupting the getsening
  return answer == "y" || answer == "Y"
end

def get_pretty_error_from_http_response(response)
  response_json = JSON.parse(response.body)["errors"][0]
  return "#{response_json["status"]} - #{response_json["message"]}"
end

def count_total_artifact_size_in_mb(unused_artifacts)
  total_size_in_mb = 0

  unused_artifacts.each{ |artifact|
    artifact_name = get_artifact_name(artifact)

    artifact_details = get_artifact_details(artifact_name)
    size_in_mb = artifact_details["size"].to_f / 1000 / 1000
    total_size_in_mb = total_size_in_mb + size_in_mb
  }
  return total_size_in_mb
end

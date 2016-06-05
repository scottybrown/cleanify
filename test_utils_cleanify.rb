#!/usr/bin/ruby

require 'test/unit'
require 'json'
require_relative 'utils_cleanify.rb'

class TestUTilsCleanify < Test::Unit::TestCase
  def test_strip_artifact_names
    assert_equal(nil, strip_artifact_names(nil))
    assert_equal([], strip_artifact_names([]))
    assert_equal(["name"], strip_artifact_names([" name # with a comment lol"]))
    assert_equal(["name", "name2", "name3", "name4"], strip_artifact_names([" name # with a comment lol", "name2", "    name3", "name4   "]))
    assert_equal(["thisisaname"], strip_artifact_names([" thisisaname "]))
    assert_equal([""], strip_artifact_names([" # just a comment lol"]))
    assert_equal([""], strip_artifact_names([" "]))
    assert_equal([""], strip_artifact_names([""]))
    assert_equal([nil], strip_artifact_names([nil]))
    assert_equal(["name"], strip_artifact_names(["name"]))
    assert_equal([""], strip_artifact_names(["#"]))
    assert_equal(["name"], strip_artifact_names([" name # sf # sef # ef # wef"]))
  end

  def test_get_artifact_name
    # This function is expected to change in the future, so we won't test its functionality
    # Just test that it can handle nils, empties, etc
    assert_equal(nil, get_artifact_name(nil))
    assert_equal(nil, get_artifact_name(""))
    assert_equal(nil, get_artifact_name({}.to_json))
    assert_equal(nil, get_artifact_name({fieldtest: 'dave'}.to_json))
  end

  def test_filter_out_artifacts_to_keep
    assert_equal(JSON.parse('[]'), filter_out_artifacts_to_keep(JSON.parse('[]'), []))
    assert_equal(nil, filter_out_artifacts_to_keep(nil, nil))

    test_artifacts = '[{"uri": "name1"}, {"uri": "name2"}, {"uri": "name3"}]'
    keepers = ["name2"]
    expected = '[{"uri": "name1"}, {"uri": "name3"}]'
    assert_equal(JSON.parse(expected), filter_out_artifacts_to_keep(JSON.parse(test_artifacts), keepers))

    keepers = ["name2", "name1"]
    expected = '[{"uri": "name3"}]'
    assert_equal(JSON.parse(expected), filter_out_artifacts_to_keep(JSON.parse(test_artifacts), keepers))

    keepers = ["name3", "name2", "name1"]
    expected = '[]'
    assert_equal(JSON.parse(expected), filter_out_artifacts_to_keep(JSON.parse(test_artifacts), keepers))

    # Should remove partial matches too
    keepers = ["2", "e1"]
    expected = '[{"uri": "name3"}]'
    assert_equal(JSON.parse(expected), filter_out_artifacts_to_keep(JSON.parse(test_artifacts), keepers))

    keepers = ["name"]
    expected = '[]'
    assert_equal(JSON.parse(expected), filter_out_artifacts_to_keep(JSON.parse(test_artifacts), keepers))

    keepers = ["name1",""]
    expected = '[{"uri": "name2"}, {"uri": "name3"}]'
    assert_equal(JSON.parse(expected), filter_out_artifacts_to_keep(JSON.parse(test_artifacts), keepers))
  end

  def test_get_pretty_error_from_http_response
    # response is actually an instance of Net::HttpNotFound, but I couldn't instantiate one of those. I think because I don't know the params for the constructor
    # But all my method requires is that the object given has .body on it.
    # So I make a mock response as a random Hash, then define the fmethod "body()" on it, returning what I want it to return.
    # This does not use any mocking functionality of the test framework. I'm not sure minitest has any. RSpec does, but this totes works.
    # A cleaner option might be to make the function take body, then just pass in the body instead of the whole response
    # Previous to this I wrote a small class in this class that has a body() method, with a constructor that sets it to whatever is given.
    mock_response = {}
    def mock_response.body; '{"errors":[{"status":404,"message":"No results found."}]}'; end
    assert_equal("404 - No results found.", get_pretty_error_from_http_response(mock_response))

    def mock_response.body; '{"errors":[{"status":"herpa derpa","message":"wizza wozzle"}]}'; end
    assert_equal("herpa derpa - wizza wozzle", get_pretty_error_from_http_response(mock_response))

    def mock_response.body; '{"errors":[{"status":404,"message":"No results found."}, {"status":"herpa derpa","message":"wizza wozzle"}]}'; end
    assert_equal("404 - No results found.", get_pretty_error_from_http_response(mock_response))
  end

  def test_count_total_artifact_size_in_mb
    # To make testing easy, when artifact details (including size) is requested from artifactory, I just return the value given - the artifact_name. Which in this case is the URI.
    def get_artifact_details(artifact_name); {"size" => artifact_name}; end

    # I'm giving these sizes in bytes of 1mb and 2mb respectively
    artifacts = JSON.parse('[{"uri": 1000000}, {"uri": 2000000}]')
    assert_equal(3, count_total_artifact_size_in_mb(artifacts))

    artifacts = JSON.parse('[{"uri": 50000000}]')
    assert_equal(50, count_total_artifact_size_in_mb(artifacts))

    artifacts = JSON.parse('[{"uri": 2500000}, {"uri": 2200000}]')
    assert_equal(4.7, count_total_artifact_size_in_mb(artifacts))

    artifacts = JSON.parse('[]')
    assert_equal(0, count_total_artifact_size_in_mb(artifacts))

  end
end

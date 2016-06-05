#!/usr/bin/ruby

require_relative 'config/config_cleanify'

def get_artifacts_to_keep_from_file
  return IO.readlines($keepers_file_name)
end

def save_file(result)
  # not in use
  #File.open('unused_artifacts.txt', 'w') { |f| f.puts(result) }
end

def load_file()
  # not in use
  #File.open('unused_artifacts.txt') { |f| f.gets }
end


require 'fulmar/plugin/core4/version'
require 'fulmar/plugin/core4/dsl_helper'
require 'fulmar/plugin/core4/host_file'

module Fulmar
  module Plugin
    module CORE4
      # Plugin configuration
      class Configuration
        def initialize(config)
          @config = config
        end

        def test_files
          Dir.glob("#{File.dirname(__FILE__)}/config_tests/*.rb")
        end

        def rake_files
          Dir.glob(File.dirname(__FILE__) + '/rake/*.rake')
        end
      end
    end
  end
end

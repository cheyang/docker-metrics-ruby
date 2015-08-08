require "docker/metrics/version"
require "docker"
require "docker/metrics/lxc/container"
require "monkey_patch/deep_merge"
require "monkey_patch/shell"

$METRIC_SHELL_DIR=File.expand_path("../../../scripts", __FILE__)

module Docker
  module Metrics
    
    def self.containers
      
    end
    
    def self.container(name)
      if is_lxc_driver?
        container = Docker::Metrics::LXC::Container.new(name)
      end
      
      container
    end
    
    def self.get_container_names(options={:all=>false})
      
      names =[]
      Docker::Container.all(options.select!{|k,v| k==:all}).each{|container|
        names << container.info["Names"][0].gsub(/^\//,'')
        
      }
      
      names
    end
    
    def self.is_lxc_driver?
      return Docker.info["ExecutionDriver"].start_with?("lxc")
    end
    
  end
end

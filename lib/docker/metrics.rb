require "docker/metrics/version"
require "docker"
require "lxc"

module Docker
  module Metrics
    
    def self.containers
      
    end
    
    def self.container
      
    end
    
    def self.get_container_names
      
      names =[]
      Docker::Container.all.each{|container|
        names << container.info["Names"][0].gsub(/^\//,'')
        
      }
      
      names
    end
    
    def self.is_lxc_driver?
      return Docker.info["ExecutionDriver"].start_with?("lxc")
    end
    
  end
end



module Docker
  module Metrics
    class Container
      
      
      # Initialize a new Docker::Metrics::Container instance
      # @param [String] name container name
      # @return [Docker::Metrics::Container] container instance
      def initialize(name)
          @name = name
          container = Docker::Container.get(@name)
          @id = container.id
          @real_pid = container.json['State']['Pid']
      end
      
      #irb(main):003:0> LXC.container('ab83a2638bb23f24d8811fa9b4ca458efca9269696ff3112cc670be2833f3f92').memory_usage

      def is_LXC?
        
      end
      
      def gather_data(require_details=false)
        
        data = {}                
        
        data = gather_docker_info(require_details)
        
        data = hash_deep_merge(data,gather_docker_metrics(@real_pid, require_details))
               
        data["Timestamp"] = Time.now.to_s       
               
        return data     
      end
      
      #Gather docker info from docker remote api
      def gather_docker_info(require_details)
        
        container_info = {}
        container = Docker::Container.get(@name)
        raw_data = container.json
        
        container_info['Name']= raw_data['Name'].gsub!(/^\//,'')
        container_info['Id']= raw_data['Id']
        container_info['Image']=raw_data['Image']
        container_info['ImageName']=raw_data['Config']['Image']
        container_info['State']=raw_data['State']
        container_info['Config']={}
        container_info['Config']['Hostname']=raw_data['Config']['Hostname']
        container_info['Config']['Env']=raw_data['Config']['Env']
        
        return container_info
      end
      
      def gather_docker_metrics(require_details)
        return nil
      end
      
    end    
  end
end
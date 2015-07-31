require 'lxc'

module Docker
  module Metrics
    module LXC
      class Container < Docker::Metrics::Container
        
        # Initialize a new Docker::Metrics::Container instance
        # @param [String] name container name
        # @return [Docker::Metrics::Container] container instance
        def initialize(name)
          super(name)
        end
        
        #irb(main):003:0> LXC.container('ab83a2638bb23f24d8811fa9b4ca458efca9269696ff3112cc670be2833f3f92').memory_usage
=begin
  "cpu_stats": {
            "cpu_usage": {
                "total_usage": 808260479136,
                "percpu_usage": [
                    403102504028,
                    405157975108
                ],
                "usage_in_kernelmode": 210970000000,
                "usage_in_usermode": 115730000000
            },
            "system_cpu_usage": 572271810000000,
            "throttling_data": {
                "periods": 0,
                "throttled_periods": 0,
                "throttled_time": 0
            }
        }
=end
       def container_cpu_metrics(container,require_details)     
         
         cpu_usage_stats = container.user_and_kernel_cpu_usage()
          
          cpu_usage_stats["percpu_usage"] = container.percpu_usage
          
          cpu_usage_stats["total_usage"] = container.cpu_total_usage
          
          cpu_stats = {"cpu_usage" => cpu_usage_stats }
          
          return cpu_stats
       end
     
       def container_memory_metrics(container,require_details)     
       end


       def gather_docker_metrics(require_details)
          metrics ={"Metrics"=>{}}
          lxc_container = LXC.container(@id)
          
          metrics["Metrics"] = container_cpu_metrics(lxc_container,require_details)
          
       end
        
        
      end
    end
  end
end
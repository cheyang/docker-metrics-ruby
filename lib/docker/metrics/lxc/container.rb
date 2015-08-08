require 'lxc'
require 'docker/metrics/container'
require "monkey_patch/lxc/container"

module Docker
  module Metrics
    module LXC
      
    end
  end
end

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
=begin
  "memory_stats": {
            "usage": 689934336,
            "max_usage": 706244608,
            "stats": {
                "active_anon": 300949504,
                "active_file": 66375680,
                "cache": 608997376,
                "hierarchical_memory_limit": 9223372036854772000,
                "hierarchical_memsw_limit": 9223372036854772000,
                "inactive_anon": 301277184,
                "inactive_file": 21319680,
                "mapped_file": 579031040,
                "pgfault": 30187901,
                "pgmajfault": 3381,
                "pgpgin": 13271205,
                "pgpgout": 13102764,
                "recent_rotated_anon": 58071,
                "recent_rotated_file": 2468,
                "recent_scanned_anon": 60956,
                "recent_scanned_file": 3926,
                "rss": 80936960,
                "rss_huge": 0,
                "swap": 39407616,
                "total_active_anon": 300949504,
                "total_active_file": 66375680,
                "total_cache": 608997376,
                "total_inactive_anon": 301277184,
                "total_inactive_file": 21319680,
                "total_mapped_file": 579031040,
                "total_pgfault": 30187901,
                "total_pgmajfault": 3381,
                "total_pgpgin": 13271205,
                "total_pgpgout": 13102764,
                "total_rss": 80936960,
                "total_rss_huge": 0,
                "total_swap": 39407616,
                "total_unevictable": 0,
                "total_writeback": 0,
                "unevictable": 0,
                "writeback": 0
            },
            "failcnt": 0,
            "limit": 3977789440
        },
=end     
        def container_memory_metrics(container,require_details)   
          memory_usage_stats = {}
          
          memory_usage_stats["usage"] = container.memory_usage
          
          memory_usage_stats["max_usage"]= container.max_memory_usage
          
          memory_usage_stats["limit"]= container.memory_limit
          
          memory_usage_stats["memory_failcnt"] = container.memory_failcnt
          
          if require_details
            memory_usage_stats["stats"] = container.memory_stats
          else
            memory_stats = container.memory_stats
            
            memory_usage_stats["stats"] = {}
            
            memory_usage_stats["stats"]["rss"] = memory_stats["rss"].to_i
            
            memory_usage_stats["stats"]["cache"] = memory_stats["cache"].to_i
          end
          
          
          return {"memory_usage"=> memory_usage_stats}
        end
        
        def container_network_metrics(container,require_details)   
           return {"network_usage"=> container.network_stats}
        end
        
        
        def gather_docker_metrics(real_pid, require_details)
          metrics_summary ={"Metrics"=>nil}
          lxc_container = ::LXC.container(@id)
          
          lxc_container.set_pid(real_pid)
          
          metrics = container_cpu_metrics(lxc_container,require_details)
          
          metrics = hash_deep_merge(metrics, container_memory_metrics(lxc_container,require_details))
          
          metrics_summary["Metrics"] = metrics
          
          metrics_summary
        end
        
      
        
      end
    end
  end
end
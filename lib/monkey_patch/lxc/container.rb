module LXC
  class Container
    
    NANOSECONDS_IN_SECOND = 1000000000
    
    
    
    def user_and_kernel_cpu_usage
      
      cpu_hash ={"usage_in_kernelmode" => nil, "usage_in_usermode" => nil}
      
      result = run("cgroup", "cpuacct.stat").to_s.strip
      unless result.empty? 
        cpu_usage_array = result.split("\n")
      end
      #["user 10675589\nsystem 1122811"]
      cpu_usage_array.each{|cpu_usage_str|
        
        if cpu_usage_str.start_with?("user")
          cpu_hash["usage_in_usermode"] = (cpu_usage_str.split(" ")[1].to_i * NANOSECONDS_IN_SECOND) / get_clock_ticket()
        elsif cpu_usage_str.start_with?("system")
          cpu_hash["usage_in_kernelmode"]  = (cpu_usage_str.split(" ")[1].to_i * NANOSECONDS_IN_SECOND) / get_clock_ticket()
        else
          raise "unsupported cpuacct.stat for lxc container #{@name}"
        end
        
      }
      
      
      cpu_hash
      
      #? nil : Float("%.4f" % (result.to_i / 1E9))
    end
    
    def network_stats
      network_hash = {}
      
      stats_dir =  network_stats_dir
      
      network_keys =['rx_bytes','rx_errors','tx_bytes','tx_errors']
      
      network_keys.each{|network_key|
        network_hash[network_key] = `cat #{stats_dir}/#{network_key}`.to_s.strip.to_i
      
      }
      
      network_hash
    end
    
    def get_clock_ticket
      
      if @clock_ticket.nil?
        @clock_ticket = `getconf CLK_TCK`.to_s.strip.to_i
      end
      
      @clock_ticket
    end
    
    def cpu_total_usage
      result = run("cgroup", "cpuacct.usage").to_s.strip
      result.empty? ? nil : result.to_i
    end
    
    def percpu_usage
      per_cpus =[]
      result = run("cgroup", "cpuacct.usage_percpu").to_s.strip
      
      result.split(" ").each{|percpu|
        
        per_cpus << percpu.to_i
      }
      
      return per_cpus
    end
    
    
    def max_memory_usage
      result = run("cgroup", "memory.max_usage_in_bytes").to_s.strip
      #memory.stat
      
      result.to_i
    end
    
    
    def memory_stats
      result = run("cgroup", "memory.stat").to_s.strip
      
      parse_to_hash(result)
    end
    
    def memory_limit
      result = run("cgroup", "limit_in_bytes").to_s.strip
      
      result.to_i
    end
    
    def memory_failcnt
      result = run("cgroup", "memory.failcnt").to_s.strip
      
      result.to_i
    end
    
    #pgrep -P $(ps -Af | grep lxc-start | grep $CONTAINER_ID | awk '{ print $2; }')
    def get_external_container_process_id
      `ps -Af | grep lxc-start | grep ${@name} | awk '{ print $2; }`.to_s.strip.to_i
    end
    
    def get_external_cmd_process_id
      `pgrep -P $(ps -Af | grep lxc-start | grep ${@name} | awk '{ print $2; }')`.to_s.strip.to_i
    end
    
    def set_pid pid
      @pid = pid
    end
    
    #mapping docker container and its virtual Ethernet interface in host
    def get_virtual_network_interface
      if @network_interface.nil?
        if @pid.nil?
          @pid = get_external_cmd_process_id
        end
       
       cmd = "sh -c #{Shell.findveth_cmd @pid}"
       
       puts "cmd=#{cmd}"
       
       @network_interface =`#{cmd}`.to_s
     end
     
     puts "network interface is #{@network_interface}"
     
     @network_interface
    end
    
    def network_stats_dir
      
      "/sys/class/net/#{get_virtual_network_interface()}/statistics"
    end
    
    
    private
    
    def parse_to_hash(input)
      
      
      hash = {}
      
      unless input.empty? 
        result = input.split("\n")
      end
      
      result.each{|line|
        kv = line.split(" ")
        key=kv[0]
        
        value = kv[-1]
        
        hash[key]=value
      }
      
      return hash
    end
  end
end
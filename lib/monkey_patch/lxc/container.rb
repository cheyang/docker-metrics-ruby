module LXC
  class Container
     
    def user_and_kernel_cpu_usage
      
      cpu_hash ={"usage_in_kernelmode" => nil, "usage_in_usermode" => nil}
      
      result = run("cgroup", "cpuacct.stat").to_s.strip
      unless result.empty? 
        cpu_usage_array = result.split("\n")
      end
      #["user 10675589\nsystem 1122811"]
      cpu_usage_array.each{|cpu_usage_str|
      
        if cpu_usage_str.start_with?("user")
          cpu_hash["usage_in_usermode"] = cpu_usage_str.split(" ")[1].to_i
        elsif cpu_usage_str.start_with?("system")
           cpu_hash["usage_in_kernelmode"]  = cpu_usage_str.split(" ")[1].to_i
        else
          raise "unsupported cpuacct.stat for lxc container #{@name}"
        end
      
      }
      
      
      cpu_hash
      
      #? nil : Float("%.4f" % (result.to_i / 1E9))
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
      result = run("cgroup", "memory.stats").to_s.strip
      
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
    
    
    private
    
    def parse_to_hash(input)
      
      hash = {}
      
      unless input.empty? 
        result = input.split("\n")
      end
      
      result.each{|line|
        kv = line.split(" ")
        key=line[0]
        
        value = line[-1]
        
        hash[key]=value
      }
      
      return hash
    end
  end
end
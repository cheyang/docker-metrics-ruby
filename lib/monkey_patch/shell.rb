  module Shell
    def self.findveth_cmd(pid)
      cmd = <<-FINDVETH
      #!/bin/sh
      #thanks to https://github.com/aidanhs
      set -o pipefail
      set -o errexit
  
      TMP=$(mktemp)
  
      peer_ifidx_line="$(nsenter --target #{pid} --net ethtool -S eth0 | grep peer_ifindex)"
      peer_ifidx="$(echo "$peer_ifidx_line" | sed 's/.* \([0-9]*\)$/\1/')"
  
      nsenter --target 1 --net ip link | grep "^$peer_ifidx: " > $TMP
      if [ "$(cat $TMP | wc -l)" -ne 1 ]; then
          echo "Found incorrect number of interfaces"
          exit 1
      fi
  
      echo $(cat $TMP | awk '{print $2}' | sed 's/\([^:]*\).*/\1/')      
      FINDVETH
    end
    
  end
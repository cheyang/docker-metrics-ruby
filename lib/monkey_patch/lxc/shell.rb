module LXC
  module Shell
    extend self

   

    # Execute a LXC command
    # @param [String] name command name
    # @param [Array] args command arguments
    # @return [String] execution result
    #
    # If you would like to use pipe command you"ll need to 
    # provide a block that returns string
    def run(command, *args)
      command_name = "lxc-#{command}"

      unless BIN_FILES.include?(command_name)
        raise ArgumentError, "Invalid command: #{command_name}."
      end

      cmd = ""
      cmd << "sudo " if use_sudo == true
      cmd << "#{command_name} #{args.join(" ")}".strip
      cmd << " | #{yield}" if block_given?

      # Debug if LXC_DEBUG env is set
      if ENV["LXC_DEBUG"]
        puts "Executing: #{cmd}"
      end

      out = `#{cmd.strip}`
    end
  end
end
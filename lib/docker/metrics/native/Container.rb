

module Docker
  module Metrics
    module Native
      class Container
        extends Docker::Metrics::Container
        
        # Initialize a new Docker::Metrics::Container instance
        # @param [String] name container name
        # @return [Docker::Metrics::Container] container instance
        def initialize(name)
          @name = name
        end
        
        #irb(main):003:0> LXC.container('ab83a2638bb23f24d8811fa9b4ca458efca9269696ff3112cc670be2833f3f92').memory_usage
        
        
        
        
      end
    end
  end
end
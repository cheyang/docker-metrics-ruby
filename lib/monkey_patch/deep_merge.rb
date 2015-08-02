module Kernel
  #deep merge
 def self.hash_deep_merge source_hash, to_merge_hash

    to_merge_hash.each_pair do |key, val|
      if source_hash.has_key?(key) then
        if val.is_a?(Hash) and source_hash[key].is_a?(Hash) then
          source_hash[key] = deep_merge(source_hash[key], val)
        elsif val != source_hash[key] then
          source_hash[key] = val
        end
      else
        source_hash[key] = val
      end
    end
    return source_hash
  end
end
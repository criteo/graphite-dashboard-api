module GraphiteDashboardApi
  module ExtraOptions
    attr_accessor :extra_options
    def method_missing(m, *args)
      if args && args.size > 0
        @extra_options[m.to_s] = args[0]
      end
      @extra_options[m.to_s]
    end

    def extra_options_to_hash
      hash = {}
      @extra_options.each do |k,v|
        hash[k.to_s] = v
      end
      hash
    end

    def extra_options_from_hash!(std_options, hash)
      extra_options = hash.keys - std_options
      extra_options.each do |k|
        @extra_options[k] = hash[k]
      end
      self
    end
  end
end

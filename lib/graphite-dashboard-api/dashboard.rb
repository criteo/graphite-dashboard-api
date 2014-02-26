module GraphiteDashboardApi
  class Dashboard

    include Api

    attr_accessor :name
    attr_accessor :graphs
    attr_accessor :stringify_graphSize

    def initialize(name = nil, &block)
      @name = name
      @graphs = []
      @defaultGraphParams_width  = '800'
      @defaultGraphParams_from   = '-5minutes'
      @defaultGraphParams_until  = 'now'
      @defaultGraphParams_height = '400'
      @refreshConfig_interval =  600000
      @refreshConfig_enabled  = false
      @graphSize_width        = 400
      @graphSize_height       = 250
      @stringify_graphSize    = false # tweaking option

      # default timeConfig
      @timeConfig_type = 'relative'
      @timeConfig_relativeStartUnits = 'minutes'
      @timeConfig_relativeStartQuantity = '5'
      @timeConfig_relativeUntilUnits = 'now'
      @timeConfig_relativeUntilQuantity = ''

      @timeConfig_startDate = '1970-01-01T00:00:00'
      @timeConfig_endDate = '1970-01-01T00:05:00'
      @timeConfig_startTime = '9:00 AM'
      @timeConfig_endTime  = '5:00 PM'

      instance_eval(&block) if block
    end

    DEFAULT_GRAPH_PARAMS = [:width, :from, :until, :height]
    REFRESH_CONFIG = [:interval, :enabled]
    TIME_CONFIG = [:startDate, :relativeStartUnits, :endDate, :relativeStartQuantity, :relativeUntilQuantity, :startTime, :endTime, :type, :relativeUntilUnits]
    GRAPH_SIZE = [:width, :height]

    OPTIONS = {
      'defaultGraphParams' => DEFAULT_GRAPH_PARAMS,
      'refreshConfig' => REFRESH_CONFIG,
      'timeConfig' => TIME_CONFIG,
      'graphSize' => GRAPH_SIZE,
    }

    def stringify_graphSize(arg = nil)
      if arg
        @stringify_graphSize = arg
      end
      @stringify_graphSize
    end

    def graphs(arg = nil)
      if arg
        @graphs = arg
      end
      @graphs
    end

    OPTIONS.each do |k, options|
      options.each do |v|
        accessor_name = k + '_' + v.to_s
        attr_accessor accessor_name
        define_method(accessor_name) do |arg = nil|
        if arg
          instance_variable_set("@#{accessor_name}".to_sym, arg)
        else
          instance_variable_get "@#{accessor_name}".to_sym
        end
        end
        define_method((accessor_name.to_s + '_').to_sym) do |arg = nil|
        send(accessor_name, arg)
        end
      end
    end

    def to_hash
      state = {}
      state['name'] = @name
      OPTIONS.each do |k, options|
        state[k] = Hash.new
        options.each do |kk|
          state[k][kk.to_s] = instance_variable_get "@#{k}_#{kk}".to_sym
          state[k][kk.to_s] = state[k][kk.to_s].to_s if (k.eql? 'graphSize' and @stringify_graphSize)
        end
      end

      state['graphs'] = @graphs.map do |graph|

        [graph.leading_entries, graph.to_hash, graph.url(state['graphSize'])]
      end

      hash = { 'state' => state }
      hash
    end

    def from_hash!(hash)
      state = hash['state']
      @name = state['name']
      OPTIONS.each do |k, options|
        if state[k]
          options.each do |kk|
            value = state[k][kk.to_s]
            instance_variable_set("@#{k}_#{kk}".to_sym, value) if value
          end
        end
      end
      if state['graphs']
        state['graphs'].each do |graph_entry|
          fail 'Graph entry is supposed to have 3 elements' unless graph_entry.size.eql? 3
          graph = graph_entry[1]
          new_graph = Graph.new
          new_graph.from_hash!(graph)
          @graphs << new_graph
        end
      end
      self
    end

    def encode
      json = JSON.generate(to_hash['state'])
      'state=' + URI.encode(json, my_unsafe)
    end

    def decode(encoded_string)
      json = URI.decode(encoded_string[/=(.*)/, 1], my_unsafe)
      JSON.parse(json)
    end

    def my_unsafe
      Regexp.union(URI::UNSAFE, /[,&+]/)
    end

  end
end

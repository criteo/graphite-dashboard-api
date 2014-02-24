module GraphiteDashboardApi
  class Dashboard
    attr_accessor :name
    attr_accessor :graphs

    def initialize(name)
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
    end

    DEFAULT_GRAPH_PARAMS = %i(width from until height)
    REFRESH_CONFIG = %i(interval enabled)
    TIME_CONFIG = %i(startDate relativeStartUnits endDate relativeStartQuantity relativeUntilQuantity startTime endTime type relativeUntilUnits)
    GRAPH_SIZE = %i(width height)

    OPTIONS = {
      'defaultGraphParams' => DEFAULT_GRAPH_PARAMS,
      'refreshConfig' => REFRESH_CONFIG,
      'timeConfig' => TIME_CONFIG,
      'graphSize' => GRAPH_SIZE,
    }

    OPTIONS.each do |k,options|
      options.each do |v|
        accessor_name = k + '_' + v.to_s
        attr_accessor accessor_name
      end
    end

    def to_hash
      state = Hash.new
      state['name'] = @name
      OPTIONS.each do |k,options|
        state[k] = Hash.new
        options.each do |kk|
          state[k][kk.to_s] = instance_variable_get "@#{k}_#{kk}".to_sym
        end
      end

      state['graphs'] = @graphs.map do |graph|
        [ graph.target_encode, graph.to_hash, graph.url(state['graphSize'])]
      end

      hash = { 'state' => state }
      hash
    end
  end
end

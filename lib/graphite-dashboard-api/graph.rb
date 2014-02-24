require 'uri'

module GraphiteDashboardApi
  class Graph
    PROPS = %i(from until width height)
    [PROPS, :targets, :titles].flatten.each do |a|
      attr_accessor a
      define_method(a) do |arg=nil|
      if arg
        instance_variable_set("@#{a}".to_sym, arg)
      else
        instance_variable_get "@#{a}".to_sym
      end
      end
      define_method((a.to_s + '_').to_sym) do |arg=nil|
      self.send(a, arg)
      end
    end

    def initialize(title, &block)
      @title = title
      @targets = []
      self.instance_eval(&block) if block
    end

    def url(default_options)
      "/render?" + render_options(default_options) + '&' + target_encode + "&title=#{@title || default_title}"
    end

    def default_title
      URI::encode(@targets.first)
    end

    def render_options(default_options)
      opts = []
      PROPS.each do |k|
        v = instance_variable_get "@#{k}".to_sym
        v ||= default_options[k.to_s]
        opts << "#{k.to_s}=#{v}" if v
      end
      opts.join('&')
    end

    def target_encode
      @targets.map do |target|
        "target=" + URI::encode(target)
      end.join('&')
    end

    def to_hash
      hash = Hash.new
      PROPS.each do |k|
        v = instance_variable_get "@#{k}".to_sym
        hash[k.to_s] = v if v
      end
      hash['target'] = @targets
      hash['title'] = @title if @title
      hash
    end
  end
end

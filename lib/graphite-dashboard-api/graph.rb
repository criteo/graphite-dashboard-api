require 'uri'

module GraphiteDashboardApi
  class Graph
    PROPS = [:from, :until, :width, :height]
    [PROPS, :targets, :titles, :compact_leading].flatten.each do |a|
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

    def initialize(title=nil, &block)
      @title = title
      @targets = []
      @compact_leading = false #this is tweaking stuff
      self.instance_eval(&block) if block
    end

    def url(default_options)
      "/render?" + render_options(default_options) + '&' + target_encode + "&title=#{URI::escape(@title || default_title, my_unsafe)}"
    end

    #This is probably an over simplification TODO
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

    def my_unsafe
      Regexp.union(URI::UNSAFE, /[,&+]/)
    end

    def leading_entries
      if @targets.size == 1
        leading_entries = "target=#{@targets[0]}"
      else
        if @compact_leading
          leading_entries = target_encode
        else
          leading_entries = @targets
        end
      end
    end

    def target_encode
      @targets.map do |target|
        "target=" + URI::escape(target, my_unsafe)
      end.join('&')
    end

    def to_hash
      hash = Hash.new
      hash['title'] = @title if @title
      PROPS.each do |k|
        v = instance_variable_get "@#{k}".to_sym
        hash[k.to_s] = v if v
      end
      hash['target'] = @targets
      hash
    end
  end
end

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
      "/render?" + render_options(default_options) + '&' + target_encode + "&title=#{@title || default_title}"
    end

    #This is probably an over simplification TODO
    def default_title
      @targets.first
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

    def leading_entries
      if @compact_leading
        leading_entries = target_encode
      else
        leading_entries = @targets
      end
    end

    def target_encode
      @targets.map do |target|
        "target=" + target
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

    def from_hash!(hash)
      @title = hash['title']
      PROPS.each do |k|
        value = hash[k.to_s]
        instance_variable_set("@#{k}".to_sym, value) if value
      end
      if hash['target']
        hash['target'].each do |target|
          @targets << target
        end
      end
      self
    end
  end
end

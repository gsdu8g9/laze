module Laze
  class Renderer
    attr_reader :options, :string

    def initialize(*args)
      raise ArgumentError unless args.any?

      if args[0].is_a?(Page)
        @string = args[0].content
        @options = { :locals => args[0].properties }
      else
        @string, @options = args[0], args[1]
      end
    end

    # First apply markdown, only then wrap in layout. A layout that contains
    # HTML boiler plate stuff (<html>, <doctype>, etc) will get messed up
    # when markdownized.
    def to_s(locals = {})
      output = string
      output = markdownize(output)
      output = wrap_in_layout(output)
      output = liquify(output, (options[:locals] || {}).merge(locals))
      output
    end
    alias_method :render, :to_s

    def self.render(*args)
      new(*args).render
    end

  private

    def wrap_in_layout(string)
      return string unless layout = Layout.find(options[:locals][:layout])
      output = string
      while layout
        output = layout.wrap(output)
        layout = Layout.find(layout.layout)
      end
      output
    end

    # TODO: take options for output
    def markdownize(string)
      RDiscount.new(string).to_html
    end

    # TODO: take options for output
    def liquify(string, locals = {})
      Liquid::Template.parse(string).render('page' => stringify_keys(locals))
    end

    def stringify_keys(hash)
      hash.inject({}) do |options, (key, value)|
        options[key.to_s] = value
        options
      end
    end
  end
end
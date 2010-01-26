module Laze #:nodoc:
  module Plugins #:nodoc:
    module ImageCheck
      def self.applies_to?(kind) #:nodoc:
        kind == 'Laze::Renderers::StylesheetRenderer'
      end

      def render(locals = {})
        Laze.debug 'Checking for missing stylesheet images'
        super.scan(/url\(\s*('|")?\s*(.+?)\s*\1?\s*\)/) do |match|
          filename = match[1].split("?", 2).first
          if %w(.gif .png .jpg .jpeg).include?(File.extname(filename))
            path = File.expand_path(File.join('input', options[:locals][:path], filename))
            unless File.exists?(path)
              Laze.warn "Image #{filename} not found (#{options[:locals][:filename]})."
            end
          end
        end
      end
    end
  end
end
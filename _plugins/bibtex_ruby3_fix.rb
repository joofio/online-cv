# Fix bibtex-ruby 4.4.7 compatibility with Ruby 3.0+
# Proc.new without a block was removed in Ruby 3.0
if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.0.0')
  require 'bibtex'
  module BibTeX
    class Bibliography
      def each(&block)
        if block_given?
          data.each(&block)
          self
        else
          to_enum
        end
      end
    end
  end
end

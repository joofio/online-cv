# Fix bibtex-ruby 4.4.7 compatibility with Ruby 3.0+
# Proc.new without a block was removed in Ruby 3.0
if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.0.0')
  require 'bibtex'
  module BibTeX
    class Bibliography
      # Override the each method to fix Proc.new without block error in Ruby 3.0+
      # Original implementation in bibtex-ruby 4.4.7 uses Proc.new which fails in Ruby 3.0+
      # This version returns an Enumerator when no block is given, matching Ruby 3.0+ behavior
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

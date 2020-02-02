module Naturally
  # An entity which can be compared to other like elements for
  # sorting. It's an object representing
  # a value which implements the {Comparable} interface which can
  # convert itself to an array.
  class Segment
    include Comparable

    def initialize(v)
      @val = v
    end

    def <=>(other)
      to_array <=> other.to_array
    end

    # @return [Array] a representation of myself in array form
    #                 which enables me to be compared against
    #                 another instance for sorting.
    #                 The array is prepended with a symbol so
    #                 two arrays are always comparable.
    #
    # @example a simple number
    #   Segment.new('10').to_array #=> [:int, 10]
    #
    # @example a college course code
    #   Segment.new('MATH101').to_array #=> [:str, "MATH", 101]
    #
    # @example Section 633a of the U.S. Age Discrimination in Employment Act
    #   Segment.new('633a').to_array #=> [:int, 633, "a"]
    def to_array
      # TODO: Refactor, probably via polymorphism
      if @val =~ /^(\p{Digit}+)(\p{Alpha}+)$/
        [:int, $1.to_i, $2]
      elsif @val =~ /^(\p{Alpha}+)(\p{Digit}+)$/
        [:str, $1, $2.to_i]
      elsif @val =~ /^\p{Digit}+$/
        [:int, @val.to_i]
      elsif @val.upcase =~ /^(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})$/
        [:int, convert_roman_numerals]
      else
        [:str, @val]
      end
    end


    # Convert the given roman numeral string (between 0-100)
    # into an integer so objects with roman numerals can
    # accurately be compared against each other.
    #
    # @return [Integer] a representation of the roman numeral
    #         as an integer
    def convert_roman_numerals
      @val =
        if @val.include?('iv')
          @val.gsub('iv', '4')
        elsif @val.include?('ix')
          @val.gsub('ix', '9')
        elsif @val.include?('xl')
          @val.gsub('xl', 'f')
        elsif @val.include?('xc')
          @val.gsub('xc', 'n')
        else
          @val
        end

      hashmap = { 'i'=>1,'4'=>4,'v'=>5,'9'=>9,'x'=>10,'f'=>40,'l'=>50,'n'=>90,'c'=>100 }

      @val = @val.chars.collect do |numeral|
        hashmap[numeral]
      end
    end
  end
end

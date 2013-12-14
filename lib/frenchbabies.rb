require "frenchbabies/version"
require "frenchbabies/scanner"
require "frenchbabies/publisher"

module FrenchBabies
  class << self
    def tick
      Publisher.publish Scanner.scan
    end
  end
end

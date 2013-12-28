module FrenchBabies
  class Publisher
    class << self
      def publish messages
        sites = FrenchBabies.googlesites
        messages.each do |message|
          sites.create_page message
        end
      end
    end
  end
end
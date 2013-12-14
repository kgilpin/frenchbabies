require "frenchbabies/version"
require "frenchbabies/scanner"
require "frenchbabies/publisher"

module FrenchBabies
  class << self
    def initialize
      configure_mail
    end

    def tick
      messages = Scanner.scan
      unless messages.empty?
        puts "Processing messages from:"
        puts messages.map(&:sender).join("\n")
      end
      Publisher.publish messages
    end
    
    protected
    
    def configure_mail
      require "mail"
      Mail.defaults do
        retriever_method :pop3, :address    => "pop.gmail.com",
                                :port       => 995,
                                :user_name  => Settings[:"email-user-name"],
                                :password   => Settings[:"email-password"],
                                :enable_ssl => true
      end
    end
  end
end

require "frenchbabies/version"
require "frenchbabies/scanner"
require "frenchbabies/publisher"

module FrenchBabies
  class << self
    def initialize
      configure_mail
    end

    def tick
      Publisher.publish Scanner.scan
    end
    
    protected
    
    def configure_mail
      require "mail"
      Mail.defaults do
        retriever_method :pop3, :address    => "pop.gmail.com",
                                :port       => 995,
                                :user_name  => Settings[:email_user_name],
                                :password   => Settings[:email_password],
                                :enable_ssl => true
      end
    end
  end
end

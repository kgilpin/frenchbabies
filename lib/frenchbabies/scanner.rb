require 'frenchbabies/message'

module FrenchBabies
  class Scanner
    class << self
      def scan
        messages = []
        Mail.find_and_delete(:what => :first, :count => 10, :order => :asc).each do |mail|
          body = nil
          images = []
          if mail.multipart?
            body = [ mail.body.preamble ]
            mail.parts.each do |part|
              collect_body part, body
            end
            body << mail.body.epilogue
            body.compact!
            body = body.join("\n")
            images = mail.attachments.map do |attachment|
              Image.new(attachment.filename, attachment.body.decoded)
            end
          else
            body = mail.body.decoded
          end
          messages << Message.new(mail.sender, mail.subject, body, images)
        end
        messages
      end
      
      protected
      
      def collect_body(part, body = [])
        if part.parts.length > 0
          part.parts.each do |p|
            collect_body p, body
          end
        elsif part.content_type =~ /^text\/x?html\b/
          body << part.body.decoded
        elsif part.content_type =~ /^image\// || part.content_type =~ /^text\/plain\b/
          # pass
        else
          $stderr.puts "Unrecognized content type '#{part.content_type}' in mail part"
        end
        body
      end
    end
  end
end
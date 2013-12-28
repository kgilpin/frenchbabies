require 'oauth2'
require 'nokogiri'
require 'base64'

module FrenchBabies
  class GoogleSites
    attr_reader :api_token
    
    def initialize
      @api_token = connect
    end
    
    def create_page(message)
      body = <<-MSG
<entry xmlns="http://www.w3.org/2005/Atom">
  <category scheme="http://schemas.google.com/g/2005#kind"
      term="http://schemas.google.com/sites/2008#announcement" label="announcement"/>
  <link rel="http://schemas.google.com/sites/2008#parent" type="application/atom+xml"
      href="#{FrenchBabies.homepage_id}"/>
  <title>#{message.title.encode(:xml => :text)}</title>
  <content type="xhtml">
    <div xmlns="http://www.w3.org/1999/xhtml">
<![CDATA[
#{message.body}
]]>
    </div>
  </content>
</entry>
      MSG

      payload = {
        headers: {
          "Content-Type"   => "application/atom+xml",
          "Content-Length" => body.length.to_s
        },
        body: body
      }
     
      p payload
      
      message_body = api_token.post("feeds/content/site/frenchbabiesbyaudrey", payload).body
      
      p message_body
      
      message_id = Nokogiri::XML.parse(message_body).xpath("//xmlns:link[@rel='self']").first['href']
      
      message.images.each do |attachment|
        body = <<-MSG
--END_OF_PART
Content-Type: application/atom+xml
          
<entry xmlns="http://www.w3.org/2005/Atom">
  <category scheme="http://schemas.google.com/g/2005#kind"
      term="http://schemas.google.com/sites/2008#announcement" label="attachment"/>
  <link rel="http://schemas.google.com/sites/2008#parent" type="application/atom+xml"
      href="#{message_id}"/>
  <title>#{attachment.title.encode(:xml => :text)}</title>
</entry>

--END_OF_PART
Content-Type: #{attachment.content_type}
Content-Transfer-Encoding: BASE64

#{Base64.encode64 attachment.body}
--END_OF_PART--
        MSG
        
        payload = {
          headers: {
            "Content-Type" => "multipart/related; boundary=END_OF_PART",
            "Content-Length" => body.length.to_s
          },
          body: body
        }
        
        p payload
        
        api_token.post("feeds/content/site/frenchbabiesbyaudrey", payload)
      end
      
      message_id
    end
    
    protected
    
    def connect
      auth_client = OAuth2::Client.new Settings[:"google-client-id"], Settings[:"google-client-secret"], {:site => 'https://accounts.google.com', :authorize_url => "/o/oauth2/auth", :token_url => "/o/oauth2/token"}
      access_token = OAuth2::AccessToken.new(auth_client, 'foobar', refresh_token: Settings[:"google-refresh-token"])
      token = access_token.refresh!
      api_client = OAuth2::Client.new Settings[:"google-client-id"], Settings[:"google-client-secret"], site: 'https://sites.google.com'
      OAuth2::AccessToken.new(api_client, token.token, token.to_hash)
    end
  end
end
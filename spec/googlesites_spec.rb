require 'frenchbabies/googlesites'

include FrenchBabies

describe GoogleSites do
  
  shared_context "GoogleSites instance" do
    let(:googlesites) { GoogleSites.new }
    let(:api_token) { double(:api_token) }
    before {
      GoogleSites.any_instance.stub(:connect).and_return api_token
    }
  end
  
  describe "#create_page" do
    include_context "GoogleSites instance"
    
    let(:sender) { "me@example.com" }
    let(:title) { "the title" }
    let(:content) { "the message" } 
    let(:image) { FrenchBabies::Image.new("the image", "image/png", "the-encoded-image-body") }
    
    context "content and image" do
      it "submits the document and attachment" do
        message_payload = {
          :headers=>{"Content-Type"=>"application/atom+xml", "Content-Length"=>"519"},
          :body=> <<-BODY
<entry xmlns="http://www.w3.org/2005/Atom">
  <category scheme="http://schemas.google.com/g/2005#kind"
      term="http://schemas.google.com/sites/2008#announcement" label="announcement"/>
  <link rel="http://schemas.google.com/sites/2008#parent" type="application/atom+xml"
      href="https://sites.google.com/feeds/content/site/frenchbabiesbyaudrey/2788880672212124750"/>
  <title>the title</title>
  <content type="xhtml">
    <div xmlns="http://www.w3.org/1999/xhtml">
<![CDATA[
the message
]]>
    </div>
  </content>
</entry>
BODY
        }
        response = double(:response, body: <<-RESPONSE_BODY)
<entry xmlns="http://www.w3.org/2005/Atom">
  <link rel="self" href="https://sites.google.com/feeds/content/site/frenchbabiesbyaudrey/the-id"/>
</entry>
        RESPONSE_BODY

        image_payload = {
          :headers=>{"Content-Type"=>"multipart/related; boundary=END_OF_PART", "Content-Length"=>"580"},
          :body=> <<-BODY
--END_OF_PART
Content-Type: application/atom+xml
          
<entry xmlns="http://www.w3.org/2005/Atom">
  <category scheme="http://schemas.google.com/g/2005#kind"
      term="http://schemas.google.com/sites/2008#announcement" label="attachment"/>
  <link rel="http://schemas.google.com/sites/2008#parent" type="application/atom+xml"
      href="https://sites.google.com/feeds/content/site/frenchbabiesbyaudrey/the-id"/>
  <title>the image</title>
</entry>

--END_OF_PART
Content-Type: image/png
Content-Transfer-Encoding: BASE64

dGhlLWVuY29kZWQtaW1hZ2UtYm9keQ==

--END_OF_PART--
BODY
        }
        
        api_token.should_receive(:post).with("feeds/content/site/frenchbabiesbyaudrey", message_payload).and_return response
        api_token.should_receive(:post).with("feeds/content/site/frenchbabiesbyaudrey", image_payload)
        
        message = FrenchBabies::Message.new(sender, title, content, [ image ])
        
        googlesites.create_page(message).should == "https://sites.google.com/feeds/content/site/frenchbabiesbyaudrey/the-id"
      end
    end
  end
end
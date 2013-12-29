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
    let(:content) { "the message\n\nlink to @@title@@" } 
    let(:image) { FrenchBabies::Image.new("the image", "image/png", "the-raw-image-body") }
    
    context "content and image" do
      it "submits the document and attachment" do
        message_payload = {
          :headers=>{"Content-Type"=>"application/atom+xml", "Content-Length"=>"589"},
          :body=> <<-BODY
<entry xmlns="http://www.w3.org/2005/Atom" xmlns:sites="http://schemas.google.com/sites/2008">
  <category scheme="http://schemas.google.com/g/2005#kind"
      term="http://schemas.google.com/sites/2008#announcement" label="announcement"/>
  <link rel="http://schemas.google.com/sites/2008#parent" type="application/atom+xml"
      href="https://sites.google.com/feeds/content/site/frenchbabiesbyaudrey/2788880672212124750"/>
  <title>the title</title>
  <sites:pageName>the-title</sites:pageName>
  <content type="html">
<![CDATA[
the message

link to the-title
]]>
  </content>
</entry>
BODY
        }
        response = double(:response, body: <<-RESPONSE_BODY)
<entry xmlns="http://www.w3.org/2005/Atom">
  <link rel="self" href="https://sites.google.com/feeds/content/site/frenchbabiesbyaudrey/the-id"/>
  <title>the-title</title>
</entry>
        RESPONSE_BODY

        image_payload = {
          :headers=>{"Content-Type"=>"multipart/related; boundary=END_OF_PART", "Content-Length"=>"520"},
          :body=> <<-BODY
--END_OF_PART
Content-Type: application/atom+xml

<entry xmlns="http://www.w3.org/2005/Atom">
  <category scheme="http://schemas.google.com/g/2005#kind"
      term="http://schemas.google.com/sites/2008#attachment" label="attachment"/>
  <link rel="http://schemas.google.com/sites/2008#parent" type="application/atom+xml"
      href="https://sites.google.com/feeds/content/site/frenchbabiesbyaudrey/the-id"/>
  <title>the image</title>
</entry>

--END_OF_PART
Content-Type: image/png

the-raw-image-body

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
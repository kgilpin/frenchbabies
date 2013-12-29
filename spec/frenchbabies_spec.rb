require 'frenchbabies'
include FrenchBabies

describe FrenchBabies do
  describe "#tick" do
    it "scans and publishes" do
      Scanner.should_receive(:scan).and_return messages = [ double(:message1, title: "Message 1", sender: "kgilpin@gmail.com", authorize?: true), double(:message2, title: "Message 2", sender: "kgilpin@gmail.com", authorize?: false) ]
      Publisher.should_receive(:publish).with(messages[0..0])
      
      FrenchBabies.tick
    end
  end
end
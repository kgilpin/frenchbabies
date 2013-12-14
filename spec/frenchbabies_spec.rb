require 'frenchbabies'
include FrenchBabies

describe FrenchBabies do
  describe "#tick" do
    it "scans and publishes" do
      Scanner.should_receive(:scan).and_return messages = double(:messages)
      Publisher.should_receive(:publish).with(messages)
      
      FrenchBabies.tick
    end
  end
end
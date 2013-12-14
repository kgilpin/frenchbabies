module FrenchBabies
  Image = Struct.new(:title, :image) do
    def to_s
      {
        title: title,
        size: image.length
      }.to_s
    end    
  end
end
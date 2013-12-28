module FrenchBabies
  Image = Struct.new(:title, :content_type, :body) do
    def to_s
      {
        title: title,
        content_type: content_type,
        size: body.length
      }.to_s
    end    
  end
end
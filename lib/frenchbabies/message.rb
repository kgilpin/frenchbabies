require 'frenchbabies/image'

module FrenchBabies
  Message = Struct.new(:sender, :title, :body, :images) do
    def images
      self[:images] || []
    end

    def to_s
      {
        title: title,
        body: body,
        image_count: images.length
      }.to_s
    end
  end
end
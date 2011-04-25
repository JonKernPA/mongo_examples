class Product
  include MongoMapper::Document
  key :name, String, :required => true, :unique => true

  many :releases
  
  def to_s
    text = name
    releases.each_with_index do |r, i|
      text += "\n" if i == 0
      text += "  Version #{r.major}:#{r.minor} on #{r.released_at.localtime.strftime("%d-%b-%Y")}"
    end
    text
  end
end


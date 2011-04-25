class Product
  include MongoMapper::Document
  
  key :name, String, :required => true, :unique => true

  many :releases
  
  # scope :by_age, lambda { |age| releases.where(:released_at.gt => age.days.ago) }
  
  def to_s
    text = name
    releases.each_with_index do |r, i|
      text += "\n" if i == 0
      text += "  Version #{r.major}:#{r.minor} on #{r.released_at.localtime.strftime("%d-%b-%Y")}\n"
    end
    text
  end
end


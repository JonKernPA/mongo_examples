class Release
  include MongoMapper::EmbeddedDocument
  key :major, String, :required=>true
  key :minor, String, :default => 0
  key :released_at, Time, :default => Time.now

  #embedded_in :product
end

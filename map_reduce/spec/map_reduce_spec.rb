require 'spec_helper'

describe "MapReduce" do

  before :all do
    Article.delete_all
    Article.create(:author => "John Knowles", :title => "A Separate Peace")
    Article.create(:author => "Ayn Rand", :title => "Fountainhead")
    Article.create(:author => "John Knowles", :title => "Peace Breaks Out")
    Article.create(:author => "Ayn Rand", :title => "Atlas Shrugged")

    Article.create(:author => "Pearl S. Buck", :title => "East Wind:West Wind (1930)")
    Article.create(:author => "Pearl S. Buck", :title => "The House of Earth (1935)")
    Article.create(:author => "Pearl S. Buck", :title => "The Good Earth (1931)")
    Article.create(:author => "Pearl S. Buck", :title => "Sons (1933)")
    Article.create(:author => "Pearl S. Buck", :title => "A House Divided (1935)")
    Article.create(:author => "Pearl S. Buck", :title => "The Mother (1933)")
    Article.create(:author => "Pearl S. Buck", :title => "This Proud Heart (1938)")
    Article.create(:author => "Pearl S. Buck", :title => "The Patriot (1939)")
    Article.create(:author => "Pearl S. Buck", :title => "Other Gods (1940)")

  end

  describe "setup" do
    it "should have data" do
      Article.count.should > 0
    end
  end

  describe "Simple Stats" do
    it "should compute article counts per author" do
      results = ArticleStats.book_counts_by_author
      results.should include({"_id"=>"Ayn Rand", "value"=>2.0})
      results.should include({"_id"=>"John Knowles", "value"=>2.0})
      results.should include({"_id"=>"Pearl S. Buck", "value"=>9.0})
    end
  end

end

class Article
  include MongoMapper::Document
  key :title, String
  key :author, String
  timestamps!
end

class ArticleStats

  def self.book_counts_by_author
    results = []
    counts_cursor = ArticleStats.build.find()
    # map_hash is an OrderedHash that looks like
    # {"_id"=>"Ayn Rand", "value"=>2.0}
    counts_cursor.each_with_index do |map_hash,i|
      results << map_hash
      puts "#{i+1}: #{map_hash["_id"]}: #{map_hash["value"]}"
    end
    # An array of map_hash results for each unique key
    results
  end

  # Create a "record" for each document that has the author and a count of 1
  def self.map
    <<-MAP
function() {
  emit(this.author, 1);
}
    MAP
  end

  # When the map part is run, it will have bundled the unique authors up as keys
  # and provided the value(s) that match each key. In this case, we are planning to
  # run the map over each Article instance, essentially sorting by author, and then
  # the values will reflect each title for that author.
  def self.reduce
    <<-REDUCE
function(key, values) {
  var article_count = 0;
  for (var i in values) {
    article_count += 1;
  }
  return article_count;
}
    REDUCE
  end

  def self.build
    Article.collection.map_reduce(map, reduce, :out => "mr_results")
  end

end
class User
  include MongoMapper::Document

  key :name, :required => true
  
  many :events
  
  def to_s
    text = "\n" + "- "*25
    text += "\n#{name.upcase}"
    if events.size > 0
      text += "\nYOUR EVENTS:"
      events.each {|e| text += "\n  #{e.to_summary}"}
    else
      text += "\n  You have no events. Click *here* to get started!"
    end
    text
  end
end

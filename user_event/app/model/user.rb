class User
  include MongoMapper::Document

  key :name, :required => true
  
  many :events
  
  def likes
    Event.where(:like_ids => id).all
  end
  
  def attending
    Event.where(:attendees => id).all
  end

  def interested_in
    Event.where(:interested => id).all
  end  
  
  def likes_event(event)
    event.likes << self
    event.save!
  end
  
  def to_s
    text = "\n" + "- "*25
    text += "\n#{name.upcase}"
    if events.size > 0
      text += "\n  YOUR EVENTS:"
      events.each {|e| text += "\n    #{e.to_summary}"}
    else
      text += "\n    You have no events. Click *here* to get started!"
    end
    text += "\n  You like #{likes.count} events" if likes.count > 0
    text += "\n  You are attending #{attending.count} events" if attending.count > 0
    text += "\n  You are interested in #{interested_in.count} events" if interested_in.count > 0
    text
  end
end

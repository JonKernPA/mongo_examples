class Event
  include MongoMapper::Document

  key :title
  key :user_id
  belongs_to :user
  
  key :attendees, Set
  key :interested, Set
  # ensure_index :attendees
  # ensure_index :interested
  
  def attending(a_user)
    # self.push_uniq(:attendees => a_user.id)
    attendees << a_user.id
    save
  end

  def interested_in(a_user)
    interested << a_user.id
    save
  end
  
  def to_s
    text = "#{title} -- by #{user.name}"
    if attendees.size > 0
      text += "\n  ATTENDEES:"
      attendees.each {|id| text += "\n  -#{User.find(id).name}"}
    else
      text += "\n  NO ATTENDEES YET -- get out and market this event!"
    end

    if interested.size > 0
      text += "\n  INTERESTED:"
      interested.each {|id| text += "\n  -#{User.find(id).name}"}
    else
      text += "\n  NO FOLKS INTERESTED YET -- change the event or get out and market this event!"
    end
    text
  end
end

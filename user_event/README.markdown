# Simple Demo

Features:
* Cucumber
* RSpec
* Factory Girl
* MongoMapper

Events are created by a user (aka, an author)
Users can: 
* register for an event, or
* indicate interest (a maybe?)
* See list of events
* There is no more (I said it was *small*)

## The Model

![UserEvent](https://github.com/JonKernPA/mongo_examples/raw/master/user_event/user_event_model.png "from UMLet tool")

## Tests

If you run the tests as follows:
	jonsmac2-2:user_event jon$ spec spec/

You should see output like this:
	jonsmac2-2:user_event jon$ spec spec/
	......

	Test: event_spec.rb

	EVENTS
	--------------------------------------------------
	Code Retreat Timbuktoo -- by Fred
	   Attendees   Interested    Likes
	       2            2          0
	  ATTENDEES:
	  -Harry
	  -Fred
	  INTERESTED:
	  -Jared
	  -Sally

	--------------------------------------------------
	Financial Regulation Made Easy -- by Fred
	   Attendees   Interested    Likes
	       1            0          0
	  ATTENDEES:
	  -Fred
	  NO FOLKS INTERESTED YET -- change the event or get out and market this event!

	USERS

	- - - - - - - - - - - - - - - - - - - - - - - - - 
	FRED
	  YOUR EVENTS:
	    Code Retreat Timbuktoo #: 2, Int: 2 Likes: 0
	    Financial Regulation Made Easy #: 1, Int: 0 Likes: 0
	  You are attending 2 events
	- - - - - - - - - - - - - - - - - - - - - - - - - 
	HARRY
	    You have no events. Click *here* to get started!
	  You are attending 1 events
	- - - - - - - - - - - - - - - - - - - - - - - - - 
	JARED
	    You have no events. Click *here* to get started!
	  You are interested in 1 events
	- - - - - - - - - - - - - - - - - - - - - - - - - 
	MARTHA
	    You have no events. Click *here* to get started!
	- - - - - - - - - - - - - - - - - - - - - - - - - 
	SALLY
	    You have no events. Click *here* to get started!
	  You are interested in 1 events
	.....

Test: user_spec.rb

	EVENTS

	--------------------------------------------------
	Code Retreat in Timbuktoo -- by Fred
	   Attendees   Interested    Likes
	       2            2          0
	  ATTENDEES:
	  -Fred
	  -Harry
	  INTERESTED:
	  -Jared
	  -Sally

	--------------------------------------------------
	Financial Regulation Made Easy -- by Sally
	   Attendees   Interested    Likes
	       0            0          1
	  NO ATTENDEES YET -- get out and market this event!
	  NO FOLKS INTERESTED YET -- change the event or get out and market this event!


	USERS

	- - - - - - - - - - - - - - - - - - - - - - - - - 
	FRED
	  YOUR EVENTS:
	    Code Retreat in Timbuktoo #: 2, Int: 2 Likes: 0
	  You like 1 events
	  You are attending 1 events
	- - - - - - - - - - - - - - - - - - - - - - - - - 
	HARRY
	    You have no events. Click *here* to get started!
	  You are attending 1 events
	- - - - - - - - - - - - - - - - - - - - - - - - - 
	JARED
	    You have no events. Click *here* to get started!
	  You are interested in 1 events
	- - - - - - - - - - - - - - - - - - - - - - - - - 
	MARTHA
	    You have no events. Click *here* to get started!
	- - - - - - - - - - - - - - - - - - - - - - - - - 
	SALLY
	  YOUR EVENTS:
	    Financial Regulation Made Easy #: 0, Int: 0 Likes: 1
	  You are interested in 1 events

	Finished in 0.192199 seconds

	11 examples, 0 failures

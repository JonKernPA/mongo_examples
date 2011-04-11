# Simple Demo

Events are created by a user (aka, an author)
Users can: 
* register for an event, or
* indicate interest (a maybe?)

## The Model

![UserEvent](https://github.com/JonKernPA/mongo_examples/raw/master/user_event/user_event_model.png "from UMLet tool")
![panda!](https://github.com/tekkub/failpanda/raw/master/failure_panda.jpg)

## Tests

If you run the tests as follows:
	jonsmac2-2:user_event jon$ spec spec/

You should see output like this:
	jonsmac2-2:user_event jon$ spec spec/
	......
	--------------------------------------------------
	Code Retreat Timbuktoo -- by Fred
	   Attendees   Interested    Likes
	       2            2          0
	  ATTENDEES:
	  -Harry
	  -Fred
	  INTERESTED:
	  -Sally
	  -Jared

	--------------------------------------------------
	Financial Regulation Made Easy -- by Fred
	   Attendees   Interested    Likes
	       1            0          0
	  ATTENDEES:
	  -Fred
	  NO FOLKS INTERESTED YET -- change the event or get out and market this event!


	Finished in 0.088106 seconds

	6 examples, 0 failures
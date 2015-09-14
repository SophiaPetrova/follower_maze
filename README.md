# Follower Maze
This is my solution for the follower maze problem. 
More details on the problem can be found in the [instructions](instructions.md) file.

Please find details below on my design decisions and other instructions.

# Dependencies
I've used `bundle` to manage my dependencies. There are two test dependencies:
- `pry`: for debugging.
- `rspec`: test framework.
- `require_all`: utility gem to require all files in a directory. This is the only runtime dependency. Nothing more than a helper gem for requiring dependencies. I've only used it because it is a simpler way of loading all the files in the subdirectories.'

Code was ran locally using ruby 2.0.0.

# How to run the tests
In addition to the provided tests (by the follower_maze script + jar) I've written unit tests and a smoke test. To run the unit tests first do `bundle install` (this will download all the dependencies) and then `bundle exec rspec`. The smoke test can be ran by doing `bundle exec rspec smoke_tests/` (assuming you've ran `bundle install` before).

# How the code is organized
I've tried to create an event driven system. 

To mimic that, every new message is a new `EventCommand`. There are five types of those (one for each type of message). A `EventCommandBuilder` class converts the received strings to specific events and passes that to a `EventCommandExecutor`. This guy has one actor for each type of event. Based on the input it just triggers the specific actor (which means simply talking to the `ClientPool` to notify and/or to the `UsersFollowerManager` to record user interactions (aka adding a follower; unfollowing).

Generic configuration is added controlled by the `AppConfig` class. It can be tweaked to have more configurations if needed.

Organizing the event queue on a hash was a simple way I found of quickly checking if the next event to be triggered was available as look ups in hash tables take constant time. So, although the class is named `UnprocessedEventsQueue` its underlying is a hash table.

Extensions should be simple. The `UserFollowerManager`, for example, has a `UserFollowersRegistry`. The later abstracts the mappings between followers and following. In case that was stored in file (or a DB), this could be easily changed. The same holds true for the `ClientPool`.

I've tried to design the code in a dependency injection style so that the unit tests were simpler. For that the `App` class has to create all the dependencies and properly assign them before bootstrapping the application.

# How to run the server
Running the server should be fairly simple. First do a `bundle install` to guarantee that you have the dependencies installed, then, from the root of the project, do `ruby src/app.rb`.

# Assumptions
I've made a few assumptions based on the tests the provided jar generates:
- The protocol doesn't have gaps in the ordering of the messages.
- There are no retries while trying to communicate with a client (a message is attempted to be sent only once. If it fails, I don't retry).
- Messages to clients that don't exist are simply ignored.
- Private messages can be sent to users that are not followers.
- Repeated sequence numbers are to be ignored.

# Points for improvement
- Add logging. The `App` class provides a logger, but I didn't add statements throughout the code. They can be added for easier debugging in case needed.
- Add metrics. We can easily add metrics for number of messages received; types of messages received; number of errors; number of disconnects. All of that can help identify the system behavior (e.g.: high number of "F" messages to an specific user would indicate that is a popular user).
- Parallelize the worker through more threads (caveat will be maintaining the ordering of the messages).
- Only one events source.
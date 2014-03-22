## ActiveDiigo

[![Gem Version](https://badge.fury.io/rb/active_diigo.png)](http://badge.fury.io/rb/active_diigo)

### Description

ActiveDiigo is a wrapper for Diigo API(version: v2). It provides ActiveRecord like interaction with Diigo API. You just need to inherit ActiveDiigo::Base in class you want to use active_diigo in. It's also works standalone and it's framework agnostic gem, enabling itself to be used in any ruby framework.

### Installation

as you install any other ruby gem

    [sudo] gem install active_diigo
  
using bundler

    gem 'active_diigo'

and then

    bundle install

### Uses

Setup API Key and user credentials in initializer or anywhere before using active_diigo

    ActiveDiigo.api_key = 'YOUR_API_KEY'
    ActiveDiigo.username = '<user-name>'
    ActiveDiigo.username = '<password>'
  
then

    ActiveDiigo::Base.find(username, options)
    #=> returns array of ActiveDiigo::Base objects
    ActiveDiigo::Base.save(title, url, options)
    #=> returns a hash with message (saved or not) 
    #OR
    class MyDiigo < ActiveDiigo::Base; end
    MyDiigo.find(username, options)
    #=> Returns array of MyDiigo objects

### Contributing to active_diigo
 
  * Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
  * Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
  * Fork the project
  * Start a feature/bugfix branch
  * Commit and push until you are happy with your contribution
  * Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
  * Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

### TODO

  * Chaining and scoping for query parameters

### Copyright

Copyright (c) 2011-2014 Bagwan Pankaj. See LICENSE for further details.


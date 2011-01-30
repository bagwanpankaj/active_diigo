# Copyright (c) 2011 Bagwan Pankaj
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module ActiveDiigo
  
  class Base
    
    class << self; attr_reader :request; end
    attr_accessor :title, :url, :user, :desc, :tags, :shared, :created_at, :updated_at, :comments, :annotations, :readlater
        
    def initialize(options)
      build_self(options)
    end
    
    def self.find(user, options = {})
      options.merge!({:user => user})
      ResponseObject.new(connection.bookmarks(options), self).parsed_objects
    end
    
    def self.save(title, url, options = {})
      options.merge!({:title => title, :url => url})
      connection.save
    end
    
    private
    
    def self.active_request_connection
      username, password = assign_access_credentials!
      Request.new(username, password)
    end
    class << self; alias_method :connection, :active_request_connection; end
    
    def self.assign_access_credentials!
      [ActiveDiigo.username, ActiveDiigo.password]
    end
    
    def build_self(options)
      options.each do |k,v|
        send(:"#{k}=", v) if send(:respond_to?, :"#{k}=")
      end
    end
    
  end
  
end
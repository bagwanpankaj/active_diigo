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
  class Request
    
    include HTTParty
    
    base_uri 'https://secure.diigo.com/api/v2'

    API_VERSION = 'v2'

    def initialize(uname, password)
      self.class.basic_auth uname, password
    end

    def bookmarks(options = {})
      options.merge!({:key => ActiveDiigo.api_key})
      self.class.get('/bookmarks', {:query => options})
    end
    
    def save(options = {})
      options.merge!({:key => ActiveDiigo.api_key})
      self.class.post('/bookmarks', {:body => options})
    end
    
  end
end
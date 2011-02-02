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
  
  class ResponseObject
    
    attr_reader :raw_response, :parsed_response, :parsed_objects
    
    def initialize(http_response, receiver_klass)
      @raw_response, @receiver_klass = http_response, receiver_klass
      validate_response!
      @parsed_objects = build_objects
    end
    
    private
    
    def build_object(options)
      @receiver_klass.new(options)
    end
    
    def build_objects
      parse! and @parsed_response.collect{|pr| build_object(pr) }
    end
    
    def parse!
      @parsed_response = JSON.parse(@raw_response) rescue @raw_response.parsed_response
    end
    
    def validate_response!
      case @raw_response.response.class.to_s
        when Net::HTTPUnauthorized.to_s then raise ActiveDiigo::Errors::NotAuthorizedError.new
        when Net::HTTPBadRequest.to_s then raise ActiveDiigo::Errors::BadRequestError.new
        when Net::HTTPForbidden.to_s then raise ActiveDiigo::Errors::ForbiddenError.new
        when Net::HTTPNotFound.to_s then raise ActiveDiigo::Errors::NotFoundError.new
        when Net::HTTPInternalServerError.to_s then raise ActiveDiigo::Errors::InternalServerError.new
        when Net::HTTPServiceUnavailable.to_s then raise ActiveDiigo::Errors::ServiceUnavailableError.new
        when Net::HTTPBadGateway.to_s then raise ActiveDiigo::Errors::BadGatewayError.new
      end
    end
    
  end
  
end
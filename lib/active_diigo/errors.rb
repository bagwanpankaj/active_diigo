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
  
  module Errors
    class ActiveDiigoError < StandardError
      def initialize(status_code)
        super("ActiveDiigo status #{status_code} - #{self.class}")
      end
    end
    class NotAuthorizedError < ActiveDiigoError
      def initialize; super(401); end
    end
    class ForbiddenError < ActiveDiigoError
      def initialize; super(403); end
    end
    class BadRequestError < ActiveDiigoError
      def initialize; super(400); end
    end
    class NotFoundError < ActiveDiigoError
      def initialize; super(404); end
    end
    class InternalServerError < ActiveDiigoError
      def initialize; super(500); end
    end
    class BadGatewayError < ActiveDiigoError
      def initialize; super(502); end
    end
    class ServiceUnavailableError < ActiveDiigoError
      def initialize; super(503); end
    end
  end
  
end
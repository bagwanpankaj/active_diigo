require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ActiveDiigo" do
  
  describe ActiveDiigo do
    before(:all) do
      ActiveDiigo.api_key = 'TEST_API_KEY'
      ActiveDiigo.username = 'test-user'
      ActiveDiigo.password = 'test-pass'
    end
    
    it "should have api_key as an accessor" do
      ActiveDiigo.should respond_to(:api_key)
      ActiveDiigo.api_key.should == 'TEST_API_KEY'
    end
    
    it "should allow to set api_key" do
      ActiveDiigo.should respond_to(:api_key)
      ActiveDiigo.api_key = 'TEST_API_KEY_CHANGED'
      ActiveDiigo.api_key.should == 'TEST_API_KEY_CHANGED'
    end
    
    it "should have username as an accessor" do
      ActiveDiigo.should respond_to(:username)
      ActiveDiigo.username.should == 'test-user'
    end
    
    it "should allow to set username" do
      ActiveDiigo.should respond_to(:username)
      ActiveDiigo.username = 'TEST_USER'
      ActiveDiigo.username.should == 'TEST_USER'
    end
    
    it "should have password as an accessor" do
      ActiveDiigo.should respond_to(:password)
      ActiveDiigo.password.should == 'test-pass'
    end
    
    it "should allow to set password" do
      ActiveDiigo.should respond_to(:password)
      ActiveDiigo.password = 'TEST_PASS'
      ActiveDiigo.password.should == 'TEST_PASS'
    end
    
    it "should respond version method" do
      ActiveDiigo.should respond_to(:version)
    end
    
    it "should return current version of gem" do
      ActiveDiigo.version.should == File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))
    end
    
  end
  
  describe ActiveDiigo::Request do
    before(:all) do
      ActiveDiigo.api_key = 'TEST_API_KEY'
      @base_uri = "https://secure.diigo.com/api/v2"
    end
    it "should have HTTParty included" do
      ActiveDiigo::Request.should include HTTParty
    end
    
    it "should have base_uri set as diigo api uri" do
      ActiveDiigo::Request.base_uri.should == @base_uri
    end
    
    it "should have API version v2 for diigo API" do
      ActiveDiigo::Request::API_VERSION.should == 'v2'
    end
    
    it "should raise ArgumentError when not initialized with with proper no of argument" do
      Proc.new do
        ActiveDiigo::Request.new()
      end.should raise_error(ArgumentError)
    end
    
    it "should not raise error when initialized properly" do
      Proc.new do
        ActiveDiigo::Request.new('user', 'pass')
      end.should_not raise_error(ArgumentError)
    end
    
    it "should send a 10 bookmarks in json format by default when requested" do
      mock_request_for("https://test-user:test-pass@secure.diigo.com/api/v2/bookmarks?user=test-user&key=TEST_API_KEY")
      
      con = ActiveDiigo::Request.new('test-user', 'test-pass')
      res = con.bookmarks(:user => 'test-user')
      res.parsed_response.should be_an_instance_of Array
      res.size.should == 10
    end
    
    it "should get error json while saving bookmark without required params" do
      mock_request_for("https://test-user:test-pass@secure.diigo.com/api/v2/bookmarks", :method => :post,
       :fixture => 'save_error')
      con = ActiveDiigo::Request.new('test-user', 'test-pass')
      res = con.save()
      res["message"].should == "Error detected. Please check your input. Contact service@diigo.com if there's any problem."
    end
    
    it "should get success json while saving bookmark" do
      mock_request_for("https://test-user:test-pass@secure.diigo.com/api/v2/bookmarks", :method => :post,
       :fixture => 'save_success')
      con = ActiveDiigo::Request.new('test-user', 'test-pass')
      res = con.save(:title => "my bookmark", :url => "http://mybookmark.com")
      res["message"].should == "Saved 1 bookmark(s)"
      res['code'].should == 1
    end
    
  end
  
  describe ActiveDiigo::Base do
    
    before(:all) do
      ActiveDiigo.api_key = 'TEST_API_KEY'
      ActiveDiigo.username = 'test-user'
      ActiveDiigo.password = 'test-pass'
    end
    
    it "should find bookmarks with user test-user and return 10 bookmarks defaultly" do
      mock_request_for("https://test-user:test-pass@secure.diigo.com/api/v2/bookmarks?user=test-user&key=TEST_API_KEY")
      
      response = ActiveDiigo::Base.find('test-user')
      response.size.should == 10
    end
    
    it "should find bookmarks with user test-user and return 2 bookmarks" do
      mock_request_for("https://test-user:test-pass@secure.diigo.com/api/v2/bookmarks?count=2&user=test-user&key=TEST_API_KEY",
       :fixture => 'bookmarks_count')
      
      response = ActiveDiigo::Base.find('test-user', :count => 2)
      response.size.should == 2
    end
    
    it "should find bookmarks with specified tags" do
      mock_request_for("https://test-user:test-pass@secure.diigo.com/api/v2/bookmarks?tags=mysql%2C%20rvm&user=test-user&key=TEST_API_KEY",
       :fixture => 'bookmarks_with_tags')
      
      response = ActiveDiigo::Base.find('test-user', :tags => 'mysql, rvm')
      response.size.should == 1
      response.first.tags.should include('mysql')
    end
    
    it "should find bookmarks that includes tags searched for" do
      mock_request_for("https://test-user:test-pass@secure.diigo.com/api/v2/bookmarks?tags=mysql%2C%20rvm&user=test-user&key=TEST_API_KEY",
       :fixture => 'bookmarks_with_tags')
      
      response = ActiveDiigo::Base.find('test-user', :tags => 'mysql, rvm')
      response.first.tags.should include('mysql')
      response.first.tags.should include('rvm')
    end    
    
    it "should save bookmark and should return success" do
      mock_request_for("https://test-user:test-pass@secure.diigo.com/api/v2/bookmarks", :method => :post,
       :fixture => 'save_success')      
      response = ActiveDiigo::Base.save('test-title', 'http://testtitle.com')
      response["message"].should == "Saved 1 bookmark(s)"
      response['code'].should == 1
    end
    
    it "should get ArgumentError while calling save without arguments" do
      Proc.new do
        response = ActiveDiigo::Base.save()
      end.should raise_error(ArgumentError)
    end
    
    it "should return object of class that inherits ActiveDiigo::Base" do
      class MyDiigo < ActiveDiigo::Base; end
      mock_request_for("https://test-user:test-pass@secure.diigo.com/api/v2/bookmarks?user=test-user&key=TEST_API_KEY")
      
      response = MyDiigo.find('test-user')
      response.size.should == 10
      response.first.should be_an_instance_of MyDiigo
    end
    
    it "should respond to all methods in class that inherits ActiveDiigo::Base" do
      class MyDiigo < ActiveDiigo::Base; end
      MyDiigo.should respond_to(:find)
      MyDiigo.should respond_to(:save)
    end
    
  end
  
  describe "Misc" do
    describe ActiveDiigo::Errors do
      
      before(:all) do
        @base_name = "ActiveDiigo::Errors::ActiveDiigoError"
      end
      
      it "should inherit from Standard Error" do
        ActiveDiigo::Errors::ActiveDiigoError.superclass.name.should == "StandardError"
      end
      
      it "should have various error classes implemented" do
        ActiveDiigo::Errors::ActiveDiigoError.name.should == @base_name
        ActiveDiigo::Errors::NotAuthorizedError.superclass.name.should == @base_name
        ActiveDiigo::Errors::ForbiddenError.superclass.name.should == @base_name
        ActiveDiigo::Errors::BadRequestError.superclass.name.should == @base_name
        ActiveDiigo::Errors::NotFoundError.superclass.name.should == @base_name
        ActiveDiigo::Errors::InternalServerError.superclass.name.should == @base_name
        ActiveDiigo::Errors::BadGatewayError.superclass.name.should == @base_name
        ActiveDiigo::Errors::ServiceUnavailableError.superclass.name.should == @base_name
      end
      
    end
  end
  
end

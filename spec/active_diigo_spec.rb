require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ActiveDiigo" do
  
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

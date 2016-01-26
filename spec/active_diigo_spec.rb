require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ActiveDiigo" do

  describe ActiveDiigo do
    before(:all) do
      ActiveDiigo.api_key = 'TEST_API_KEY'
      ActiveDiigo.username = 'test-user'
      ActiveDiigo.password = 'test-pass'
    end

    it "should have api_key as an accessor" do
      expect(ActiveDiigo).to respond_to(:api_key)
      expect(ActiveDiigo.api_key).to eq 'TEST_API_KEY'
    end

    it "should allow to set api_key" do
      expect(ActiveDiigo).to respond_to(:api_key)
      ActiveDiigo.api_key = 'TEST_API_KEY_CHANGED'
      expect(ActiveDiigo.api_key).to eq 'TEST_API_KEY_CHANGED'
    end

    it "should have username as an accessor" do
      expect(ActiveDiigo).to respond_to(:username)
      expect(ActiveDiigo.username).to eq 'test-user'
    end

    it "should allow to set username" do
      expect(ActiveDiigo).to respond_to(:username)
      ActiveDiigo.username = 'TEST_USER'
      expect(ActiveDiigo.username).to eq 'TEST_USER'
    end

    it "should have password as an accessor" do
      expect(ActiveDiigo).to respond_to(:password)
      expect(ActiveDiigo.password).to eq 'test-pass'
    end

    it "should allow to set password" do
      expect(ActiveDiigo).to respond_to(:password)
      ActiveDiigo.password = 'TEST_PASS'
      expect(ActiveDiigo.password).to eq 'TEST_PASS'
    end

    it "should respond version method" do
      expect(ActiveDiigo).to respond_to(:version)
    end

    it "should return current version of gem" do
      expect(ActiveDiigo.version).to eq File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))
    end

  end

  describe ActiveDiigo::Request do
    before(:all) do
      ActiveDiigo.api_key = 'TEST_API_KEY'
      @base_uri = "https://secure.diigo.com/api/v2"
    end
    it "should have HTTParty included" do
      expect(ActiveDiigo::Request).to include HTTParty
    end

    it "should have base_uri set as diigo api uri" do
      expect(ActiveDiigo::Request.base_uri).to eq @base_uri
    end

    it "should have API version v2 for diigo API" do
      expect(ActiveDiigo::Request::API_VERSION).to eq 'v2'
    end

    it "should raise ArgumentError when not initialized with with proper no of argument" do
      expect(Proc.new do
              ActiveDiigo::Request.new()
            end).to raise_error(ArgumentError)
    end

    it "should not raise error when initialized properly" do
      expect(Proc.new do
              ActiveDiigo::Request.new('user', 'pass')
            end).not_to raise_error(ArgumentError)
    end

    it "should send a 10 bookmarks in json format by default when requested" do
      mock_request_for("https://test-user:test-pass@secure.diigo.com/api/v2/bookmarks?user=test-user&key=TEST_API_KEY")

      con = ActiveDiigo::Request.new('test-user', 'test-pass')
      res = con.bookmarks(:user => 'test-user')
      expect(res.parsed_response).to be_an_instance_of Array
      expect(res.size).to eq 10
    end

    it "should get error json while saving bookmark without required params" do
      mock_request_for("https://test-user:test-pass@secure.diigo.com/api/v2/bookmarks", :method => :post,
       :fixture => 'save_error')
      con = ActiveDiigo::Request.new('test-user', 'test-pass')
      res = con.save()
      expect(res["message"]).to eq "Error detected. Please check your input. Contact service@diigo.com if there's any problem."
    end

    it "should get success json while saving bookmark" do
      mock_request_for("https://test-user:test-pass@secure.diigo.com/api/v2/bookmarks", :method => :post,
       :fixture => 'save_success')
      con = ActiveDiigo::Request.new('test-user', 'test-pass')
      res = con.save(:title => "my bookmark", :url => "http://mybookmark.com")
      expect(res["message"]).to eq "Saved 1 bookmark(s)"
      expect(res['code']).to eq 1
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
      expect(response.size).to eq 10
    end

    it "should find bookmarks with user test-user and return 2 bookmarks" do
      mock_request_for("https://test-user:test-pass@secure.diigo.com/api/v2/bookmarks?count=2&user=test-user&key=TEST_API_KEY",
       :fixture => 'bookmarks_count')

      response = ActiveDiigo::Base.find('test-user', :count => 2)
      expect(response.size).to eq 2
    end

    it "should find bookmarks with specified tags" do
      mock_request_for("https://test-user:test-pass@secure.diigo.com/api/v2/bookmarks?tags=mysql%2C%20rvm&user=test-user&key=TEST_API_KEY",
       :fixture => 'bookmarks_with_tags')

      response = ActiveDiigo::Base.find('test-user', :tags => 'mysql, rvm')
      expect(response.size).to eq 1
      expect(response.first.tags).to include('mysql')
    end

    it "should find bookmarks that includes tags searched for" do
      mock_request_for("https://test-user:test-pass@secure.diigo.com/api/v2/bookmarks?tags=mysql%2C%20rvm&user=test-user&key=TEST_API_KEY",
       :fixture => 'bookmarks_with_tags')

      response = ActiveDiigo::Base.find('test-user', :tags => 'mysql, rvm')
      expect(response.first.tags).to include('mysql')
      expect(response.first.tags).to include('rvm')
    end

    it "should save bookmark and should return success" do
      mock_request_for("https://test-user:test-pass@secure.diigo.com/api/v2/bookmarks", :method => :post,
       :fixture => 'save_success')
      response = ActiveDiigo::Base.save('test-title', 'http://testtitle.com')
      expect(response["message"]).to eq "Saved 1 bookmark(s)"
      expect(response['code']).to eq 1
    end

    it "should get ArgumentError while calling save without arguments" do
      expect(Proc.new do
              response = ActiveDiigo::Base.save()
            end).to raise_error(ArgumentError)
    end

    it "should return object of class that inherits ActiveDiigo::Base" do
      class MyDiigo < ActiveDiigo::Base; end
      mock_request_for("https://test-user:test-pass@secure.diigo.com/api/v2/bookmarks?user=test-user&key=TEST_API_KEY")

      response = MyDiigo.find('test-user')
      expect(response.size).to eq 10
      expect(response.first).to be_an_instance_of MyDiigo
    end

    it "should respond to all methods in class that inherits ActiveDiigo::Base" do
      class MyDiigo < ActiveDiigo::Base; end
      expect(MyDiigo).to respond_to(:find)
      expect(MyDiigo).to respond_to(:save)
    end

  end

  describe "Misc" do
    describe ActiveDiigo::Errors do

      before(:all) do
        @base_name = "ActiveDiigo::Errors::ActiveDiigoError"
      end

      it "should inherit from Standard Error" do
        expect(ActiveDiigo::Errors::ActiveDiigoError.superclass.name).to eq "StandardError"
      end

      it "should have various error classes implemented" do
        expect(ActiveDiigo::Errors::ActiveDiigoError.name).to eq @base_name
        expect(ActiveDiigo::Errors::NotAuthorizedError.superclass.name).to eq @base_name
        expect(ActiveDiigo::Errors::ForbiddenError.superclass.name).to eq @base_name
        expect(ActiveDiigo::Errors::BadRequestError.superclass.name).to eq @base_name
        expect(ActiveDiigo::Errors::NotFoundError.superclass.name).to eq @base_name
        expect(ActiveDiigo::Errors::InternalServerError.superclass.name).to eq @base_name
        expect(ActiveDiigo::Errors::BadGatewayError.superclass.name).to eq @base_name
        expect(ActiveDiigo::Errors::ServiceUnavailableError.superclass.name).to eq @base_name
      end

    end
  end

end

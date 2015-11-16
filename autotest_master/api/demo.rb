# module Kr
#   module Api
#     module News
#       def hello(name)
#         puts "hello #{name}"
#       end
#     end
#     module Posts

#     end
#   end
# end



# class Person
#   include Kr::Api::News
#   def initialize(name)
#     @name = name
#   end
#   def hello
#     super(@name)
#   end
# end

# Person.new("Steve").hello

# class Person
#   def initialize(opts = {})
#     @options = opts
#   end

#   def print_name
#     puts "my name is #{@options[:name]}"
#   end

#   def print_age
#     puts "my age is #{@options[:age]}"
#   end
# end


# person = Person.new(age: 1)
# person.print_age
# person.print_name



# require "spec_helper"
# require 'rubygems'
# require 'spec'

require 'test/unit'

class UserTest < Test::Unit::TestCase
  def setup
    @user = "me"
  end

  def test_full_name
    assert_equal("me", @user)
  end

  class ProfileTest < UserTest
    setup
    def setup_profile
      @user += ": profile"
    end

    def test_has_profile
      assert_match(/: profile/, @user)
    end
  end
end




describe "baidu", :type => :controller do
  describe "get index" do
   before{ response = Faraday.get 'http://sushi.com/nigiri/sake.json' }
   it{ 
   }
  end
  describe "GET 'index'" do
    before { get "http://baidu.com/" }
    it { should respond_with(:success) }
  end
  describe "GET 'not exists'" do
    before { get "http://baidu.com/ooxx" }
    it { should respond_with(:not_found) }
  end
end

# describe Person do
#   describe "#hello" do
#     let(:name) { "Steve" }
#     let(:person) { Person.new name }
#     subject { person.hello }
#     it { should eq("hello #{name}") }

#     it { expect(user.confirmation_sent_at).not_to be_nil }
#   end 
# end

# describe RegistrationsController do
#   describe "POST 'create'" do
#     context "exist user" do
#       let(:user) { create :user }
#       context "valid password" do
#         before { post :create, username: user.username, password: user.password }
#         it { should respond_with(:redirect) }
#       end
#       context "invalid password" do
#         before { post :create, username: user.username, password: "ooxx" }
#         fit { should respond_with(:success) }
#       end
#     end

#     context "non-exists user" do
#       before { post :create, username: 'ooxx', password: 'ooxx' }
#       it { should respond_with(:success) }
#     end

#     context "api" do
#       before { Net::HTTP.get(URI.parse('http://www.google.com')) }
#       fit { 
#         json = response.body
#         expect(json.count).to be(2)
#         expect(json.first["name"]).to eq("Bevis")
#       }
#     end
#   end
# end

# rspec spec/controllers/a.rb -t focus
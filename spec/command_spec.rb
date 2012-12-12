require 'rspec'
BOT_ROOT        = File.join(File.dirname(__FILE__), '..')
BOT_ENVIRONMENT = 'development'

require File.join(File.dirname(__FILE__), '../lib/bot.rb')
bot = CampfireBot::Bot.instance
require "#{BOT_ROOT}/lib/event.rb"


class TestingCommand < CampfireBot::Event::Command

  def filter_message(msg)
    super
  end
end

describe "processing messages" do
  
  before(:all) do
    bot = CampfireBot::Bot.instance
    @nickname = bot.config['nickname']
  end
  
  before(:each) do
    @command = TestingCommand.new("command", nil, nil)
  end  
    
  def match?(msg)
    @command.match?({:message => msg})
  end
  
  describe "and recognizing a command" do
    
    it "should handle a !command" do
      match?("!command").should be_true
    end
  
    it "should handle a !command with arguments" do
      match?("!command foo").should be_true
    end
  
    it "should handle a command with nickname and a comma" do
      match?("#{@nickname}, command").should be_true
    end
  
    it "should handle a command with nickname and a colon" do
      match?("#{@nickname}: command").should be_true
    end
  
    it "should handle a command with nickname and arguments" do
      match?("#{@nickname}, command foo").should be_true
    end
  
    it "should ignore a non-matching !command" do
      match?("!foo").should be_false
    end
  
    it "should ignore an addressed non-command" do
      match?("#{@nickname}, nothing").should be_false
    end
  
    it "should ignore things that aren't commands at all" do
      ["nothing", "#{@nickname}, ", " ! command", "hey #{@nickname}", "!command!command", "!command,command"].each do |t|
        match?(t).should be_false
      end
    end
  end
  
  describe "and filtering it" do
    
    def filter(msg)
      @command.filter_message({:message => msg})[:message]
    end

    it "should be empty with no arguments" do
      filter("!command").should == ""
      filter("#{@nickname}, command").should == ""
    end
    
    it "should return one argument" do
      filter("!command foo").should == "foo"
      filter("#{@nickname}, command foo").should == "foo"
    end
    
    it "should return more than one argument" do
      filter("!command foo bar baz").should == "foo bar baz"
      filter("#{@nickname}, command foo bar baz").should == "foo bar baz"
    end
    
    it "should deal with some weirdness" do
      filter("!command !command").should == "!command"
    end
    
  end
end


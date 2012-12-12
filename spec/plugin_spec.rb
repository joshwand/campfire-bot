require 'rspec'
BOT_ROOT        = File.join(File.dirname(__FILE__), '..')
BOT_ENVIRONMENT = 'test'

require File.join(File.dirname(__FILE__), '../lib/bot.rb')
bot = CampfireBot::Bot.instance

describe "config_var method" do
  class ExamplePlugin < CampfireBot::Plugin
    config_var :foo, "default foo"
  end

  def setup_plugin(klass, config={})
    @bot = CampfireBot::Bot.instance
    @bot.stub!(:config).and_return({'nickname' => 'Bot'}.merge(config))
    @plugin = klass.new
    CampfireBot::Plugin.registered_plugins[klass.to_s] = @plugin
  end

  it "should setup default bug_url value" do
    setup_plugin ExamplePlugin
    @plugin.foo.should == "default foo"
  end

  it "should allow override of parameter via configuration" do
    setup_plugin ExamplePlugin, 'example_plugin_foo' => 'bar'
    @plugin.foo.should == "bar"
  end

  it "should keep defaults for two classes separate" do
    class ExamplePlugin2 < CampfireBot::Plugin
      config_var :bar, "default bar"
    end
    setup_plugin ExamplePlugin
    plugin = @plugin
    setup_plugin ExamplePlugin2
    plugin.instance_variable_get(:@foo).should == "default foo"
    @plugin.instance_variable_get(:@bar).should == "default bar"
    # Used to fail with value "default bar"
    plugin.instance_variable_get(:@bar).should == nil
    @plugin.instance_variable_get(:@foo).should == nil
  end
end

require 'pony'

class Standup < CampfireBot::Plugin

  on_command 'standup', :standup

  def initialize
    @config = YAML::load(ERB.new(File.read("#{BOT_ROOT}/standup-config.yml")).result)[BOT_ENVIRONMENT]
  end

  def standup(msg)
    bot.log.debug "sending standup email to #{to_addresses}"

    Pony.mail({
      :to => to_addresses,
      :from => from(msg),
      :subject => subject,
      :body => msg[:message]
    }.merge(pony_options))

    msg.speak "Sent standup email to #{to_addresses.join(', ')}"
  end

  private

  def from(msg)
    msg[:user][:email_address]
  end

  def to_addresses
    @config['to']
  end

  def subject
    @config['subject']
  end

  def pony_options
    @config['pony_options']
  end
end

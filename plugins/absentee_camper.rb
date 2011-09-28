require 'plugin'

module AbsenteeCamper
  autoload :NotificationManager, "#{BOT_ROOT}/plugins/absentee_camper/notification_manager"
  autoload :EmailNotifier, "#{BOT_ROOT}/plugins/absentee_camper/email_notifier"
  autoload :ProwlNotifier, "#{BOT_ROOT}/plugins/absentee_camper/prowl_notifier"
  autoload :Config, "#{BOT_ROOT}/plugins/absentee_camper/config"
  autoload :Logger, "#{BOT_ROOT}/plugins/absentee_camper/logger"

  class CampfirePlugin < CampfireBot::Plugin
    include Config
    on_message /@\w+/i, :role_call

    def initialize
      config_store = Config::ConfigStore.instance
      config_store.root_config = bot.config
      config_store.plugin_config = bot.config['absentee_camper']

      Logger.instance.log = bot.log
    end

    def role_call(msg)
      room = msg[:room]

      body = msg['body']
      body.scan(/@\w+/).each do |mention|
        mentioned = mention[1..-1]
        if plugin_config['users'].keys.include? mentioned
          # If the user isn't in the room, fire off a notification
          unless room.users.map { |u| u['id'] }.include? user_id_from_config(mentioned)
            NotificationManager.new(room, plugin_config['users'][mentioned]).send_notifications body
            room.speak("[Notified #{mentioned}]")
          end
        end
      end
    end

    private

    def user_id_from_config(mentioned)
      if plugin_config['users'][mentioned].is_a? Hash
        user_id = plugin_config['users'][mentioned]['id']
      else
        user_id = plugin_config['users'][mentioned]
      end
    end
  end

  module Helpers
    def room_uri(room)
      "https://#{root_config['site']}.campfirenow.com/room/#{room.id}"
    end
  end
end

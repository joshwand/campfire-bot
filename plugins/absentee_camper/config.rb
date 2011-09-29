module AbsenteeCamper
  module Config

    def root_config
      bot.config
    end

    def plugin_config
      ConfigStore.instance.plugin_config
    end

    class ConfigStore
      include Singleton

      def initialize
        self.plugin_config = YAML::load(ERB.new(File.read("#{BOT_ROOT}/absentee-camper-config.yml")).result)[BOT_ENVIRONMENT]
      end

      attr_accessor :root_config
      attr_accessor :plugin_config
    end
  end
end

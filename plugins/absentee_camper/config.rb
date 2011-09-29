module AbsenteeCamper
  module Config

    def root_config
      bot.config
    end

    def plugin_config
      PluginConfig.instance.config
    end

    class PluginConfig
      include Singleton

      def initialize
        self.config = YAML::load(ERB.new(File.read("#{BOT_ROOT}/absentee-camper-config.yml")).result)[BOT_ENVIRONMENT]
      end

      attr_accessor :config
    end
  end
end

module AbsenteeCamper
  module Config

    def root_config
      ConfigStore.instance.root_config
    end

    def plugin_config
      ConfigStore.instance.plugin_config
    end

    class ConfigStore
      include Singleton

      attr_accessor :root_config
      attr_accessor :plugin_config
    end
  end
end

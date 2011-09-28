module AbsenteeCamper
  class NotificationManager

    def initialize(room, user_config)
      if user_config.is_a?(Hash) and user_config['notification_methods']
        user_config['notification_methods'].each do |notifier, initialization_info|
          add_notifier AbsenteeCamper.const_get("#{notifier}Notifier".to_sym).new(room, initialization_info)
        end
      else
        # Everyone gets Email notifications if no other notifier is defined.
        # In this case, user_config is the user_id.

        Logger.instance.debug "No notification methods defined.  Falling back to email notifications."
        @notifiers = [EmailNotifier.new(room, user_config)]
      end
    end

    def send_notifications(message)
      @notifiers.each { |notifier| notifier.notify message }
    end

    private

    def add_notifier(notifier)
      @notifiers ||= []
      @notifiers << notifier
    end
  end
end

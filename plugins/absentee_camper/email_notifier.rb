require 'pony'

module AbsenteeCamper
  class EmailNotifier
    include Config
    include Helpers

    def initialize(room, user_id)
      @email_address = room.user(user_id)['email_address']
      @room = room
    end

    def notify(message)
      Logger.instance.debug "sending email to #{@email_address}"
      Pony.mail({
        :to => @email_address,
        :body => email_body(message)
      }.merge(pony_options))
    end

    private

    def email_body(message)
      body = <<-BODY
Come back to the campfire!  We're having a good time telling ghost stories!  Here's one you missed:

#{message}

#{room_uri(@room)}
      BODY
    end

    def pony_options
      plugin_config['pony_options']
    end
  end
end

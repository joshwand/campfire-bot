require 'prowl'

module AbsenteeCamper
  class ProwlNotifier
    include Config
    include Helpers

    def initialize(room, api_key)
      @api_key = api_key
      @room = room
    end

    def notify(message)
      Logger.instance.debug "sending prowl notification"
      Prowl.add(:apikey => @api_key,
                :application => 'Campfire',
                :event => @room.name,
                :description => message,
                :url => room_uri(@room))
    end
  end
end

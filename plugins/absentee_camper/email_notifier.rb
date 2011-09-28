require 'pony'

module AbsenteeCamper
  class EmailNotifier
    include Config
    include Helpers

    def initialize(room, user_id)
      @email_address = room.user(user_id)['email_address']
      @room = room
      configure_pony
    end

    def notify(message)
      Logger.instance.debug "sending email to #{@email_address}"
      ::Pony.mail :to => @email_address, :body => email_body(message)
    end

    private

    def email_body(message)
      body = <<-BODY
Come back to the campfire!  We're having a good time telling ghost stories!  Here's one you missed:

#{message}

#{room_uri(@room)}
      BODY
    end

    def configure_pony
      ::Pony.options = {
        # Uncomment for use with Gmail
        #
        #:via => :smtp, :via_options => {
        #:address              => 'smtp.gmail.com',
        #:port                 => '587',
        #:enable_starttls_auto => true,
        #:user_name            => 'your username',
        #:password             => 'your password',
        #:authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
        #:domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
        #},
        :from => "Absentee Camper <campfire-#{root_config['site']}@#{plugin_config['replyto_email_domain']}>",
        :subject => '[Campfire] People are talking about you!'
      }

      if plugin_config['smtp']
        ::Pony.options.merge!({
          :via => :smtp,
          :via_options => {
            :address => plugin_config['smtp']['address'] || 'localhost',
            :port => plugin_config['smtp']['port'] || '25',
            :domain => plugin_config['smtp']['domain'],
            :enable_starttls_auto => plugin_config['smtp']['enable_starttls_auto'] || false,
            :authentication => plugin_config['smtp']['authentication'] || :plain,
            :user_name => plugin_config['smtp']['username'],
            :password => plugin_config['smtp']['password']
          }
        })
      end
    end
  end
end

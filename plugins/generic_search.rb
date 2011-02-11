require 'cgi'
require 'net/http'

#
# Search sites like Google and Wikipedia
#
# You configure the command name and URL pattern.  Given a search
# term, it attempts to respond with the URL of the first search
# result.  It does so by simply inserting the term into the URL at the
# '%s'.  If the url redirects, it responds with the redirect target
# instead, so you get a hint about what you'll see.  Otherwise, you
# get just the expanded url pattern.
#
# This is useful for a wide range of sites.  Sample config:
#
# generic_search_commands:
#   wikipedia: "http://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go"
#   google: "http://www.google.com/search?hl=en&q=%s&btnI=I'm+Feeling+Lucky&aq=f&oq="
#   php: "http://us3.php.net/manual-lookup.php?pattern=%s&lang=en"
#   letmegooglethatforyou: "http://letmegooglethatforyou.com/?q=%s"
#
# Note that the last site never redirects, which is fine.
#
class GenericSearch < CampfireBot::Plugin
  attr_reader :commands

  def initialize
    @commands = bot.config["generic_search_commands"] || {}
    commands.each { |c, s|
      method = "do_#{c}_command".to_sym
      self.class.send(:define_method, method) {|msg|
        msg.speak(http_peek(sprintf(s, CGI.escape(msg[:message]))))
      }
      self.class.on_command(c, method)
    }
  end

  protected

  # Follow the url just enough to see if it redirects.  If so,
  # return the redirect.  Otherwise, return the original.
  def http_peek(url)
    uri = URI.parse url
    http = Net::HTTP.new(uri.host, uri.port)

    # Unfortunately the net/http(s) API can't seem to do this for us,
    # even if we require net/https from the beginning (ruby 1.8)
    if uri.scheme == "https"
      require 'net/https'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    res = http.start { |http|
      req = Net::HTTP::Get.new uri.request_uri
      #req.basic_auth u, p
      response = http.request req
    }
    case res
    when Net::HTTPRedirection
      uri.merge res.header['Location']
    else # Net::HTTPSuccess or error
      url
    end.to_s
  end
end

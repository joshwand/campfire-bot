# Courtesy of joshwand (http://github.com/joshwand)
class Seen < CampfireBot::Plugin
  ACTIVITY_REGEXP = /^(.*)$/
  SEEN_REGEXP = /([^\?]+)(?=\?)*/
  
  on_message Regexp.new("#{ACTIVITY_REGEXP.source}", Regexp::IGNORECASE), :update
  on_command 'seen', :seen
  on_command 'reload_seen', :reload
  
  def initialize
    @data_file  = File.join(BOT_ROOT, 'tmp', "seen-#{BOT_ENVIRONMENT}.yml")
    @seen       = YAML::load(File.read(@data_file)) rescue {}
  end
  
  def update(msg)
    left_room = (msg[:message] == "has left the room " ? true : false)
    @seen[msg[:person]] = {:time => Time.now, :left => left_room}
 
    File.open(@data_file, 'w') do |out|
      YAML.dump(@seen, out)
    end
  end
  
  def seen(msg)
    found = false
    msg[:message] =~ SEEN_REGEXP
    
    if !$1.nil?
      first_name = $1.match("[A-Za-z]+")[0]
      
      @seen.each do |person, seenat|
        if person.downcase.include?(first_name.downcase)
          time_ago = time_ago_in_words(seenat[:time])
          left = seenat[:left] ? "leaving the room " : ""
          msg.speak("#{person} was last seen #{left}#{time_ago} ago")
          found = true
        end
      end
      
      if !found
        msg.speak("Sorry, I haven't seen #{first_name}.")
      end
      
    end
  end
  
  def reload(msg)
    @seen = {}
    msg.speak("ok, reloaded seen db")
  end
  
  protected
  
  def time_ago_in_words(from_time, include_seconds = false)
    distance_of_time_in_words(from_time, Time.now, include_seconds)
  end
  
  def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round
 
    case distance_in_minutes
      when 0..1
        return (distance_in_minutes == 0) ? 'less than a minute' : '1 minute' unless include_seconds
        case distance_in_seconds
          when 0..4   then 'less than 5 seconds'
          when 5..9   then 'less than 10 seconds'
          when 10..19 then 'less than 20 seconds'
          when 20..39 then 'half a minute'
          when 40..59 then 'less than a minute'
          else             '1 minute'
        end
 
        when 2..44           then "#{distance_in_minutes} minutes"
        when 45..89          then 'about 1 hour'
        when 90..1439        then "about #{(distance_in_minutes.to_f / 60.0).round} hours"
        when 1440..2879      then '1 day'
        when 2880..43199     then "#{(distance_in_minutes / 1440).round} days"
        when 43200..86399    then 'about 1 month'
        when 86400..525599   then "#{(distance_in_minutes / 43200).round} months"
        when 525600..1051199 then 'about 1 year'
        else                      "over #{(distance_in_minutes / 525600).round} years"
    end
  end
end

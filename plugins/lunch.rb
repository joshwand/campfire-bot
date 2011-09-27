require 'yaml'

# Lunch Picker
# Add 'lunch_locations' array to the config.yml. This will seed the storage backend.

class Lunch < CampfireBot::Plugin
  on_command 'lunch', :lunch
  on_command 'add_location', :add_location
  on_command 'delete_location', :delete_location
  
  def initialize
    @log = Logging.logger["CampfireBot::Plugin::Lunch"]
    @data_file = File.join(BOT_ROOT, 'var', 'lunch_locations.yml')
    begin
      @locations = YAML::load(File.read(@data_file))
    rescue Errno::ENOENT => e
      @locations = bot.config['lunch_locations']
      write_locations_to_file
    end
  end
  
  def lunch(msg)
    msg.speak "I think we should go to #{pick_location} for lunch!"
  end
  
  def add_location(msg)
    if msg[:message].empty?
      msg.speak "Please include the location you'd like to add."
      return
    end
    if @locations.include? msg[:message]
      msg.speak "I already know about #{msg[:message]}."
    else
      @locations.push msg[:message]
      write_locations_to_file
      msg.speak "I'll be sure to remember #{msg[:message]} for next time."
    end
  end
  
  def delete_location(msg)
    if @locations.include? msg[:message]
      @locations.delete msg[:message]
      write_locations_to_file
      msg.speak "I'll forget about #{msg[:message]}."
    else
      msg.speak "I don't know about #{msg[:message]}"
    end
    
  end
  
  def pick_location
    return @locations.shuffle.first
  end
  
  def write_locations_to_file
    File.open("#{@data_file}.tmp", 'w') do |out|
      YAML.dump(@locations, out)
    end
    File.rename("#{@data_file}.tmp", @data_file)
  end
end
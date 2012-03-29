class Fun < CampfireBot::Plugin
  on_command    'say',              :say
  on_message    Regexp.new("^#{bot.config['nickname']},\\s+(should|can|will|shall) (i|he|she|we|they) do it\\?", Regexp::IGNORECASE), :do_or_do_not
  on_message    Regexp.new("^(good morning|morning|m0ink|hello|hi|hey|whassup|what's up|yo|hola|ola|'sup|sup)(,)*\\s*(#{bot.config['nickname']}).*$", Regexp::IGNORECASE), :greet
  on_message  /(how's it|how are|how're) (ya |you )*(going|doing|doin).*/, :howareya
  on_command    "blame", :blame
  on_command    "trout", :trout
  on_command    "slap", :trout
  on_command    "troutslap", :trout
  # on_speaker    'Tim R.',           :agree_with_tim
  # on_message    /undo it/i,         :do_it
  # on_message    /(^|\s)do it/i,     :undo_it
  # at_time       1.minute.from_now,  :do_it

  def initialize
    @last_agreed = 20.minutes.ago
    @log = Logging.logger["CampfireBot::Plugin::Fun"]
  end
  
  def say(m)
    m.speak(m[:message])
  end
  
  def do_it(m = nil)
    m.speak('Do it!')
  end
  
  def undo_it(m)
    m.speak('Undo it!')
  end
  
  def do_or_do_not(m)
    responses = ['Do it!', 'Don\'t do it!', 'Undo it!']
    m.speak(responses.choice)
  end
  
  def agree_with_tim(m)
    m.speak('I agree with Tim.') unless @last_agreed > 15.minutes.ago
    @last_agreed = Time.now
  end
  
  def greet(m)
    messages = ['Howdy', 'Wassup', 'Greets', 'Hello', 'Hey there', "It's a", 'Good day']
    m.speak("#{messages.choice} #{m[:person].split(' ')[0]}")
  end
  
  def howareya(m)
    messages = ["just great", "peachy", "mas o menos", 
    	 "you know how it is", "eh, ok", "pretty good. how about you?"]
    m.speak(messages[rand(messages.size)])
  end
  
  def blame(m)
    # TODO: capture user-submitted entries to a yaml file and regurgitate them
    # TODO: put all the default ones in a separate yaml
    if m[:message].strip.length > 0
      blamed = m[:message].strip
    else
      users = m[:room].users.delete_if {|u| u[:name] == bot.campfire.me[:name]}.map {|u| u[:name]}
      others = ["nobody", "my", "Microsoft", "Steve Jobs", "the terrorists", "your", 
                "Project Management", "Development", "Management", "Corporate", "Cartman", "the user", 
                "the liberal media", "Wall Street"]
      
      # mostly blame the other users
      if rand(10) >= 2
        blamed = users.choice
      else 
        blamed = others.choice
      end
      
    end
    
    case blamed
    when "nobody"
      blamestring = "It's nobody's fault"
    when "your", "my"
      blamestring = "It's all #{blamed} fault"
    else
      blamestring = "It's all #{blamed}'s fault"
      blamestring = "It's all #{blamed}' fault" if blamed[-1].chr == "s"
    end
   
    m.speak blamestring
  end
  
  def trout(m)
    if m[:message].strip.length > 0
      selected_user_name = m[:message].strip
    else
      users = m[:room].users.map{|u| u[:name] }
      selected_user_name = users.choice
    end
    m.speak("#{m[:person]} slaps #{selected_user_name} #{["upside the head", "in the face", "on the rear", "where it counts", "in the knees", "ineffectually", "in the elbow", "on the funny bone", "in the ear", "on the nose", "in the teeth"].choice} with a #{%w(good-sized large decaying moldy spiked sabre-toothed surprised disappointed dramatic enraged rabid bug-eyed rotten foul-smelling demonic cluestick-holding).choice} trout")
  end
end

module Journalist

  def Journalist.report_espionage_messages(start_page, end_page)
    message_page = Journalist.to_page(:espionage, 1)
    page_count = message_page.search("li.curPage").text.split("/")[1].to_i
    if page_count == 0
      raise "turn_to message failed or no message"
    elsif page_count < end_page
      end_page = page_count
    end

    for i in start_page..end_page
      begin
        puts "reporting page #{i}"
        message_page = Journalist.to_page(:espionage, i)
        message_page.search("span.msg_title").each do |r|
          message = r.parent.parent

          is_moon = false
          is_moon = true if message.search("figure.moon").to_s != ""
          position = message.search("a.txt_link").first.text[/\[(.*?)\]/, 1]

          Journalist.record_espionage(message, position, is_moon)
        end
      rescue
        begin
          Account.instance.login
        rescue
          retry
        end
        retry
      end
      # puts "[Journalist] page #{i}, didn't found"
    end
    return true
  end

  def Journalist.report_newest_message(position, type, deep = false, moon = false)
    # message_page = $AGENT.get Settings.s131.pages.messages
    message_page = Journalist.to_page(type, 1)
    # message_page.search("span.msg_title")

    page_count = message_page.search("li.curPage").text.split("/")[1].to_i
    if page_count == 0
      puts "turn to page unsuccessful"
    end

    puts "begin to report #{type} message on #{position}"
    found_it = false
    for i in 1..7
      message_page = Journalist.to_page(type, i)
      message_page.search("span.msg_title").each do |r|
        message = r.parent.parent

        is_moon = false
        is_moon = true if message.search("figure.moon").to_s != ""

        found_it = true if position == message.search("a.txt_link").first.text[/\[(.*?)\]/, 1] and moon == is_moon

        if found_it
          Journalist.record_espionage(message, position)
          return true
        end
      end
      puts "[Journalist] page #{i}, didn't found"
    end
    return false
  end

  def Journalist.get_number(number)
    if number.include? "M"

      return (number.gsub(" ", "").gsub("M", "").to_f * 1000000).to_i
    else
      return number.gsub(".", "").gsub("%", "").gsub(" ", "").to_i
    end
  end

  def Journalist.record_espionage(message, position, is_moon = false)
    puts "[Journalist]report planet at #{position}"

    planet = Planet.find_by(position: position)

    time = message.search("span.msg_date.fright").text.to_time
    at = Time.new(time.year,time.month,time.day,time.hour,time.min,time.sec, "+00:00")
    report_time = ActiveSupport::TimeZone.new('London').local_to_utc(at).getlocal

    if planet == nil
      puts "can't found this planet in database"
      return false
    elsif report_time < planet.updated_at
      puts "this message is too old"
      return false
    end
    # puts message

    metal = Settings.unknow
    crystal = Settings.unknow
    deuterium = Settings.unknow
    if message.search("span.status_abbr_inactive").empty?
      is_idle = true
    else
      is_idle = false
    end
    puts "is_idle: #{is_idle}"

    message.search("span.resspan").each_with_index do |m, i|
      # puts m
      # puts i
      case i
      when 0
        metal = get_number(m.text.split(":")[1])
        puts "--metal #{metal}"
      when 1
        crystal = get_number(m.text.split(":")[1])
        puts "--crystal #{crystal}"
      when 2
        deuterium = get_number(m.text.split(":")[1])
        puts "--deuterium #{deuterium}"
      end
    end

    counter_espionage = Settings.unknow
    fleets_value = Settings.unknow
    defence_value = Settings.unknow
    resource_sum = Settings.unknow
    loot = Settings.unknow
    activity = Settings.unknow

    message.search("span.ctn.ctn4").each do |s|
      case s.text.split(":")[0]
      when "Activity"
        activity =  s.text.split(":")[1]
        puts "--activity #{activity}"
      when "Resources"
        resource_sum =  get_number(s.text.split(":")[1])
        puts "--resource_sum #{resource_sum}"
      when "Loot"
        loot = get_number(s.text.split(":")[1])
        puts "--loot #{loot}"
      when "Fleets"
        fleets_value = get_number(s.text.split(":")[1])
        puts "--fleets_value #{fleets_value}"
      when "Defence"
        defence_value = get_number(s.text.split(":")[1])
        puts "--defence_value #{defence_value}"
      end
    end

    message.search("span.fright").each do |s|
      case s.text.split(":")[0]
      when "Chance of counter-espionage"
        counter_espionage = get_number(s.text.split(":")[1])
        puts "--counter_espionage #{counter_espionage}"
      end
    end

    planet.counter_espionage = counter_espionage
    planet.fleets_value = fleets_value
    if planet.defence_value == Settings.unknow
      planet.defence_value = defence_value
    elsif defence_value != Settings.unknow
      planet.defence_value = defence_value
    end

    planet.resource_sum = resource_sum
    planet.resource_value = metal + crystal * 1.5 + deuterium * 3.0
    planet.loot = loot
    planet.activity = activity

    if message.search("span.status_abbr_inactive.tooltip.js_hideTipOnMobile").text != ""
      planet.empire.update(status: message.search("span.status_abbr_inactive.tooltip.js_hideTipOnMobile").text)
    end

    if planet.resource == nil
      resource = Resource.new do |resource|
        resource.metal = metal
        resource.crystal = crystal
        resource.deuterium = deuterium
        resource.planet = planet
      end
      resource.save
      planet.resource
    else
      planet.resource.metal = metal
      planet.resource.crystal = crystal
      planet.resource.deuterium = deuterium
      planet.resource.save
    end

    if !is_idle
      planet.empire.update(status: "")
    end

    planet.save
  end

  # def Journalist.search_report(tab_name, page_number, position, type)
  #
  # end

  # Journalist.to_page :espionage, 1
  def Journalist.to_page(tab_name, page_number)
    page = $AGENT.post(Settings.s131.pages.messages, {
      "messageId" => "-1",
      "tabid" => "#{Settings.messages_tab[tab_name]}",
      "action" => "107",
      "pagination" => "#{page_number}"
    })
  end

  # Journalist.to_tab :espionage
  def Journalist.to_tab(tab_name)
    page = $AGENT.post(Settings.s131.pages.messages, {
      "page" => "messages",
      "tab" => Settings.messages_tab[tab_name]
    })
  end


end

# 4>3 post
# messageId:-1
# tabid:20
# action:107
# pagination:3
# ajax:1
#
# 3>2
# messageId:-1
# tabid:20
# action:107
# pagination:2
# ajax:1
#
# 2>1
# messageId:-1
# tabid:20
# action:107
# pagination:1
# ajax:1
#
# to_combat
# page:messages
# tab:21
# ajax:1
#
# combat_3
# messageId:-1
# tabid:21
# action:107
# pagination:3
# ajax:1
#
# to_message
# page:messages
# tab:20
# ajax:1
#
# other
# page:messages
# tab:24
# ajax:1
#
# union  get
# page:messages
# tab:23
# ajax:1
#
# expedition get
# page:messages
# tab:22
# ajax:1
#

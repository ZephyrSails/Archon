

module BlackEagle

  def BlackEagle.update_resource
    login_result = Account.instance.login
    "Light Fighter 0\n"
    fleet1_page.body.to_s[/Light Fighter (d*?)\n/, 1]
    puts login_result.body
    metal = eval(login_result.body.to_s[/metal":{"resources":(.*?),"tooltip":"Metal/, 1])
    Resource.find_by(name: "metal").update(available: metal[:actual], max: metal[:max], production: metal[:production])
    puts "actualFormat: #{metal[:actualFormat]}"
    puts "actual: #{metal[:actual]}"
    puts "max: #{metal[:max]}"
    puts "production: #{metal[:production]}"

    crystal = eval(login_result.body.to_s[/crystal":{"resources":(.*?),"tooltip":"Crystal/, 1])
    Resource.find_by(name: "crystal").update(available: crystal[:actual], max: crystal[:max], production: crystal[:production])
    puts "actualFormat: #{crystal[:actualFormat]}"
    puts "actual: #{crystal[:actual]}"
    puts "max: #{crystal[:max]}"
    puts "production: #{crystal[:production]}"

    deuterium = eval(login_result.body.to_s[/deuterium":{"resources":(.*?),"tooltip":"Deuterium/, 1])
    Resource.find_by(name: "deuterium").update(available: deuterium[:actual], max: deuterium[:max], production: deuterium[:production])
    puts "actualFormat: #{deuterium[:actualFormat]}"
    puts "actual: #{deuterium[:actual]}"
    puts "max: #{deuterium[:max]}"
    puts "production: #{deuterium[:production]}"

    energy = eval(login_result.body.to_s[/energy":{"resources":(.*?),"tooltip":"Energy/, 1])
    Resource.find_by(name: "energy").update(available: energy[:actual])
    puts "actualFormat: #{energy[:actualFormat]}"
    puts "actual: #{energy[:actual]}"
  end

  def BlackEagle.galaxy_report(gala)
    galaxy = []
    score = []
    for i in 1..499
      galaxy[i] = "#{i}"
      score[i] = ""
    end
    Planet.all.each do |p|
      if p.position.split(":")[0] == gala.to_s
        # if p.empire.status == "" or p.empire.status == nil
        if true and p.empire != nil
          galaxy[p.position.split(":")[1].to_i] += " #{p.position.split(":")[2]}:#{p.empire.rank}(#{p.empire.status})"
        end
      end
    end
    # puts galaxy
    puts galaxy

    # for i in 1..499
    #   for j in 1..499
    #     if (i-j).abs <= 30
    #       score[i] += galaxy[j]/ Math.sqrt(2700000+95000*(i-j).abs)
    #     elsif (i-j).abs <= 90
    #       score[i] += (galaxy[j]/ Math.sqrt(2700000+95000*(i-j).abs))/4
    #     # elsif (i-j).abs <= 160
    #     #   score[i] += (galaxy[j]/ Math.sqrt(2700000+95000*(i-j).abs))/4
    #
    #     end
    #   end
    # end

  end

  # rails runner "BlackEagle.weekly_update_galaxy"
  def BlackEagle.clean_universe
    $AGENT = Mechanize.new
    rank_page = $AGENT.get Settings.apis.players
    players_page = $AGENT.get Settings.apis.players
    $AGENT.open_timeout = 1.5
    $AGENT.read_timeout = 1.5
    api_ids = []
    players_page.search("player").each do |player|
      player_id = player.attribute("id").to_s.to_i
      api_ids << player_id
    end
    Empire.all.each do |empire|
      unless api_ids.include? empire.api_id.to_i
        puts "kick #{empire.api_id}"
        empire.destroy
        # empire.delete
      end
    end

    return true

  end
  # ActiveRecord::Base.logger.level = 1
  def BlackEagle.update_universe(begin_from = 0)
    # Settings.reload!
    $AGENT = Mechanize.new
    rank_page = $AGENT.get Settings.apis.players
    players_page = $AGENT.get Settings.apis.players
    $AGENT.open_timeout = 1.5
    $AGENT.read_timeout = 1.5

    players_page.search("player").each do |player|

      player_id = player.attribute("id").to_s.to_i

      if player_id <= begin_from
        next
      end
      puts player_id

      # next if player_id == "1" || player_id == "100000"

      player_status = player.attribute("status").to_s

      player_name = player.attribute("name").to_s
      alliance_api_id = player.attribute("alliance").to_s

      retry_time = 0
      begin
        player_page = $AGENT.get "#{Settings.apis.player}#{player_id}"
      rescue
        if retry_time < 5
          retry_time += 1
          retry
        else
          puts "nono"
          next
        end
      end

      begin
        player_rank = player_page.search("position").first.text.to_i
      rescue
        player_rank = nil
      end

      begin
        player_score = player_page.search("position").first.attribute("score").text.to_i
      rescue
        player_score = nil
      end

      empire = Empire.find_by(api_id: player_id)
      if empire == nil
        empire = Empire.new do |empire|
          empire.galaxy = Galaxy.find_by(id: 1)
          empire.api_id = player_id
          empire.status = player_status
          empire.name = player_name
          empire.alliance_api_id = alliance_api_id
          empire.rank = player_rank
          empire.score = player_score
        end
      else
        empire.status = player_status
        empire.name = player_name
        empire.rank = player_rank
        empire.score = player_score
        empire.alliance_api_id = alliance_api_id
      end
      player_page.search("position").each_with_index do |player, index|
        # puts Settings.score_type["#{index}"]
        # puts player.attribute("score").text.to_i
        empire[Settings.score_type["#{index}"]] = player.attribute("score").text.to_i
      end
      empire.save

      player_page.search("planet").each do |planet|
        planet_id = planet.attribute("id").to_s
        planet_name = planet.attribute("name").to_s
        planet_coords = planet.attribute("coords").to_s

        planet_model = Planet.find_by(api_id: planet_id)
        if planet_model == nil
          planet_model = Planet.new do |p|
            p.api_id = planet_id
            p.name = planet_name
            p.position = planet_coords
            p.empire = empire
          end
        else
          planet_model.name = planet_name
          planet_model.empire = empire
        end
        planet_model.save

        if planet.child != nil
          moon_id = planet.child.attribute("id").to_s
          moon_name = planet.child.attribute("name").to_s
          moon_size = planet.child.attribute("size").to_s

          moon_model = Moon.find_by(api_id: moon_id)
          if moon_model == nil
            moon_model = Moon.new do |m|
              m.api_id = moon_id
              m.name = moon_name
              m.size = moon_size
              m.planet = planet_model
            end
          else
            moon_model.name = moon_name
            moon_model.planet = planet_model
          end
          moon_model.save

        end
      end
    end
  end

  # rails runner "BlackEagle.search_land(2)"
  def BlackEagle.search_land(g)
    # Planet.joins(:empire).where("empires.status = ?", "i").order(:position).each do |p|

    galaxy = []
    score = []
    for i in 1..499
      galaxy[i] = 0
      score[i] = 0
    end
    Planet.order(:position).each do |p|

      if (p.empire.status == "i" or p.empire.status == "I") and p.empire.score.to_i > 10000 and p.position.split(":")[0] == g.to_s
        # puts "location: #{p.position}, score: #{p.empire.score}"
        # galaxy << {solor: p.position.split(":")[1], score: Math.sqrt(p.empire.score)}
        galaxy[p.position.split(":")[1].to_i] += Math.sqrt(p.empire.score)
      end
    end
    # puts galaxy

    for i in 1..499
      for j in 1..499
        if (i-j).abs <= 30
          score[i] += galaxy[j]/ Math.sqrt(2700000+95000*(i-j).abs)
        elsif (i-j).abs <= 90
          score[i] += (galaxy[j]/ Math.sqrt(2700000+95000*(i-j).abs))/4
        # elsif (i-j).abs <= 160
        #   score[i] += (galaxy[j]/ Math.sqrt(2700000+95000*(i-j).abs))/4

        end
      end
    end

    best_index = 0
    best_score = 0
    for i in 1..499
      if score[i] > best_score
        best_score = score[i]
        best_index = i
      end
      puts "#{i}: #{score[i]}"
    end
    puts "best pleace: #{g.to_s}:#{best_index}"
    return best_index
  end
end

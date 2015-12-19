module DroneNavy

  def DroneNavy.batch_send(positions, type="lc", espi_number=1, speed = 10, cargo = [0, 0, 0])
    from = Preference.planets[$PLANET][1]
    slot_count = Preference.free_slot
    retry_time = 3
    count_number = 0

    begin
      fleet1_page = $AGENT.get Settings.pages.fleet_1
      case type
      when "lc"
        ship_code = "am203"
        ship_name = "Large Cargo"
        mission = :attack
      when "espi"
        ship_code = "am210"
        ship_name = "Espionage Probe"
        mission = :espionage
      end
      start_with = fleet1_page.body.to_s[/#{ship_name}\s(.*+)\n/, 1][/\((.*)\)/, 1].to_i
    rescue
      Account.instance.login
      puts "failed 1"
      retry
    end

    puts "[DroneNavy] #{DateTime.now}, begin to batch, start with: #{start_with}"
    positions.each_with_index do |to, index|
      sleep 0.01
      # 2015-12-19 08:09:24
      case type
      when "lc"
        number_needed = to.need_large_cargo
      when "espi"
        number_needed = espi_number
      end
      begin
        ship_count = fleet1_page.body.to_s[/#{ship_name}\s(.*+)\n/, 1][/\((.*)\)/, 1].to_i

        if type == "espi"
          slot_used = start_with - ship_count
          General.count_fleet_alt(fleet1_page)
          while $CURRENT_FLEET[0] == $CURRENT_FLEET[1]
          # while slot_used == slot_count
            puts "[DroneNavy][#{index}/#{positions.length}]#{Time.now}:slot full, slot {#{$CURRENT_FLEET[0]}/#{$CURRENT_FLEET[1]}}"
            sleep 2
            fleet1_page = $AGENT.get Settings.pages.fleet_1
            # ship_count = fleet1_page.body.to_s[/#{ship_name}\s(.*+)\n/, 1][/\((.*)\)/, 1].to_i
            General.count_fleet_alt(fleet1_page)
          end
          fleet1_page = $AGENT.get Settings.pages.fleet_1
          puts "[DroneNavy][#{index}/#{positions.length}]#{Time.now}:fleet sending 1, slot {#{$CURRENT_FLEET[0]}/#{$CURRENT_FLEET[1]}}"
        else
          puts "[DroneNavy][#{index}/#{positions.length}]#{Time.now}:fleet sending 1, count #{number_needed}"
        end

        ship_choosen_form = fleet1_page.form_with :name => "shipsChosen"
        # large_cargo = to.need_large_cargo
        ship_choosen_form.field_with(:name => ship_code).value = number_needed
        ship_choosen_form.field_with(:name => "galaxy").value = from.split(":")[0].to_i
        ship_choosen_form.field_with(:name => "system").value = from.split(":")[1].to_i
        ship_choosen_form.field_with(:name => "position").value = from.split(":")[2].to_i
        ship_choosen_form.field_with(:name => "speed").value = speed

        fleet2_page = $AGENT.submit ship_choosen_form
        sleep 0.01
        details_form = fleet2_page.form_with :name => "details"
        details_form.field_with(:name => "mission").value = Settings.missions[mission]
        details_form.field_with(:name => "galaxy").value = to.position.split(":")[0].to_i
        details_form.field_with(:name => "system").value = to.position.split(":")[1].to_i
        details_form.field_with(:name => "position").value = to.position.split(":")[2].to_i
        puts "[DroneNavy][#{index}/#{positions.length}]#{Time.now}:fleet sending 2, to #{to.position}"

        fleet3_page = $AGENT.submit details_form
        sleep 0.01
        sending_form = fleet3_page.form_with :name => "sendForm"
        sending_form.field_with(:name => "metal").value = cargo[0]
        sending_form.field_with(:name => "crystal").value = cargo[1]
        sending_form.field_with(:name => "deuterium").value = cargo[2]
        final_page = $AGENT.submit sending_form
        count_number = final_page.body.to_s[/#{ship_name}\s(.*+)\n/, 1][/\((.*)\)/, 1].to_i

        if count_number != ship_count
          puts "[DroneNavy][#{index}/#{positions.length}]#{Time.now}: #{ship_count}=>#{count_number} fleet sent successful"
          fleet1_page = final_page
          if type != "espi"
            to.update_farm_count
          end
        elsif type != "espi"
          puts "[DroneNavy][#{index}/#{positions.length}]#{Time.now}: #{ship_count}=>#{count_number} something wrong"
          # raise ""
        end

      rescue => e
        puts e.message
        sleep 1
        Account.instance.login
        begin
          fleet1_page = $AGENT.get Settings.pages.fleet_1
        rescue

        end
        retry
      end
    end
    puts "#{start_with}=>#{count_number}"
  end








  def DroneNavy.send_fleet(from, to, mission, fleet, speed = 10, cargo = [0, 0, 0])
    retry_time = 3
    begin
      puts "[DroneNavy] #{DateTime.now}, begin to send_fleet to #{to}"
      fleet1_page = $AGENT.get Settings.pages.fleet_1
      sleep 0.01
      ship_choosen_form = fleet1_page.form_with :name => "shipsChosen"
      for i in 202..215
        next if i == 212
        ship_choosen_form.field_with(:name => "am#{i}").value = fleet[Settings.fleets["am#{i}"]].to_i
      end
      ship_choosen_form.field_with(:name => "galaxy").value = from.split(":")[0].to_i
      ship_choosen_form.field_with(:name => "system").value = from.split(":")[1].to_i
      ship_choosen_form.field_with(:name => "position").value = from.split(":")[2].to_i
      ship_choosen_form.field_with(:name => "speed").value = speed
      puts "--[DroneNavy] #{DateTime.now}, sending fleet, process 1 complished"

      fleet2_page = $AGENT.submit ship_choosen_form
      sleep 0.01
      details_form = fleet2_page.form_with :name => "details"
      details_form.field_with(:name => "mission").value = Settings.missions[mission]
      details_form.field_with(:name => "galaxy").value = to.split(":")[0].to_i
      details_form.field_with(:name => "system").value = to.split(":")[1].to_i
      details_form.field_with(:name => "position").value = to.split(":")[2].to_i
      puts "--[DroneNavy] #{DateTime.now}, sending fleet, process 2 complished"

      fleet3_page = $AGENT.submit details_form
      sleep 0.01
      sending_form = fleet3_page.form_with :name => "sendForm"
      sending_form.field_with(:name => "metal").value = cargo[0]
      sending_form.field_with(:name => "crystal").value = cargo[1]
      sending_form.field_with(:name => "deuterium").value = cargo[2]
      puts "--[DroneNavy] #{DateTime.now}, sending fleet, process 3 complished"
      final_page = $AGENT.submit sending_form

      puts "--[DroneNavy] #{DateTime.now}, fleet sent successful"
      return true
    rescue
      retry_time -= 1
      if retry_time > 0
        puts "--[DroneNavy] #{DateTime.now}, something went wrong, retry #{retry_time} times"
        retry
      else
        puts "--[DroneNavy] #{DateTime.now}, no retry_time left, relogin"
        raise
        retry
      end
    end
  end

end

# def mini_spy(from, to)
#   galaxy_page = $AGENT.get "http://s131-en.ogame.gameforge.com/game/index.php?page=galaxy"
#   galaxy_form = galaxy_page.form_with :name => "galaform"
#   galaxy_form.field_with(:name => galaxy).value = ""
#
# end


# 10+{35000/%×开方[(1000000+星球数差×5000)/speed]}
# 1005000
# 0:30:57
# 1002.496882788171
# 1004.987562112089
# 10+{35000/%×开方[(2700000+太阳系数差×95000)/speed]}
# 1671.825349730049
# 0:51:27 h
# 10+[35000/%×开方(银河系数差×20000000/有效速度)]
#
# (10+350/percentage*SQRT((1000000+DiffP*5000)/speed))
#
# 10(35000/%* √((1000000+planets*5000)/speed) )
#
# 10+350/
#
# 10+(35000/%*radical((1000000+planets*5000)/speed))
#
# 1005000/4000*3
# 15.85086748414736

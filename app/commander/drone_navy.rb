module DroneNavy

  def DroneNavy.send_fleet(from, to, mission, fleet, speed = 10, cargo = [0, 0, 0])
    retry_time = 3
    begin
      puts "[DroneNavy] begin to send_fleet to #{to}"
      fleet1_page = $AGENT.get "http://s131-en.ogame.gameforge.com/game/index.php?page=fleet1"
      sleep 1
      ship_choosen_form = fleet1_page.form_with :name => "shipsChosen"
      for i in 202..215
        next if i == 212
        ship_choosen_form.field_with(:name => "am#{i}").value = fleet[Settings.fleets["am#{i}"]].to_i
      end
      ship_choosen_form.field_with(:name => "galaxy").value = from.split(":")[0].to_i
      ship_choosen_form.field_with(:name => "system").value = from.split(":")[1].to_i
      ship_choosen_form.field_with(:name => "position").value = from.split(":")[2].to_i
      ship_choosen_form.field_with(:name => "speed").value = speed
      puts "--[DroneNavy], sending fleet, process 1 complished"

      fleet2_page = $AGENT.submit ship_choosen_form
      sleep 1
      details_form = fleet2_page.form_with :name => "details"
      details_form.field_with(:name => "mission").value = Settings.missions[mission]
      details_form.field_with(:name => "galaxy").value = to.split(":")[0].to_i
      details_form.field_with(:name => "system").value = to.split(":")[1].to_i
      details_form.field_with(:name => "position").value = to.split(":")[2].to_i
      puts "--[DroneNavy], sending fleet, process 2 complished"

      fleet3_page = $AGENT.submit details_form
      sleep 1
      sending_form = fleet3_page.form_with :name => "sendForm"
      sending_form.field_with(:name => "metal").value = cargo[0]
      sending_form.field_with(:name => "crystal").value = cargo[1]
      sending_form.field_with(:name => "deuterium").value = cargo[2]
      puts "--[DroneNavy], sending fleet, process 3 complished"
      final_page = $AGENT.submit sending_form

      puts "--[DroneNavy], fleet sent successful"
      return true
    rescue
      retry_time -= 1
      if retry_time > 0
        puts "--[DroneNavy], something went wrong, retry #{retry_time} times"
        retry
      else
        puts "--[DroneNavy], no retry_time left, relogin"
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

module Archivist
  def Archivist.get_planet_i_from(galaxy)
    planet_i = []
    for i in 1..499
      planet_i[i] = []
    end

    Planet.all.each do |p|
      begin
        planet_i[p.get_solor.to_i][p.get_pos.to_i] = p if p.is_idle? and p.get_galaxy.to_i == galaxy.to_i
      rescue
      end
    end

    return planet_i
  end

  def Archivist.get_planet_i_close_to(position)
    positions = []
    Planet.all.each do |planet|
      positions << planet.position if planet.is_idle? and planet.is_less_flight_time?(position)
    end
    return positions
  end

  def Archivist.get_deep_espionage_target_close_to(position)
    positions = []
    Planet.all.each do |planet|
      positions << planet.position if planet.is_idle? and planet.is_less_flight_time?(position)
    end
    return positions
  end

  # positions = Archivist.get_positions(Archivist.options_light_spy)
  def Archivist.options_light_spy()
    options = {
      is_idle?: [true],
      is_less_flight_time?: [true, "1:410:4", 15000, 3000],
      is_defence_unknow?: [true]
    }
  end

  def Archivist.options_close_idle()
    options = {
      is_idle?: [true],
      is_less_flight_time?: [true, "1:410:4"],
      is_safe_to_espionage?: [true]
    }
  end

  def Archivist.options_close_idle_unknow()
    options = {
      is_idle?: [true],
      is_less_flight_time?: [true, "1:410:4", 15000, 3000],
      is_safe_to_espionage?: [true],
      is_defence_unknow?: [true]
    }
  end

  def Archivist.options_close_idle_safe(from = "1:410:4")
    options = {
      is_idle?: [true],
      is_less_flight_time?: [true, from, 15000, 3000],
      is_safe?: [true],
      has_more_economy_score?: [true]
    }
  end

  def Archivist.options_idle(duration=3000, speed=15000, eco_score=100, from="1:410:4")
    options = {
      is_idle?: [true],
      get_galaxy: ["1"],
      # is_less_flight_time?: [true, from, speed, duration],
      is_defence_unknow?: [true],
      has_more_economy_score?: [true, eco_score]
    }
  end

  def Archivist.optins_idle_gala(galaxy = "1", eco_score = 100)
    options = {
      is_idle?: [true],
      get_galaxy: [galaxy],
      # is_less_flight_time?: [true, from, speed, duration],
      is_defence_unknow?: [true],
      has_more_economy_score?: [true, eco_score]
    }
  end

  def Archivist.options_idle_safe_to_espionage_unknow(galaxy = "1", eco_score = 100)
    options = {
      is_idle?: [true],
      get_galaxy: [galaxy],
      is_safe_to_espionage_unknow?: [true],
      has_more_economy_score?: [true, eco_score]
    }
  end

  def Archivist.options_idle_defence_unknow(galaxy = "1", eco_score = 100)
    options = {
      is_idle?: [true],
      get_galaxy: [galaxy],
      is_safe_to_espionage?: [true],
      is_defence_unknow?: [true],
      has_more_economy_score?: [true, eco_score]
    }
  end
  # options = Archivist.options_idle(3000, 15000, 100, "1:410:4")
  # options = Archivist.optins_idle_gala("1", 100)
  # options[:is_safe_to_espionage?] = [true]
  # options = Archivist.options_idle_safe_to_espionage_unknow
  # options = Archivist.options_idle_defence_unknow
  # positions = Archivist.get_positions(options)
  # Processor.instance.start
  # Account.instance.login
  # Captain.spy_i_on(positions, 12, 10)
  # Processor.instance.stop

  def Archivist.get_best_target(count = 10)
    Archivist.get_positions(Archivist.options_close_idle_safe)[0..(count-1)]
  end

  def Archivist.get_positions(options = {})
    positions = []
    Planet.all.each do |planet|
      found_one = true
      options.each_pair do |key, value|
        expected_result = value.first
        found_one &= planet.send(key, *value.drop(1)) == expected_result
        break unless found_one
        # if planet.send(key, *value.drop(1)) != expected_result
        #   found_one = false
        # end
      end
      positions << planet if found_one
    end
    return positions
  end

  #
  # def get_somethings(options = {})
  #   somethings = []
  #   Something.all.each do |something|
  #     found_one = true
  #     options.each_pair do |key, value|
  #       expected_result = value.first
  #
  #       if something.send(key, *value.drop(1)) != expected_result
  #         found_one = false
  #       end
  #
  #     end
  #     somethings << something if found_one
  #   end
  #   return somethings
  # end

end

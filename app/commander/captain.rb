module Captain

  def Captain.hello
    puts "Hi, there"
  end

  def Captain.one_order_loot
    GeneralHelper.get_agent
    positions = Archivist.get_positions(Archivist.options_close_idle_safe)
    Captain.spy_i_on(positions)
    positions = (Archivist.get_positions(Archivist.options_close_idle_safe).sort_by &:resource_value).reverse[0..9]
    Captain.large_cargo_loot(positions)
  end

  def Captain.one_order_spy
    GeneralHelper.get_agent
    positions = Archivist.get_positions(Archivist.options_light_spy)
    Captain.spy_i_on(positions, 1, 2)
  end


  # $PLANET_I = Archivist.get_planet_i_from(1)
  # positions = Archivist.get_positions(Archivist.options_close_idle_unknow)
  # GeneralHelper.get_agent
  def Captain.spy_i_on(positions, number = 1, interval = 5)
    positions.each_with_index do |to, index|
      begin
        from = "1:410:4"
        puts "sending spy to #{to.position}, #{index} finished"
        Captain.send_spy(from, to.position, number)
        sleep interval
      rescue Exception => e
        puts e.backtrace.join("\n")
        GeneralHelper.get_agent
        retry
      end
    end
  end

  def Captain.send_spy(from, to, number)
    fleet_id = General.send_spy(from, to, number)
    # Processor.instance("General.send_spy(#{from}, #{to}, #{number})")

    single_flight_time = Abacus.get_time(from, to, 160000000) + 1
    return_time = single_flight_time * 2
    Processor.instance.add_schdule("Journalist.report_newest_message(#{to}, espionage)", single_flight_time)

    # TODO Fleet management
    # Processor.instance.add_schdule("General.remove_fleet(#{fleet_id})", return_time)
  end

  def Captain.large_cargo_loot(positions)
    positions.each_with_index do |to, index|
      begin
        from = "1:410:4"
        fleet = Fleet.new
        fleet.large_cargo = to.need_large_cargo

        DroneNavy.send_fleet(from, to.position, :attack, fleet)
      rescue Exception => e
        puts e.backtrace.join("\n")
        GeneralHelper.get_agent
        retry
      end
    end
  end



  def Captain.deep_spy(from, to)
    General.send_spy(from, to, 39)
  end


end

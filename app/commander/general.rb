module General

  def General.send_spy(from, to, number)
    probe_speed = 160000000
    fleet_slot = 9
    times = 3

    fleet = Fleet.new do |f|
      f.espionage_probe = number
    end
    # fleet.save
    DroneNavy.send_fleet(from, to, :espionage, fleet)

    return fleet.id
  end

  def General.remove_fleet(id)
    Fleet.find_by(id: id.to_i).delete
    return id
  end

end

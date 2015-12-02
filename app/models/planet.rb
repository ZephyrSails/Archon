class Planet < ActiveRecord::Base
  belongs_to :empire

  has_one :moon, dependent: :destroy
  has_one :resource, dependent: :destroy
  has_one :facility, dependent: :destroy
  has_many :fleets, dependent: :destroy

  def get_galaxy
    return self.position.split(":")[0]
  end

  def get_solor
    return self.position.split(":")[1]
  end

  def get_pos
    return self.position.split(":")[2]
  end

  def is_idle?
    begin
      return true if self.empire.status == "i" or self.empire.status == "I"
    rescue
      return false
    end
    return false
  end

  def has_more_score?(score)
    begin
      return true if self.empire.score.to_i > score
    rescue
      return false
    end
    return false
  end

  def has_more_economy_score?(score = 100)
    begin
      return true if self.empire.score_economy.to_i > score
    rescue
      return false
    end
    return false

  end

  def is_less_flight_time?(position, speed = 12750, second = 2700)
    if Abacus.get_time(self.position, position, speed) < second
      return true
    else
      return false
    end
  end

  def has_more_resource?(resource = 250000)
    if self.resource_value > resource
      return true
    else
      return false
    end
  end

  def need_large_cargo
    return ((((self.loot / 100.0) * self.resource_sum ) / 25000).round) + 1
  end

  def is_safe_to_espionage?
    if self.counter_espionage == 0
      return true
    else
      return false
    end
  end

  def is_safe_to_espionage_unknow?
    if self.counter_espionage == nil
      return true
    else
      return false
    end
  end

  def is_defence_unknow?
    if self.defence_value == Settings.unknow
      return true
    else
      return false
    end
  end

  def is_safe?
    if self.defence_value == 0 and self.counter_espionage == 0
      return true
    else
      return false
    end
  end

  def Planet.get_by_pos(position)
    return Planet.find_by(position: position)
  end



end

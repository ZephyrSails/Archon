module Abacus
# 10+{35000/%×开方[(1000000+星球数差×5000)/speed]}
# 10+{35000/%×开方[(2700000+太阳系数差×95000)/speed]}
# 10+[35000/%×开方(银河系数差×20000000/有效速度)]

# 10+ (350 / document.getElementById('sel2').value * Math.sqrt(enf*1000/spd));
# 10+(35000/%*radical((distance)/speed))

  def Abacus.is_f(string)
    # The double negation turns this into an actual boolean true - if you're
    # okay with "truthy" values (like 0.0), you can remove it.
    !!Float(string) rescue false
  end


  def Abacus.hello
    puts "hello"
  end

  def Abacus.get_time(from, to, speed, percentage = 1, times = 3)
    percentage = percentage.to_f
    speed = speed.to_f
    times = times.to_f
    return (10 + 350 / percentage * Math.sqrt(get_distance(from, to)*1000/speed.to_f)).round/times
  end

  def Abacus.get_distance(from, to)
    galaxy = get_galaxy_shift(from, to)
    solar = get_solar_shfit(from, to)
    dis = get_dis_shfit(from, to)
    if galaxy > 0
      return 20000 * galaxy
    elsif solar > 0
      return 2700 + solar * 95
    elsif dis > 0
      return 1000 + dis * 5
    else
      return 0
    end
  end

  def Abacus.get_galaxy_shift(from, to)
    return [(from.split(":")[0].to_i - to.split(":")[0].to_i).abs, (from.split(":")[0].to_i - 9).abs + (to.split(":")[0].to_i - 0).abs, (to.split(":")[0].to_i - 9).abs + (from.split(":")[0].to_i - 0).abs].min
  end

  def Abacus.get_solar_shfit(from, to)
    return [(from.split(":")[1].to_i - to.split(":")[1].to_i).abs, (from.split(":")[1].to_i - 499).abs + (to.split(":")[1].to_i - 0).abs, (to.split(":")[1].to_i - 499).abs + (from.split(":")[1].to_i - 0).abs].min
  end

  def Abacus.get_dis_shfit(from, to)
    return (from.split(":")[2].to_i - to.split(":")[2].to_i).abs
  end

end
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

class Processor
  include Singleton
  # Processor.instance.$processer

  @@processor = nil
  def stop
    if @@processor and @@processor.status != false
      @@processor.kill
      @@processor = nil
      return true
    else
      return false
    end
  end

  # processor.status
  def start

    if @@processor == nil or @@processor.status == false
      @@processor = Thread.new do
        while true
          # puts 1
          begin
            mission = (Schdule.all.sort_by &:launch_time).first
            if mission and DateTime.now > mission.launch_time

              # mission.
              params = mission.get_params
              mod = mission.get_module_name
              func = mission.get_func_name
              begin
                Object.const_get(mod).send(func, *params)
              rescue => e
                puts e.backtrace.join("\n")
                Account.instance.login
                retry
              end

              mission.delete
            end
          rescue => e
            puts e.backtrace.join("\n")
          end
          sleep 2
          # puts 1
        end
      end
      return true
    else
      return false
    end
  end



  def wake_up

    puts "I'm wake, I'm wake"

  end

  def add_schdule(order, time = 0)

    schdule_record = Schdule.new do |s|
      s.order = order
      s.launch_time = DateTime.now + time.second
    end
    schdule_record.save

  end

end

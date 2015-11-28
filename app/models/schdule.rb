class Schdule < ActiveRecord::Base

  def get_params
    params = self.order[/\((.*?)\)/, 1].gsub(" ", "").split(",")
    params.each_with_index do |param, index|
      params[index] = param.to_f if Abacus.is_f(params[index])
      # puts param.to_f != 0.0
    end
  end

  def get_module_name
    return self.order.split("(")[0].split(".")[0]
  end

  def get_func_name
    return self.order.split("(")[0].split(".")[1]
  end

end

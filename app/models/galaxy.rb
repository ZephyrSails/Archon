class Galaxy < ActiveRecord::Base
  has_one :empire, dependent: :destroy
end

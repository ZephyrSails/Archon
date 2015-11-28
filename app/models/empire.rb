class Empire < ActiveRecord::Base

  has_many :planets, dependent: :destroy

  has_one :technology, dependent: :destroy

  belongs_to :galaxy
end

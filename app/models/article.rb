class Article < ActiveRecord::Base
  #attr_accessible :title, :description

  has_many :counters
end

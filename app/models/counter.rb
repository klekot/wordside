class Counter < ActiveRecord::Base
  #attr_accessible :counter

  belongs_to :article
  belongs_to :user
end

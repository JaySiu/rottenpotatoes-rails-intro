class Movie < ActiveRecord::Base

  def self.reorder(para)
    self.order(para)
  end
end

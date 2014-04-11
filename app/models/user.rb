# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base

  #---------   Associations   -----------
  has_many :user_game_relations
  has_many :games, through: :user_game_relations

end

# == Schema Information
#
# Table name: user_game_relations
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  game_id     :integer
#  position    :integer          default(1)
#  total_score :integer          default(0)
#  created_at  :datetime
#  updated_at  :datetime
#

class UserGameRelation < ActiveRecord::Base
  # position => player position / order in game

  #---------   Associations   -----------
  belongs_to :user
  belongs_to :game
  has_many :frames, ->{ order "frames.position asc" }

  #---------   Scopes    -----------
  scope :for_player, lambda{ |player|
    where(user: player).first
  }

  scope :for_player_position, lambda{ |position|
    where(position: position)
  }

  scope :by_position, order("position asc")

end

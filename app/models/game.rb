# == Schema Information
#
# Table name: games
#
#  id                     :integer          not null, primary key
#  status                 :boolean          default(FALSE)
#  current_player_id      :integer          not null
#  current_frame_position :integer          default(1)
#  created_at             :datetime
#  updated_at             :datetime
#

class Game < ActiveRecord::Base
  # current_frame_position => curent round number
  FRAMES_COUNT = 10

  #---------   Associations   -----------
  has_many :user_game_relations, -> { order "user_game_relations.position asc" }
  has_many :players, -> { order "user_game_relations.position asc" },
            through: :user_game_relations, source: "user", class_name: "User", foreign_key: "user_id"
  has_many :frames, through: :user_game_relations
  belongs_to :current_player, class_name: "User"

  #---------   Scopes   -----------
  scope :in_progress, where("status <> 'finished'")
  scope :finished, where(status: "finished")

  #---------   Validations   -----------
  validates :status, inclusion: { in: %w(new in_progress finished) }
  validates :current_frame_position, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: FRAMES_COUNT + 1 }
  validates :current_player_id, presence: {message: "You have no players in game"}, if: :in_progress?

  #---------   Statemachine   -----------
  state_machine :status, initial: :new do
    before_transition :new => :in_progress, do: :set_started_data
    after_transition do |game|
      game.save
    end

    event :start do
      transition :new => :in_progress
    end

    event :finish do
      transition :in_progress => :finished
    end
  end

  #--------------------------------------

  def current_frame
    current_player_relation.frames.for_position(current_frame_position).first
  end

  def current_player_relation
    user_game_relations.for_player(current_player)
  end

  def next_player
    current_player_position = current_player_relation.position
    relation = user_game_relations.for_player_position(current_player_position + 1).first
    relation && relation.user
  end

  def first_player
    user_game_relations.for_player_position(1).first.user
  end

  private

  def set_started_data
    current_frame_position = 0
    self.current_player = players.first
  end

end

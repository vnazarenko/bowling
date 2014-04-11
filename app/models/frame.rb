# == Schema Information
#
# Table name: frames
#
#  id                    :integer          not null, primary key
#  user_game_relation_id :integer
#  first_try_score       :integer
#  second_try_score      :integer
#  position              :integer          default(1)
#  created_at            :datetime
#  updated_at            :datetime
#

class Frame < ActiveRecord::Base
  # position => frame / roung number

  #---------   Associations   -----------
  belongs_to :user_game_relation

  #---------   Scopes   -----------

  scope :for_position, lambda{|position|
    where(position: position)
  }

  #---------   Validations    -----------
  validates :first_try_score, :second_try_score, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to:10 }, allow_nil: true
  validate :check_total_frame_score

  def total_score
    first_try_score.to_i + second_try_score.to_i
  end

  def set_score(score)
    if first_try_score.present?
      self.second_try_score = score.to_i
    else
      self.first_try_score = score.to_i
    end
    save!
  end

  def to_text
    if bonus_frame?
      "#{first_try_score} #{second_try_score}"
    elsif strike?
      "10"
    elsif spare?
      "#{first_try_score}/"
    else
      "#{first_try_score}-#{second_try_score}"
    end.gsub('10', 'X').strip
  end

  def strike?
    first_try_score == 10
  end

  def spare?
    !strike? && total_score == 10
  end

  def opened?
    total_score < 10
  end

  def final_frame?
    position == Game::FRAMES_COUNT
  end

  def bonus_frame?
    position == Game::FRAMES_COUNT + 1
  end

  def previous_frame
    user_game_relation.frames.for_position(position - 1).first
  end

  def next_frame
    user_game_relation.frames.for_position(position + 1).first
  end

  def finished?
    if bonus_frame?
      (previous_frame.strike? && first_try_score.present? && second_try_score.present?) || (previous_frame.spare? && first_try_score.present?) || opened?
    else
      (first_try_score.present? && second_try_score.present?) || (first_try_score.present? && first_try_score == 10)
    end
  end

  private

  def check_total_frame_score
    if total_score > 10 && !bonus_frame?
      errors.add(:second_try_score, "You've knocked too many pins. Maybe you hit next line?")
    end
  end

end

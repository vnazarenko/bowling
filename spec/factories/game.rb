FactoryGirl.define do

  factory :game do
  end

  factory :user_game_relation do
    game
    user
    position 1
  end

end



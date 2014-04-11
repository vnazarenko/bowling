module BowlingLogic
  class << self

    def create_new_game
      Game.create
    end

    def add_player_to(player, game)
      if game.new?
        relation = game.user_game_relations.new
        relation.user = player
        relation.position = game.players.count + 1
        relation.save!
      end
      game
    end

    def start_game!(game)
      game.start!
      create_initial_frames_for!(game)
      game
    end

    def take_score(game, score)
      #find current frame
      current_frame = game.current_frame
      #add score to frame
      current_frame.set_score(score)
      return current_frame if current_frame.errors.count > 0

      #recalculate total score
      recalculate_score!(game)

      #change player or move to next frame if need
      switch_to_next_player_or_frame!(game, current_frame)

      #return game data
      game
    end

    def game_scoreboard(game)
      result = []
      game.user_game_relations.each do |relation|
        info = {player_name: relation.user.name,
                current: relation.user_id == game.current_player_id,
                total_score: relation.total_score,
                scores: []}
        relation.frames.each do |frame|
          info[:scores] << frame.to_text
        end
        result << info
      end
      result
    end


    private

    def create_initial_frames_for!(game)
      game.user_game_relations.each do |relation|
        (1..(Game::FRAMES_COUNT + 1)).each do |i|
          relation.frames.create!(position: i)
        end
      end
    end

    def switch_to_next_player_or_frame!(game, current_frame)
      if current_frame.finished?

        if current_frame.final_frame? && !current_frame.opened?
          set_game_current_frame_position(game, current_frame.position + 1)
        else

          if current_frame.bonus_frame?
            set_game_current_frame_position(game, current_frame.position - 1)
          end

          if game.next_player
            set_game_current_player(game, game.next_player)
          else

            if current_frame.final_frame? || current_frame.bonus_frame?
              game.finish!
            else
              set_game_current_frame_position(game, current_frame.position + 1)
              set_game_current_player(game, game.first_player)
            end

          end
        end
      end
      game
    end

    def recalculate_score!(game)
      relation = game.current_player_relation
      total_score = 0
      map = map_frames_with_position(relation.frames)
      relation.frames.each do |frame|
        next if frame.bonus_frame?

        total_score += frame.total_score
        unless frame.opened?
          total_score += map[frame.position + 1].first_try_score.to_i
          if frame.strike?
            second_try = map[frame.position + 1].second_try_score
            second_try = second_try.to_i if frame.final_frame?
            total_score += (second_try || map[frame.position + 2].first_try_score).to_i
          end
        end
      end

      relation.update_attribute(:total_score, total_score)
    end

    def set_game_current_frame_position(game, position)
      game.current_frame_position = position
      game.save!
    end

    def set_game_current_player(game, player)
      game.current_player = player
      game.save!
    end

    def map_frames_with_position(frames)
      result = {}
      frames.each do |frame|
        result[frame.position] = frame
      end
      result
    end

  end
end

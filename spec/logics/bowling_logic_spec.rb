require 'spec_helper'

describe BowlingLogic do
  before do
    @game = BowlingLogic.create_new_game
    @player1 = FactoryGirl.create(:user)
    @player2 = FactoryGirl.create(:user)
    BowlingLogic.add_player_to(@player1, @game)
    BowlingLogic.add_player_to(@player2, @game)
  end

  context "create game" do
    subject { BowlingLogic.create_new_game }
    its(:status){should == "new"}
    it "should have no players" do
      subject.players.count.should == 0
    end
  end

  context "add players" do
    before do
    end

    it "should have correct count of players" do
      @game.players.count.should == 2
    end
  end

  context "add players in progress" do
    before do
      BowlingLogic.start_game(@game)
    end

    subject { BowlingLogic.add_player_to(FactoryGirl.create(:user), @game)}
    it "should not add new players" do
      subject.players.count.should == 2
    end

  end

  context "start game" do
    subject{ BowlingLogic.start_game(@game)}
    its(:status){should == "in_progress"}
    it "should frames for player" do
      subject.frames.count.should == 22
    end

  end

  context "take score" do
    before do
      BowlingLogic.start_game(@game)
    end

    context "regular game" do
      context "open frame" do
        before do
          BowlingLogic.take_score(@game, 3)
          BowlingLogic.take_score(@game, 4)
          BowlingLogic.take_score(@game, 5)
          BowlingLogic.take_score(@game, 1)
        end
        subject{@game}
        its(:status){should == "in_progress"}
        its(:current_frame_position){should == 2}
        its(:current_player_id){should == @player1.id}

        it "should have correct total score" do
          @game.user_game_relations.for_player(@player1).total_score.should == 7
          @game.user_game_relations.for_player(@player1).position.should == 1
          @game.user_game_relations.for_player(@player2).total_score.should == 6
          @game.user_game_relations.for_player(@player2).position.should == 2
        end

      end

      context "spare" do
        before do
          #p1f1
          BowlingLogic.take_score(@game, 6)
          BowlingLogic.take_score(@game, 4)
          #p2f1
          BowlingLogic.take_score(@game, 5)
          BowlingLogic.take_score(@game, 1)
          #p1f2
          BowlingLogic.take_score(@game, 7)
          BowlingLogic.take_score(@game, 1)

        end
        subject{@game}
        its(:status){should == "in_progress"}
        its(:current_frame_position){should == 2}
        its(:current_player_id){should == @player2.id}

        it "should have correct total score" do
          @game.user_game_relations.for_player(@player1).total_score.should == 10 + 7 + 7 + 1
          @game.user_game_relations.for_player(@player2).total_score.should == 6
        end

      end

      context "strike" do
        before do
          #p1f1
          BowlingLogic.take_score(@game, 6)
          BowlingLogic.take_score(@game, 4)
          #p2f1
            BowlingLogic.take_score(@game, 10)
          #p1f2
          BowlingLogic.take_score(@game, 7)
          BowlingLogic.take_score(@game, 0)
          #p2f2
            BowlingLogic.take_score(@game, 10)
          #p1f3
          BowlingLogic.take_score(@game, 2)
          BowlingLogic.take_score(@game, 3)
          #p2f3
            BowlingLogic.take_score(@game, 3)
            BowlingLogic.take_score(@game, 5)

        end
        subject{@game}
        its(:status){should == "in_progress"}
        its(:current_frame_position){should == 4}
        its(:current_player_id){should == @player1.id}

        it "should have correct total score" do
          @game.user_game_relations.for_player(@player1).total_score.should == 10 + 7 + 7 + 2 + 3
          @game.user_game_relations.for_player(@player2).total_score.should == 10 + 10 + 3 + 10 + 3 + 5 + 3 + 5
        end

      end

    end

    context "finishing game" do
      before do
        @game.current_player = @player1
        @game.current_frame_position = 9
        #p1f9
        BowlingLogic.take_score(@game, 2)
        BowlingLogic.take_score(@game, 3)
        #p2f9
          BowlingLogic.take_score(@game, 3)
          BowlingLogic.take_score(@game, 5)
      end

      context "final frame is open" do
        before do
          #p1f10
          BowlingLogic.take_score(@game, 4)
          BowlingLogic.take_score(@game, 4)
          #p2f10
            BowlingLogic.take_score(@game, 1)
            BowlingLogic.take_score(@game, 2)
        end

        subject{@game}
        its(:status){should == "finished"}
        its(:current_frame_position){should == 10}
        its(:current_player_id){should == @player2.id}

        it "should have correct total score" do
          @game.user_game_relations.for_player(@player1).total_score.should == 2 + 3 + 4 + 4
          @game.user_game_relations.for_player(@player2).total_score.should == 3 + 5 + 1 + 2
        end

      end

      context "final frame is spare" do
        before do
          #p1f10
          BowlingLogic.take_score(@game, 4)
          BowlingLogic.take_score(@game, 4)
          #p2f10
            BowlingLogic.take_score(@game, 5)
            BowlingLogic.take_score(@game, 5)
            BowlingLogic.take_score(@game, 10)
        end

        subject{@game}
        its(:status){should == "finished"}
        its(:current_frame_position){should == 10}
        its(:current_player_id){should == @player2.id}

        it "should have correct total score" do
          @game.user_game_relations.for_player(@player1).total_score.should == 2 + 3 + 4 + 4
          @game.user_game_relations.for_player(@player2).total_score.should == 3 + 5 + 5 + 5 + 10
        end

      end

      context "final frame is strike" do
        before do
          #p1f10
          BowlingLogic.take_score(@game, 10)
          BowlingLogic.take_score(@game, 10)
          BowlingLogic.take_score(@game, 10)
          #p2f10
            BowlingLogic.take_score(@game, 5)
            BowlingLogic.take_score(@game, 1)
        end

        subject{@game}
        its(:status){should == "finished"}
        its(:current_frame_position){should == 10}
        its(:current_player_id){should == @player2.id}

        it "should have correct total score" do
          @game.user_game_relations.for_player(@player1).total_score.should == 2 + 3 + 10 + 10 + 10
          @game.user_game_relations.for_player(@player2).total_score.should == 3 + 5 + 5 + 1
        end

      end

    end

  end

end


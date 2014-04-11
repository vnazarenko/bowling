require 'spec_helper'

describe Game do

  context "current game frame" do
    describe "no players" do
      before do
        @game = Game.create
        @game.start
      end

      it "should have erros" do
        @game.errors.messages.should == {:current_player_id=>["You have no players in game"]}
      end

    end

    describe "has players" do
      before do
        @game = Game.create
        @game.players << FactoryGirl.create(:user)
        @game.start!
      end

      it "should have erros" do
        @game.in_progress?.should be_true
      end

    end
  end


end

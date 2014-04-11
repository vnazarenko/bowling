require 'spec_helper'

describe Frame do
  before do
    @game = FactoryGirl.create(:game)
    @player = FactoryGirl.create(:user)
    @relation = FactoryGirl.create(:user_game_relation, user: @player, game: @game)
    @frame1 = FactoryGirl.create(:frame, user_game_relation: @relation, position: 1, first_try_score: 3, second_try_score: 4)

  end

  context "set score 1st try" do
    before do
      @frame = FactoryGirl.create(:frame, user_game_relation: @relation, position: 2)
      @frame.set_score(4)
    end

    subject{@frame.reload}

    its(:total_score){should == 4}
    its(:finished?) {should be_false}
  end

  context "set strike" do
    before do
      @frame = FactoryGirl.create(:frame, user_game_relation: @relation, position: 2)
      @frame.set_score(10)
    end

    subject{@frame.reload}
    its(:total_score){should == 10}
    its(:finished?) {should be_true}
    its(:strike?){should be_true}

  end

  context "set score 2nd try" do
    before do
      @frame = FactoryGirl.create(:frame, user_game_relation: @relation, position: 2, first_try_score: 4)
      @frame.set_score(4)
    end

    subject{@frame}

    its(:total_score){should == 8}
    its(:strike?){should be_false}
    its(:spare?){should be_false}
    its(:final_frame?){should be_false}
    its(:bonus_frame?){should be_false}
    its(:finished?) {should be_true}
  end

  context "context previous frame" do
    subject{FactoryGirl.create(:frame, user_game_relation: @relation, position: 2)}

    its(:previous_frame){should == @frame1}
  end

  context "bonus frame" do
    context "prev strike" do
      before do
        FactoryGirl.create(:frame, user_game_relation: @relation, position: 10, first_try_score: 10)
      end

      context "only 1 try done" do
        subject{FactoryGirl.create(:frame, user_game_relation: @relation, position: 11, first_try_score: 10)}
        its(:finished?){should be_false}
        its(:bonus_frame?){should be_true}
      end

      context "2 tries done" do
        subject{FactoryGirl.create(:frame, user_game_relation: @relation, position: 11, first_try_score: 10, second_try_score: 10)}
        its(:finished?){should be_true}
        its(:total_score){should == 20}
      end
    end

    context "prev spare" do
      before do
        FactoryGirl.create(:frame, user_game_relation: @relation, position: 10, first_try_score: 7, second_try_score: 3)
      end

      subject{FactoryGirl.create(:frame, user_game_relation: @relation, position: 11, first_try_score: 10)}
      its(:finished?){should be_true}
    end

    context "prev regular" do
      before do
        FactoryGirl.create(:frame, user_game_relation: @relation, position: 10, first_try_score: 7, second_try_score: 0)
      end

      subject{FactoryGirl.create(:frame, user_game_relation: @relation, position: 11)}
      its(:finished?){should be_true}
    end
  end

end


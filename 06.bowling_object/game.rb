# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(shots)
    @shots = []
    @frames = []
    @shots = shots
    @game_result = 0
    frames = insert_zero_for_strikes
    frames.each do |frame|
      @frames.push(Frame.new(frame[0], frame[1]))
    end
  end

  def score
    @frames.each_with_index do |frame, index|
      if frame.score == 10 && frame.first_shot.score == 10 && index < 9
        strike(frame, index)
      elsif frame.score == 10 && index < 9
        spare(frame, index)
      else
        @game_result += frame.score
      end
    end
    @game_result
  end

  def strike(frame, index)
    @game_result += if @frames[index + 1].first_shot.score == 10
                      frame.score + @frames[index + 2].first_shot.score + 10
                    else
                      frame.score + @frames[index + 1].score
                    end
  end

  def spare(frame, index)
    @game_result += frame.score + @frames[index + 1].first_shot.score
  end

  def insert_zero_for_strikes
    @shots.each_with_index do |shot, index|
      @shots.insert(index + 1, 0) if shot == 'X'
    end
    @shots.each_slice(2).to_a
  end
end

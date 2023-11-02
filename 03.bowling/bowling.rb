# frozen_string_literal: true

class Bowling
  STRIKE = 1
  SPARE = 2
  ALL_PIN = 10 #strikeとspareの判定用
end

def gets_score
  score = ARGV[0]
  scores = score.split(',')
  shots = []
  scores.each do |s|
    if s == 'X'
      shots << 10
      shots << 0
    else
      shots << s.to_i
    end
  end
  shots.each_slice(2).to_a
end

def judge(frame)
  if frame[0] == Bowling::ALL_PIN # strike
    return Bowling::STRIKE
  elsif frame.sum == Bowling::ALL_PIN  # spare
    return Bowling::SPARE
  end
end

def cal_strike(frames, num)
  flag = judge(frames[num + 1])
  point = if flag == Bowling::STRIKE
             20 + frames[num + 2][0]
           else
             10 + frames[num + 1].sum
           end
  point
end

def cal_score(frames)
  point = 0
  frames.each_with_index do |frame, num|
    flag = judge(frame)
    if num >= 9
      point += frame.sum
    elsif flag == Bowling::STRIKE
      point += cal_strike(frames, num)
    elsif flag == Bowling::SPARE
      point += frame.sum + frames[num + 1][0]
    else
      point += frame.sum
    end
  end
  puts point
end
frames = gets_score
cal_score(frames)


# frozen_string_literal: true

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
    frames = []
    shots.each_slice(2) do |s|
      frames << s
    end
    frames
end

def judge(frame)
  # strike
  if frame[0] == 10
    flag = 1 
  # spare
  elsif frame.sum == 10
    flag = 2 
  end
end

def cal_strike(frames, num, point)
  flag = judge(frames[num + 1])
  if flag == 1
    point += 20 + frames[num + 2][0]
  else
    point += 10 + frames[num + 1].sum
  end
  point
end

def cal_score(frames)
  point = 0
  flag = 0
  frames.each_with_index do |frame, num|
    flag = judge(frame)
    if num >= 9
      point += frame.sum
    elsif flag == 1
      point = cal_strike(frames, num, point)
      flag = 0
    elsif flag == 2
      point += frame.sum + frames[num + 1][0]
      flag = 0
    else
      point += frame.sum
    end
  end
  puts point
end
frames = gets_score
cal_score(frames)

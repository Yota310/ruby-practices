# frozen_string_literal: true

$strike = 1
$spare = 2
$all_pin = 10 #strikeとspareの判定用

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
  frames = shots.each_slice(2).to_a
  frames
end

def judge(frame)
  if frame[0] == $all_pin  # strike
    return $strike
  elsif frame.sum == $all_pin  # spare
    return $spare
  end
end

def cal_strike(frames, num)
  flag = judge(frames[num + 1])
  point = if flag == $strike
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
    elsif flag == $strike
      point += cal_strike(frames, num)
      flag = 0
    elsif flag == $spare
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

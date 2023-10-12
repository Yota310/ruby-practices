require "debug"

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


def cal_result
    point = 0
    flag = 0
    frames.each do |frame|
    binding.break
     if flag == 1
        point += frame.sum * 2
        flag = 0
     elsif flag == 2
        point += frame.sum + frame[0]
        flag = 0 
        else
        point += frame.sum
        end

        if frame[0] == 10 # strike
        flag = 1
        elsif frame.sum == 10 # spare
        flag = 2
     end
    end
end
puts point
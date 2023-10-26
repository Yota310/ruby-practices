#!/usr/bin/env ruby
require "optparse"
require "date"
def get_date #日付を受け取るメソッド
  date = {} #-y,-mの値を保存する用のハッシュ
  date[:y] = Date.today.year  
  date[:m] = Date.today.month
  #オプション(-y,-m)の定義
  opt = OptionParser.new
  opt.on("-y [VAL]"){|v| date[:y] = v}
  opt.on("-m [VAL]"){|v| date[:m] = v}
  opt.parse(ARGV)
  #初日と最終日を取得
  day_last = Date.new(date[:y].to_i,date[:m].to_i,-1)
  day_first = Date.new(date[:y].to_i,date[:m].to_i,1)
  [day_last,day_first]
end

def mk_blank(n) #１日の曜日を合わせるためのメソッド
  print "   " * n
end

def mk_cal(day_last,day_first) #カレンダー作成メソッド
  puts "      #{day_first.mon}月#{day_first.year}"
  puts " 日 月 火 水 木 金 土"
  mk_blank(day_first.wday)
    
  (day_first..day_last).each do |day|
    print sprintf(" %2d",day.day)
    puts "" if day.saturday?
  end
end
day_last,day_first = get_date
mk_cal(day_last,day_first)

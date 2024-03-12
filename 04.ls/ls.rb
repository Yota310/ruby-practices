#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

MAX_COL = 3 # 出力時の列の最大数

def option
  opt = OptionParser.new
  params = {}
  opt.on('-l') { |v| params[:l] = v }
  opt.parse(ARGV)
  params
end

def check_file_type(type)
  authority = []
  types = type.split('')
  file_type = types[0].to_s + types[1].to_s
  special_authority = types[2]
  authority.push(types[3], types[4], types[5])
  convert_file_type(file_type)
  convert_special_authority(special_authority)
  convert_authority(authority)
end

def convert_file_type(file_type)
  case file_type
  when '01'
    print 'p'
  when '02'
    print 'c'
  when '04'
    print 'd'
  when '06'
    print 'b'
  when '10'
    print '-'
  when '12'
    print 'l'
  when '14'
    print 's'
  end
end

def convert_special_authority(special_authority)
  case special_authority # 特殊権限
  when '0'
    print ''
  when '1'
    print 't'
  when '2'
    print 's'
  when '4'
    print 's'
  end
end

def convert_authority(authority)
  authority.each do |auth|
    case auth
    when '0'
      print '---'
    when '1'
      print '--x'
    when '2'
      print '-w-'
    when '3'
      print '-wx'
    when '4'
      print 'r--'
    when '5'
      print 'r-x'
    when '6'
      print 'rw-'
    when '7'
      print 'rwx'
    end
  end
end

def get_files(files)
  params = option
  Dir.glob('./*').each do |path|
    if File.file?(path) # ファイル名を出力
      files.push(File.basename(path))
    else
      path.split
      files.push(path[2..])
    end
  end
  [files, params]
end

def setup_files(files)
  row = files.size / MAX_COL + 1
  output = files.each_slice(row).to_a
  output.map! { |data| data.values_at(0...row) }
  maxsize = files.max_by(&:length).length
  [output.transpose, maxsize, files]
end

def get_max_total(files)
  max = 0
  total = 0
  files.each do |file|
    data = File.stat(file)
    size = data.size.to_s.length
    max = size if size > max
    total += data.blocks
  end
  [max, total]
end

def output_l(files)
  max, total = get_max_total(files)
  puts "total #{total}"
  files.each do |file|
    data = File.stat(file)
    type = format('%06d', data.mode.to_s(8))
    check_file_type(type)
    print "  #{data.nlink}"
    print " #{Etc.getpwuid(data.uid).name}"
    print "  #{Etc.getgrgid(data.gid).name}"
    print format("% #{max + 2}s", data.size)
    print " #{data.mtime.strftime('%0m %0d %H:%M')}"
    print " #{file}"
    puts
  end
end

def output_files(output, maxsize, params, files)
  if params[:l] == true
    output_l(files)
  else
    output.each do |data|
      data.each do |name|
        print format("%-#{maxsize + 1}s", name)
      end
      puts
    end
  end
end

files = []

files, params = get_files(files)
output, maxsize, files = setup_files(files)
output_files(output, maxsize, params, files)

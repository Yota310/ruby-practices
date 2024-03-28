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

def print_file_type(type)
  authority = []
  types = type.split('')
  file_type = types[0].to_s + types[1].to_s
  special_authority = types[2]
  authority.push(types[3], types[4], types[5])
  print convert_file_type(file_type)
  print convert_special_authority(special_authority)
  print convert_authority(authority)
end

def convert_file_type(file_type)
  {
    '01' => 'p',
    '02' => 'c',
    '04' => 'd',
    '06' => 'b',
    '10' => '-',
    '12' => 'l',
    '14' => 's'
  }[file_type]
end

def convert_special_authority(special_authority)
  {
    '0' => '',
    '1' => 't',
    '2' => 's',
    '4' => 's'
  }[special_authority]
end

def convert_authority(authority)
  authority.map do |auth|
    {
      '0' => '---',
      '1' => '--x',
      '2' => '-w-',
      '3' => '-wx',
      '4' => 'r--',
      '5' => 'r-x',
      '6' => 'rw-',
      '7' => 'rwx'
    }[auth]
  end.join
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
  total = files.map { |file| File.stat(file).blocks }.sum
  max = files.map { |file| File.stat(file).size.to_s.length }.max
  [max, total]
end

def output_l(files)
  max, total = get_max_total(files)
  puts "total #{total}"
  files.each do |file|
    data = File.stat(file)
    type = format('%06d', data.mode.to_s(8))
    print_file_type(type)
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

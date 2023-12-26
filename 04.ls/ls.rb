#!/usr/bin/env ruby
# frozen_string_literal: true

MAX_COL = 3 # 出力時の列の最大数

def get_files(files)
  Dir.glob('./*').each do |path|
    if File.file?(path) # ファイル名を出力
      files.push(File.basename(path))
    else
      path.split
      files.push(path[2..])
    end
  end
  files
end

def setup_files(files)
  row = files.size / MAX_COL + 1
  output = files.each_slice(row).to_a
  output.map! { |data| data.values_at(0...row) }
  maxsize = files.max_by(&:length).length
  puts maxsize
  [output.transpose, maxsize]
end

def output_files(output, maxsize)
  output.each do |data|
    data.each do |name|
      print format("%-#{maxsize + 1}s", name)
    end
    puts
  end
end

files = []

files = get_files(files)
output, maxsize = setup_files(files)
output_files(output, maxsize)

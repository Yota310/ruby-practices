#!/usr/bin/env ruby
# frozen_string_literal: true

def get_files(files)
  Dir.glob('./*').each do |path|
    files.push(File.basename(path)) if File.file?(path) # ファイル名を出力
  end
end

def setup_files(files)
  max_col = 3
  maxsize = 0
  row = files.size / max_col + 1
  output = Array.new(row).map { Array.new(max_col) }
  i = 0
  files.each_with_index do |file, index|
    num = index % row # 配列の添字に対応させるための計算
    i += 1 if num.zero? && index != 0
    output[num][i] = file
    maxsize = file.size if maxsize < file.size
  end
  [output,maxsize]
end

def output_files(output,maxsize)
  output.each do |output|
    output.each do |name|
      print format("%-#{maxsize + 1}s", name)
    end
    puts
  end
end

files = []

get_files(files)
output,maxsize = setup_files(files)
output_files(output,maxsize)

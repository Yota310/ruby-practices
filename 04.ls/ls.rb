#!/usr/bin/env ruby
# frozen_string_literal: true

def get_file(files)
  Dir.glob('./*').each do |path|
    files.push(File.basename(path)) if File.file?(path) # ファイル名を出力
  end
end

def setup_file(files)
  max_col = 3
  row = files.size / max_col + 1
  outputs = Array.new(row).map { Array.new(max_col) }
  i = 0
  files.each_with_index do |file, index|
    num = index % row # 配列の添字に対応させるための計算
    i += 1 if num.zero? && index != 0
    outputs[num][i] = file
  end
  outputs
end

def outputs_file(outputs)
  outputs.each do |output|
    output.each do |name|
      print format('%-10s', name)
    end
    puts
  end
end

files = []

get_file(files)
outputs = setup_file(files)
outputs_file(outputs)

#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

require_relative 'file_info'
class LsCommand
  MAX_COL = 3 # 出力時の列の最大数

  def initialize
    @files = []
    @params = option
  end

  def option
    opt = OptionParser.new
    params = {}
    opt.on('-l') { |v| params[:l] = v }
    opt.on('-a') { |v| params[:a] = v }
    opt.on('-r') { |v| params[:r] = v }
    opt.parse(ARGV)
    params
  end

  def hidden_file
    Dir.glob('./.*').each do |path|
      path.split
      @files.push(path[2..]) # ドット付きのファイル名を出力
    end
  end

  def input_files
    hidden_file if @params[:a] == true
    Dir.glob('./*').each do |path|
      if File.file?(path) # ファイル名を出力
        @files.push(File.basename(path))
      else
        path.split
        @files.push(path[2..])
      end
    end
  end

  def setup_files
    @files.reverse! if @params[:r] == true
    row = @files.size / MAX_COL + 1
    @output = @files.each_slice(row).to_a
    @output.map! { |data| data.values_at(0...row) }
    @maxsize = @files.max_by(&:length).length
  end

  def output_files
    if @params[:l] == true
      total = @files.map { |file| File.stat(file).blocks }.sum
      max = @files.map { |file| File.stat(file).size.to_s.length }.max
      puts "total #{total}"
      @files.each do |file|
        output = FileInfo.new(file)
        output.output_l(max)
      end
    else
      @output.transpose.each do |data|
        data.each do |name|
          print format("%-#{@maxsize + 3}s", name)
        end
        puts
      end
    end
  end

  def self.run
    ls = LsCommand.new
    ls.input_files
    ls.setup_files
    ls.output_files
  end
end

LsCommand.run

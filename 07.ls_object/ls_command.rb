#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

require_relative 'file_info'
class LsCommand
  MAX_COL = 3

  def initialize(argv)
    @argv = argv
    @params = set_params
  end

  def run
    files = []
    files = input_files(files)
    output, maxsize = setup_files(files)
    output_files(files, output, maxsize)
  end

private

  def set_params
    opt = OptionParser.new
    params = {}
    opt.on('-l') { |v| params[:l] = v }
    opt.on('-a') { |v| params[:a] = v }
    opt.on('-r') { |v| params[:r] = v }
    opt.parse(@argv)
    params
  end

  def hidden_file(files)
    Dir.glob('./.*').each do |path|
      path.split
      files.push(path[2..])
    end
  end

  def input_files(files)
    hidden_file(files) if @params[:a]
    Dir.glob('./*').each do |path|
      if File.file?(path)
        files.push(File.basename(path))
      else
        path.split
        files.push(path[2..])
      end
    end
    files
  end

  def setup_files(files)
    files.reverse! if @params[:r]
    row = files.size / MAX_COL + 1
    output = files.each_slice(row).to_a
    output.map! { |data| data.values_at(0...row) }
    maxsize = files.max_by(&:length).length
    [output,maxsize]
  end

  def output_files(files, output, maxsize)
    if @params[:l]
      total = files.map { |file| File.stat(file).blocks }.sum
      max = files.map { |file| File.stat(file).size.to_s.length }.max
      puts "total #{total}"
      files.each do |file|
        output = FileInfo.new(file)
        output.output_l(max)
      end
    else
      output.transpose.each do |data|
        data.each do |name|
          print format("%-#{maxsize + 3}s", name)
        end
        puts
      end
    end
  end
end

LsCommand.new(ARGV).run

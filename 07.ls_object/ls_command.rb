#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

require_relative 'file_info'
class LsCommand
  MAX_COL = 3

  def initialize(argv)
    @params = get_params(argv)
    @files = input_files
  end

  def run
    outputs = setup_outputs
    maxsize = get_maxsize
    output_files(outputs, maxsize)
  end

  private

  def get_params(argv)
    opt = OptionParser.new
    params = {}
    opt.on('-l') { |v| params[:l] = v }
    opt.on('-a') { |v| params[:a] = v }
    opt.on('-r') { |v| params[:r] = v }
    opt.parse(argv)
    params
  end

  def input_files
    files = []
    if @params[:a]
      Dir.glob('./.*').each do |path|
        path.split
        files.push(path[2..])
      end
    end
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

  def get_maxsize
    maxsize = @files.max_by(&:length).length
  end

  def setup_outputs
    @files.reverse! if @params[:r]
    row = @files.size / MAX_COL + 1
    outputs = @files.each_slice(row).to_a
    outputs.map! { |output| output.values_at(0...row) }
    outputs
  end

  def output_files(outputs, maxsize)
    if @params[:l]
      total = @files.map { |file| File.stat(file).blocks }.sum
      max = @files.map { |file| File.stat(file).size.to_s.length }.max
      puts "total #{total}"
      @files.each do |file|
        output = FileInfo.new(file)
        output.output_l(max)
      end
    else
      outputs.transpose.each do |output|
        output.each do |name|
          print format("%-#{maxsize + 3}s", name)
        end
        puts
      end
    end
  end
end

LsCommand.new(ARGV).run

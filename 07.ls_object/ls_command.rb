#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

require_relative 'file_info'
class LsCommand
  MAX_COL = 3

  def initialize(argv)
    @params = get_params(argv)
    files = input_files
    @files = @params[:r] ? files.reverse : files
  end

  def run
    if @params[:l]
      output_files_details
    else
      output_files_names
    end
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
        files.push(path[2..])
      end
    end
    Dir.glob('./*').each do |path|
      if File.file?(path)
        files.push(File.basename(path))
      else
        files.push(path[2..])
      end
    end
    files
  end

  def culc_maxsize
    @files.max_by(&:length).length
  end

  def setup_output_files
    row = @files.size / MAX_COL + 1
    outputs = @files.each_slice(row).to_a
    outputs.map! { |output| output.values_at(0...row) }
    outputs
  end

  def output_files_details
    total = @files.map { |file| File.stat(file).blocks }.sum
    max = @files.map { |file| File.stat(file).size.to_s.length }.max
    puts "total #{total}"
    @files.each do |file|
      file_info = FileInfo.new(file)
      file_info.output_l(max)
    end
  end

  def output_files_names
    output_files = setup_output_files
    maxsize = culc_maxsize
    output_files.transpose.each do |output_file|
      output_file.each do |file|
        print format("%-#{maxsize + 3}s", file)
      end
      puts
    end
  end
end

LsCommand.new(ARGV).run

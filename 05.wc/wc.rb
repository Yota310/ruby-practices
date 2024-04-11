# frozen_string_literal: true

require 'optparse'

def option
  opt = OptionParser.new
  params = {}
  opt.on('-l') { |v| params[:l] = v }
  opt.on('-w') { |v| params[:w] = v }
  opt.on('-c') { |v| params[:c] = v }
  opt.parse(ARGV)
  params
end

def import_files
  if !ARGV.empty?
    f = File.open(ARGV.last, 'r')
    file = f.read
    size = f.size
    f.close
  else
    file = $stdin.read
    size = file.size
  end
  [size, file]
end

def exists_option(size, file, params)
  result = {}
  result[:l] = file.count("\n")
  result[:w] = file.split(' ').count
  result[:c] = size
  result[:name] = ARGV.last
  result.delete(:l) if params[:l].nil? && !params.empty?
  result.delete(:w) if params[:w].nil? && !params.empty?
  result.delete(:c) if params[:c].nil? && !params.empty?
  result.values.to_a
end

def output_results(result)
  result.each do |output|
    print format('%8s', output)
  end
end

def main
  params = option
  size, file = import_files
  result = exists_option(size, file, params)
  output_results(result)
end

main

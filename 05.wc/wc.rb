# frozen_string_literal: true

require 'optparse'

def judge_option_state
  opt = OptionParser.new
  option_state = {}
  opt.on('-l') { |v| option_state[:l] = v }
  opt.on('-w') { |v| option_state[:w] = v }
  opt.on('-c') { |v| option_state[:c] = v }
  opt.parse(ARGV)
  option_state
end

def setup_import_files
  files = []
  size = []
  argv_array = Dir.glob(ARGV)
  if !argv_array.empty?
    argv_array.each do |argv|
    f = File.open(argv, 'r')
    files.push(f.read)
    size.push(f.size)
  end
  else
    file = $stdin.read
    files.push(file)
    size.push(file.bytesize)
  end
  [size, files, argv_array]
end

def setup_result(size, file, option_state, i, argv_array)
  result = {}
  result[:l] = file.count("\n")
  result[:w] = file.split(' ').count
  result[:c] = size
  result[:name] = argv_array[i]
  result.delete(:l) if option_state[:l].nil? && !option_state.empty?
  result.delete(:w) if option_state[:w].nil? && !option_state.empty?
  result.delete(:c) if option_state[:c].nil? && !option_state.empty?
  result #result.values
end

def max_num(results, option_state)
  total = {}

  total[:l] = results.sum {|result| result[:l]} if option_state[:l]
  total[:w] = results.sum {|result| result[:w]} if option_state[:w]
  total[:c] = results.sum {|result| result[:c]} if option_state[:c]
  total[:name] = 'total' if total[:l] || total[:w] || total[:c]
  total
end

def output_results(result)
  result.values.each do |output|
    print format('%8s', output)
  end
  puts
end

def main
  results = []
  total = {}
  option_state = judge_option_state
  size, files, argv_array = setup_import_files
  files.each_with_index do |file, i|
    results.push(setup_result(size[i], file, option_state,i, argv_array))
  end
  total = max_num(results, option_state)
  results.push(total) if results.size > 1
  results.each do |result|
    output_results(result)
  end
end

main

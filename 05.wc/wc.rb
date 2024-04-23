# frozen_string_literal: true

require 'optparse'

def judge_option_state
  opt = OptionParser.new
  option_state = {}
  opt.on('-l') { |v| option_state[:l] = v }
  opt.on('-w') { |v| option_state[:w] = v }
  opt.on('-c') { |v| option_state[:c] = v }
  opt.parse!(ARGV)
  option_state
end

def set_up_import_files
  array_files = []
  filename_array = Dir.glob(ARGV)
  if !filename_array.empty?
    filename_array.each do |argv|
      File.open(argv, 'r') do |f|
        name = argv
        argv = {}
        argv[:name] = name
        argv[:content] = f.read
        argv[:size] = f.size
        array_files.push(argv)
      end
    end
  else
    file = $stdin.read
    hash_file[:content] = file
    hash_file[:size] = file.bytesize
    hash_files.push(hash_file)
  end
  [array_files, filename_array]
end

def set_up_result(size, file, filename)
  result = {}
  result[:l] = file.count("\n")
  result[:w] = file.split(' ').count
  result[:c] = size
  result[:name] = filename
  result
end

def set_up_total_num(results, _option_state, _filename_array, total)
  total[:l] = results.sum { |result| result[:l] }
  total[:w] = results.sum { |result| result[:w] }
  total[:c] = results.sum { |result| result[:c] }
  total[:name] = 'total'
  total
end

def output_results(result, option_state)
  result.delete(:l) if option_state[:l].nil? && !option_state.empty?
  result.delete(:w) if option_state[:w].nil? && !option_state.empty?
  result.delete(:c) if option_state[:c].nil? && !option_state.empty?
  result.each_value do |output|
    print format('%8s', output)
  end
  puts
end

def main
  results = []
  total = {}
  option_state = judge_option_state
  array_files, argv_array = set_up_import_files
  array_files.each do |file|
    results.push(set_up_result(file[:size], file[:content], file[:name]))
  end
  total = set_up_total_num(results, option_state, argv_array, total)
  results.push(total) if results.size > 1
  results.each do |result|
    output_results(result, option_state)
  end
end

main

# frozen_string_literal: true

require 'optparse'

def judge_option_state
  opt = OptionParser.new
  option_state = {}
  parse_num = ARGV.find_index {|argv| /\./.match?(argv) }
  opt.on('-l') { |v| option_state[:l] = v }
  opt.on('-w') { |v| option_state[:w] = v }
  opt.on('-c') { |v| option_state[:c] = v }
  opt.parse(ARGV[..parse_num]) 
  option_state
end

def setup_import_files
  files = []
  size = []
  argv_array = Dir.glob(ARGV)
  argv_array.delete_at(0) if argv_array[0].match('-')
  if !argv_array.empty?
    argv_array.each do |argv|
      File.open(argv, 'r') { |f| 
      files.push(f.read)
      size.push(f.size)
      }    
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
  result
end

def setup_total_num(results, option_state, argv_array)
  total = {}

  total[:l] = results.sum { |result| result[:l] } if option_state[:l] || option_state.empty?
  total[:w] = results.sum { |result| result[:w] } if option_state[:w] || option_state.empty?
  total[:c] = results.sum { |result| result[:c] } if option_state[:c] || option_state.empty?
  total[:name] = 'total' if total[:l] || total[:w] || total[:c] || argv_array.size > 1
  total
end

def output_results(result)
  result.each_value do |output|
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
  total = setup_total_num(results, option_state, argv_array)
  results.push(total) if results.size > 1
  results.each do |result|
    output_results(result)
  end
end

main

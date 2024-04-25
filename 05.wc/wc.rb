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
  filenames = Dir.glob(ARGV)
  if !filenames.empty?
    data_array = filenames.map do |filename|
      File.open(filename, 'r') do |f|
        { name: filename, size: f.size, content: f.read }
      end
    end
  else
    data_array = []
    data = $stdin.read
    data_array.push({ content: data, size: data.bytesize, name: '' })
  end
  data_array
end

def set_up_result(size, file, filename)
  result = {}
  result[:l] = file.count("\n")
  result[:w] = file.split(' ').count
  result[:c] = size
  result[:name] = filename
  result
end

def set_up_total_num(results, total)
  total[:l] = results.sum { |result| result[:l] }
  total[:w] = results.sum { |result| result[:w] }
  total[:c] = results.sum { |result| result[:c] }
  total[:name] = 'total'
  total
end

def output_results(result_hash, option_state)
  result_hash.delete(:l) if option_state[:l].nil? && !option_state.empty?
  result_hash.delete(:w) if option_state[:w].nil? && !option_state.empty?
  result_hash.delete(:c) if option_state[:c].nil? && !option_state.empty?
  result_hash.each_value do |output|
    print format('%8s', output)
  end
  puts
end

def main
  results = []
  total = {}
  option_state = judge_option_state
  data_array = set_up_import_files
  data_array.each do |data|
    results.push(set_up_result(data[:size], data[:content], data[:name]))
  end
  if results.size > 1
    total = set_up_total_num(results, total)
    results.push(total)
  end
  results.each do |result|
    output_results(result, option_state)
  end
end

main

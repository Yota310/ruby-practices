def get_file(files)
  Dir.glob('./*').each do |path|
    files.push(File.basename(path)) if File.file?(path) # ファイル名を出力
  end
end

def set_up_file(files)
  max_col = 3
  row = files.size / max_col + 1
  outputs = Array.new(row).map{Array.new(max_col)}
  i = 0
  files.each_with_index do |file,index|
    num = index % row
   i += 1 if num == 0 && index != 0
   outputs[num][i] = file
  end
  outputs
end

def outputs_file(outputs)
  outputs.each do |output|
    output.each do |name|
      print sprintf("%-10s", name)
    end
    puts
  end
end

files = []

get_file(files)
outputs = set_up_file(files)
outputs_file(outputs)

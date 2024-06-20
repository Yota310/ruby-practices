# frozen_string_literal: true

class FileInfo
  def initialize(file_name)
    file_stat = File.stat(file_name)
    @name = file_name
    @size = file_stat.size
    @user_id = Etc.getpwuid(file_stat.uid).name
    @group_id = Etc.getgrgid(file_stat.gid).name
    @type = format('%06d', file_stat.mode.to_s(8))
    @date = file_stat.mtime.strftime('%0m %0d %H:%M')
    @nlink = file_stat.nlink
  end

  def print_file_type
    authority = []
    types = @type.split('')
    file_type = types[0].to_s + types[1].to_s
    special_authority = types[2]
    authority.push(types[3], types[4], types[5])
    print convert_file_type(file_type)
    print convert_special_authority(special_authority)
    print convert_authority(authority)
  end

  def convert_file_type(file_type)
    {
      '01' => 'p',
      '02' => 'c',
      '04' => 'd',
      '06' => 'b',
      '10' => '-',
      '12' => 'l',
      '14' => 's'
    }[file_type]
  end

  def convert_special_authority(special_authority)
    {
      '0' => '',
      '1' => 't',
      '2' => 's',
      '4' => 's'
    }[special_authority]
  end

  def convert_authority(authority)
    authority.map do |auth|
      {
        '0' => '---',
        '1' => '--x',
        '2' => '-w-',
        '3' => '-wx',
        '4' => 'r--',
        '5' => 'r-x',
        '6' => 'rw-',
        '7' => 'rwx'
      }[auth]
    end.join
  end

  def output_l(max)
    print_file_type
    print "  #{@nlink}"
    print " #{@user_id}"
    print "  #{@group_id}"
    print format("% #{max + 2}s", @size)
    print " #{@date}"
    print " #{@name}"
    puts
  end
end

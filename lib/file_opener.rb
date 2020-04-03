module FILE_OPENER
  def self.open_file(file_path)  
    file_opener = File.open(file_path)
    file_content = file_opener.readlines.map(&:chomp)
    file_opener.close

    file_content
  end
end

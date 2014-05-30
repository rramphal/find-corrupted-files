def file_has_null_ending?(filename, num_bytes = 10)
  file = File.new(filename, "r")
  file.seek(-num_bytes, IO::SEEK_END)
  last_bytes = file.read(num_bytes)

  return last_bytes === "\u0000" * num_bytes
end

def get_all_files_from_directory(dir)
  return Dir[ File.join(dir, '**', '*') ].reject { |file| File.directory?(file) }
end

unless ARGV.empty?
  files = get_all_files_from_directory(ARGV.first)

  errors = Array.new

  File.open("corrupted_files.log", "w") do |output|
    files.each do |file|
      begin
        if file_has_null_ending?(file)
          output.write(file + "\n")
          puts file
        end
      rescue Exception => e
        errors << e
      end
    end
  end

  File.open("errors.log", "w") do |output|
    unless errors.empty?
      errors.each do |error|
        output.write(error + "\n")
        puts error
      end
    end
  end
end

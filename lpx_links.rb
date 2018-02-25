#!/usr/bin/env ruby

require_relative './lib/config'
require 'json'
require 'fileutils'

# read the plist, create a json & parse a list of links
module GetLinks
  def launch
    create_dirs
    plist_to_json
    json_parse
    print_file(DWN_LST, @line.sort)
    print_file(JSN_FLE, @json_file)
    del_temp_files
    report
    show_report
  end

  def create_dirs
    FileUtils.mkdir_p(DWN_LNK)
    FileUtils.mkdir_p(TMPDIR)
    FileUtils.mkdir_p(JSN_DIR)
  end

  def plist_to_json
    `plutil -convert json \'#{PLIST}\' -o #{JSN}`
    @json = JSON.parse(File.read(JSN))
    @json_file = JSON.pretty_generate(@json[PKG])
  end

  def json_parse
    @line = []
    @json[PKG].each do |i|
      @line << "#{File.join(URL, i[1][DLN])}\n"
    end
  end

  def print_file(file, content)
    f = File.open(file, 'w')
    f.puts content
    f.close
  end

  def del_temp_files
    FileUtils.remove_dir(TMPDIR)
  end

  def report
    msg = '#' * 60
    msg << "\n\tlpx_links has found #{@line.to_a.length} links."
    msg << "\nCheck the following file:\n\t#{DWN_LST}"
    rep = File.open(REPORT, 'w')
    rep.puts msg
    rep.close
  end

  def show_report
    puts "Done! Found #{@line.to_a.length} links."
    `cd #{File.join(DWN_LNK)} ; open .`
    sleep 1
    `open -a TextEdit #{REPORT}`
  end
end

include GetLinks
launch

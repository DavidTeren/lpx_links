require 'fileutils'
require 'json'
require 'pp'

# Converts the Logic content plist file to JSON and
# writes a pretty print version.
class PackagesFile

  def initialize
    plist_to_json
    pretty_format_packages_file
  end

  def read_package_file
    JSON.parse(File.read(packages_file))
  end

  private

  def pretty_format_packages_file
    res = pretty_format_json
    File.open(packages_file, 'w+') do |f|
      f.puts res
      f.close
    end
  end

  def pretty_format_json
    JSON.pretty_generate(read_package_file)
  end

  def plist_to_json
    `plutil -convert json \'#{plist_file}\' -o #{packages_file}`
  end

  def plist_file
    file = find_plist_file.chomp
    raise 'Error: PLIST file not found!' if file.empty?
    file
  end

  def find_plist_file
    `find '/Applications/Logic Pro X.app/Contents/Resources' \\
-name  logicpro\*.plist`
  end

  def extract_file_name(file)
    File.basename(file)
  end

  def packages_file
    FileUtils.mkpath(config_home) unless File.exist?(config_home)
    File.join(config_home, 'packages.json')
  end

  def config_home
    File.join(ENV['HOME'], 'Music', 'LogicLinks', 'config')
  end
end

PackagesFile.new if $PROGRAM_NAME == __FILE__

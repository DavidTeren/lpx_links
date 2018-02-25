require_relative 'lib/applescript_dialogs'
require_relative 'lib/packages_file'
require 'uri'

class LogicLinks
  attr_accessor :packages, :download_location

  def initialize
    # Check for legit Logic installation.
    msg = "No Logic Pro X found!\n\nLogicLinks requires Logic Pro X to be installed.\n\nClosing..."
    close_app(msg) unless logic_check?
    # Get the packages info
    @packages = PackagesFile.new.read_package_file

    # Options
    ## Get the download links

    ## Install packages
    ### Select Install Path
    options = option_select
    close_app("Aborted!\n\nClosing...") unless options
    if options.include?("1)")
      puts "Foo"
      ## Download packages
      ### Select download location
      download_packages
    elsif options.include?("2)")
      puts "Bar"
      p download_location
      ## Install packages
      ### Select Install Path
    else
      puts "not working!"
    end
  end

  def logic_check?
    File.exist?('/Applications/Logic Pro X.app/Contents/Info.plist')
  end

  def dl_file(package)
    File.join(download_location + package[1]['DownloadName'])
  end

  private

  def option_select
    AppleScriptDialogs
        .select_from_list_dialog({options:
                                      ['1) Download Content files',
                                       '2) Install the Files',
                                      ],
                                  title: "LogicLinks",
                                  prompt: "Make a selection:",
                                  multi_select: false,
                                  ok_btn_name: "Run",
                                  cnl_btn_name: "Abort"})
  end

  def close_app(msg)
    AppleScriptDialogs
        .button_dialog({prompt: msg,
                        buttons: ["Close"],
                        icon: 'caution'
                       })
    exit 0
  end

  def download_location
    @download_location ||= AppleScriptDialogs.select_folder_dialog.delete("'")
  end

  def download_packages
    download_location
    packages['Packages'].each do |package|
      puts '*' * 80
      puts "Downloading " + package[0].split('_').join(' ')
      if File.exist?(dl_file(package))
        puts "File already exists. Skipping download..."
        next
      end
      dl_path = URI.join(dl_uri, package[1]['DownloadName']).to_s
      dl_size = package[1]['DownloadSize']
      cmd = "curl -o #{dl_file(package)} #{dl_path} "
      `#{cmd}`
    end
  end

  def hget_path
    @hget_path = File.join(bin_path, 'hget')
  end

  def bin_path
    @bin_path ||= File.expand_path('lib/bin')
  end

  def dl_uri
    @dl_uri = 'http://audiocontentdownload.apple.com/lp10_ms3_content_2016/'
  end
  # Check for instance conf

  # Options
  ## Get the download links
  ## Download packages
  ### Select download location
  ## Install packages
  ### Select Install Path

  # Determine state
  ##  Currently installed
  ## Still to Install
end

LogicLinks.new if __FILE__ == $PROGRAM_NAME

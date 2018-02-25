require 'open3'

module AppleScriptDialogs
  module_function

  def osascript(language, script)
    Open3.capture3('osascript', '-l', language, stdin_data: script)
  end

  def applescript(script)
    res = osascript('AppleScript', script)
    state = res[0].chomp
    return false if state.empty? || state == 'false'
    return true if state.to_s.include?('OK')
    state
  end

  # Returns true (Ok) or false (Cancel) or
  # one of up to three custom button names
  #
  # :icon = stop, note or caution
  # Usage
  # button_dialog({prompt: 'Please select an option:',
  #                buttons: ["Option 1",
  #                          "Option 2",
  #                          "Option 3"]})
  def button_dialog(params = {})
    buttons_array = params[:buttons] ||= %w[OK Cancel ...]
    params[:prompt] = params[:prompt] ||= 'Select OK to continue:'
    params[:buttons] = buttons_array.to_s.delete('[]')
    script = 'tell app "System Events" '
    script << "to display dialog \"#{params[:prompt]}\" "
    script << "buttons {#{params[:buttons]}} "
    script << "with icon #{params[:icon]}" if params[:icon]
    res = applescript script
    return res if res.is_a?(TrueClass) || res.is_a?(FalseClass)
    res.gsub('button returned:', '')
  end

  def select_folder_dialog(params = {})
    params[:prompt] = params[:prompt] ||= 'Please select a folder'
    script = 'quoted form of POSIX path of '
    script << "(choose folder with prompt \"#{params[:prompt]}:\") "
    applescript script
  end

  # select_from_list_dialog({options:
  #                              ['Do this',
  #                               'Do that',
  #                               'Do Something Else',
  #                               "What the!!!"],
  #                          title: "LogicLinks",
  #                          prompt: "Make a selection:",
  #                          multi_select: true,
  #                          ok_btn_name: "Submit",
  #                          cnl_btn_name: "Abort"})
  def select_from_list_dialog(params = {})
    options_array = params[:options] ||= %w[Option-1 Option-2 Option-3]
    multi_select_msg(params)
    params[:default_options] = options_array[0] unless params[:default_options]
    params[:options] = options_array.to_s.delete('[]')
    applescript select_from_list_script(params)
  end

  def select_from_list_script(params)
    script = "choose from list {#{params[:options]}}"
    script << "with title \"#{params[:title]}\" " if params[:title]
    script << "with prompt \"#{params[:prompt]}\" " if params[:prompt]
    script << "OK button name \"#{params[:ok_btn_name]}\" " if params[:ok_btn_name]
    script << "cancel button name \"#{params[:cnl_btn_name]}\" " if params[:cnl_btn_name]
    script << "default items {\"#{params[:default_options]}\"} "
    script << 'with multiple selections allowed' if params[:multi_select]
    script
  end

  def multi_select_msg(params)
    return unless params[:multi_select]
    params[:prompt] =
      "#{params[:prompt]}\n(Cmd + click for multiple selection.) "
  end
end

require 'fileutils'
include FileUtils

def home_path
  File.expand_path('../spec_work/shhh_home', File.dirname(__FILE__))
end

def dotfiles_path
  File.expand_path('../spec_work/shhh_dotfiles', File.dirname(__FILE__))
end

def setup_work_directories
  mkdir_p(home_path)
  mkdir_p(dotfiles_path)
  Shhh.home_path = home_path
  Shhh.dotfiles_path = dotfiles_path
end

def cleanup_work_directories
  rm_rf(home_path)
  rm_rf(dotfiles_path)
end

def create_empty_file(path)
  File.open(path, "w") do |file|
    file.write(path)
  end
end
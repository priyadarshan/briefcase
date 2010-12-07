require 'commander/import'
require File.expand_path('../shhh', File.dirname(__FILE__))

program :name, 'Shhh'
program :version, Shhh::VERSION
program :description, 'Makes it easier to keep dotfiles in git'

command :import do |c|
  c.syntax = 'shhh import PATH'
  c.description = 'Move PATH to the version controlled directory and symlink from its current location.'
  c.when_called Shhh::Commands::Import
  c.option '--dynamic', 'Imports dotfile and creates dynamic version. Adds generated version\'s path to ~/.dotfiles/.gitignore.'
end

command :sync do |c|
  c.syntax = 'shhh sync'
  c.description = 'Updates all symlinks for files included in ~/.dotfiles'
  c.when_called Shhh::Commands::Sync
end

command :generate do |c|
  c.syntax = 'shhh generate'
  c.description = 'Generates static versions of all dynamic dotfiles in ~/.dotfiles'
  c.when_called Shhh::Commands::Generate
end

default_command :help

# command :suggest do |c|
#   c.syntax = 'shhh suggest'
#   c.description 'List dotfiles that are in your home directory and not in ~/.dotfiles'
#   c.when_called Shhh::Commands::Suggest
# end
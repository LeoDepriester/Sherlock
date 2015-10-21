#!/usr/bin/env ruby

"""
Sherlock is a little log analyser.
Copyright (C) 2014  Léo 'cryptobioz' Depriester (leo.depriester@exadot.fr)
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

require 'optparse'
require_relative "lib/sherlock"

sherlock = Sherlock::Base.new

command = [""]
while command[0] != "quit"
  print sherlock.prompt
  command = $stdin.gets.chomp
  command = command.split(' ')
  case command[0]
  when "help"
    puts "== COMMANDS =="
    puts "help              => Show all commands"
    puts "quit              => Leave the software"
    puts "show options      => Set availables options"
  when "set"
    if command.length == 3
      if command[1] == "service"
        sherlock.setService(command[2])
      else
        sherlock.setOption(command[1], command[2])
      end
    else
      puts "No enought arguments"
    end
  when "show"
    if command.length == 2
      if command[1] == "options"
        sherlock.availablesOptions
      end
    end
  when "back"
    sherlock.back
  when "services"
    sherlock.listServices
  when "quit"
    puts "Good Bye !"
  when "all"

  else
    puts "This command doesn't exist !"
  end
end

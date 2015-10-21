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
    puts "help                    => Show all commands"
    puts "quit                    => Leave the software"
    puts "services                => List availables services modules"
    puts "use [service]           => Use the selected service module"
    puts "options                 => Show options that will be use by a service"
    puts "service options         => Show help menu about availables options for your actual service"
    puts "service functions       => Show help menu about availables functions for your actual service"
    puts "run [function]          => Run function of your actual service"
  when "set"
    if command.length == 3
      sherlock.setOption(command[1], command[2])
    else
      puts "No enought arguments"
    end
  when "use"
    if command.length == 2
      sherlock.useService(command[1])
    end
  when "options"
    sherlock.getOptions
  when "service"
    case command[1]
    when "functions"
      sherlock.getServiceFunctions
    when "options"
      sherlock.getServiceOptions
    end
  when "run"
    if command.length == 2
      sherlock.run(command[1])
    end
  when "back"
    sherlock.back
  when "services"
    sherlock.listServices
  when "quit"
    puts "Good Bye !"
  end
end

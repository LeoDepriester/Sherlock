require_relative 'console'
require 'require_all'
require_rel '../services'
class Base
  extend SSH
  def initialize
    @service = nil
    @console = Console.new
  end

  def prompt
    return @console.showPrompt()
  end

  def setService(service)
    @service = service
    # Set service on console
    @console.setService(service)
  end

  def availablesOptions
    if @service == nil
      return @console.showError("options", "no_service")
    elsif @service == "ssh"
      puts SSH::getOptions
      return @console.showOptions(SSH::getOptions)
    end
  end

  def listServices
    Dir.foreach("lib/services/") do |file|
      if file =~ /\.rb/
        puts file.split('.rb')
      end
    end
  end

  def serviceOptions
  end
end

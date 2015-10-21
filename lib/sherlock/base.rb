require_relative "../services"

class Sherlock::Base
  def initialize
    @ssh     = Services::SSH.new
    # => @apache2 = Services::Apache2.new

    @service = nil
    @services = {"ssh" => @ssh}
    @console = Sherlock::Console.new
    @options = {}
  end

  def prompt
    return @console.showPrompt(@service)
  end

  def setService(service)
    if @services.include? service
      @service = service
      @options = @services[service].getOptions
    else
      @console.showError("service", "not_available")
    end
  end

  def back
    @service = nil
    @options = {}
  end

  def availablesOptions
    if @service == nil
      @console.showError("options", "no_service")
    elsif @service == "ssh"
      puts @ssh.getOptions
      @console.showOptions(@ssh.getOptions)
    end
  end

  def setOptions(option, argument)
    if @service == nil
      return @console.showError("options", "no_service")
    elsif @service == "ssh"
      @ssh.check

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

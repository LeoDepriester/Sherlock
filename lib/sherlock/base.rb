require_relative "../services"

class Sherlock::Base
  def initialize
    @ssh     = Services::SSH.new
    # => @apache2 = Services::Apache2.new

    @service = nil
    @services = {"ssh" => @ssh}
    @console = Sherlock::Console.new
    @options = Hash.new
  end

  def run
    if @service == nil
      @console.showError("run", "no_service")
    else
      @services[@service].run(@options)
    end
  end

  def prompt
    return @console.showPrompt(@service)
  end

  def options
    @console.showRegisteredOptions(@options)
  end

  def setService(service)
    if @services.include? service
      @service = service
      @options = @services[@service].getOptions
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
    else
      @console.show(@services[@service].optionsMenu)
    end
  end

  def setOption(option, argument)
    if @service == nil
      @console.showError("options", "no_service")
    else
      if @services[@service].checkOption(option, argument)
        @options[option] = argument
      else
        @console.showError("options", "bad_option")
      end
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

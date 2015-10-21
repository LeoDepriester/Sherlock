require_relative "../services"

class Sherlock::Base
  def initialize
    @ssh     = Services::SSH.new
    @apache2 = Services::Apache2.new

    @service = nil
    @services = {"ssh" => @ssh, "apache2" => @apache2}
    @console = Sherlock::Console.new
  end

  # Run a function of a service
  def run(function)
    if @service == nil
      @console.showError("run", "no_service")
    else
      @console.show(@services[@service].run(function))
    end
  end

  # Prepare the prompt
  def prompt
    return @console.showPrompt(@service)
  end

  # Configure a service for the user
  def useService(service)
    if @services.include? service
      @service = service
    else
      @console.showError("service", "not_available")
    end
  end

  # Unset the service
  def back
    @service = nil
    @options = {}
  end

  # List of options for a service
  def getOptions
    if @service == nil
      @console.showError("options", "no_service")
    else
      @console.showOptions(@services[@service].getOptions)
    end
  end

  # Set an option
  def setOption(option, argument)
    if @service == nil
      @console.showError("options", "no_service")
    else
      if @services[@service].checkOption(option, argument)
        @services[@service].setOption(option, argument)
      else
        @console.showError("options", "bad_option")
      end
    end
  end

  # Generate the list of services
  def listServices
    Dir.foreach("lib/services/") do |file|
      if file =~ /\.rb/
        puts file.split('.rb')
      end
    end
  end

  # Get help menu for functions
  def getServiceFunctions
    @console.show(@services[@service].functionsMenu)
  end

  # Get Help menu for options
  def getServiceOptions
    @console.show(@services[@service].optionsMenu)
  end

end

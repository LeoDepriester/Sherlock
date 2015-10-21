class Sherlock::Console
  def initialize
  end

  def showPrompt(service)
    return "#{service}> "
  end

  def setService(service)
    @service = service
  end

  def showOptions(options)
    return ""
  end

  def showError(command, error)
    case command
    when "service"
      case error
      when "not_available"
        puts "[-] This service doesn't exist."
      end
    when "options"
      case error
      when "no_service"
        puts "[-] Set service before."
      else
        puts "[-] Undefined error."
      end
    else
      puts "[-] Undefined error"
    end
  end
end

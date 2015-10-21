class Console
  def initialize
    @service = ""
  end

  def showPrompt
    return "#{@service}> "
  end

  def setService(service)
    @service = service
  end

  def showOptions(options)
    return ""
  end

  def showError(command, error)
    case command
    when "options"
      case error
      when "no_service"
        return "[-] Set service before."
      else
        return "[-] Undefined error."
      end
    else
      return "[-] Undefined error"
    end
  end
end

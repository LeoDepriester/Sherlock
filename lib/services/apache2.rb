require 'csv'
require 'time'
require 'date'

class Services::Apache2
  def initialize
    @log_files = Dir["dev/logs/access.log*"]
    @options = {"fd" => Time.now.strftime("%d-%m-%Y-%T"), "td" => Time.now.strftime("%d-%m-%Y-%T")}
    @functions = ["requests"]
  end

  """ < OPTIONS PART > """
  # Update an option
  def setOption(option, argument)
    @options[option] = argument
  end

  # Return list of options with values
  def getOptions
    return @options
  end

  # Check if an option exist
  def checkOption(option, argument)
    if @options.include? option
      if option == "fd" || option == "td"
        if checkFormatDate(argument)
          return true
        else
          return false
        end
      end
      return true
    else
      return false
    end
  end

  """ </ OPTIONS PART > """

  """ < MENU PART > """
  # Return help menu for options
  def optionsMenu
    menu  = "== OPTIONS ==\n"
    menu << "fd     <21-10-2015-07:28:00>  => Analyse logs from this date\n"
    menu << "td     <22-10-2015-00:00:00>  => Analyse logs to this date\n"
    return menu
  end

  # Return help menu for functions
  def functionsMenu
    menu  = "== FUNCTIONS ==\n"
    menu << "requests                      => Return all requests between 'fd' and 'td'\n"
    return menu
  end

  """ < MENU PART > """


  # Run a function
  def run(function)
    case function
    when "requests"
      getRequests
    end
  end


  """ < CORE PART > """
  # Return all requests
  def getRequests
    results = ""
    @log_files.each do |file|
      counter = 0
      file = File.new(file, "r")
      while (line = file.gets)
        # Get date of line
        date = getDateFromLog(line)
        if goodDate(date)
          data = line.match(/^([0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}) \- \- \[([0-9]{1,2}\/[a-zA-Z]{3}\/[0-9]{4}):([0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2}) \+[0-9]{4}\] \"(.*) \/(.*) HTTP\/1\.1\" [0-9]{3} [0-9]{3} \"-\" \"(.*)\"$/)
          if data != nil
            results << '%-15s | ' % data[1]
            results << '%-12s | ' % data[2]
            results << '%-9s | ' % data[3]
            results << '%-5s | ' % data[4]
            results << '/%-35s | ' % data[5]
            results << data[6]
            results << "\n"
          end
        end
      end
      file.close
    end
    if results == ""
      return "[*] No result."
    else
      return results
    end
  end
  """ </ CORE PART > """

  """ < PRIVATE PART > """
  def goodDate(date)
    fd = getDateFromUser(@options["fd"])
    td = getDateFromUser(@options["td"])
    ts_line = DateTime.new(date[:year].to_i, date[:month].to_i, date[:day].to_i, date[:hour].to_i, date[:min].to_i, date[:sec].to_i).to_time.to_i
    ts_fd = DateTime.new(fd[:year], fd[:month], fd[:day], fd[:hour], fd[:min], fd[:sec]).to_time.to_i
    ts_td = DateTime.new(td[:year], td[:month], td[:day], td[:hour], td[:min], td[:sec]).to_time.to_i
    if ts_line > ts_fd && ts_line < ts_td
      return true
    else
      return false
    end
  end

  def getDateFromLog(line)
    data = line.match(/^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3} - - \[([0-9]{1,2})\/([a-zA-Z]{3})\/([0-9]{4}):([0-9]{1,2}):([0-9]{1,2}):([0-9]{1,2})/)
    month = Time.parse(data[2])
    month = month.strftime("%m")
    date = {:day => data[1], :month => month, :year => data[3], :hour => data[4], :min => data[5], :sec => data[6]}
    return date
  end

  def getDateFromUser(date)
    data = date.match(/^([0-9]{2})-([0-9]{2})-([0-9]{4})-([0-9]{2}):([0-9]{2}):([0-9]{2})$/)
    date = {:day => data[1].to_i, :month => data[2].to_i, :year => data[3].to_i, :hour => data[4].to_i, :min => data[5].to_i, :sec => data[6].to_i}
    return date
  end

  def checkFormatDate(date)
    if date =~ /^[0-9]{2}-[0-9]{2}-[0-9]{4}-[0-9]{2}:[0-9]{2}:[0-9]{2}$/
      return true
    else
      return false
    end
  end
  """ </ PRIVATE PART > """
end

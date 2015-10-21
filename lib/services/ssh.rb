require 'csv'
require 'time'
require 'date'

class Services::SSH
  def initialize
    @log_files = Dir["dev/logs/auth.log*"]
    @options = {"fd" => Time.now.strftime("%d-%m-%Y-%T"), "td" => Time.now.strftime("%d-%m-%Y-%T"), "export" => "No "}
    @functions = ["connections"]
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
    menu << "export yes|no                 => Do you want export results to CSV\n"
    return menu
  end

  # Return help menu for functions
  def functionsMenu
    menu  = "== FUNCTIONS ==\n"
    menu << "connections                  => Return all connections between 'fd' and 'td'\n"
    return menu
  end

  """ < MENU PART > """


  # Run a function
  def run(function)
    case function
    when "connections"
      getConnections
    end
  end


  """ < CORE PART > """
  # Return all connections and disconnections
  def getConnections
    @log_files.each do |file|
      counter = 0
      file = File.new(file, "r")
      while (line = file.gets)
        # Get date of line
        date = getDateFromLog(line)
        if goodDate(date)
          if(line =~ /CRON\[\d+\]/)
          elsif(line =~ /sshd\[\d+\]/)
            # User connection
            if(line =~ /Accepted password/)
              data = line.match(/^([a-zA-Z]{3} [0-9]{1,2}) ([0-9]{2}:[0-9]{1,2}:[0-9]{1,2}) .* for (.*) from ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})/)
              puts "Type : Connection"
              puts "Date : #{data[1]}"
              puts "Hour : #{data[2]}"
              puts "User : #{data[3]}"
              puts "IP   : #{data[4]}"
              puts "Line : #{line}"
              puts ""

            elsif(line =~ /Received disconnect/)
              data = line.match(/^([a-zA-Z]{3} [0-9]{1,2}) ([0-9]{2}:[0-9]{1,2}:[0-9]{1,2}) .* from ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})/)
              puts "Type : Disconnect"
              puts "Date : #{data[1]}"
              puts "Hour : #{data[2]}"
              puts "IP   : #{data[3]}"
              puts "Line : #{line}"
              puts ""
            end
          end
          counter = counter + 1
        end
        end
        file.close
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
    data = line.match(/^([a-zA-Z]{3}) ([0-9]{1,2}) ([0-9]{2}):([0-9]{1,2}):([0-9]{1,2})/)
    month = Time.parse(data[1])
    month = month.strftime("%m")
    date = {:day => data[2], :month => month, :year => Time.now.strftime("%Y"), :hour => data[3], :min => data[4], :sec => data[5]}
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

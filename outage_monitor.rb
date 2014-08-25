# outage_monitor.rb
# 
# Ruby script to monitor Comcast internet outages
# a datetime log entry is made every time the connection fails
#
# usage: ruby outage_monitor.rb

LOG_FILE = 'outages.txt'
INTERVAL = 60 # seconds
IP_LIST = [
           '68.87.75.194', # Comcast primary PA DNS server
           '68.87.64.146', # Comcast secondary PA DNS server
           '68.87.64.146', # Comcast East Coast DNS server
           '8.8.8.8' # Google primary DNS server
          ]

# checks the internet connection at the requested interval
def run
  while true
    create_log_entry unless connection_is_active
    sleep(INTERVAL)
  end
end

# determines if a connection can be made to any of the provided IPs
def connection_is_active  
  IP_LIST.each do |ip|
    return true if ip_is_active(ip)
  end
  
  false
end

# pings the requested IP
def ip_is_active(ip)
  `ping -c 1 #{ip}`
  $?.exitstatus == 0
end

# writes a datetime to the log
def create_log_entry
  File.open(LOG_FILE, 'a') do |file|
    file.write(Time.now)
    file.write("\n")
  end
end

# starts the script
if __FILE__ == $0
  run
end

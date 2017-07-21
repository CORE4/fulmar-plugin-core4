require 'rbconfig'

global_test 'Find duplicates in hosts file' do |_config|
  is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)
  hosts_file = is_windows ? 'C:\Windows\System32\drivers\etc\hosts' : '/etc/hosts'
  duplicates = Fulmar::Plugin::CORE4::HostFile.new(hosts_file).check
  next {severity: :warning,
    message: "Found duplicates in hosts file: #{duplicates.join(', ')}"
  } unless duplicates.empty?
end

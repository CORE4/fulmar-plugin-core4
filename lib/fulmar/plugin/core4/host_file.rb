module Fulmar
  module Plugin
    module CORE4
      # Analyses /etc/hosts
      class HostFile
        attr_reader :filename

        def initialize(filename)
          @filename = filename
        end

        def check
          read_file
          duplicate_ipv4 = find_duplicates(@ipv4_hosts)
          duplicate_ipv6 = find_duplicates(@ipv6_hosts)
          duplicate_ipv4 + duplicate_ipv6
        end

        def find_duplicates(hosts)
          hosts.group_by(&:last).select { |_key, value| value.size > 1 }.map(&:first)
        end

        def read_file
          @ipv4_hosts = []
          @ipv6_hosts = []
          File.open(@filename) do |file|
            until file.eof?
              if (hosts = parse_line(file.gets))
                ip = hosts.shift
                add_hosts(ip, hosts)
              end
            end
          end
        end

        protected

        def add_hosts(ip, hosts)
          if ip.include?(':') # ipv6
            hosts.each do |host|
              @ipv6_hosts << [ip, host]
            end
          else # ipv4
            hosts.each do |host|
              @ipv4_hosts << [ip, host]
            end
          end
        end

        def parse_line(line)
          return nil unless line
          line = line.split('#').first.strip
          return nil if line.empty?
          parts = line.gsub(/\s+/, ' ').split(' ')
          return nil if parts.size == 1
          parts
        end
      end
    end
  end
end

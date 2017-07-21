require 'fulmar/plugin/core4/host_file'

include Fulmar::Plugin::CORE4

HOST_FILE_PATH = "#{File.dirname(__FILE__)}/fixtures/host_files".freeze

describe HostFile do
  describe 'check' do
    it 'should return no errors for an empty file' do
      host_file = HostFile.new("#{HOST_FILE_PATH}/empty_hosts.txt")
      expect(host_file.check).to be_empty
    end

    it 'should return no errors for a simple file' do
      host_file = HostFile.new("#{HOST_FILE_PATH}/simple_hosts.txt")
      expect(host_file.check).to be_empty
    end

    it 'should find duplicate IPv6 hosts' do
      host_file = HostFile.new("#{HOST_FILE_PATH}/duplicatev6_hosts.txt")
      expect(host_file.check).to include 'homeserver'
    end

    it 'should find a duplicate for ipv4' do
      host_file = HostFile.new("#{HOST_FILE_PATH}/duplicatev4_hosts.txt")
      expect(host_file.check).to include 'homeserver'
    end

    it 'should not find duplicates in comments' do
      host_file = HostFile.new("#{HOST_FILE_PATH}/comment_hosts.txt")
      expect(host_file.check).to be_empty
    end

    it 'should not mix and match IPv4 and IPv6' do
      host_file = HostFile.new("#{HOST_FILE_PATH}/ipv6_hosts.txt")
      expect(host_file.check).to be_empty
    end

    it 'should find both duplicates in lists' do
      host_file = HostFile.new("#{HOST_FILE_PATH}/duplicate_hidden.txt")
      expect(host_file.check).to include 'mysql'
      expect(host_file.check).to include 'redis'
    end
  end
end

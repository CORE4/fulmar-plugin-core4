def vagrant_sharing_port
  @port ||= rand(10_000..65_535)
end

if config.plugins.dig(:core4, :enable_vagrant_sharing)
  namespace :share do
    task :prepare

    desc 'Share vagrant machine within the local network'
    task vagrant: 'share:prepare' do
      info "Open https://vagrant#{vagrant_sharing_port}.core4dev.de"
      remote_shell.interactive = true
      remote_shell.run "ssh -R #{vagrant_sharing_port}:localhost:443 -p 314 core4@192.168.2.36"
    end

    namespace :prepare do
      task neos: 'environment:vagrant:neos' do
        site_node_name = config[:site_node_name]
        hostname = "vagrant#{vagrant_sharing_port}.core4dev.de"

        # Remove existing share domains
        remote_shell.strict = false
        if remote_shell.run "FLOW_CONTEXT=#{config[:flow_context]} ./flow domain:list | grep vagrant"
          remote_shell.last_output.each do |line|
            if (data = /^\|[\w\s]+\|\s+([a-zA-Z\d\-.]+)\s+\|/.match(line))
              remote_shell.run "FLOW_CONTEXT=#{config[:flow_context]} ./flow domain:delete --hostname #{data[1]}"
            end
          end
        end
        remote_shell.strict = true

        # Add a new share domain
        remote_shell.run "FLOW_CONTEXT=#{config[:flow_context]} " \
                       "./flow domain:add --site-node-name #{site_node_name} --hostname #{hostname}"
      end
    end
  end
end

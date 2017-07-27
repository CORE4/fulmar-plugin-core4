namespace :initialize do
  # common tasks for all projects
  task :vagrant do
    info 'Running common vagrant tasks...'
    # Add composer auth
    auth_json = "#{ENV['HOME']}/.composer/auth.json"
    if File.exist?(auth_json)
      info ' Copying local composer auth file into vagrant machine...'
      local_shell.run "cat #{auth_json} | vagrant ssh -c \"mkdir -p ~/.composer; cat > ~/.composer/auth.json\""
    else
      info " #{auth_json} not found. Skipping..."
    end

    # Add known hosts
    info ' Copying known_hosts for this project...'
    local_shell.run "cat .known_hosts | vagrant ssh -c \"cat > ~/.ssh/known_hosts\"", in: config.base_path

    # Add ssh config
    info ' Adding ssh configuration for this project...'
    Dir.mktmpdir do |temp_directory|
      download('/home/vagrant/.ssh/config', temp_directory)
      service = Fulmar::Infrastructure::Service::SSHConfigService.new(config, "#{temp_directory}/config")
      service.quiet = true
      service.add_hosts
      upload("#{temp_directory}/config", '/home/vagrant/.ssh')
      FileUtils.rm "#{temp_directory}/config"
      FileUtils.rm "#{temp_directory}/config.bak"
    end

    # Replace FLOW_CONTEXT with a personal one
    neos_config = '/etc/nginx/sites-available/neos.conf'
    remote_shell.strict = false
    if remote_shell.run "test -f #{neos_config}"
      username = `git config --global user.name`.strip.gsub(' ', '')
      flow_context = "Development/Vagrant/#{username}"
      info " Setting flow context to #{flow_context}..."
      remote_shell.run [
        "sudo sed -i.bak \"s+Development/Vagrant;+#{flow_context};+g\" neos.conf",
        'sudo rm neos.conf.bak'
      ], in: '/etc/nginx/sites-available'
      remote_shell.run [
        "sed -i.bak s+\\\"Development/Vagrant\"+\"#{flow_context}\\\"+g local.fish",
        'rm local.fish.bak'
      ], in: '/home/vagrant/.config/fish'
    else
      info " #{neos_config} not found. Skipping..."
    end

    remote_shell.strict = true
  end
end

unless config.plugins[:core4][:sync].nil?
  namespace :setup do
    namespace :vagrant do
      desc 'Update vagrant database and assets from internal cache server'
      task :download do
        plugin_config = config.plugins[:core4][:sync]
        config.set *config.plugins[:core4][:sync][:to].split(':').map(&:to_sym)

        info 'Loading database...'
        remote_shell.run "curl -s #{plugin_config[:database_url]} > /tmp/database.sql.gz"
        mariadb.load_dump('/tmp/database.sql.gz')

        info 'Loading assets...'
        urls = [*plugin_config[:assets_url]]
        paths = [*plugin_config[:assets_path]]
        fail 'The number of assets urls must match the number of assets paths' unless urls.size == paths.size
        urls.each_index do |i|
          remote_shell.run [
            "mkdir -p #{paths[i]}",
            "curl -s #{urls[i]} | tar -xzf - -C #{paths[i]}"
          ]
        end
      end
    end
  end
end

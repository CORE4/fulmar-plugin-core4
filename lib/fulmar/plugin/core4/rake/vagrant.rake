namespace :initialize do
  # common tasks for all projects
  task :vagrant do
    info 'Common Vagrant tasks'
    auth_json = "#{ENV['HOME']}/.composer/auth.json"
    if File.exist?(auth_json)
      info ' Copying local composer auth file into vagrant machine...'
      local_shell.run "cat #{auth_json} | vagrant ssh -c \"mkdir -p ~/.composer; cat > ~/.composer/auth.json\""
    else
      info "#{auth_json} not found. Skipping..."
    end

    info ' Copying known_hosts for this project...'
    local_shell.run "cat .known_hosts | vagrant ssh -c \"cat > ~/.ssh/known_hosts\"", in: config.base_path

    # Replace flow_context with a personal one
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

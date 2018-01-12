namespace :cleanup do
  desc 'Clean up all related vms and other stuff after/before build'
  task vms: 'environment:local:base' do
    # Remove packaged box
    FileUtils.rm_f 'package.box'

    box = config.project.name

    # Manually stop running vms
    local_shell.run 'vboxmanage list runningvms'
    output = local_shell.last_output.map { |line| line.split(' ').first }.select { |line| line.include?(box) }
    output.each do |old_machine|
      local_shell.run "vboxmanage controlvm #{old_machine} poweroff"
    end

    # Manually remove all vms
    local_shell.run 'vboxmanage list vms'
    output = local_shell.last_output.map { |line| line.split(' ').first }.select { |line| line.include?(box) }
    output.each do |old_machine|
      local_shell.run "vboxmanage unregistervm #{old_machine} --delete"
    end

    # Remove any leftover files
    local_shell.run "rm -fr \"VirtualBox VMs/#{box}#*\"; true", in: ENV['HOME']
  end
end

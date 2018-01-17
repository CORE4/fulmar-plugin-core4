def vagrant_sharing_port
  @port ||= rand(10_000..65_535)
end

namespace :share do
  task :prepare

  task vagrant: 'share:prepare' do
    info "Open https://vagrant#{vagrant_sharing_port}.core4dev.de"
    remote_shell.run "ssh -R #{vagrant_sharing_port}:localhost:443 -n"
  end
end

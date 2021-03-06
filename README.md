# Fulmar::Plugin::CORE4

This plugin combines several helping tasks and services for CORE4 GmbH & Co. KG.
If you find it useful anyway, feel free to use it.

## Installation

This plugin will be installable via gem install `fulmar-plugin-core4` when it is working. It will need Fulmar 2.
You can also checkout this repo and run `gem build fulmar-plugin-core4.gemspec` and
`gem install fulmar-plugin-core4*.gem`

## Usage

### fulmar test:config

This plugin adds an additional test to the `test:config` task. It checks
your host file (e.g. /etc/hosts) for duplicate entries. These may occur
when a vagrant machine is not uninstalled via `vagrant destroy`.

### fulmar setup:vagrant:download

The plugin provides a task to update local development environment from
cached data on the internal storage server. 

You can configure the asset and database path for the internal cache
server within the plugin configuration. It should look something like this:

```yaml
plugin:
  core4:
    sync:
      to: 'vagrant:neos'
      dump_path: /srv/storage/xxx/yyy.sql.gz
      remote_assets_path: /srv/storage/xxx/Resources
      assets_path: /srv/neos/Data/Persistent/Resources
```

`remote_assets_path` and `assets_path` may be arrays of the same size. Fulmar
will then iterate over all file and extract them to the given directories:

```yaml
plugin:
  core4:
    sync:
      to: 'vagrant:neos'
      dump_path: /srv/storage/xxx/yyy.sql.gz
      remote_assets_path:
        - /srv/storage/xxx/Resources
        - /srv/storage/xxx/Something
      assets_path:
        - /srv/neos/Data/Persistent/Resources
        - /srv/neos/Data/Something
```

### Vagrant sharing

A fulmar task allows sharing the vagrant machine with the local network. Port 443 ist forwarded to
a proxy which will make the content accessible.

The Task `share:vagrant` open the tunnel but needs a loaded environment. You can add the
environment/target configuration in the empty task `share:prepare`.

```ruby
namespace :share do
  task prepare: 'environment:vagrant:neos' do
    # prepare your app, add the new domain
    # "vagrant#{vagrant_sharing_port}.core4dev.de"
  end
end
```

If you configure a Neos environment, you can use the prebuilt task `share:prepare` like this:

```ruby
namespace :share do
  task prepare: 'environment:vagrant:neos share:prepare:neos'
end
```

You need to configure the option `site_node_name` .

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/CORE4/fulmar-plugin-core4.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

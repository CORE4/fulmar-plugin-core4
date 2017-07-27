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

### fulmar vagrant:update

The plugin provides a task to update local development environment from
cached data on the internal storage server. 

You can configure the asset and database urls for the internal cache
server within the plugin configuration. It should look something like this:

```yaml
plugin:
  core4:
    sync:
      to: 'vagrant:neos'
      database_url: https://storage.core4.de/xxx/yyy.sql.gz
      assets_url: https://storage.core4.de/xxx/zzz.tar.gz
      assets_path: /srv/neos/Data/Persistent
```

`assets_url` and `assets_path` may be arrays of the same size. Fulmar
will then iterate over all file and extract them to the given directories:

```yaml
plugin:
  core4:
    sync:
      to: 'vagrant:neos'
      database_url: https://storage.core4.de/xxx/yyy.sql.gz
      assets_url:
        - https://storage.core4.de/xxx/zzz1.tar.gz
        - https://storage.core4.de/xxx/zzz2.tar.gz
      assets_path:
        - /srv/neos/Data/Persistent
        - /srv/neos/Data/Something
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/CORE4/fulmar-plugin-core4.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

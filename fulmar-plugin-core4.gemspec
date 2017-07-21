# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fulmar/plugin/core4/version'

Gem::Specification.new do |spec|
  spec.name          = 'fulmar-plugin-core4'
  spec.version       = Fulmar::Plugin::CORE4::VERSION
  spec.authors       = ['Gerrit Visscher']
  spec.email         = ['g.visscher@core4.de']

  spec.summary       = 'CORE4 GmbH internal plugin'
  spec.description   = 'This adds specific helper methods and tasks for our workflow at CORE4 GmbH'
  spec.homepage      = 'https://github.com/CORE4/fulmar-plugin-core4'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/}) || %w(.editorconfig).include?(f)
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'fulmar', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
end

# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = 'knife-ansible-inventory'
  spec.version       = '0.1.0'
  spec.authors       = ['Austin Heiman']
  spec.email         = ['atheimanksu@gmail.com']

  spec.summary       = 'Chef knife plugin for generating an Ansible inventory'
  spec.homepage      = 'https://github.com/atheiman/knife-ansible-inventory'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'chef', '~> 12.12'
  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end

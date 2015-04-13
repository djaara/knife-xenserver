# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "knife-xenserver/version"

Gem::Specification.new do |s|
  s.name        = "knife-xenserver"
  s.version     = Knife::XenServer::VERSION
  s.has_rdoc    = true
  s.authors     = ["Sergio Rubio", "Pedro Perez"]
  s.email       = ["info@bvox.net"]
  s.homepage = "http://github.com/bvox/knife-xenserver"
  s.summary = "XenServer Support for Chef's Knife Command"
  s.description = s.summary
  s.extra_rdoc_files = ["README.md", "LICENSE" ]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.add_dependency "fog", ">= 1.20"
  s.add_dependency "terminal-table", "~> 1.4"
  s.add_dependency "chef", "~> 11.0"
  s.add_dependency "colored", "= 1.2"
  s.add_dependency "uuidtools", "~> 2.1"
  s.require_paths = ["lib"]
end

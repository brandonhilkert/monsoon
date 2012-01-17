# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "monsoon/version"

Gem::Specification.new do |s|
  s.name        = "monsoon"
  s.version     = Monsoon::VERSION
  s.authors     = ["Brandon Hilkert"]
  s.email       = ["brandonhilkert@gmail.com"]
  s.homepage    = "https://github.com/brandonhilkert/egg_carton"
  s.summary     = %q{Monsoon MongoDB Backup Utility}
  s.description = %q{Monsoon is a MongoDB backup tool that allows you to take backups and store them in Amazon S3.}

  s.rubyforge_project = "monsoon"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", "~> 2.8"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rake"
end

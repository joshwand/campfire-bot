# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "version"

Gem::Specification.new do |s|
  s.name        = "campfire-bot"
  s.version     = CampfireBot::VERSION
  s.authors     = ["Josh Wand", "Chad Boyd"]
  s.email       = ["", "hoverlover@gmail.com"]
  s.homepage    = "https://github.com/joshwand/campfire-bot"
  s.summary     = %q{This is a bot for 37 Signals’ Campfire chat service.}
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib", "plugins"]

  s.add_dependency 'twitter-stream', '~> 0.1'
  s.add_dependency 'tinder', '>= 1.4.3'
  s.add_dependency 'hpricot', '~> 0.8.3'
  s.add_dependency 'mime-types', '~> 1.16'
  s.add_dependency 'activesupport', '~> 3.0.3'
  s.add_dependency 'logging', '~> 1.4.3'
  s.add_dependency 'eventmachine', '~> 0.12.10'
  s.add_dependency 'i18n', '~> 0.5.0'
end

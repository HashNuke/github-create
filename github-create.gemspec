$:.push File.expand_path("../lib", __FILE__)

require "github-create/version"

Gem::Specification.new do |s|
  s.name        = "github-create"
  s.version     = Github::Create::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Akash Manohar"]
  s.email       = ["akash@akash.im"]
  s.homepage    = "http://akash.im"
  s.summary     = "github-create v0.1"
  s.description = "github-create helps you setup github repositories for your projects from command-line"

  s.rubyforge_project = "github-create"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

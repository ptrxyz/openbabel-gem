$:.unshift File.expand_path('../lib', __FILE__)
require 'openbabel/version'

Gem::Specification.new do |s|
  s.name               = "openbabel"
  s.version            = OpenBabel::GEMVERSION

  s.authors = ["Andreas Maunz, Christoph Helma, Katsuhiko Nishimra"]
  s.date = %q{2012-04-03}
  s.description = %q{OpenBabel as a GEM}
  s.email = ["andreas@maunz.de","helma@in-silico.ch"]
  s.homepage = %q{http://github.com/opentox/openbabel-gem}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{OpenBabel!}
  s.license = "GPL-3"
  s.test_files = ["test/test_openbabel.rb"]

  s.files = %w{Rakefile lib/openbabel.rb lib/openbabel/version.rb}
  s.extensions = ['ext/openbabel/extconf.rb']
end

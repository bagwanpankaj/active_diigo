# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{active_diigo}
  s.version = File.read("./VERSION")#"0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bagwan Pankaj"]
  s.date = %q{2011-02-02}
  s.description = %q{ActiveDiigo is a wrapper for Diigo API(version: v2).}
  s.email = %q{me@bagwanpankaj.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.markdown"
  ]
  s.files = [
    "LICENSE.txt",
    "VERSION",
    "lib/active_diigo.rb",
    "lib/active_diigo/base.rb",
    "lib/active_diigo/errors.rb",
    "lib/active_diigo/request.rb",
    "lib/active_diigo/response_object.rb"
  ]
  s.homepage = %q{http://github.com/bagwanpankaj/active_diigo}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Diigo Restful API wrapper; much like ActiveRecord}
  s.test_files = [
    "spec/active_diigo_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/fake_web_stub.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
    else
      s.add_dependency(%q<httparty>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
    end
  else
    s.add_dependency(%q<httparty>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
  end
end


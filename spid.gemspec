# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "spid/version"

Gem::Specification.new do |spec|
  spec.name       = "spid"
  spec.version    = Spid::VERSION
  spec.authors    = ["David Librera"]
  spec.email      = ["davidlibrera@gmail.com"]
  spec.homepage   = "https://github.com/italia/spid-ruby"
  spec.summary    = "SPID (https://www.spid.gov.it) integration for ruby"
  spec.license    = "BSD-3"
  spec.files      = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.metadata    = {
    "homepage_uri" => "https://github.com/italia/spid-ruby",
    "changelog_uri" => "https://github.com/italia/spid-ruby/blob/master/CHANGELOG.md",
    "source_code_uri" => "https://github.com/italia/spid-ruby/",
    "bug_tracker_uri" => "https://github.com/italia/spid-ruby/issues"
  }
  spec.required_ruby_version = ">= 3.1"

  spec.add_runtime_dependency "activesupport", ">= 7.0.2.3"
  spec.add_runtime_dependency "listen", ">= 0"
  spec.add_runtime_dependency "rack", ">= 1", "< 3"
  spec.add_runtime_dependency "rake", ">= 10.0", "< 13"
  spec.add_runtime_dependency "xmldsig", ">= 0.6.6"

  spec.add_development_dependency "bundler", "~> 2.3.7"
  spec.add_development_dependency "bundler-audit", "~> 0"
  spec.add_development_dependency "coveralls", "~> 0"
  spec.add_development_dependency "faraday", "~> 0"
  spec.add_development_dependency "faraday_middleware", "~> 0"
  spec.add_development_dependency "nokogiri", "~> 1.8", ">= 1.8.3"
  spec.add_development_dependency "pry", "~> 0"
  spec.add_development_dependency "pry-doc", "~> 0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "0.57.2"
  spec.add_development_dependency "rubocop-rspec", "1.27.0"
  spec.add_development_dependency "timecop", "~> 0"
  spec.add_development_dependency "vcr", "~> 4.0", ">= 4.0.0"
  spec.add_development_dependency "webmock", "~> 3.4", ">= 3.4.2"
end

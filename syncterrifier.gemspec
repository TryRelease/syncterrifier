# frozen_string_literal: true

require_relative "lib/syncterrifier/version"

Gem::Specification.new do |spec|
  spec.name = "syncterrifier"
  spec.version = Syncterrifier::VERSION
  spec.authors = ["Bradley Herman"]
  spec.email = ["brad@tryrelease.com"]

  spec.summary = "Gem to interact w/ the Synctera API"
  spec.description = "Synctera doesn't have an SDK for Ruby, so we built one.  Syncterrifying."
  spec.homepage = "https://github.com/TryRelease/syncterrifier"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/TryRelease/syncterrifier"
  spec.metadata["changelog_uri"] = "https://github.com/TryRelease/syncterrifier/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'amazing_print'
end

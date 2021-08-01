require_relative "lib/syslog_parser/version"

Gem::Specification.new do |spec|
  spec.name = "syslog_parser"
  spec.version = SyslogParser::VERSION
  spec.authors = ["Juan Manuel Ramallo"]
  spec.email = ["juanmanuelramallo@hey.com"]

  spec.summary = "Syslog parser"
  spec.description = "Syslog parser"
  spec.homepage = "https://github.com/juanmanuelramallo/syslog_parser"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/juanmanuelramallo/syslog_parser"
  spec.metadata["changelog_uri"] = "https://github.com/juanmanuelramallo/syslog_parser/blob/master/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]
end

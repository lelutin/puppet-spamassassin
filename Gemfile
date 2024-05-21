source ENV['GEM_SOURCE'] || 'https://rubygems.org'

def location_for(place_or_version, fake_version = nil)
  case place_or_version
  when %r{\A(git[:@][^#]*)#(.*)}
    [fake_version, { git: Regexp.last_match(1), branch: Regexp.last_match(2), require: false }].compact
  when %r{\Afile://(.*)}
    ['>= 0', { path: File.expand_path(Regexp.last_match(1)), require: false }]
  else
    [place_or_version, { require: false }]
  end
end

def gem_type(place_or_version)
  if place_or_version =~ %r{\Agit[:@]}
    :git
  elsif !place_or_version.nil? && place_or_version.start_with?('file:')
    :file
  else
    :gem
  end
end

puppet_version = "~> #{ENV['PUPPET_GEM_VERSION']}" unless ENV['PUPPET_GEM_VERSION'].nil?
puppet_type = gem_type(puppet_version)
facter_version = ENV['FACTER_GEM_VERSION']
hiera_version = ENV['HIERA_GEM_VERSION']

ruby_version_segments = Gem::Version.new(RUBY_VERSION.dup).segments
minor_version = ruby_version_segments[0..1].join('.')

group :development do
  if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.1.0')
    gem 'fast_gettext', '2.4.0', require: false
  else
    gem 'fast_gettext', require: false
  end
  if Gem::Version.new(RUBY_VERSION.dup) == Gem::Version.new('2.1.9')
    gem 'json', '= 2.7.1', require: false
  else
    gem 'json', '<= 2.7.1', require: false
  end
  gem 'json_pure', '<= 2.7.1', require: false if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.0.0')
  # rubocop:disable Bundler/DuplicatedGem
  gem 'puppet-blacksmith', '~> 7.0', require: false, platforms: [:ruby] if Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new('2.7.0')
  gem 'puppet-blacksmith', '~> 6.1', require: false, platforms: [:ruby] if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.7.0')
  # rubocop:enable Bundler/DuplicatedGem
end

gem 'puppetlabs_spec_helper', '>= 5.0', require: false
gem 'rake', require: false

# Use info from metadata.json for tests
# rubocop:disable Bundler/DuplicatedGem
gem 'puppet_metadata', '~> 3.0', require: false if Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new('2.7.0')
gem 'puppet_metadata', '~> 2.1', require: false if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.7.0')
# rubocop:enable Bundler/DuplicatedGem

# This draws in rubocop and other useful gems for puppet tests
# rubocop:disable Bundler/DuplicatedGem
gem 'voxpupuli-test', '~> 6.0', require: false if Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new('2.7.0')
gem 'voxpupuli-test', '~> 5.7', require: false if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.7.0')
# rubocop:enable Bundler/DuplicatedGem

gems = {}

gems['puppet'] = location_for(puppet_version)

# If facter or hiera versions have been specified via the environment
# variables

gems['facter'] = location_for(facter_version) if facter_version
gems['hiera'] = location_for(hiera_version) if hiera_version

if Gem.win_platform? && puppet_version =~ %r{^(file:///|git://)}
  # If we're using a Puppet gem on Windows which handles its own win32-xxx gem
  # dependencies (>= 3.5.0), set the maximum versions (see PUP-6445).
  gems['win32-dir'] =      ['<= 0.4.9', { require: false }]
  gems['win32-eventlog'] = ['<= 0.6.5', { require: false }]
  gems['win32-process'] =  ['<= 0.7.5', { require: false }]
  gems['win32-security'] = ['<= 0.2.5', { require: false }]
  gems['win32-service'] =  ['0.8.8', { require: false }]
end

gems.each do |gem_name, gem_params|
  gem gem_name, *gem_params
end

# Evaluate Gemfile.local and ~/.gemfile if they exist
extra_gemfiles = [
  "#{__FILE__}.local",
  File.join(Dir.home, '.gemfile'),
]

extra_gemfiles.each do |gemfile|
  eval(File.read(gemfile), binding) if File.file?(gemfile) && File.readable?(gemfile) # rubocop:disable Security/Eval
end
# vim: syntax=ruby

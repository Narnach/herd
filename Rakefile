require "rake"
require "rake/clean"
require "rake/gempackagetask"
require 'rubygems'

################################################################################
### Gem
################################################################################

begin
  # Parse gemspec using the github safety level.
  filename = Dir['*.gemspec'].first
  data = File.read(filename)
  spec = nil
  Thread.new { spec = eval("$SAFE = 3\n%s" % data)}.join

  # Create the gem tasks
  Rake::GemPackageTask.new(spec) do |package|
    package.gem_spec = spec
  end
rescue Exception => e
  printf "WARNING: Error caught (%s): %s\n", e.class.name, e.message
end

desc 'Package and install the gem for the current version'
task :install => :gem do
  system "sudo gem install -l pkg/%s-%s.gem" % [spec.name, spec.version]
end

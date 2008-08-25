Gem::Specification.new do |s|
  # Project
  s.name         = 'herd'
  s.summary      = "Herd a pack of mongrels"
  s.description  = "You can use it to control multiple mongrel and merb clusters in different directories at the same time."
  s.version      = '0.1.0'
  s.date         = '2008-08-25'
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["Wes Oldenbeuving", "Filip H.F. Slagter"]
  s.email        = "narnach@gmail.com"
  s.homepage     = "http://www.github.com/Narnach/herd"

  # Files
  s.bindir       = "bin"
  s.executables  = %w[herd]
  s.require_path = "lib"
  bin_files = %w[herd].map {|f| 'bin/%s' % f}
  lib_files = %w[herd].map {|f| 'lib/%s.rb' % f}
  test_files = %w[].map {|f| 'test/%s' % f}
  spec_files = %w[].map {|f| 'spec/%s' % f}
  s.files        = %w[MIT-LICENSE README.rdoc Rakefile herd.gemspec] + bin_files + lib_files + test_files + spec_files
  s.test_files   = test_files + spec_files

  # rdoc
  s.has_rdoc         = true
  s.extra_rdoc_files = %w[ README.rdoc MIT-LICENSE]
  s.rdoc_options << '--inline-source' << '--line-numbers' << '--main' << 'README.rdoc'

  # Requirements
  s.required_ruby_version = ">= 1.8.0"
end

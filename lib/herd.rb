require 'yaml'

class Herd
  attr_reader :project, :extra_mongrel_options

  def initialize(project=nil,extra_mongrel_options=nil)
    @project = project
    @extra_mongrel_options = extra_mongrel_options
  end

  def init
    proj = config[project] ||= {}
    proj['rails_dirs'] ||= []
    proj['merbs'] ||= []
    proj['mongrel_options'] ||= []
    File.open(config_file, 'wb') {|f| f.write(config.to_yaml)}
  end

  def list
    config.each do |project_name, options|
      puts project_name
      for type in %w[rails_dirs merbs]
        if options[type]
          puts '  %s: %i' % [type,options[type].size]
          for project_dir in options[type]
            puts '    - %s' % project_dir
          end
        end
      end
      if options['mongrel_options'].kind_of?(Array) and options['mongrel_options'].size > 0
        puts '  mongrel_options: %s' % options['mongrel_options'].join(' ')
      end
    end
  end

  def start
    check_project
    check_rails_dirs
    all_mongrels 'start'
    all_merbs 'start'
  end

  def stop
    check_project
    all_mongrels 'stop'
    all_merbs 'stop'
  end

  def restart
    check_project
    all_mongrels 'restart'
    all_merbs 'stop'
    all_merbs 'start'
  end

  private

  def all_merbs(action)
    merbs.each do |merb_options|
      merb(merb_options, action)
    end
  end

  def all_mongrels(cmd)
    rails_dirs.each do |dir|
      mongrel(dir, cmd)
    end
  end

  def check_project
    return unless project_config == {}
    puts "No project specified for '%s'. To initialize this project, run:" % project
    puts "  herd init %s" % project
    exit
  end

  def check_rails_dirs
    raise "No rails directories defined for this project" if rails_dirs.size == 0
  end

  def config
    @config ||= YAML.load_file(config_file)
  rescue SystemCallError => e
    return @config ||= {}
  end

  def config_file
    File.expand_path("~/.herd.yml")
  end

  def mongrel(dir, cmd)
    merged_mongrel_options = (mongrel_options + extra_mongrel_options).uniq
    sh(('cd %s' % dir), ('mongrel_rails cluster::%s %s' % [cmd, merged_mongrel_options.join(' ')]))
  end

  def merb(options, action)
    if action == 'start'
      merb_options = '-d'
      options.each do |key, value|
        case key
        when 'port'
          merb_options << ' -p %s' % value
        when 'env'
          merb_options << ' -e %s' % value
        end
      end
    else
      merb_options = '-k all'
    end
    sh(
      'cd %s' % options['dir'],
      'merb %s' % merb_options
    )
  end

  def merbs
    @merbs ||= (project_config['merbs'] || [])
  end

  def mongrel_options
    @mongrel_options ||= (project_config['mongrel_options'] || [])
  end

  def project_config
    @project_config ||= (config[project] || {})
  end

  def rails_dirs
    @rails_dirs ||= (project_config['rails_dirs'] || [])
  end

  def sh(*cmds)
    printf "# %s\n" % cmds.join(" && \n#   ")
    system cmds.join(" && ")
  end
end

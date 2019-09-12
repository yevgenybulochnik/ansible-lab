# VM class is used to define vagrant vms, but specific defaults are set. Most defaults can be overwritten.
# @Params
#   hostname: hostname of machine, required param
#   box: vagrant image/box to use to provision the machine. Default is ubuntu/xenial64
#   cpus: number of cpus for the machine, default 1
#   memory: memory for the machine, default 512
#   aliases: aliases for vagrant-hostmanager, default is empty list
# @Example
#   VM.new(
#     hostname: 'machine',
#     box: 'ubuntu/xenial64',
#     cpus: '2',
#     memory: '1024',
#     aliases: %w(example.local, shop.example.local)
#   )

class VM
  @@groups = {'all:vars' => {'ansible_python_interpreter' => '/usr/bin/python3'}}

  def self.groups
    @@groups
  end

  def self.adjust_groups(groups, hostname)
    groups.each do |group|
      if self.groups.key?(group)
        self.groups[group].push(hostname)
      else
        self.groups[group] = [hostname]
      end
    end
  end

  attr_accessor :hostname, :box, :cpus, :bridge_network, :memory, :groups, :aliases

  def initialize(options = {})
    self.hostname = options[:hostname]
    self.box = options[:box] || 'ubuntu/xenial64'
    self.cpus = options[:cpus] || '1'
    self.bridge_network = options[:bridge_network] || false
    self.memory = options[:memory] || '512'
    self.groups = options[:groups] || ['roletest']
    self.aliases = options[:aliases] || %w()
    self.class.adjust_groups(self.groups, self.hostname)
  end
end

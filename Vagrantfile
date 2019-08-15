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
  attr_accessor :hostname, :box, :cpus, :memory, :groups, :aliases
  def initialize(options ={})
    self.hostname = options[:hostname]
    self.box = options[:box] || 'ubuntu/xenial64'
    self.cpus = options[:cpus] || '1'
    self.memory = options[:memory] || '512'
    self.groups = options[:groups] || []
    self.aliases = options[:aliases] || %w()
  end
end


nodes  = [
  VM.new(
    hostname: 'ansiblehost',
    cpus: '2',
    memory: '2048',
    groups: ['roletest']
  ),
]

Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
  end
  groups = {}
  nodes.each_with_index do |node, i|
    config.vm.define node.hostname do |node_config|
      node_config.vm.box = node.box
      node_config.vm.hostname = node.hostname
      node_config.vm.network :private_network, ip: "172.17.64.#{i + 100}"
      node_config.hostmanager.aliases = node.aliases
      node_config.vm.provider :virtualbox do |vbox|
        vbox.name = node.hostname
        vbox.memory = node.memory
        vbox.cpus = node.cpus
      end
      node.groups.each do |group|
        if groups.key?(group)
          groups[group].push(node.hostname)
        else
          groups[group] = [node.hostname]
        end
      end
      if i + 1 == nodes.length
        node_config.vm.provision "ansible" do |ansible|
          ansible.limit = "all"
          ansible.playbook = "provision.yml"
          ansible.groups = groups
        end
      end
    end
  end
end

# vi: set ft=ruby:

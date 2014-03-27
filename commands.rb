require 'io/console'

class StartVpn < Vagrant.plugin(2, :command)
  def execute
    print "Username: "
    username = STDIN.gets.chomp
    print "Password: "
    password = STDIN.noecho(&:gets).chomp

    authfile = File.open('auth.txt', 'w')
    authfile.write username
    authfile.write "\n"
    authfile.write password
    authfile.close

    command = "sudo nohup openvpn --config /etc/openvpn/vpn.conf --script-security 2 --up /etc/openvpn/update-resolv-conf --auth-user-pass /tmp/auth.txt &"
    puts "\nRunning: #{command}"

    with_target_vms do |vm|
      ssh_opts = {extra_args: []}
      vm.action(:ssh_run, ssh_run_command: "mv /vagrant/auth.txt /tmp/auth.txt", ssh_opts: ssh_opts)
      vm.action(:ssh_run, ssh_run_command: "sudo pkill openvpn", ssh_opts: ssh_opts)
      env = vm.action(:ssh_run, ssh_run_command: command, ssh_opts: ssh_opts)
      status = env[:ssh_run_exit_status] || 0
      return status
    end
  end
end

SSH_CONFIG = <<EOF
### BEGIN TUNNELBLINK CONFIG ###
Host tunnelblink
  HostName 127.0.0.1
  User vagrant
  Port 5122
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /Users/#{ENV['USER']}/.vagrant.d/insecure_private_key
  IdentitiesOnly yes
  LogLevel FATAL

Host <host-behind-vpn>
  ProxyCommand ssh -A tunnelblink nc %h %p
### END TUNNELBLINK CONFIG ###

EOF

class SshConfig < Vagrant.plugin(2, :command)
  def execute
    puts "Add the following to your .ssh/config:\n\n"
    puts SSH_CONFIG
    puts "Replace <host-behind-vpn> with whatever host you want to add access to."
  end
end

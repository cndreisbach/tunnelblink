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

    with_target_vms(nil, single_target: true) do |vm|
      vm.action(:ssh_run, ssh_run_command: "mv /vagrant/auth.txt /tmp/auth.txt")
      vm.action(:ssh_run, ssh_run_command: "sudo pkill openvpn")
      env = vm.action(:ssh_run, ssh_run_command: command)
      status = env[:ssh_run_exit_status] || 0
      return status
    end
  end
end
```yaml
AB:
  hosts:
    A:
      ansible_host: 1.2.3.4
      ansible_user: ansible
      ansible_become: true
      ansible_ssh_common_args: '-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
    B:
      ansible_host: 1.2.3.5
      ansible_user: ansible
      ansible_become: true
      ansible_ssh_common_args: '-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
```

inventory.yml: 
```yaml
[defaults]
#timeout = 60
#host_key_checking = False
#pipelining = True
inventory = ./inventory.yml
#ansible_python_interpreter = /usr/bin/python3
#[ssh_connection]
#ssh_args = -o ControlMaster=auto -o ControlPersist=60s
```

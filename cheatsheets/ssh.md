# SSH cheatsheet

## shelltut lab

```bash
./scripts/ssh-lab.sh up
./scripts/ssh-lab.sh ssh
./scripts/ssh-lab.sh ssh -- 'ls /data'
./scripts/ssh-lab.sh down
```

```bash
ssh -F playground/ssh/ssh_config.example shelltut-lab
```

## Connect

```bash
ssh user@host
ssh -p 2222 user@host
ssh -i ~/.ssh/id_ed25519 user@host
ssh host 'uname -a'                 # remote command
```

## Keys

```bash
ssh-keygen -t ed25519 -C "you@example"
ssh-copy-id user@host               # install public key (real hosts)
ssh-add -l
ssh-keygen -lf key.pub              # fingerprint
```

## Config (`~/.ssh/config`)

```sshconfig
Host mybox
  HostName example.com
  User you
  Port 22
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
  # ProxyJump bastion
```

## Copy

```bash
scp file user@host:/path/
scp user@host:/path/file ./
scp -r dir user@host:/path/
sftp user@host
```

Prefer `rsync` for repeated directory syncs.

## Tunnels (stretch)

```bash
ssh -L 8080:127.0.0.1:80 user@host    # local forward
ssh -R 8080:127.0.0.1:80 user@host    # remote forward
ssh -J bastion internal               # jump host
```

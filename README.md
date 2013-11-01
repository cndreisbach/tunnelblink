# Tunnelblink

## What is it?

A Vagrant setup to connect you to a VPN without using Tunnelblick. It instead uses a virtual machine running a HTTP proxy.

## Why would you want to do this?

You can connect to most things directly, while proxying only traffic that needs to go to the VPN through your new virtual machine.

## What do I do? (easy version)

You'll need to know your VPN name and password.

```
git clone git@github.cfpb.gov:cndreisbach/tunnelblink.git
cd tunnelblink
cp -r ~/Library/Application\ Support/Tunnelblick/Configurations/*.tblk .
mv *.tblk vpn.tblk
vagrant up
vagrant start-vpn
```

After the first time, it's just:

```
vagrant up
vagrant start-vpn
```
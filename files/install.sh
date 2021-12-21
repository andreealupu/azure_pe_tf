#!/bin/bash
URL="https://pm.puppet.com/cgi-bin/download.cgi?dist=ubuntu&rel=18.04&arch=amd64&ver=latest"
sudo wget -O puppet-enterprise-latest.tar.gz $URL
mkdir puppet-enterprise-latest
tar -xf 'puppet-enterprise-latest.tar.gz' -C puppet-enterprise-latest --strip-components=1
mv /tmp/pe.conf /home/alupu/puppet-enterprise-latest/conf.d/
sudo ./puppet-enterprise-latest/puppet-enterprise-installer -c ./puppet-enterprise-latest/conf.d/pe.conf -y
sudo puppet infrastructure console_password --password=puppetlabs!
sudo puppet agent -t
sudo puppet agent -t
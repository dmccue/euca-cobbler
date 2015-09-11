#!/bin/bash

export ANSIBLE_HOST_KEY_CHECKING=False

clchostname=$(grep -A1 '\[clc\]' hosts | tail -1)
clchost=$(dig +short ${clchostname})
forklimit=20
vaultpassfile=~/.vault_pass.txt

[ "$1" == "reset" ] && { 
  echo Running: ansible-playbook --vault-password-file=${vaultpassfile} -f${forklimit} -k -i cobbler.py playbook-reset.yml -v
  ansible-playbook --vault-password-file=${vaultpassfile} -f${forklimit} -k -i cobbler.py playbook-reset.yml -v
  exit
}
[ "$1" == "setupinitial" ] && { ansible-playbook --vault-password-file=${vaultpassfile} -f${forklimit} -k -i cobbler.py playbook-setupinitial.yml -v; exit; }
[ "$1" == "deploy" ] && {
  echo Running: ansible-playbook --vault-password-file=${vaultpassfile} -f${forklimit} -i hosts playbook-deploy.yml -v
  ansible-playbook --vault-password-file=${vaultpassfile} -f${forklimit} -i hosts playbook-deploy.yml -v
  exit
}
[ "$1" == "deploy-viascript" ] && {
  echo Running: ansible-playbook --vault-password-file=${vaultpassfile} -f${forklimit} -i hosts playbook-deploy-viascript.yml -v
  ansible-playbook --vault-password-file=${vaultpassfile} -f${forklimit} -i hosts playbook-deploy-viascript.yml -v
  exit
}
[ "$1" == "ping" ] && { ansible --vault-password-file=${vaultpassfile} -f${forklimit} -b -i cobbler.py -u deploy -m ping dmccue -v; exit; }
[ "$1" == "vars" ] && { ansible-playbook --vault-password-file=${vaultpassfile} -f${forklimit} -b -i cobbler.py vars.yml -e "hosts=${2}" -v; exit; }


echo Usage $0 [reset,setupinitial,deploy,deploy-viascript,ping]

#ansible -k -i cobbler.py dmccue -u root -m shell -a 'uptime'
#ansible-playbook -f20 -i hosts -b -u deploy playbook-deploy.yml
#ansible-playbook -i cobbler.py playbook-repos.yml
#ansible-playbook -i hosts -b -u deploy playbook/site.yml -v --extra-vars 'nc_gateway=${clchost} euca_version=4.1 euca2ools_version=3.2'
#ansible -i hosts -b -u deploy -m shell -a 'yum install -y http://downloads.eucalyptus.com/software/eucalyptus/4.1/centos/6/x86_64/epel-release-6.noarch.rpm' all
#ansible -i hosts -b -u deploy -m shell -a 'yum install -y http://downloads.eucalyptus.com/software/eucalyptus/4.1/centos/6/x86_64/eucalyptus-release-4.1.el6.noarch.rpm' all
#ansible -i hosts -b -u deploy -m shell -a 'yum install -y http://downloads.eucalyptus.com/software/euca2ools/3.2/centos/6/x86_64/euca2ools-release-3.2.el6.noarch.rpm' all
#ansible -i hosts -b -u deploy -m shell -a 'yum update -y' all

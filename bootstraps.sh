#!/bin/bash

#knife bootstrap control-surface --ssh-user peter --sudo --identity-file ~/.ssh/id_rsa --node-name control-surface --run-list 'recipe[learn_chef_apache2]'
#knife bootstrap space-monster --ssh-user peter --sudo --identity-file ~/.ssh/id_rsa --node-name space-monster --run-list 'recipe[learn_chef_apache2]'
knife bootstrap arrested-development --ssh-user peter --sudo --identity-file ~/.ssh/id_rsa --node-name arrested-development --run-list 'recipe[learn_chef_apache2]'
#knife bootstrap credibility-problem --ssh-user peter --sudo --identity-file ~/.ssh/id_rsa --node-name credibility-problem --run-list 'recipe[learn_chef_apache2]'

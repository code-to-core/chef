#!/bin/bash

knife ssh "role:data" 'sudo chef-client' --ssh-user peter --identity-file ~/.ssh/id_rsa --attribute ipaddress

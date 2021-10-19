#!/bin/sh
# This file will be executed when the container starts
# Enter commands here to start ansible playbooks or python scripts

# shell scrips
echo "Hello World!"

# ansible
ansible-playbook hello-world.yml

# python
python hello-world.py

pip list

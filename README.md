# challenge_terraform

Proyecto del curso de Configuration Management.
El proyecto provisiona un setup que contiene Jenkins y Redis como contendores a traves de Terraform, proporcionando un keypair para poder ejecutar Ansible playbooks de manera local.Ademas el playbook se encarga de instalar Docker y e instalar una instancia de Jenkins que el usuario va a poder acceder despues. 
Comando para correr una vez el provisionamiento se da a traves del pipeline de Github: `ansible-playbook ansible_playbooks/docker.yaml --user ec2-user  --private-key ~/.ssh/keypair.pem`

#!/usr/bin/env bash

echo
echo "Iniciando o Script de Pós-Instalação do Linux Ubuntu Cloud 22.04 - Jammy Jellyfish para o Ambiente Openstack..."
echo

sleep 5

sudo apt-get update && sudo apt-get upgrade
sudo apt-get autoremove

echo
echo "Adicionando Ferramentas de Sistema..."
echo

#sudo apt-get install ubuntu-restricted-extras -y
sudo apt-get install curl wget -y
sudo apt-get install ca-certificates gnupg -y
#sudo apt-get install thermald -y
#sudo apt-get install build-essential dkms binutils -y
#sudo apt-get install openvpn easy-rsa -y
#sudo apt-get install guestfish libguestfs-tools cloud-image-utils -y

echo
echo "Adicionando Ferramentas de Rede..."
echo

sudo apt-get install net-tools traceroute ethtool -y
sudo apt-get install nmap tcpdump sysstat -y
sudo apt-get install dnsutils apache2 vsftpd -y

echo
echo "Adicionando Ferramentas do Terminal..."
echo

sudo apt-get install htop neofetch screenfetch -y
sudo apt-get install vim vim-tiny vim-athena vim-gtk3 vim-nox neovim -y
sudo apt-get install plocate -y

#echo
#echo "Adicionando Programas para Desenvolvimento..."
#echo

#sudo apt-get install git meson make cmake -y
#sudo apt-get install gcc g++ gdb valgrind -y
#sudo apt-get install nodejs npm maven -y
#sudo apt-get install python3 python3-pip python3-venv -y
#sudo apt-get install default-jre default-jdk default-jdk-headless -y
#sudo apt-get install openjdk-21-jre openjdk-21-jdk openjdk-21-jdk-headless -y

echo
echo "Adicionando Configuração de Servidores..."
echo

sudo apt-get install mysql-server mysql-client -y
sudo systemctl enable mysql
sudo systemctl start mysql

echo
echo "Adicionando Atualização do Kernel..."
echo

sudo apt-get install linux-generic-hwe-22.04 -y
sudo apt-get update && sudo apt-get upgrade
sudo apt-get autoremove

echo
echo "Todos os Programas foram Instalados com Sucesso!"
echo

sleep 5

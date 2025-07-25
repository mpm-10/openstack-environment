#!/usr/bin/env bash

sudo ip link set dev br-provider up
sudo ip addr add 200.0.113.1/24 dev br-provider

sudo iptables -t nat -A POSTROUTING -o eno1 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o eno2 -j MASQUERADE

sudo iptables -A FORWARD -i eno1 -o eno2 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i eno2 -o eno1 -m state --state RELATED,ESTABLISHED -j ACCEPT

sudo iptables -A FORWARD -i eno1 -o eno2 -j ACCEPT
sudo iptables -A FORWARD -i eno2 -o eno1 -j ACCEPT

#!/bin/bash
curl https://sh.rustup.rs -sSf | sh -s -- -y
#curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
PATH=$PATH:$HOME/.cargo/bin
sudo apt-get install -y build-essential libssl-dev


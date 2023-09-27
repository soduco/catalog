#!/bin/bash

# Bash "strict mode", to help catch problems and bugs in the shell
# script. Every bash script you write should include this. See
# http://redsymbol.net/articles/unofficial-bash-strict-mode/ for
# details.
set -euo pipefail

# Tell apt-get we're never going to be able to give manual
# feedback:
export DEBIAN_FRONTEND=noninteractive

# Debian stretch reached end of life. We have to switch to ELTS/archive repos for Debian and Postgresql
# Temporarily remove the postgresql APT repo. It will be later replaced with the Archive repo.
rm /etc/apt/sources.list.d/pgdg.list

# Replace the existing debian repo with the Freexian Extended LTS.
sh -c 'echo "deb http://deb.freexian.com/extended-lts stretch-lts main contrib non-free" > /etc/apt/sources.list'
apt-key adv -q --keyserver keyserver.ubuntu.com --recv-keys A07310D369055D5A

# Update the package listing, so we know what package exist:
apt-get update -q

# Install the Postgresql archive repo
apt install -qy --no-install-recommends curl\
					ca-certificates\
					gnupg\
					apt-transport-https
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/apt-archive.postgresql.org.gpg >/dev/null
sh -c 'echo "deb http://apt-archive.postgresql.org/pub/repos/apt stretch-pgdg-archive main" > /etc/apt/sources.list.d/pgdg.list'
apt-get update -q
apt-get -qy --no-install-recommends install postgresql-11-cron

# Cleanup
#apt-get remove --purge -yq curl\
#			   ca-certificates\
#			   gnupg\
#			   apt-transport-https

# Delete index files we don't need anymore:
rm -rf /var/lib/apt/lists/*

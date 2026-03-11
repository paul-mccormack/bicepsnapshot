FROM mcr.microsoft.com/azure-powershell:ubuntu-24.04

RUN set -ex; \
    apt -y update && apt -y upgrade; \
    apt -y install --no-install-recommends curl ca-certificates; \
    #rm -rf /var/lib/apt/lists/*
    apt-get install wget; \
    wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb; \
    dpkg -i packages-microsoft-prod.deb; \
    apt-get update; \
    apt-get install azure-functions-core-tools-4


    

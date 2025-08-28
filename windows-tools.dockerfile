FROM docker.io/debian:latest as choco

RUN apt update && apt upgrade -y && apt install -y wine wget

RUN wget https://github.com/PowerShell/PowerShell/releases/download/v7.5.2/PowerShell-7.5.2-win-x64.exe && mv PowerShell-7.5.2-win-x64.exe PowerShell.exe

# switch to wine
SHELL ["/usr/bin/wine", "cmd"]

RUN PowerShell.exe
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;\
  iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

FROM choco

RUN choco install cmake make rustup.installer

CMD ["/usr/bin/wine", "cmd"]

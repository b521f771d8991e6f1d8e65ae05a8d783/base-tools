FROM docker.io/swift:windowsservercore-ltsc2022 AS build

# download dependencies
WORKDIR /tmp
ADD https://static.rust-lang.org/dist/rust-1.93.1-x86_64-pc-windows-msvc.msi rust-installer.msi
RUN msiexec /i C:\tmp\rust-installer.msi /qn /norestart /L*v C:\tmp\rust-install.log

ADD https://nodejs.org/dist/v24.13.1/node-v24.13.1-x64.msi node-installer.msi
RUN msiexec /i C:\tmp\node-installer.msi /qn /norestart /L*v C:\tmp\node-install.log

ADD https://github.com/Kitware/CMake/releases/download/v4.2.3/cmake-4.2.3-windows-x86_64.msi cmake-installer.msi
RUN msiexec /i C:\tmp\cmake-installer.msi /qn /norestart /L*v C:\tmp\cmake-install.log

ADD https://github.com/microsoft/vcpkg/archive/refs/tags/2026.01.16.zip vcpkg.zip
RUN tar -xf vcpkg.zip; move vcpkg-2026.01.16 C:\vcpkg; cd C:\vcpkg; .\bootstrap-vcpkg.bat -disableMetrics; .\vcpkg install sqlite3 abseil boost vcpkg-tool-ninja

ADD https://github.com/gnustep/tools-windows-msvc/releases/download/latest/GNUstep-Windows-MSVC-x64-Release.zip GNUStep.zip
RUN tar -xf GNUStep.zip; move GNUstep C:\

RUN npm install -g wasm-pack

WORKDIR /workspace

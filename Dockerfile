ARG REPO=mcr.microsoft.com/dotnet/runtime

# Installer image
FROM amd64/buildpack-deps:bullseye-curl AS installer

# Retrieve ASP.NET Core
RUN aspnetcore_version=7.0.0 \
    && curl -fSL --output aspnetcore.tar.gz https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-$aspnetcore_version-linux-x64.tar.gz \
    && aspnetcore_sha512='02ce2e0b3c4b1d0eb0d9bdb9517a3293404b2a1aaf23311e305b856bb15723414f6328887788b875f0f80361f3e195c872ea3984971e5f0ab1ad5de43950d707' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -oxzf aspnetcore.tar.gz ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz




# ASP.NET Core image
FROM $REPO:7.0.0-bullseye-slim-amd64

# PDF Creating libs
RUN apt-get update -y
RUN apt-get upgrade  -y
RUN apt-get install build-essential chrpath libssl-dev libxft-dev libfreetype6-dev libfreetype6 libfontconfig1-dev libfontconfig1 -y
COPY phantomjs-2.1.1-linux-x86_64.tar.bz2 phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/
RUN ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/
RUN rm phantomjs-2.1.1-linux-x86_64.tar.bz2

# ASP.NET Core version
ENV ASPNET_VERSION=7.0.0

COPY --from=installer ["/shared/Microsoft.AspNetCore.App", "/usr/share/dotnet/shared/Microsoft.AspNetCore.App"]
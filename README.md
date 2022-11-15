# .NET 7.0 docker html to pdf

🚩 Problem: Creating PDF report in .NET 7.0 and runinng it in docker container without using paid libraries.

💡 Solution: Create HTML reports and convert them to PDF using Phantom.Js (![https://phantomjs.org](https://phantomjs.org)). 


# Creating PDF

Creating PDF using HTML is straight forward, you can find it [here (port creators git repo)](https://github.com/TheSalarKhan/PhantomJs.NetCore), and solution works superb on native windows, linux and mac but if you are using docker image to run your asp.net core apps, you need to install some additional tools to your docker image. 

This can be done in 2 ways: 
1. Adding a few lines to your docker file
2. Using my prebuilt image (or building your own)  ***NOTE: simpler and faster way***

## 1. Adding a few lines to your docker file

This is a simple method, but this method will install libs with every ```docker image build``` command and that can be annoying *(note: not every, docker has some kind of image cache thing)*. 
1. Add **.tar.bz2** file from this repo to you project root (where .Dockerfile is located)
2. Edit your projects *.Dockerfile* add this lines after ```EXPOSE```: 
```
RUN apt-get update -y
RUN apt-get upgrade  -y
RUN apt-get install build-essential chrpath libssl-dev libxft-dev libfreetype6-dev libfreetype6 libfontconfig1-dev libfontconfig1 libgdiplus -y
COPY phantomjs-2.1.1-linux-x86_64.tar.bz2 /app/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/
RUN ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/
```
3. Now you can run your docker image build normally and you should be able to generate PDFs, installation of additional tools will take some time and that is a frustrating part, so I recommend doing this using second method.

## 2. Using my prebuilt image (or building your own) 

This solution is easier since image is already built and tools are preinstalled, so ```docker image build``` is faster.
1. Edit first line of project *.Dockerfile*, replace default image with prebuilt one: 
```
FROM leorule/dotnetsdk:7.0 AS base
```
2. And that is it, you can now run ```docker image build``` and everything should work fine. 

*For .NET 6.0 you can use ```FROM leorule/dotnetsdk:6.0 AS base```*

### 2.1. Building your own image

Building your own image is simple, you can use .Dockerfile from this repo that I have used to build my image. 
That .Dockerfile is offical .net file (that can be found [here](https://github.com/dotnet/dotnet-docker/blob/07befaabf8b7278111dd64869beb74ac36dda657/src/aspnet/7.0/bullseye-slim/amd64/Dockerfile) or on [dockerhub](https://hub.docker.com/_/microsoft-dotnet-aspnet)) with the addition of commands that will install the necessary tools. 

For creating your docker image all you need is, an empty folder that contains that **tar.bz2** file that you can download from this repo, and your selected runtime 
that can be found on [Microsoft's official dockerhub](https://hub.docker.com/_/microsoft-dotnet-aspnet) (check section "Full Tag Listing"). 

Once you have that, all you need to do is edit that file, add lines from **method 1** that install tools needed. I have added them before ```ENV ASPNET_VERSION=7.0.0``` and then run your ```docker image build <image_name>``` giving your image a name. 

Now you can update your projects *.Dockerfile* and insted of line from **method 2** you add ```FROM <image_name> as BASE``` using image name you used in step before this. 

--
### That is all folks! 



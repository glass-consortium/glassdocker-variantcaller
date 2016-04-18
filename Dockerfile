## dockerfile for wrapping flowr in docker running centos 6.6 ##

### https://github.com/flow-r/docker_centos_flowr

FROM centos:6.6

## For questions, visit https:
MAINTAINER "Samir B. Amin" <tweet:sbamin>; "Sahil Seth" <tweet:sethsa>

## Install and update EPEL repository ##
### Use HTTP rather than HTTPS: To avoid error like, Cannot retrieve metalink for repository epel.

RUN yum install -y epel-release && sed -i "s/mirrorlist=https/mirrorlist=http/" /etc/yum.repos.d/epel.repo
RUN yum update -y && yum install -y \
	sshfs rsync nano screen socat dos2unix \
	wget curl \
	zip unzip \
	openssl098e openssl-devel libcurl-devel libssh2-devel \
	java-1.8.0-openjdk-devel \
	R

# Install flowr & ultraseq
RUN mkdir -p /opt && cd /opt/ && mkdir -p /usr/share/doc/R-3.2.3/html
RUN Rscript -e 'install.packages(c("httr", "git2r", "stringr", "dplyr", "tidyr", "devtools", "flowr"), repos = c(CRAN="http://cran.rstudio.com", DRAT="http://sahilseth.github.io/drat"))' && Rscript -e 'library(flowr);setup()'
# test flowr
RUN ln -s /root/bin/flowr /usr/bin/flowr && flowr run x=sleep_pipe platform=local execute=TRUE
# install ultraseq
RUN Rscript -e 'devtools::install_github("flow-r/ultraseq", subdir = "ultraseq")'

ENTRYPOINT ["flowr"]
CMD ["--help"]

## END ##

## To build image:
# cat content of this file to /opt/Dockerfile ; then run following command as root or docker privileged user - last dot is important.
# cd /opt && docker build -t gmapps/docker_centos_flowr:0.9.2 -t gmapps/docker_centos_flowr:latest .
# Building image will take a while (30-60 min); upon successful exit, run following from host system to see status of example flowr run:
# docker run gmapps/docker_centos_flowr:latest status x="~/flowr/runs"

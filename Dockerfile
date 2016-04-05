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

# Install flowr
RUN mkdir -p /opt && cd /opt/ && mkdir -p /usr/share/doc/R-3.2.3/html
RUN Rscript -e 'install.packages(c("httr", "git2r", "stringr", "dplyr", "tidyr", "devtools", "flowr"), repos = c(CRAN="http://cran.rstudio.com", DRAT="http://sahilseth.github.io/drat"))' && Rscript -e 'library(flowr);setup()'
RUN ln -s /root/bin/flowr /usr/bin/flowr && flowr run x=sleep_pipe platform=local execute=TRUE

ENTRYPOINT ["flowr"]
CMD ["--help"]

## END ##

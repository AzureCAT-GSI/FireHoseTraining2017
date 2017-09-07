#Docker file Ubuntu

FROM centos:latest

MAINTAINER Clau

#Update
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm 
#Install pip

 RUN yum -y install python-pip python-dev build-essential 

 RUN pip install enum

 RUN pip install msrest

 RUN yum -y install gcc gcc-c++ kernel-devel

 RUN yum -y install python-devel libxslt-devel libffi-devel openssl-devel

 RUN pip install msrestazure

 #Install Ansible
 RUN pip install ansible

#Install azure sdk
RUN pip install "azure==2.0.0rc5"

RUN pip install packaging

RUN yum -y install nano

#Set working directory
WORKDIR /pb

#Copy playbooks into container
ADD . /pb




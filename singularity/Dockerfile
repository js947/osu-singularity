from centos:7
run yum install -y epel-release && yum install -y singularity && yum clean all && rm -rf /var/cache/yum
entrypoint ["/usr/bin/singularity"]

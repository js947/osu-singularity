FROM centos:7 as builder
RUN yum group install -y "Development Tools"
RUN yum-config-manager --add-repo https://yum.repos.intel.com/mpi/setup/intel-mpi.repo
RUN rpm --import https://yum.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
RUN yum install -y intel-mpi-2019.6-088

RUN ln -s /opt/intel/impi/2019.6.166/intel64/bin/mpivars.sh /etc/profile.d/intel-mpi.sh
SHELL ["bash", "-lc"]

WORKDIR /root
RUN curl https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-5.6.2.tar.gz | tar xzf - --strip-components=1
RUN ./configure CC=mpicc CXX=mpicxx --prefix=/usr && make && make install

FROM centos:7
RUN yum-config-manager --add-repo https://yum.repos.intel.com/mpi/setup/intel-mpi.repo
RUN rpm --import https://yum.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
RUN yum install -y intel-mpi-rt-2019.6-166 && yum clean all && rm -rf /var/cache/yum

ENV LD_LIBRARY_PATH=/opt/intel/impi/2019.6.166/intel64/lib:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=/opt/intel/impi/2019.6.166/intel64/lib/release:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=/opt/intel/impi/2019.6.166/intel64/libfabric/lib:$LD_LIBRARY_PATH

COPY --from=builder /usr/libexec/osu-micro-benchmarks /usr/libexec/osu-micro-benchmarks

ENV PATH=/usr/libexec/osu-micro-benchmarks/mpi/startup:$PATH
ENV PATH=/usr/libexec/osu-micro-benchmarks/mpi/pt2pt:$PATH
ENV PATH=/usr/libexec/osu-micro-benchmarks/mpi/collective:$PATH
ENV PATH=/usr/libexec/osu-micro-benchmarks/mpi/one-sided:$PATH

CMD ["bash", "-il"]

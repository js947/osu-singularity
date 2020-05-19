FROM centos:7 as builder
RUN yum group install -y "Development Tools"
RUN yum install -y mpich mpich-devel mpich-autoload
SHELL ["bash", "-lc"]

WORKDIR /root
RUN curl https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-5.6.2.tar.gz | tar xzf - --strip-components=1
RUN ./configure CC=mpicc CXX=mpicxx --prefix=/usr && make && make install

FROM centos:7
RUN yum install -y mpich && yum clean all && rm -rf /var/cache/yum
COPY --from=builder /usr/libexec/osu-micro-benchmarks /usr/libexec/osu-micro-benchmarks

ENV PATH=/usr/libexec/osu-micro-benchmarks/mpi/startup:$PATH
ENV PATH=/usr/libexec/osu-micro-benchmarks/mpi/pt2pt:$PATH
ENV PATH=/usr/libexec/osu-micro-benchmarks/mpi/collective:$PATH
ENV PATH=/usr/libexec/osu-micro-benchmarks/mpi/one-sided:$PATH

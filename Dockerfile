FROM apache/zeppelin:0.9.0


USER root

# mostly copied from https://hub.docker.com/r/jupyter/datascience-notebook/dockerfile

# Julia dependencies
# install Julia packages in /opt/julia instead of $HOME
ENV JULIA_DEPOT_PATH=/opt/julia
ENV JULIA_PKGDIR=/opt/julia
ENV JULIA_VERSION=1.4.2

ENV CONDA_DIR=/opt/conda
ENV NB_USER=1000

WORKDIR /tmp

RUN mkdir "/opt/julia-${JULIA_VERSION}" && \
    wget -q https://julialang-s3.julialang.org/bin/linux/x64/$(echo "${JULIA_VERSION}" | cut -d. -f 1,2)"/julia-${JULIA_VERSION}-linux-x86_64.tar.gz" && \
    echo "d77311be23260710e89700d0b1113eecf421d6cf31a9cebad3f6bdd606165c28 *julia-${JULIA_VERSION}-linux-x86_64.tar.gz" | sha256sum -c - && \
    tar xzf "julia-${JULIA_VERSION}-linux-x86_64.tar.gz" -C "/opt/julia-${JULIA_VERSION}" --strip-components=1 && \
    rm "/tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz"
RUN ln -fs /opt/julia-*/bin/julia /usr/local/bin/julia

# Show Julia where conda libraries are \
RUN mkdir /etc/julia && \
    echo "push!(Libdl.DL_LOAD_PATH, \"$CONDA_DIR/lib\")" >> /etc/julia/juliarc.jl && \
    # Create JULIA_PKGDIR \
    mkdir "${JULIA_PKGDIR}" && \
    chown "${NB_USER}" "${JULIA_PKGDIR}"


# Add Julia packages. 

RUN julia -e "using Pkg; pkg\"up\"; pkg\"add IJulia DataFrames CSV BenchmarkTools\"; pkg\"precompile\"" &&\
    # move kernelspec out of home \
    mv "${HOME}/.local/share/jupyter/kernels/julia"* "${CONDA_DIR}/share/jupyter/kernels/" && \
    chmod -R a+rx "${CONDA_DIR}" && \
    rm -rf "${HOME}/.local"

USER ${NB_USER}
WORKDIR ${Z_HOME}

# take as many Julia threads as CPU cores
ENV JULIA_NUM_THREADS=100

FROM silkeh/clang:dev-unstable

RUN apt update

ENV XZ_OPT=-e9
COPY build-dkms-module.sh build-dkms-module.sh
RUN chmod +x ./build-dkms-module.sh
RUN bash ./build-dkms-module.sh

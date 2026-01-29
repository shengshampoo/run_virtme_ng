FROM silkeh/clang:dev-unstable

RUN apt update

ENV XZ_OPT=-e9
COPY build-bcachefs-tools-ko.sh build-bcachefs-tools-ko.sh
RUN chmod +x ./build-bcachefs-tools-ko.sh
RUN bash ./build-bcachefs-tools-ko.sh

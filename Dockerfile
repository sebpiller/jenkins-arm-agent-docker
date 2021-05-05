FROM eryk81/jenkins-agent-arm64
LABEL arch="arm|arm64"

ARG k3sversion=1.21.0%2Bk3s1

# ARG dockerrepo=http://nexus.home/repository/docker_buster/
ARG dockerrepo=https://download.docker.com/linux/ubuntu/

ADD https://raw.githubusercontent.com/jenkinsci/docker-inbound-agent/master/jenkins-agent /default-entrypoint.sh

USER root

RUN \
    apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
      wget curl software-properties-common gnupg2 git \
      openjdk-11-jdk-headless maven \
      npm nodejs && \

    curl -fsSL --insecure https://download.docker.com/linux/debian/gpg | apt-key add - && \

    REL=$(lsb_release -cs) && \
    add-apt-repository "deb $dockerrepo $REL stable" && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
      docker-ce docker-ce-cli containerd.io && \

    rm -rf /var/lib/apt/lists/* && \

    wget -O k3s https://github.com/k3s-io/k3s/releases/download/v$k3sversion/k3s-armhf && \
    mv ./k3s /usr/local/bin/k3s && \
    chmod +x /usr/local/bin/k3s

RUN chmod +x /default-entrypoint.sh

VOLUME /root/.m2

ENTRYPOINT [ "/bin/sh", "-c", "/default-entrypoint.sh" ]
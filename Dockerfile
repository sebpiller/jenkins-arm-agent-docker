FROM eryk81/jenkins-agent-arm64
LABEL arch="arm|arm64"

ARG k3sversion=1.21.0%2Bk3s1

# ARG dockerrepo=http://nexus.home/repository/docker_buster/
ARG dockerrepo=https://download.docker.com/linux/ubuntu

USER root
ADD https://raw.githubusercontent.com/jenkinsci/docker-inbound-agent/master/jenkins-agent /default-entrypoint.sh
RUN echo "service docker start" >> /default-entrypoint.sh && \
    chmod +x /default-entrypoint.sh

RUN \
    apt-get update && \
    apt-get remove docker docker-engine docker.io containerd runc || \
    apt-get install -y --no-install-recommends --no-install-suggests \
      wget curl software-properties-common gnupg2 git \
      default-jdk-headless maven \
      npm nodejs \
      && \

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \

    REL=$(lsb_release -cs) && \
    echo "deb [arch=arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] $dockerrepo $REL stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \

    apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
      docker-ce docker-ce-cli containerd.io && \

    rm -rf /var/lib/apt/lists/* && \

    wget -O k3s https://github.com/k3s-io/k3s/releases/download/v$k3sversion/k3s-armhf && \
    mv ./k3s /usr/local/bin/k3s && \
    chmod +x /usr/local/bin/k3s && \

    echo 'Done'

VOLUME /root/.m2

ENTRYPOINT [ "/bin/sh", "-c", "/default-entrypoint.sh" ]
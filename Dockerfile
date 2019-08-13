FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
	openssl \
	net-tools \
	git \
	locales \
	sudo \
	dumb-init \
	vim \
	curl \
	wget \
    bash-completion

RUN mkdir /tmp/code-server && \
    curl -L https://github.com/cdr/code-server/releases/download/1.1156-vsc1.33.1/code-server1.1156-vsc1.33.1-linux-x64.tar.gz -o /tmp/code-server/code-server.tar.gz && \
    tar xzvf /tmp/code-server/code-server.tar.gz -C /tmp/code-server/ --strip-components 1 && \
    chmod +x /tmp/code-server/code-server && \
    mv /tmp/code-server/code-server /usr/local/bin/code-server && \
    rm -rf /tmp/code-server

## kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# helm
RUN mkdir /tmp/helm && \
    curl -L https://storage.googleapis.com/kubernetes-helm/helm-v2.14.3-linux-amd64.tar.gz -o /tmp/helm/helm.tar.gz && \
    tar xzvf /tmp/helm/helm.tar.gz -C /tmp/helm/ && \
    chmod +x /tmp/helm/linux-amd64/helm && \
    mv /tmp/helm/linux-amd64/helm /usr/local/bin/helm

# kustomize
RUN curl -L https://github.com/kubernetes-sigs/kustomize/releases/download/v3.0.2/kustomize_3.0.2_linux_amd64 -o ./kustomize && \
    chmod +x ./kustomize && \
    mv ./kustomize /usr/local/bin/kustomize

# kubectx/kubens/fzf
RUN git clone https://github.com/ahmetb/kubectx /opt/kubectx && \
    ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx && \
    ln -s /opt/kubectx/kubens /usr/local/bin/kubens && \
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install

RUN locale-gen en_US.UTF-8
# We unfortunately cannot use update-locale because docker will not use the env variables
# configured in /etc/default/locale so we need to set it manually.
ENV LC_ALL=en_US.UTF-8

## User account
RUN adduser --disabled-password --gecos '' coder && \
    adduser coder sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers;


RUN chmod g+rw /home && \
    mkdir -p /home/coder/workspace && \
    chown -R coder:coder /home/coder && \
    chown -R coder:coder /home/coder/workspace;

USER coder

RUN echo "source <(kubectl completion bash)" >> /home/coder/.bashrc && \
    echo 'export PS1="\[\e]0;\u@\h: \w\a\]\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> /home/coder/.bashrc

WORKDIR /home/coder/workspace

EXPOSE 8443

ENTRYPOINT ["dumb-init", "code-server"]

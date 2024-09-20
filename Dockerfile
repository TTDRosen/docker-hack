FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Replace these with your UID and GID
ARG UID=1000
ARG GID=1000
ARG USER=customuser
ARG GROUP=customgroup

# Install sudo
RUN apt-get clean
RUN apt-get update && apt-get install -y sudo curl openssh-server build-essential pciutils llvm clang git wget

# Create a group and a user with your UID and GID
RUN groupadd -g ${GID} ${GROUP} && \
    useradd -m -u ${UID} -g ${GROUP} -l -s /bin/bash ${USER} 

# Add the user to the sudo group
RUN usermod -aG sudo ${USER}

# Ensure sudo does not require a password
RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the new user
USER ${USER}

# Continue with the rest of your Dockerfile instructions
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

EXPOSE 22

RUN sudo /usr/sbin/service ssh start
RUN mkdir -p /var/run/sshd

CMD ["sudo","/usr/sbin/sshd","-D"]

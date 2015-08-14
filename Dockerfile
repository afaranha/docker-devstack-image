# As it is going to be used as Jenkins slave:
# https://wiki.jenkins-ci.org/display/JENKINS/Docker+Plugin
FROM evarga/jenkins-slave

# Set DEBIAN_FRONTEND to avoid warning like "debconf: (TERM is not set, so the
# dialog frontend is not usable.)"
ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && apt-get -y install git

# Setup devstack user
RUN mkdir -p /opt; \
    useradd -m -s /bin/bash -d /opt/stack devstack && \
    usermod -a -G docker devstack
ADD devstack.sudo /etc/sudoers.d/devstack
RUN chown root:root /etc/sudoers.d/devstack

USER jenkins
WORKDIR "/home/jenkins"

RUN git clone https://github.com/openstack/ironic.git && \
    cd ironic


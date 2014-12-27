FROM jpetazzo/dind
MAINTAINER Boris Mikhaylov kaguxmail@gmail.com

RUN apt-get -y update

RUN apt-get install -y python-yaml python-jinja2 git python-pip sshpass curl
RUN pip install docker-py

# install ansible
ENV ANSIBLE_VER 1.8.2
RUN git clone http://github.com/ansible/ansible.git /ansible
RUN cd /ansible && git checkout v$ANSIBLE_VER && git submodule update --init --recursive
ENV PATH /ansible/bin:/sbin:/usr/sbin:/usr/bin:/bin:/usr/local/bin
ENV ANSIBLE_LIBRARY /ansible/library
ENV PYTHONPATH /ansible/lib:$PYTHON_PATH

# small fix to wrapdocker
RUN sed -i 's/exec bash//g' /usr/local/bin/wrapdocker

# agent forwarding in git
RUN echo 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $*' > /opt/git_ssh
RUN chmod +x /opt/git_ssh
ENV GIT_SSH /opt/git_ssh

ENV HOME /root

ADD ansible.cfg /etc/ansible/ansible.cfg

ADD . /workdir
WORKDIR /workdir

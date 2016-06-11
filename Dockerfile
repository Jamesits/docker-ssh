FROM ubuntu:latest
RUN apt-get update && apt-get install -y \
    openssh-server nano \
  \
  && mkdir /var/run/sshd \
  && mkdir -pv /root/.ssh && chmod -v 0700 /root/.ssh \
  \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /usr/{{lib,share}/locale,share/{man,doc,info,gnome/help,cracklib,il8n},{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} \
#  \
#  && (yes | ssh-keygen -q -b 1024 -N '' -t rsa -f /etc/ssh/ssh_host_rsa_key) \
#  && (yes | ssh-keygen -q -b 1024 -N '' -t dsa -f /etc/ssh/ssh_host_dsa_key) \
#  && (yes | ssh-keygen -q -b 521 -N '' -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key) \
#  \
#  && `# SSH login fix. Otherwise user is kicked off after login` \
#  && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
  \
  && sed -i -r 's/.?UseDNS\syes/UseDNS no/' /etc/ssh/sshd_config \
  && sed -i -r 's/.?PasswordAuthentication.+/PasswordAuthentication no/' /etc/ssh/sshd_config \
  && sed -i -r 's/.?UsePAM.+/UsePAM no/' /etc/ssh/sshd_config \
  && sed -i -r 's/.?ChallengeResponseAuthentication.+/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config \
  && sed -i -r 's/.?PermitRootLogin.+/PermitRootLogin yes/' /etc/ssh/sshd_config \
  && echo -e "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

ENV ADMIN james
RUN useradd -d /home/$ADMIN -G sudo -m $ADMIN
RUN yes "86868649" | passwd james
EXPOSE 22
CMD /bin/bash

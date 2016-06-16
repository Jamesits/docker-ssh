FROM ubuntu:latest
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y openssh-server nano \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/{{lib,share}/locale,share/{man,doc,info,gnome/help,cracklib,il8n},{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive}
    
# RUN (yes | ssh-keygen -q -b 1024 -N '' -t rsa -f /etc/ssh/ssh_host_rsa_key) \
#   && (yes | ssh-keygen -q -b 1024 -N '' -t dsa -f /etc/ssh/ssh_host_dsa_key) \
#   && (yes | ssh-keygen -q -b 521 -N '' -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key) \
#   \
#   && `# SSH login fix. Otherwise user is kicked off after login` \
#   && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \

RUN sed -i -r 's/.?UseDNS\syes/UseDNS no/' /etc/ssh/sshd_config \
    && sed -i -r 's/.?PasswordAuthentication.+/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -i -r 's/.?UsePAM.+/UsePAM no/' /etc/ssh/sshd_config \
    && sed -i -r 's/.?ChallengeResponseAuthentication.+/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config \
    && sed -i -r 's/.?PermitRootLogin.+/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && echo -e "StrictHostKeyChecking no" >> /etc/ssh/ssh_config \
    && mkdir -p /var/run/sshd \
    && chmod 0755 /var/run/sshd
    
ENV GITHUB_USERNAME Jamesits
    
RUN echo "{\"URL\": \"https://github.com/%s.keys\"}" > /etc/ssh/ssh_import_id \
    && ssh-import-id $GITHUB_USERNAME
    

EXPOSE 22
CMD /usr/sbin/sshd -Dde

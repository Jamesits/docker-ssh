FROM ubuntu:latest
RUN apt update && apt upgrade -y && apt install -y nano openssh
ENV ADMIN james
RUN useradd -d /home/$ADMIN -G sudo -m $ADMIN
RUN yes "86868649" | passwd james

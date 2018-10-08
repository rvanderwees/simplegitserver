FROM fedora:latest
MAINTAINER John Doe <john.doe@example.com>
# Install packages, update image, and clear cache
RUN groupadd -r -g 900 git; useradd -r -M -c "GIT User" -g git -u 900 -s /bin/git-shell git; dnf -y install supervisor openssh-server git && dnf -y update; dnf clean all
RUN /usr/libexec/openssh/sshd-keygen rsa; /usr/libexec/openssh/sshd-keygen ecdsa; /usr/libexec/openssh/sshd-keygen ed25519
ADD supervisor-simplehttpd.ini /etc/supervisord.d/supervisor-simplehttpd.ini
ADD supervisor-sshd.ini /etc/supervisord.d/supervisor-sshd.ini
EXPOSE 80 22
ENTRYPOINT [ "/usr/bin/supervisord" ]
CMD [ "-n", "-c", "/etc/supervisord.conf" ]

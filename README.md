# Setup a simple GIT server running in a container on Fedora with persistent storage

### Prepare and setup a simple git server to be used over ssh

1. Prepare server

       # dnf -y install docker git
       # systemctl enable docker
       # systemctl start docker
       # mkdir /home/git
       # mkdir /home/git/.ssh
       # touch /home/git/.ssh/authorized_keys
       # chown -R 900:900 /home/git
       # chmod 750 /home/git
       # chmod 750 /home/git/.ssh
       # chmod 600 /home/git/.ssh/authorized_keys

1. Create a priv/pub key pair (if not already)

       # ssh-keygen

1. Add the pub key to the git user's authorized_keys

       # cat ~/.ssh/id_rsa.pub >> /home/git/.ssh/authorized_keys

1. Build container image
    1. Stop and remove old instance (if exists)

            # docker stop gitserver
            # docker rm gitserver
            # docker rmi gitserver

     1. Build new image

            # docker build --rm -t gitserver .
            
1. Start container exposing the ports for ssh and http (8022 and 8080 on the outside)

        # docker run --detach --hostname $(hostname) --publish 8080:8080 --publish 8022:22 --name gitserver --restart always --volume /home/git:/home/git:Z gitserver

1. Exec the container and setup a new repository
    1. Exec the container

            # docker exec -it gitserver /bin/bash

    1. Setup new repository

            # su - git -s /bin/bash
            $ mkdir repos
            $ cd repos
            $ git init --bare newrepo.git
            $ cd newrepo.git
            $ git update-server-info
            $ mv hooks/post-update.sample hooks/post-update
            $ exit
            # exit
    
1. Clone the repo on the local user and start commiting

       $ git clone ssh://git@server.example.com:8022/~git/repos/newrepo.git
       $ cd newrepo
       $ touch README
       $ git add README
       $ git commit -m "Initial checkin"
       $ git push origin master

1. Clone the repo unathenticated via HTTP as:

       $  git clone http://server.example.com:8080/newrepo.git


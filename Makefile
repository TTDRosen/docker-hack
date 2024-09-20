all: build start

build:
	docker build --build-arg UID=`id -u` --build-arg GID=`id -g` --build-arg USER=`whoami` --build-arg GROUP=`whoami` -t docker-hack .

start:
	docker run -v /home/`whoami`/work:/home/`whoami`/work \
		-v ${SSH_AUTH_SOCK}:${SSH_AUTH_SOCK}:ro \
		-v /home/`whoami`/.ssh/authorized_keys:/home/`whoami`/.ssh/authorized_keys:ro \
		-v /etc/ssh/ssh_host_ed25519_key:/etc/ssh/ssh_host_ed25519_key:ro \
		-v /etc/ssh/ssh_host_ed25519_key.pub:/etc/ssh/ssh_host_ed25519_key.pub:ro \
		-e SSH_AUTH_SOCK="${SSH_AUTH_SOCK}" \
		--privileged \
		-p 2222:22 -d --name docker-hack docker-hack

stop:
	docker stop docker-hack && docker rm docker-hack

bash:
	docker exec -it docker-hack bash 

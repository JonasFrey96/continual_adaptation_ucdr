ssh_key_name = "id_rsa"
export DOCKER_BUILDKIT=1

eval $(ssh-agent) && ssh-add ~/.ssh/id_rsa && export DOCKER_BUILDKIT=1 && docker build --progress=plain --ssh default -f Dockerfile ./ -t ucdr
STACK := "scalingo-20"
IMAGE := scalingo/$(STACK):latest
BASH_COMMAND := /bin/bash

.DEFAULT := test

test: BASH_COMMAND := test/run
test: docker

docker:
	@echo "Running tests in Docker using $(IMAGE)"
	@docker run --pull always --mount type=bind,src=$(PWD),dst=/buildpack,readonly --workdir /buildpack --rm --interactive --tty --env "GITLAB_TOKEN=$(GITLAB_TOKEN)" --env "GITHUB_TOKEN=$(GITHUB_TOKEN)" --env "STACK=$(STACK)" $(IMAGE) bash -c "$(BASH_COMMAND)"


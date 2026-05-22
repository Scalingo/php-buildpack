STACK := "scalingo-22"
BASH_COMMAND := /bin/bash

.DEFAULT := all

all: test
test: test22 test24 test26

test24: STACK := "scalingo-24"
test26: STACK := "scalingo-26"

test22 test24 test26: BASH_COMMAND := test/run
test22 test24 test26: IMAGE := "scalingo/$(STACK):latest"
test22 test24 test26:
	@echo "Running tests in Docker using $(IMAGE)"
	@docker run --pull always --mount type=bind,src=$(PWD),dst=/buildpack,readonly --workdir /buildpack --rm --interactive --tty --env "GITLAB_TOKEN=$(GITLAB_TOKEN)" --env "GITHUB_TOKEN=$(GITHUB_TOKEN)" --env "STACK=$(STACK)" $(IMAGE) bash -c "$(BASH_COMMAND)"

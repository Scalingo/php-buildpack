STACK := "scalingo-22"
BASH_COMMAND := /bin/bash

.DEFAULT := all

all: test
test: test20 test22 test24

test20: STACK := "scalingo-20"

test24: STACK := "scalingo-24"

test20 test22 test24: BASH_COMMAND := test/run
test20 test22 test24: IMAGE := "scalingo/$(STACK):latest"
test20 test22 test24:
	@echo "Running tests in Docker using $(IMAGE)"
	@docker run --pull always --mount type=bind,src=$(PWD),dst=/buildpack,readonly --workdir /buildpack --rm --interactive --tty --env "GITLAB_TOKEN=$(GITLAB_TOKEN)" --env "GITHUB_TOKEN=$(GITHUB_TOKEN)" --env "STACK=$(STACK)" $(IMAGE) bash -c "$(BASH_COMMAND)"

STACK := "scalingo-20"
IMAGE := scalingo/$(STACK):latest
BASH_COMMAND := /bin/bash

.DEFAULT := test

test: BASH_COMMAND := test/run
test: docker

docker:
	@echo "Running tests in Docker using $(IMAGE)"
	@docker pull $(IMAGE)
	@docker run -v $(PWD):/buildpack:ro --rm -it -e "GITLAB_TOKEN=$(GITLAB_TOKEN)" -e "GITHUB_TOKEN=$(GITHUB_TOKEN)" -e "STACK=$(STACK)" $(IMAGE) bash -c "cd /buildpack; $(BASH_COMMAND)"


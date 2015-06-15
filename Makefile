DOCKER = docker
REPO = git@github.com:aptible/docker-couchdb.git
TAGS = 1.5.0

all: release

sync-branches:
	git fetch $(REPO) master
	@$(foreach tag, $(TAGS), git branch -f $(tag) FETCH_HEAD;)
	@$(foreach tag, $(TAGS), git push $(REPO) $(tag);)
	@$(foreach tag, $(TAGS), git branch -D $(tag);)

release: $(TAGS)
	$(DOCKER) push quay.io/aptible/couchdb

build: $(TAGS)

.PHONY: $(TAGS)
$(TAGS):
	$(DOCKER) build -t quay.io/aptible/couchdb:$@ $@

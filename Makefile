##################################################################
# Clone all repositories from gitlab or other supported scms
# https://github.com/gabrie30/ghorg/blob/master/examples/gitlab.md

scm ?= gitlab
token ?= unset

scm_uri := <gitlab_host_name>
scm_group ?= <gitlab_group_abbreviation>

destination := $(abspath ./)
clone:
	ghorg clone $(scm_group) --fetch-all --base-url=https://$(scm_uri) --scm=$(scm) --token=$(token) --path $(destination)


############################################################################
# Visualize Repository
# https://github.com/acaudwell/Gource/wiki/Visualizing-Multiple-Repositories

speed ?= 4
postfix := .gource.log
repositories := $(wildcard <prefix>*) <specfic_repository_name>

vis-create-indices:
	@echo "INFO :: Parsing repositories $(source): $(repositories)"
	@$(foreach r,$(repositories),gource --output-custom-log $(r)$(postfix) $(r); awk -s  -i inplace -F'|' '// {print $$1 "|" $$2 "|" $$3 "|$(r)" $$4}' $(r)$(postfix);)

combined := combined$(postfix)
vis-render-combined:
	@echo "INFO :: Starting combined playback"
	@cat $(wildcard *$(postfix)) | sort -n > $(combined)
	@gource --time-scale $(speed) $(combined)

visualize: vis-create-indices vis-render-combined

cleanup:
	@echo "INFO :: Remove intermediate files"
	rm -rf $(wildcard *$(postfix))

test:
	@echo "INFO :: Test path prefixing with repository name"
	rm -rf test.gource.log
	echo "1633351444|A Committer|A|/.gitlab-ci.yml" > test.gource.log
	awk -s  -i inplace -F'|' '// {print $$1 "|" $$2 "|" $$3 "|/repo" $$4}' test.gource.log
	cat test.gource.log

setup:
	brew install gource
	brew install gabrie30/utils/ghorg

# -----------------------------------------------------------------
# remove temporary terraform files
# -----------------------------------------------------------------
.PHONY: clean
clean: ## remove .terraform
	find . -name ".terra*" -exec rm -rf {} \;
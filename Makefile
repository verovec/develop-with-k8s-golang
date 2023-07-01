CLUSTER_NAME := develop-with-k8s
NB_NODES := 1

REGISTRY_NAME := develop-with-k8s.localhost
REGISTRY_PORT := 5111


start:
	@bash cluster-init.sh $(CLUSTER_NAME) $(REGISTRY_NAME) $(REGISTRY_PORT) $(NB_NODES)

delete:
	@k3d cluster delete $(CLUSTER_NAME)

cleanup: delete
	@k3d registry delete $(REGISTRY_NAME)

stop:
	@k3d cluster stop $(CLUSTER_NAME) --all
	@docker stop k3d-develop-with-k8s.localhost

api: deploy dev

deploy:
	@devspace use namespace backend
	@devspace deploy --dependency api;

dev:
	@devspace dev --skip-deploy;

cleanup-images:
	@devspace cleanup images

.PHONY: start delete cleanup stop api deploy dev cleanup-images

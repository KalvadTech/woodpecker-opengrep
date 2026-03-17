IMAGE = ghcr.io/kalvadtech/woodpecker-opengrep

build:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(IMAGE):latest .

push:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(IMAGE):latest --push .

tag-latest:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(IMAGE):latest --push .

tag-version:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(IMAGE):$(VERSION) --push .

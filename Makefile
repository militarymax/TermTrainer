# TermTrainer — Незримый Университет Терминала

VERSION ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
BINARY   = termtrainer
LDFLAGS  = -ldflags "-X main.version=$(VERSION)"

.PHONY: build test lint clean release

build:
	go build $(LDFLAGS) -o $(BINARY) .

test:
	go test -v ./...

lint:
	go vet ./...

clean:
	rm -f $(BINARY)

release: build
	@echo "Built $(BINARY) version $(VERSION)"

# Cross-compile
build-darwin-arm64:
	GOOS=darwin GOARCH=arm64 go build $(LDFLAGS) -o $(BINARY)-darwin-arm64 .

build-linux-amd64:
	GOOS=linux GOARCH=amd64 go build $(LDFLAGS) -o $(BINARY)-linux-amd64 .

cross-compile: build-darwin-arm64 build-linux-amd64
	@echo "Cross-compiled for darwin/arm64 and linux/amd64"

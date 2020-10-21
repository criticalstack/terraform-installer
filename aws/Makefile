SHELL := /bin/bash

.PHONY: apply destroy update .kube/config

export GO111MODULE=on

# Get the currently used golang install path (in GOPATH/bin, unless GOBIN is set)
ifeq (,$(shell go env GOBIN))
GOBIN=$(shell go env GOPATH)/bin
else
GOBIN=$(shell go env GOBIN)
endif

apply: tftaint crit .pki/ca.crt .pki/etcd/ca.crt config-confirm tfinit tfvalidate tfapply import-ctx cluster-ready
destroy: tfdestroy

.pki/ca.crt: crit
	@[[ -f $@ ]] || $(CRIT) certs init --cert-dir .pki/
	@mkdir -p userdata/workers/files/etc/kubernetes/pki
	@cp .pki/ca.crt userdata/workers/files/etc/kubernetes/pki/ca.crt

.pki/etcd/ca.crt: $(CRIT)
	@[[ -f $@ ]] || $(CRIT) e2d pki init --ca-cert .pki/etcd/ca.crt --ca-key .pki/etcd/ca.key

import-ctx: .kube/config
	@$(CRIT) config import $(PWD)/.kube/config

CONTROL_PLANE_ENDPOINT ?= $$(terraform output -json | jq -r '.control_plane_endpoint.value')

.kube/config:
	@mkdir -p .kube
	@$(CRIT) generate kubeconfig $(PWD)/.kube/config \
		--cert-dir $(PWD)/.pki \
		--server https://$(CONTROL_PLANE_ENDPOINT):6443

cluster-ready:
	@echo -n "Waiting for controlplane to be ready ..."
	@until kubectl get no >/dev/null 2>&1; do echo -ne "\rWaiting for controlplane to be ready ..."; sleep 2; done
	@echo " Ready!"

config-confirm: tfconfig
	@$(TFCONFIG) create ./

clean:
	@rm -f .pki/ca.crt
	@rm -f .pki/ca.key
	@rm -f .pki/etcd/ca.crt
	@rm -f .pki/etcd/ca.key

tfinit:
	@terraform init
tfvalidate:
	@terraform validate
tfapply:
	@terraform apply -auto-approve
tfdestroy:
	@terraform destroy -auto-approve
tftaint:
	@terraform taint --allow-missing "module.control_plane_asg.aws_autoscaling_group.this[0]"
	@terraform taint --allow-missing "module.workers_asg.aws_autoscaling_group.this[0]"

crit:
ifeq (, $(shell which crit))
	@{ \
	set -e ;\
	CRIT_TMP_DIR=$$(mktemp -d) ;\
	cd $$CRIT_TMP_DIR ;\
	go mod init tmp ;\
	go get github.com/criticalstack/crit/cmd/crit ;\
	rm -rf $$CRIT_TMP_DIR ;\
	}
CRIT=$(GOBIN)/crit
else
CRIT=$(shell which crit)
endif


tfconfig:
ifeq (, $(shell which tfconfig))
	@{ \
	set -e ;\
	TFCONFIG_TMP_DIR=$$(mktemp -d) ;\
	cd $$TFCONFIG_TMP_DIR ;\
	go mod init tmp ;\
	go get github.com/criticalstack/crit/hack/tools/tfconfig/cmd/tfconfig ;\
	rm -rf $$TFCONFIG_TMP_DIR ;\
	}
TFCONFIG=$(GOBIN)/tfconfig
else
TFCONFIG=$(shell which tfconfig)
endif

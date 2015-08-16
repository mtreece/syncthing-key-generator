# Makefile - Makefile for generating Syncthing keys
# author: mtreece
# date: 2015-08-15
# purpose:
#   automate some of this crap ;-)

# shouldn't be changeable, but most likely to be changed
FINAL_KEYFILE_NAME ?= key.pem
FINAL_CERT_NAME ?= cert.pem
NUM_YEARS_VALID ?= 100
CERT ?= $(FINAL_CERT_NAME)

# shouldn't be changed
X509_CONFIG_NAME = conf/syncthing.cfg
X509_CSR_NAME = tmp_syncthing.csr

# universal constants
NUM_DAYS_IN_YEAR = 365

all: $(FINAL_KEYFILE_NAME) $(FINAL_CERT_NAME)

$(FINAL_KEYFILE_NAME): $(X509_CONFIG_NAME)
$(X509_CSR_NAME): $(X509_CONFIG_NAME)
	openssl req \
	    -new \
	    $$([ -f $(FINAL_KEYFILE_NAME) ] && echo -key $(FINAL_KEYFILE_NAME)) \
	    -config $(X509_CONFIG_NAME) \
	    -out $(X509_CSR_NAME)

$(FINAL_CERT_NAME): $(X509_CONFIG_NAME) $(X509_CSR_NAME) $(FINAL_KEYFILE_NAME)
	openssl x509 \
	    -req \
	    -days $$(($(NUM_YEARS_VALID) * $(NUM_DAYS_IN_YEAR))) \
	    -in $(X509_CSR_NAME) \
	    -signkey $(FINAL_KEYFILE_NAME) \
	    -out $(FINAL_CERT_NAME) \
	    -sha256 \
	    -extensions v3_req \
	    -extfile $(X509_CONFIG_NAME)

# How Device IDs are computed: http://docs.syncthing.net/dev/device-ids.html
.PHONY: show-id
show-id: $(CERT)
	@# the --quiet is needed to keep the recursive make output from feeding
	@# into the encoded-id.py script
	@$(MAKE) --quiet show-raw-id CERT=$(CERT) | ./tools/encoded-id.py

.PHONY: show-raw-id
show-raw-id: $(CERT)
	@openssl x509 -in $(CERT) -outform der | openssl dgst -binary -sha256 | ./tools/b32.pl

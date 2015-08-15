# Makefile - Makefile for generating Android SyncThing keys
# author: mtreece
# date: 2015-08-15
# purpose:
#   automate some of this crap ;-)

# shouldn't be changeable, but most likely to be changed
FINAL_KEYFILE_NAME ?= key.pem
FINAL_CERT_NAME ?= cert.pem
NUM_YEARS_VALID ?= 100

# shouldn't be changed
X509_CONFIG_NAME = syncthing.cfg
X509_CSR_NAME = tmp_syncthing.csr

# universal constants
NUM_DAYS_IN_YEAR = 365

all: $(FINAL_KEYFILE_NAME) $(FINAL_CERT_NAME)

$(FINAL_KEYFILE_NAME): $(X509_CONFIG_NAME)
$(X509_CSR_NAME): $(X509_CONFIG_NAME)
	openssl req \
	    -new \
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

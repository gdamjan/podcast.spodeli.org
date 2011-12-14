-include settings.mk

PYTHON       = python2
PIP          = pip2
BUILD_DIR    = output
SITE_DIR     = .
HYDE         = hyde -s $(SITE_DIR)
RSYNC        = rsync -av
RM           = rm -r

default: help

# pep-370 setup
export PYTHONUSERBASE = $(PWD)/py-env
export PATH := $(PYTHONUSERBASE)/bin:$(PATH)


get-deps:
	$(PIP) install --user git+git://github.com/hyde/hyde.git
	mkdir -p $(SITE_DIR)/media/js
	cd $(SITE_DIR)/media/js && wget -qN http://code.jquery.com/jquery.min.js



#
# build the static html with hyde
#

build:
	$(HYDE) gen -r -d $(BUILD_DIR)


#
# postprocessing
#

FFMPEG      = ffmpeg -loglevel quiet
MP3SRC      = $(shell find -name '*.mp3')
OGGSRC      = $(shell find -name '*.ogg')
MP3DST      = $(patsubst %.ogg,%.mp3,$(OGGSRC))
OGGDST      = $(patsubst %.mp3,%.ogg,$(MP3SRC))

$(OGGDST): $(MP3SRC)
	@$(FFMPEG) -i $< $@
$(MP3DST): $(OGGSRC)
	@$(FFMPEG) -i $< $@

postprocess: $(MP3DST) $(OGGDST)
	@echo convert mp3 to ogg and vice versa


#
# see the result localy, before deployment
#

serve:
	$(HYDE) serve -d $(BUILD_DIR)


#
# delete all output to build from scratch
#

clean:
	$(RM) $(BUILD_DIR)


#
# Deployment
#

ifneq ($(origin DEPLOY_HOST), undefined)
    DEPLOY_HOST += $(DEPLOY_HOST):
endif
ifneq ($(origin DEPLOY_USER), undefined)
    DEPLOY_USER += $(DEPLOY_USER)@
endif
ifneq ($(origin DEPLOY_DEST), undefined)
    RSYNC_DEST = $(DEPLOY_USER)$(DEPLOY_HOST)$(DEPLOY_DEST)
endif

deploy:
	ifeq ($(origin RSYNC_DEST), undefined)
		@echo "Please configure the settings.mk file (see README for details)"
		@exit 1
	endif
	$(RSYNC) $(BUILD_DIR) $(RSYNC_DEST)


#
# Help
#

define HELP
Quick-usage:

	make get-deps
	make build
	make preprocess
	make serve
	make deploy

endef

export HELP
help:
	@echo "$$HELP"

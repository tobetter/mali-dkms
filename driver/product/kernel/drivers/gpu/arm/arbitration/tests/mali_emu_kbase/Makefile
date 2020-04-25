# SPDX-License-Identifier: GPL-2.0 OR MIT
#
# (C) COPYRIGHT 2021-2022 ARM Limited or its affiliates. All rights reserved.
#
#

# linux build system bootstrap for out-of-tree module

# default to building for the host
ARCH ?= $(shell uname -m)

ifeq ($(KDIR),)
$(error Must specify KDIR to point to the kernel to target))
endif

all: mali_emu_kbase

mali_emu_kbase:
	$(MAKE) ARCH=$(ARCH) -C $(KDIR) M=$(CURDIR) EXTRA_CFLAGS="-I$(CURDIR)/../../../midgard/arbiter" modules

clean:
	$(MAKE) ARCH=$(ARCH) -C $(KDIR) M=$(CURDIR) clean

# Clang flags for ppc arch, target or host.

CLANG_CONFIG_ppc_EXTRA_ASFLAGS :=
CLANG_CONFIG_ppc_EXTRA_CFLAGS :=
CLANG_CONFIG_ppc_EXTRA_LDFLAGS :=

# Include common unknown flags
CLANG_CONFIG_ppc_UNKNOWN_CFLAGS := \
  $(CLANG_CONFIG_UNKNOWN_CFLAGS)

# We don't have any ppc flags to substitute yet.
define subst-clang-incompatible-ppc-flags
  $(1)
endef

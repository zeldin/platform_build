# Clang flags for ppc64 arch, target or host.

CLANG_CONFIG_ppc64_EXTRA_ASFLAGS :=
CLANG_CONFIG_ppc64_EXTRA_CFLAGS :=
CLANG_CONFIG_ppc64_EXTRA_LDFLAGS :=

# Include common unknown flags
CLANG_CONFIG_ppc64_UNKNOWN_CFLAGS := \
  $(CLANG_CONFIG_UNKNOWN_CFLAGS)

# We don't have any ppc64 flags to substitute yet.
define subst-clang-incompatible-ppc64-flags
  $(1)
endef

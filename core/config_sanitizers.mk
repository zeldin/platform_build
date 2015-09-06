##############################################
## Perform configuration steps for sanitizers.
##############################################

my_sanitize := $(strip $(LOCAL_SANITIZE))

# Don't apply sanitizers to NDK code.
ifdef LOCAL_SDK_VERSION
  my_sanitize := never
endif

# Configure SANITIZE_HOST / SANITIZE_TARGET.
ifeq ($(my_sanitize),)
  ifdef LOCAL_IS_HOST_MODULE
    my_sanitize := $(strip $(SANITIZE_HOST))
  else
    my_sanitize := $(strip $(SANITIZE_TARGET))
  endif

  # SANITIZE_HOST=true is a deprecated way to say SANITIZE_HOST=address.
  ifeq ($(my_sanitize),true)
    my_sanitize := address
  endif

  # SANITIZE_HOST is only in effect if the module is already using clang (host
  # modules that haven't set `LOCAL_CLANG := false` and device modules that
  # have set `LOCAL_CLANG := true`.
  ifneq ($(my_clang),true)
    my_sanitize :=
  endif
endif

ifeq ($(my_sanitize),never)
  my_sanitize :=
endif

# TSAN is not supported on 32-bit architectures. For non-multilib cases, make
# its use an error. For multilib cases, don't use it for the 32-bit case.
ifneq ($(filter thread,$(my_sanitize)),)
  ifeq ($(my_32_64_bit_suffix),32)
    ifeq ($(my_module_multilib),both)
        my_sanitize := $(filter-out thread,$(my_sanitize))
    else
        $(error $(LOCAL_PATH): $(LOCAL_MODULE): TSAN cannot be used for 32-bit modules.)
    endif
  endif
endif

# Undefined symbols can occur if a non-sanitized library links
# sanitized static libraries. That's OK, because the executable
# always depends on the ASan runtime library, which defines these
# symbols.
ifneq ($(strip $(SANITIZE_TARGET)),)
  ifndef LOCAL_IS_HOST_MODULE
    ifeq ($(LOCAL_MODULE_CLASS),SHARED_LIBRARIES)
      ifeq ($(my_sanitize),)
        my_allow_undefined_symbols := true
      endif
    endif
    # Workaround for a bug in AddressSanitizer that breaks stack unwinding.
    # https://code.google.com/p/address-sanitizer/issues/detail?id=387
    # Revert when external/compiler-rt is updated past r236014.
    LOCAL_PACK_MODULE_RELOCATIONS := false
  endif
endif

# Sanitizers can only be used with clang.
ifneq ($(my_clang),true)
  ifneq ($(my_sanitize),)
    $(error $(LOCAL_PATH): $(LOCAL_MODULE): Use of sanitizers requires LOCAL_CLANG := true)
  endif
endif

ifneq ($(filter default-ub,$(my_sanitize)),)
  my_sanitize := $(CLANG_DEFAULT_UB_CHECKS)
endif

ifneq ($(my_sanitize),)
  fsanitize_arg := $(subst $(space),$(comma),$(my_sanitize)),
  my_cflags += -fsanitize=$(fsanitize_arg)

  ifdef LOCAL_IS_HOST_MODULE
    my_cflags += -fno-sanitize-recover=all
    my_ldflags += -fsanitize=$(fsanitize_arg)
    my_ldlibs += -lrt -ldl
  else
    my_cflags += -fsanitize-undefined-trap-on-error
    my_cflags += -ftrap-function=abort
    my_shared_libraries += libdl
  endif
endif

ifneq ($(filter address,$(my_sanitize)),)
  # Frame pointer based unwinder in ASan requires ARM frame setup.
  LOCAL_ARM_MODE := arm
  my_cflags += $(ADDRESS_SANITIZER_CONFIG_EXTRA_CFLAGS)
  my_ldflags += $(ADDRESS_SANITIZER_CONFIG_EXTRA_LDFLAGS)
  ifdef LOCAL_IS_HOST_MODULE
    # -nodefaultlibs (provided with libc++) prevents the driver from linking
    # libraries needed with -fsanitize=address. http://b/18650275 (WAI)
    my_ldlibs += -lm -lpthread
    my_ldflags += -Wl,--no-as-needed
  else
    my_cflags += -mllvm -asan-globals=0
    # ASan runtime library must be the first in the link order.
    my_shared_libraries := $($(LOCAL_2ND_ARCH_VAR_PREFIX)ADDRESS_SANITIZER_RUNTIME_LIBRARY) \
                           $(my_shared_libraries) \
                           $(ADDRESS_SANITIZER_CONFIG_EXTRA_SHARED_LIBRARIES)
    my_static_libraries += $(ADDRESS_SANITIZER_CONFIG_EXTRA_STATIC_LIBRARIES)
    my_ldflags += -Wl,-rpath,$($(LOCAL_2ND_ARCH_VAR_PREFIX)ADDRESS_SANITIZER_RPATH)
    my_linker := $($(LOCAL_2ND_ARCH_VAR_PREFIX)ADDRESS_SANITIZER_LINKER)
  endif
endif

ifneq ($(filter undefined,$(my_sanitize)),)
  ifndef LOCAL_IS_HOST_MODULE
    $(error ubsan is not yet supported on the target)
  endif
endif

ifneq ($(strip $(LOCAL_SANITIZE_RECOVER)),)
  recover_arg := $(subst $(space),$(comma),$(LOCAL_SANITIZE_RECOVER)),
  my_cflags += -fsanitize-recover=$(recover_arg)
endif

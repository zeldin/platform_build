# Shared by HOST_ppc.mk and HOST_ppc64.mk.

ifeq ($(HOST_OS),darwin)
CLANG_CONFIG_ppc_DARWIN_HOST_EXTRA_ASFLAGS := \
  -integrated-as

CLANG_CONFIG_ppc_DARWIN_HOST_EXTRA_CFLAGS := \
  -integrated-as
endif

ifeq ($(HOST_OS),linux)
ifneq ($($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG),)
CLANG_CONFIG_ppc_LINUX_HOST_EXTRA_ASFLAGS := \
  --gcc-toolchain=$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG) \
  --sysroot=$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/sysroot

CLANG_CONFIG_ppc_LINUX_HOST_EXTRA_CFLAGS := \
  --gcc-toolchain=$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)

ifneq ($(strip $($(clang_2nd_arch_prefix)HOST_IS_64_BIT)),)
CLANG_CONFIG_ppc_LINUX_HOST_EXTRA_CPPFLAGS := \
  --gcc-toolchain=$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG) \
  --sysroot=$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/sysroot \
  -isystem $($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/powerpc64-linux/include/c++/4.8 \
  -isystem $($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/powerpc64-linux/include/c++/4.8/powerpc64-linux \
  -isystem $($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/powerpc64-linux/include/c++/4.8/backward

CLANG_CONFIG_ppc_LINUX_HOST_EXTRA_LDFLAGS := \
  --gcc-toolchain=$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG) \
  --sysroot=$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/sysroot \
  -B$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/powerpc64-linux/bin \
  -B$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/lib/gcc/powerpc64-linux/4.8 \
  -L$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/lib/gcc/powerpc64-linux/4.8 \
  -L$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/powerpc64-linux/lib64/
else
CLANG_CONFIG_ppc_LINUX_HOST_EXTRA_CPPFLAGS := \
  --gcc-toolchain=$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG) \
  --sysroot=$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/sysroot \
  -isystem $($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/powerpc64-linux/include/c++/4.8 \
  -isystem $($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/powerpc64-linux/include/c++/4.8/powerpc64-linux/32 \
  -isystem $($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/powerpc64-linux/include/c++/4.8/backward

CLANG_CONFIG_ppc_LINUX_HOST_EXTRA_LDFLAGS := \
  --gcc-toolchain=$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG) \
  --sysroot=$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/sysroot \
  -B$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/powerpc64-linux/bin \
  -B$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/lib/gcc/powerpc64-linux/4.8/32 \
  -L$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/lib/gcc/powerpc64-linux/4.8/32 \
  -L$($(clang_2nd_arch_prefix)HOST_TOOLCHAIN_FOR_CLANG)/powerpc64-linux/lib32/
endif
endif
endif  # Linux


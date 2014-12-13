/*
 * Copyright (C) 2005 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * Android config -- "CYGWIN_NT-5.1".
 *
 * Cygwin has pthreads, but GDB seems to get confused if you use it to
 * create threads.  By "confused", I mean it freezes up the first time the
 * debugged process creates a thread, even if you use CreateThread.  The
 * mere presence of pthreads linkage seems to cause problems.
 */
#ifndef _ANDROID_CONFIG_H
#define _ANDROID_CONFIG_H

/*
 * ===========================================================================
 *                              !!! IMPORTANT !!!
 * ===========================================================================
 *
 * This file is included by ALL C/C++ source files.  Don't put anything in
 * here unless you are absolutely certain it can't go anywhere else.
 *
 * Any C++ stuff must be wrapped with "#ifdef __cplusplus".  Do not use "//"
 * comments.
 */

/* MingW doesn't define __BEGIN_DECLS / __END_DECLS. */

#ifndef __BEGIN_DECLS
#  ifdef __cplusplus
#    define __BEGIN_DECLS extern "C" {
#  else
#    define __BEGIN_DECLS
#  endif
#endif

#ifndef __END_DECLS
#  ifdef __cplusplus
#    define __END_DECLS }
#  else
#    define __END_DECLS
#  endif
#endif

/*
 * Threading model.  Choose one:
 *
 * HAVE_PTHREADS - use the pthreads library.
 * HAVE_WIN32_THREADS - use Win32 thread primitives.
 */
#define HAVE_WIN32_THREADS

/*
 * Process creation model.  Choose one:
 *
 * HAVE_FORKEXEC - use fork() and exec()
 * HAVE_WIN32_PROC - use CreateProcess()
 */
#ifdef __CYGWIN__
#  define HAVE_FORKEXEC
#else
#  define HAVE_WIN32_PROC
#endif

/* TODO: replace references to this. */
#define HAVE_WIN32_IPC

/*
 * Memory-mapping model. Choose one:
 *
 * HAVE_POSIX_FILEMAP - use the Posix sys/mmap.h
 * HAVE_WIN32_FILEMAP - use Win32 filemaps
 */
#ifdef __CYGWIN__
#define  HAVE_POSIX_FILEMAP
#else
#define  HAVE_WIN32_FILEMAP
#endif

/*
 * Define this if you have <termio.h>
 */
#ifdef __CYGWIN__
#  define  HAVE_TERMIO_H
#endif

/*
 * Define this if you build against MSVCRT.DLL
 */
#ifndef __CYGWIN__
#  define HAVE_MS_C_RUNTIME
#endif

/*
 * Define this if you have sys/uio.h
 */
#ifdef __CYGWIN__
#define  HAVE_SYS_UIO_H
#endif

/*
 * Define this if we want to use WinSock.
 */
#ifndef __CYGWIN__
#define HAVE_WINSOCK
#endif

/*
 * Endianness of the target machine.  Choose one:
 *
 * HAVE_ENDIAN_H -- have endian.h header we can include.
 * HAVE_LITTLE_ENDIAN -- we are little endian.
 * HAVE_BIG_ENDIAN -- we are big endian.
 */
#ifdef __CYGWIN__
#define HAVE_ENDIAN_H
#endif

#define HAVE_LITTLE_ENDIAN

/*
 * We need to choose between 32-bit and 64-bit off_t.  All of our code should
 * agree on the same size.  For desktop systems, use 64-bit values,
 * because some of our libraries (e.g. wxWidgets) expect to be built that way.
 */
#define _FILE_OFFSET_BITS 64
#define _LARGEFILE_SOURCE 1

/*
 * Defined if we have the backtrace() call for retrieving a stack trace.
 * Needed for CallStack to operate; if not defined, CallStack is
 * non-functional.
 */
#define HAVE_BACKTRACE 0

/*
 * Add any extra platform-specific defines here.
 */
#define WIN32 1                 /* stock Cygwin doesn't define these */
#define _WIN32 1
#define _WIN32_WINNT 0x0500     /* admit to using >= Win2K */

#define HAVE_WINDOWS_PATHS      /* needed by simulator */

/*
 * What CPU architecture does this platform use?
 */
#define ARCH_X86

/*
 * sprintf() format string for shared library naming.
 */
#define OS_SHARED_LIB_FORMAT_STR    "lib%s.dll"

/*
 * The default path separator for the platform
 */
#define OS_PATH_SEPARATOR '\\'

/*
 * Define if <sys/socket.h> exists.
 * Cygwin has it, but not MinGW.
 */
#ifdef USE_MINGW
/* #define HAVE_SYS_SOCKET_H */
#else
#define HAVE_SYS_SOCKET_H 1
#endif

/*
 * Define if <winsock2.h> exists.
 * Only MinGW has it.
 */
#ifdef USE_MINGW
#define HAVE_WINSOCK2_H 1
#else
/* #define HAVE_WINSOCK2_H */
#endif

/*
 * Various definitions missing in MinGW
 */
#ifdef USE_MINGW
#define S_IRGRP 0
#endif

/*
 * Define if <stdbool.h> exists.
 */
#define HAVE_STDBOOL_H

#endif /*_ANDROID_CONFIG_H*/

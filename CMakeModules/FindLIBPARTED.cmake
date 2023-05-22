# SPDX-FileCopyrightText: 2008,2010,2011 by Volker Lanz <vl@fidra.de>
# SPDX-License-Identifier: BSD-2-Clause
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

include(CheckCSourceCompiles)
include(CheckFunctionExists)

if (LIBPARTED_INCLUDE_DIR AND LIBPARTED_LIBRARY)
  # Already in cache, be silent
  set(LIBPARTED_FIND_QUIETLY TRUE)
endif (LIBPARTED_INCLUDE_DIR AND LIBPARTED_LIBRARY)


FIND_PATH(LIBPARTED_INCLUDE_DIR parted.h PATH_SUFFIXES parted )

FIND_LIBRARY(LIBPARTED_LIBRARY NAMES parted)
FIND_LIBRARY(LIBPARTED_FS_RESIZE_LIBRARY NAMES parted-fs-resize)

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(LIBPARTED DEFAULT_MSG LIBPARTED_LIBRARY LIBPARTED_INCLUDE_DIR)

if (LIBPARTED_FS_RESIZE_LIBRARY)
  set(LIBPARTED_LIBS ${LIBPARTED_LIBRARY} ${LIBPARTED_FS_RESIZE_LIBRARY})
else (LIBPARTED_FS_RESIZE_LIBRARY)
  set(LIBPARTED_LIBS ${LIBPARTED_LIBRARY})
endif (LIBPARTED_FS_RESIZE_LIBRARY)

# KDE adds -ansi to the C make flags, parted headers use GNU extensions, so
# undo that
unset(CMAKE_C_FLAGS)

set(CMAKE_REQUIRED_INCLUDES ${LIBPARTED_INCLUDE_DIR})
set(CMAKE_REQUIRED_LIBRARIES ${LIBPARTED_LIBS})

CHECK_FUNCTION_EXISTS("ped_file_system_clobber" LIBPARTED_FILESYSTEM_SUPPORT) # parted < 3.0
CHECK_FUNCTION_EXISTS("ped_file_system_resize" LIBPARTED_FS_RESIZE_LIBRARY_SUPPORT) # parted != 3.0

MARK_AS_ADVANCED(LIBPARTED_LIBRARY LIBPARTED_INCLUDE_DIR LIBPARTED_FILESYSTEM_SUPPORT LIBPARTED_FS_RESIZE_LIBRARY LIBPARTED_FS_RESIZE_LIBRARY_SUPPORT)
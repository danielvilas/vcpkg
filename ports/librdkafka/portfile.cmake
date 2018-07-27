# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO edenhill/librdkafka
  REF v0.11.5
  SHA512 4a8dc46ad66f23cff4d4ef2fc8daa7207bfa3e77fd3580b3f141a73b449e60ea5381e97263235b4d0d762df027a8a2cad08637d88162d9605c82d74a1e64b67c
  HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
	OPTIONS -DLIBRDKAFKACPP_EXPORTS=1 -DRDKAFKA_BUILD_EXAMPLES=0 -DRDKAFKA_BUILD_TESTS=0
)

vcpkg_install_cmake()

# Handle copyright
# file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/librdkafka RENAME copyright)
vcpkg_install_cmake()

# Handle copyright
# file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/fann RENAME copyright)
file(GLOB DLLS
  "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/src/*.dll"
  "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/Release/*.dll"
  "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/*/Release/*.dll"
)
file(GLOB LIBS
  "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/src/*.lib"
  "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/Release/*.lib"
  "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/*/Release/*.lib"
)
file(GLOB DEBUG_DLLS
  "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/src/*.dll"
  "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/Debug/*.dll"
  "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/*/Debug/*.dll"
)
file(GLOB DEBUG_LIBS
  "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/src/*.lib"
  "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/Debug/*.lib"
  "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/*/Debug/*.lib"
)
if(DLLS)
  file(INSTALL ${DLLS} DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
endif()
if(LIBS)
  file(INSTALL ${LIBS} DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
endif()
if(DEBUG_DLLS)
  file(INSTALL ${DEBUG_DLLS} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()
if(DEBUG_LIBS)
  file(INSTALL ${DEBUG_LIBS} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
endif()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/RdKafka)

vcpkg_copy_pdbs()

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/librdkafka RENAME copyright)
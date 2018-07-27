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
  OUT_SOURCE_PATH SOURCE_PATH_FULL
  REPO apache/zookeeper
  REF release-3.5.4
  SHA512 6f48d42ba3f5b9b8a431dde2d7132542750d01066c43abc0f451ff2023477bd2dfd12be061018f2c69a1e13e63bb4af26ccb342d3d2cb4fd8f0a59f1a18055e7
  HEAD_REF master
)
set(SOURCE_PATH ${SOURCE_PATH_FULL}/src/c)

message("Please execute ant compile_jute on ${SOURCE_PATH_FULL}")
#execute_process(COMMAND "${CMAKE_COMMAND}" "-E" "environment")	

#vcpkg_execute_required_process(
#    COMMAND $ENV{ANT_HOME}/bin/ant.bat compile_jute
#    WORKING_DIRECTORY ${SOURCE_PATH_FULL}
#    LOGNAME ant-${TARGET_TRIPLET}
#)


vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

# Handle copyright
# file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/zookepeer_mt RENAME copyright)

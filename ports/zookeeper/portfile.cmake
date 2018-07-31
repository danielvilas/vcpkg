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

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
    ${CURRENT_PORT_DIR}/CMakeLists.txt.patch
) 

file(COPY ${CURRENT_PORT_DIR}/zookeeper.jute.c DESTINATION ${SOURCE_PATH}/generated/)
file(COPY ${CURRENT_PORT_DIR}/zookeeper.jute.h DESTINATION ${SOURCE_PATH}/generated/)

#execute_process(COMMAND "${CMAKE_COMMAND}" "-E" "environment")	

#vcpkg_execute_required_process(
#    COMMAND $ENV{ANT_HOME}/bin/ant.bat compile_jute
#    WORKING_DIRECTORY ${SOURCE_PATH_FULL}
#    LOGNAME ant-${TARGET_TRIPLET}
#)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DSKIP_INSTALL_FILES=ON
        -DSKIP_BUILD_EXAMPLES=ON
		-DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=TRUE
) 

vcpkg_build_cmake()

foreach(libname zookeeper_mt)
	foreach (ext dll pdb)
		file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/${libname}.${ext} DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
		file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/${libname}.${ext} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)  
	endforeach()
		file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/${libname}.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
		file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/${libname}.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)  
endforeach()
file(INSTALL ${SOURCE_PATH}/include/ DESTINATION ${CURRENT_PACKAGES_DIR}/include/zookeeper FILES_MATCHING PATTERN "*.h")
# Handle copyright
file(INSTALL ${SOURCE_PATH_FULL}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/zookeeper/copyright)
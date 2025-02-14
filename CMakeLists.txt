cmake_minimum_required(VERSION 3.12)
project("chdman CBT edition")
set(build_version "0.249-CBT_edition")
set(vcs_revision "mame0249")
#cd ../mame && git describe --dirty

if(NOT CMAKE_BUILD_TYPE)
set(CMAKE_BUILD_TYPE Release)
endif()

set(CMAKE_CXX_STANDARD 20) #needed by libocore and libutils. -
#set globally to match MAME's genie scripts.

if(WIN32)
add_compile_definitions(
  X64_WINDOWS_ABI
  CRLF=3
  OSD_WINDOWS
)
else()
add_compile_definitions(
  CRLF=2
)
endif()

if(CMAKE_SYSTEM_NAME STREQUAL "FreeBSD")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wbad-function-cast")
endif()

function(addprojectflags)
  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wsuggest-override -flifetime-dse=1")
  endif()
endfunction()

add_subdirectory(cmake_subdirs)

#chdman
add_executable(chdman
  ${CMAKE_SOURCE_DIR}/src/tools/chdman.cpp
  ${CMAKE_SOURCE_DIR}/src/version.cpp
)

target_include_directories(chdman PRIVATE
  ${CMAKE_SOURCE_DIR}/src/osd
  ${CMAKE_SOURCE_DIR}/src/lib/util
  ${CMAKE_SOURCE_DIR}/3rdparty
  ${CMAKE_SOURCE_DIR}/3rdparty/libflac/include
)
#set_property(TARGET chdman PROPERTY CXX_STANDARD 17)
target_compile_definitions(chdman PRIVATE
  BARE_BUILD_VERSION="${build_version}"
  BARE_VCS_REVISION="${vcs_revision}"
)

target_link_libraries(chdman PRIVATE utils expat 7z ocore_sdl zlib flac utf8proc)

if(UNIX)
target_link_libraries(chdman PRIVATE pthread util)
elseif(WIN32)
target_link_libraries(chdman PRIVATE utils) #circular dependency bs Windows only.
target_link_libraries(chdman PRIVATE
  user32
  winmm
  advapi32
  shlwapi
  wsock32
  ws2_32
  psapi
  iphlpapi
  shell32
  userenv
)
endif()

if(MINGW)
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static")
elseif(MSVC)
add_compile_definitions(
  XML_STATIC
  WIN32
  _WIN32
  _CRT_NONSTDC_NO_DEPRECATE
  _CRT_SECURE_NO_DEPRECATE
  _CRT_STDIO_LEGACY_WIDE_SPECIFIERS
)
endif()

install(TARGETS chdman DESTINATION ${CMAKE_INSTALL_PREFIX})

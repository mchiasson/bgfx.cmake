# bgfx.cmake - bgfx building in cmake
# Written in 2016 by Joshua Brookover <josh@jalb.me>

# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.

# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

if( NOT BGFX_DIR )
	set( BGFX_DIR "${CMAKE_CURRENT_SOURCE_DIR}/bgfx" CACHE STRING "Location of bgfx." )
endif()

if( NOT IS_DIRECTORY ${BGFX_DIR} )
	message( SEND_ERROR "Could not load bgfx, directory does not exist. ${BGFX_DIR}" )
	return()
endif()

file( GLOB BGFX_SOURCES ${BGFX_DIR}/src/*.cpp ${BGFX_DIR}/src/*.mm ${BGFX_DIR}/src/*.h )

add_library( bgfx STATIC ${BGFX_SOURCES} )
if( MSVC )
	target_compile_definitions( bgfx PRIVATE "-D_CRT_SECURE_NO_WARNINGS" )
endif()
target_include_directories( bgfx PRIVATE ${BGFX_DIR}/3rdparty ${BGFX_DIR}/3rdparty/dxsdk/include ${BGFX_DIR}/3rdparty/khronos )
target_include_directories( bgfx PUBLIC ${BGFX_DIR}/include )
target_link_libraries( bgfx PUBLIC bx )
if( MSVC )
	target_link_libraries( bgfx PUBLIC psapi )
endif()
if( APPLE )
	find_library( CARBON_LIBRARY Carbon )
	find_library( COCOA_LIBRARY Cocoa )
	find_library( METAL_LIBRARY Metal )
	find_library( QUARTZCORE_LIBRARY QuartzCore )
	mark_as_advanced( CARBON_LIBRARY )
	mark_as_advanced( COCOA_LIBRARY )
	mark_as_advanced( METAL_LIBRARY )
	mark_as_advanced( QUARTZCORE_LIBRARY )
	target_link_libraries( bgfx PUBLIC ${CARBON_LIBRARY} ${COCOA_LIBRARY} ${METAL_LIBRARY} ${QUARTZCORE_LIBRARY} )
endif()
set_source_files_properties( ${BGFX_DIR}/src/amalgamated.cpp PROPERTIES HEADER_FILE_ONLY ON )
set_source_files_properties( ${BGFX_DIR}/src/amalgamated.mm PROPERTIES HEADER_FILE_ONLY ON )
set_source_files_properties( ${BGFX_DIR}/src/hmd_ovr.cpp PROPERTIES HEADER_FILE_ONLY ON )
set_source_files_properties( ${BGFX_DIR}/src/glcontext_ppapi.cpp PROPERTIES HEADER_FILE_ONLY ON )
set_source_files_properties( ${BGFX_DIR}/src/glcontext_glx.cpp PROPERTIES HEADER_FILE_ONLY ON )
set_source_files_properties( ${BGFX_DIR}/src/glcontext_egl.cpp PROPERTIES HEADER_FILE_ONLY ON )
if( NOT APPLE )
	set_source_files_properties( ${BGFX_DIR}/src/glcontext_eagl.mm PROPERTIES HEADER_FILE_ONLY ON )
	set_source_files_properties( ${BGFX_DIR}/src/glcontext_nsgl.mm PROPERTIES HEADER_FILE_ONLY ON )
	set_source_files_properties( ${BGFX_DIR}/src/renderer_mtl.mm PROPERTIES HEADER_FILE_ONLY ON )
endif()
set_target_properties( bgfx PROPERTIES FOLDER "bgfx" )

# Instruction to build libHaru from internal package source
INCLUDE(ExternalProject)
IF(STANDALONE)
	EXTERNALPROJECT_ADD(libHaru
			URL file://${PROJECT_SOURCE_DIR}/extern/libharu-RELEASE_2_3_0.zip
			PREFIX ${CMAKE_CURRENT_BINARY_DIR}/libHaru
			CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/libHaru
								-DLIBHPDF_SHARED=OFF -DLIBHPDF_STATIC=ON
	)
ELSE(STANDALONE)
	SET(EXTRA "")
	IF(APPLE)
		SET(EXTRA  -DCMAKE_INSTALL_NAME_DIR=${CMAKE_INSTALL_PREFIX}/lib)
	ENDIF(APPLE)
	EXTERNALPROJECT_ADD(libHaru
			URL file://${PROJECT_SOURCE_DIR}/extern/libharu-RELEASE_2_3_0.zip
			PREFIX ${CMAKE_CURRENT_BINARY_DIR}/libHaru
			CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/libHaru
								-DLIBHPDF_SHARED=ON -DLIBHPDF_STATIC=OFF ${EXTRA}
	)
ENDIF(STANDALONE)

ExternalProject_Get_Property(libHaru install_dir)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/libHaru/include)
MESSAGE(STATUS "libHaru will be built in ${install_dir}")

SET( hpdf_LIBRARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/libHaru/lib PATH)
# Set uncached variables as per standard.
# 	  set(hpdf_FOUND ON)
SET(hpdf_INCLUDE_DIR ${CMAKE_CURRENT_BINARY_DIR}/libHaru/include CACHE PATH "" FORCE  )

IF(STANDALONE)
	SET(hpdf_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/libHaru/lib/libhpdfs${CMAKE_STATIC_LIBRARY_SUFFIX};-lz CACHE STRING "" FORCE)
ELSE(STANDALONE)
  SET(hpdf_LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/libHaru/lib/libhpdf${CMAKE_SHARED_LIBRARY_SUFFIX} CACHE STRING "" FORCE)
	INSTALL(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/libHaru/lib 
				  DESTINATION ./
				  USE_SOURCE_PERMISSIONS)
ENDIF(STANDALONE)

MARK_AS_ADVANCED(hpdf_LIBRARY_DIR hpdf_LIBRARY hpdf_INCLUDE_DIR)

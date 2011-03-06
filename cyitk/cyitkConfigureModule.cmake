cmake_minimum_required(VERSION 2.6)

find_package(ITK REQUIRED)
if (USE_ITK_FILE)
  include(${USE_ITK_FILE})
endif(USE_ITK_FILE)

find_package(PythonLibs REQUIRED)
if(USE_PYTHONLIBS_FILE)
  include(${USE_PYTHONLIBS_FILE})
endif(USE_PYTHONLIBS_FILE)

find_package(PythonInterp REQUIRED)
if(USE_PYTHONINTERP_FILE)
  include(${USE_PYTHONINTERP_FILE})
endif(USE_PYTHONINTERP_FILE)

#get numpy include path
execute_process(
  COMMAND
  ${PYTHON_EXECUTABLE} -c "import numpy; print numpy.get_include()"
  OUTPUT_VARIABLE NUMPY_INCLUDE_PATH
  RESULT_VARIABLE NUMPY_ERR
  OUTPUT_STRIP_TRAILING_WHITESPACE
  )
if(NUMPY_ERR)
  message(SEND_ERROR "WARNING: NumPy header not found.")
endif(NUMPY_ERR)
set(PYTHON_INCLUDE_PATH ${PYTHON_INCLUDE_PATH} ${NUMPY_INCLUDE_PATH})
 
include_directories(${PYTHON_INCLUDE_PATH})
include_directories(${CYITK_SOURCE_DIR})

#TODO: Windows? Need a FindCython.cmake
find_program(CYTHON_EXECUTABLE cython /usr/bin /usr/local/bin)

macro(cyitk_configure_module moduleName pyxSrcs)
  set(CYITK_MODULE_NAME ${moduleName})
  set(CYITK_PYX_SRCS ${pyxSrcs})
  
  #set directories and libraries for C++ ITK code
  set(CYITK_WRAPPED_SOURCE_DIR "${CYITK_WRAPPED_SOURCE_DIR}" CACHE PATH "Directories containing C++ source files included in pyx files.")
  set(CYITK_WRAPPED_LIBRARY_DIR "${CYITK_WRAPPED_LIBRARY_DIR}" CACHE PATH "Directories containing libraries generated from the included source files, if any.")
  set(CYITK_WRAPPED_LIBRARIES "${CYITK_WRAPPED_LIBRARIES}" CACHE STRING "Space-separated list of libraries generated from the included source files, if any.")
  
  include_directories(${CYITK_WRAPPED_SOURCE_DIR})
  link_directories(${CYITK_WRAPPED_LIBRARY_DIR})
  
  set(CYITK_CYTHON_WORKING_DIR ${CMAKE_CURRENT_BINARY_DIR}/${CYITK_MODULE_NAME}_cython_src)
  set(CYITK_MODULE_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/${CYITK_MODULE_NAME})
  
  #assemble image classes in a single cyitk module
  set(CYITK_IMAGE_CLASSES_MODULE_NAME cyitk)
  set(CYITK_IMAGE_CLASSES_TARGET_NAME ${CYITK_MODULE_NAME}_ImageClasses)
  set(CYITK_IMAGE_PYX_SRCS)
  file(WRITE ${CYITK_CYTHON_WORKING_DIR}/${CYITK_IMAGE_CLASSES_MODULE_NAME}.pyx "")
  foreach(PYX_FILE ${CYITK_GENERATED_IMAGE_PYX_SRCS})
    file(READ ${CMAKE_CURRENT_BINARY_DIR}/${PYX_FILE} PYX_FILE_CONTENT)
    file(APPEND ${CYITK_CYTHON_WORKING_DIR}/${CYITK_IMAGE_CLASSES_MODULE_NAME}.pyx ${PYX_FILE_CONTENT})
    file(REMOVE ${CMAKE_CURRENT_BINARY_DIR}/${PYX_FILE})
  endforeach(PYX_FILE)
  set(CYITK_IMAGE_PYX_SRCS ${CYITK_IMAGE_PYX_SRCS} ${CYITK_IMAGE_CLASSES_MODULE_NAME}.pyx)
  
  file(WRITE ${CYITK_CYTHON_WORKING_DIR}/${CYITK_IMAGE_CLASSES_MODULE_NAME}.pxd "")
  foreach(PXD_FILE ${CYITK_GENERATED_IMAGE_PXD_SRCS})
    file(READ ${CMAKE_CURRENT_BINARY_DIR}/${PXD_FILE} PXD_FILE_CONTENT)
    file(APPEND ${CYITK_CYTHON_WORKING_DIR}/${CYITK_IMAGE_CLASSES_MODULE_NAME}.pxd ${PXD_FILE_CONTENT})
    file(REMOVE ${CMAKE_CURRENT_BINARY_DIR}/${PXD_FILE})
  endforeach(PXD_FILE)
  
  #copy pyx files over to binary dir
  foreach(PYX_FILE ${CYITK_PYX_SRCS})
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/${PYX_FILE} ${CYITK_CYTHON_WORKING_DIR}/${PYX_FILE} COPYONLY)
  endforeach(PYX_FILE)
  
  #run cython on all pyx files
  execute_process(
    COMMAND
    ${CYTHON_EXECUTABLE} --cplus ${CYITK_PYX_SRCS} ${CYITK_IMAGE_PYX_SRCS} --working ${CYITK_CYTHON_WORKING_DIR} 
    OUTPUT_VARIABLE CYTHON_OUTPUT
    ERROR_VARIABLE CYTHON_ERROR
    RESULT_VARIABLE CYTHON_ERR
    )
  if(CYTHON_ERR)
    message(SEND_ERROR ${CYTHON_ERROR})
  endif(CYTHON_ERR)
  
  #generate filenames for cython-generated files
  set(CYITK_IMAGE_SRCS)
  foreach(PYX_FILE ${CYITK_IMAGE_PYX_SRCS})
    string(REGEX REPLACE ".pyx$" ".cpp" CPP_FILE ${PYX_FILE})
    set(CYITK_IMAGE_SRCS ${CYITK_IMAGE_SRCS} ${CPP_FILE})
  endforeach(PYX_FILE)
  
  set(CYITK_SRCS)
  foreach(PYX_FILE ${CYITK_PYX_SRCS})
    string(REGEX REPLACE ".pyx$" ".cpp" CPP_FILE ${PYX_FILE})
    set(CYITK_SRCS ${CYITK_SRCS} ${CPP_FILE})
  endforeach(PYX_FILE)
  
  #create __init__.py file
  set(CYITK_INIT_PY __init__.py)
  file(WRITE ${CYITK_MODULE_BINARY_DIR}/${CYITK_INIT_PY} "")
  file(APPEND ${CYITK_MODULE_BINARY_DIR}/${CYITK_INIT_PY} "import sys\n")
  file(APPEND ${CYITK_MODULE_BINARY_DIR}/${CYITK_INIT_PY} "sys.path.append('${CYITK_MODULE_BINARY_DIR}')\n")
  
  #set up targets and append entries in __init__.py
  foreach(CPP_FILE ${CYITK_IMAGE_SRCS})
    string(REGEX REPLACE ".cpp$" "" MODULE_NAME ${CPP_FILE})
    add_library(${CYITK_IMAGE_CLASSES_TARGET_NAME} MODULE ${CYITK_CYTHON_WORKING_DIR}/${CPP_FILE})
    target_link_libraries(${CYITK_IMAGE_CLASSES_TARGET_NAME} ITKCommon ITKIO ${PYTHON_LIBRARY})
    set_target_properties(${CYITK_IMAGE_CLASSES_TARGET_NAME} PROPERTIES PREFIX "" LIBRARY_OUTPUT_DIRECTORY ${CYITK_MODULE_BINARY_DIR} OUTPUT_NAME ${MODULE_NAME})
    file(APPEND ${CYITK_MODULE_BINARY_DIR}/${CYITK_INIT_PY} "from ${MODULE_NAME} import *\n")
  endforeach(CPP_FILE)
  
  foreach(CPP_FILE ${CYITK_SRCS})
    string(REGEX REPLACE ".cpp$" "" MODULE_NAME ${CPP_FILE})
    add_library(${MODULE_NAME} MODULE ${CYITK_CYTHON_WORKING_DIR}/${CPP_FILE})
    target_link_libraries(${MODULE_NAME} ITKCommon ITKBasicFilters ITKAlgorithms ITKIO ${PYTHON_LIBRARY} ${CYITK_WRAPPED_LIBRARIES})
    set_target_properties(${MODULE_NAME} PROPERTIES PREFIX "" LIBRARY_OUTPUT_DIRECTORY ${CYITK_MODULE_BINARY_DIR})
    file(APPEND ${CYITK_MODULE_BINARY_DIR}/${CYITK_INIT_PY} "from ${MODULE_NAME} import *\n")
  endforeach(CPP_FILE)
  
  #install
endmacro(cyitk_configure_module)


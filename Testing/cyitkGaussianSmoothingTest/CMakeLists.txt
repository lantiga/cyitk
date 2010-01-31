cmake_minimum_required(VERSION 2.6)
project(CYITK_GAUSSIAN_SMOOTHING_TEST)

find_path(CYITK_SOURCE_DIR cyitkGenerateImageClass.cmake ${CMAKE_CURRENT_SOURCE_DIR}/../../cyitk)

set(CYITK_WRAPPED_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}) 

include(${CYITK_SOURCE_DIR}/cyitkGenerateImageClass.cmake NO_POLICY_SCOPE)
cyitk_generate_image_class("float" 2 F2)
cyitk_generate_image_class("short" 2 S2)
cyitk_generate_image_class("double" 3 D3)

include(${CYITK_SOURCE_DIR}/cyitkConfigureModule.cmake NO_POLICY_SCOPE)
cyitk_configure_module(cyitkGaussianSmoothingTest cyitkGaussianSmoothingTest.pyx)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/test.py ${CMAKE_CURRENT_BINARY_DIR}/test.py COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input.nrrd ${CMAKE_CURRENT_BINARY_DIR}/input.nrrd COPYONLY)

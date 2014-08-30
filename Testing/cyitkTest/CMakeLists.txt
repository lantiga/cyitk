cmake_minimum_required(VERSION 2.6)
project(CYITK_TEST)

find_path(CYITK_SOURCE_DIR cyitkGenerateImageClass.cmake ${CMAKE_CURRENT_SOURCE_DIR}/../../cyitk)

include(${CYITK_SOURCE_DIR}/cyitkGenerateImageClass.cmake NO_POLICY_SCOPE)
cyitk_generate_image_class("float" 2 F F2)
cyitk_generate_image_class("short" 2 F S2)
cyitk_generate_image_class("unsigned short" 2 C US2)
cyitk_generate_image_class("double" 2 C D2)
cyitk_generate_image_class("double" 3 C D3)

include(${CYITK_SOURCE_DIR}/cyitkConfigureModule.cmake NO_POLICY_SCOPE)
cyitk_configure_module(cyitkTest "")


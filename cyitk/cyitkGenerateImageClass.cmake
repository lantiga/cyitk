cmake_minimum_required(VERSION 2.6)

#generate files for image templates
set(CYITK_GENERATED_IMAGE_PYX_SRCS)
set(CYITK_GENERATED_IMAGE_PXD_SRCS)

macro(cyitk_generate_image_class pixel_type dimension array_order suffix)
  set(CYITK_PIXEL_TYPE ${pixel_type})
  set(CYITK_ARRAY_ORDER ${array_order})
  set(CYITK_DIMENSION ${dimension})
  set(CYITK_TEMPLATE_SUFFIX ${suffix})
  configure_file(${CYITK_SOURCE_DIR}/cyitkImageT.pyx.in ${CMAKE_CURRENT_BINARY_DIR}/cyitkImage${CYITK_TEMPLATE_SUFFIX}.pyx)
  configure_file(${CYITK_SOURCE_DIR}/cyitkImageT.pxd.in ${CMAKE_CURRENT_BINARY_DIR}/cyitkImage${CYITK_TEMPLATE_SUFFIX}.pxd)
  set(CYITK_GENERATED_IMAGE_PYX_SRCS ${CYITK_GENERATED_IMAGE_PYX_SRCS} cyitkImage${CYITK_TEMPLATE_SUFFIX}.pyx)
  set(CYITK_GENERATED_IMAGE_PXD_SRCS ${CYITK_GENERATED_IMAGE_PXD_SRCS} cyitkImage${CYITK_TEMPLATE_SUFFIX}.pxd)
endmacro(cyitk_generate_image_class)


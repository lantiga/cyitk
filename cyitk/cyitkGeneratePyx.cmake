cmake_minimum_required(VERSION 2.6)

macro(cyitk_generate_pyx source_file pyx_file)
  execute_process(
    COMMAND
    ${PYTHON_EXECUTABLE} ${CYITK_SOURCE_DIR}/cyitkGeneratePyx.py ${source_file}
    OUTPUT_VARIABLE CYITK_PYX_CONTENT
    )
  file(WRITE ${pyx_file} ${CYITK_PYX_CONTENT})
endmacro(cyitk_generate_pyx)

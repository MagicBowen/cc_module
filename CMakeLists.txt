cmake_minimum_required(VERSION 3.14)

project(cc_module VERSION 1.0)

include(cmake/cc_module.cmake)

cc_module(
    NAME      infra
    TYPE      INTERFACE
    PUBLIC    ${PROJECT_SOURCE_DIR}/include/infra
)

cc_module(
    NAME      domain
    TYPE      STATIC
    FOLDER    ${PROJECT_SOURCE_DIR}/src/domain
    PUBLIC    ${PROJECT_SOURCE_DIR}/include/domain
    PROTECTED ${PROJECT_SOURCE_DIR}/src/domain
    PRIVATE   ${PROJECT_SOURCE_DIR}/src/domain/pri
    DEPENDS   infra
)
    
cc_module(
    NAME      service
    TYPE      SHARED
    FOLDER    ${PROJECT_SOURCE_DIR}/src/service
    PUBLIC    ${PROJECT_SOURCE_DIR}/include/service
    DEPENDS   domain
)
    
cc_module(
    NAME      main
    SOURCE    ${PROJECT_SOURCE_DIR}/src/main.c
    DEPENDS   service
)

# cc_module_dump()

add_executable(cc_module ${main_SOURCE})
target_link_directories(cc_module PRIVATE ${main_INCLUDE})
target_link_libraries(cc_module PRIVATE ${main_DEPENDS})

cmake_minimum_required(VERSION 3.14)

project(cc_module VERSION 1.0)

include(cmake/cc_module.cmake)

cc_module(
    NAME      infra
    PUBLIC    ${PROJECT_SOURCE_DIR}/include/infra
    ENABLE_TARGET
)

cc_module(
    NAME      domain
    TYPE      STATIC
    FOLDER    ${PROJECT_SOURCE_DIR}/src/domain
    PUBLIC    ${PROJECT_SOURCE_DIR}/include/domain
    PROTECTED ${PROJECT_SOURCE_DIR}/src/domain
    PRIVATE   ${PROJECT_SOURCE_DIR}/src/domain/pri
    DEPENDS   infra
    ENABLE_TARGET
)
    
cc_module(
    NAME      service
    TYPE      SHARED
    FOLDER    ${PROJECT_SOURCE_DIR}/src/service
    PUBLIC    ${PROJECT_SOURCE_DIR}/include/service
    DEPENDS   domain  
    ENABLE_TARGET
)
    
cc_module(
    NAME      main
    TYPE      EXECUTABLE
    SOURCE    ${PROJECT_SOURCE_DIR}/src/main.c
    DEPENDS   service
)

add_executable(main ${main_SOURCE})
target_link_directories(main PRIVATE ${main_INCLUDE})
target_link_libraries(main PRIVATE ${main_DEPENDS})

cc_module_dump()
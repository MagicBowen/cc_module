# cc_module

Define module by CMake.

Usage:

```cmake
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
    ENABLE_TARGET
)
```

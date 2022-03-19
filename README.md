# cc_module

Define module by CMake.

Usage：

```cmake
cc_module(
    NAME name
    [TYPE <SOURCE|INTERFACE|OBJECT|STATIC|SHARED|EXECUTABLE>]
    [FOLDER <source folder>]
    [SOURCE <source file>...]...
    [PUBLIC <public include path>...]...
    [PROTECTED <protected include path>...]...
    [PRIVATE <private include path>...]...
    [DEPENDS <dependent module>...]...
    [FINAL_DEPENDS <final dependent module>...]...
```

Example:

```cmake
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
```

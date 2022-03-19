add_subdirectory(infra)
add_subdirectory(domain)
add_subdirectory(service)

cc_module(
    NAME      cc_module_demo2
    TYPE      EXECUTABLE
    SOURCE    ${PROJECT_SOURCE_DIR}/src/main.c
    DEPENDS   service
)

cc_module(
    NAME      domain
    TYPE      STATIC
    FOLDER    ${CMAKE_CURRENT_SOURCE_DIR}
    PUBLIC    ${PROJECT_SOURCE_DIR}/include/domain
    PROTECTED ${PROJECT_SOURCE_DIR}/src/domain
    PRIVATE   ${PROJECT_SOURCE_DIR}/src/domain/pri
    DEPENDS   infra
)
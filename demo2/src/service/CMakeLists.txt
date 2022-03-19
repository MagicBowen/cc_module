cc_module(
    NAME      service
    TYPE      SHARED
    FOLDER    ${CMAKE_CURRENT_SOURCE_DIR}
    PUBLIC    ${PROJECT_SOURCE_DIR}/include/service
    DEPENDS   domain
)

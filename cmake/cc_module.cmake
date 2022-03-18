include(CMakeParseArguments)

function(cc_module)
    set(opts
        ENABLE_TARGET
    )
    set(single_args 
        NAME
        FOLDER
        TYPE       # STATIC|SHARED|OBJECT|INTERFACE|EXECUTABLE
    )
    set(multi_args
        SOURCE
        PUBLIC
        PROTECTED
        PRIVATE
        DEPENDS
        FINAL_DEPENDS   
    )

    cmake_parse_arguments(MODULE "${opts}" "${single_args}" "${multi_args}" ${ARGN})

    if(CC_BINARY_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "unknown keywords given to cc_binary(): \"${CC_BINARY_UNPARSED_ARGUMENTS}\"")
        return()
    endif()

    get_property(module_list GLOBAL PROPERTY module_list_property)

    list(FIND module_list ${MODULE_NAME} module_index)
    if(NOT module_index EQUAL -1)
        message(FATAL_ERROR "duplicated create module: \"${MODULE_NAME}\"")
        return()
    endif()

    set(MODULE_ALL_PUBLIC     ${MODULE_PUBLIC})
    set(MODULE_ALL_PROTECTED  ${MODULE_PROTECTED})
    set(MODULE_ALL_INCLUDES   ${MODULE_PRIVATE})
    set(MODULE_ALL_DEPENDS    ${MODULE_DEPENDS} ${MODULE_FINAL_DEPENDS})

    foreach(module_dep IN LISTS MODULE_DEPENDS)
        list(FIND module_list ${module_dep} module_index)
        if(module_index EQUAL -1)
            message(FATAL_ERROR "dependent module has not found: \"${module_dep}\"")
            return()        
        endif()
        set(MODULE_ALL_PUBLIC    ${MODULE_ALL_PUBLIC}    ${${module_dep}_PUBLIC})
        set(MODULE_ALL_PROTECTED ${MODULE_ALL_PROTECTED} ${${module_dep}_PROTECTED})
    endforeach()
    
    set(MODULE_ALL_INCLUDES ${MODULE_ALL_INCLUDES} ${MODULE_ALL_PUBLIC} ${MODULE_ALL_PROTECTED})

    foreach(module_final_dep IN LISTS MODULE_FINAL_DEPENDS)
        list(FIND module_list ${module_final_dep} module_index)
        if(module_index EQUAL -1)
            message(FATAL_ERROR "final dependent module has not found: \"${module_final_dep}\"")
            return()        
        endif()    
        set(MODULE_ALL_INCLUDES ${MODULE_ALL_INCLUDES} ${${module_final_dep}_INCLUDE})
    endforeach()

    if(MODULE_FOLDER)
        file(GLOB_RECURSE MODULE_ALL_SOURCES CONFIGURE_DEPENDS
            ${MODULE_FOLDER}/*.c
            ${MODULE_FOLDER}/*.C
            ${MODULE_FOLDER}/*.cc
            ${MODULE_FOLDER}/*.cpp
        )
    endif()
    set(MODULE_ALL_SOURCES ${MODULE_ALL_SOURCES} ${MODULE_SOURCE})

    set(${MODULE_NAME}_SOURCE     ${MODULE_ALL_SOURCES}   PARENT_SCOPE)
    set(${MODULE_NAME}_INCLUDE    ${MODULE_ALL_INCLUDES}  PARENT_SCOPE)
    set(${MODULE_NAME}_PUBLIC     ${MODULE_ALL_PUBLIC}    PARENT_SCOPE)
    set(${MODULE_NAME}_PROTECTED  ${MODULE_ALL_PROTECTED} PARENT_SCOPE)
    set(${MODULE_NAME}_DEPENDS    ${MODULE_ALL_DEPENDS}   PARENT_SCOPE)

    set(module_list ${module_list} ${MODULE_NAME})
    set_property(GLOBAL PROPERTY module_list_property ${module_list})

    if(MODULE_ENABLE_TARGET)
        if((MODULE_TYPE STREQUAL "INTERFACE") OR (NOT MODULE_ALL_SOURCES))
            add_library(${MODULE_NAME} INTERFACE)
            target_include_directories(${MODULE_NAME} INTERFACE ${MODULE_ALL_INCLUDES})
        else()
            if(MODULE_TYPE STREQUAL "EXECUTABLE")
                add_executable(${MODULE_NAME} ${MODULE_ALL_SOURCES})
            else()
                add_library(${MODULE_NAME} ${MODULE_TYPE} ${MODULE_ALL_SOURCES})
            endif()
            target_include_directories(${MODULE_NAME} PUBLIC ${MODULE_ALL_PUBLIC} PRIVATE ${MODULE_ALL_INCLUDES})
        endif()
        target_link_libraries(${MODULE_NAME} PUBLIC ${MODULE_DEPENDS} PRIVATE ${MODULE_FINAL_DEPENDS})
    endif()
endfunction()


function(cc_module_dump)
    get_property(module_list GLOBAL PROPERTY module_list_property)
    foreach(module IN LISTS module_list)
        set(module_source    ${${module}_SOURCE})
        set(module_include   ${${module}_INCLUDE})
        set(module_public    ${${module}_PUBLIC})
        set(module_protected ${${module}_PROTECTED})
        set(module_depends   ${${module}_DEPENDS})

        message(STATUS "--------------------------------------")
        message(STATUS "Module    : ${module}")
        message(STATUS "Source    : ${module_source}")
        message(STATUS "Public    : ${module_public}")
        message(STATUS "Protected : ${module_protected}")
        message(STATUS "Include   : ${module_include}")
        message(STATUS "Depends   : ${module_depends}")
        message(STATUS "--------------------------------------")
    endforeach()
endfunction()
#
# - Test CXX compiler for a flag
# Check if the CXX compiler accepts a flag
#
# itkCHECK_CXX_ACCEPTS_FLAGS(FLAGS VAR)
# - macro which checks if the code compiles with the given flags
#  FLAGS - cxx flags to try
#  VAR   - variable to store whether compiler accepts the FLAGS (TRUE or FALSE)
#
MACRO(itkCHECK_CXX_ACCEPTS_FLAGS FLAGS VAR)
    #
    # If this file changed since CMakeOutput.log changed rerun the macro
    #
    SET(FORCE_RUN FALSE)
    IF(${CMAKE_SOURCE_DIR}/CMake/itkCheckCXXAcceptsFlags.cmake IS_NEWER_THAN ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log)
      SET(FORCE_RUN TRUE)
    ENDIF(${CMAKE_SOURCE_DIR}/CMake/itkCheckCXXAcceptsFlags.cmake IS_NEWER_THAN ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log)
    IF(NOT DEFINED ${VAR} OR FORCE_RUN)
    SET(_SOURCE "int main() { return 0;}\n")
    FILE(WRITE "${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/src.cxx"
      "${_SOURCE}")

    MESSAGE(STATUS "Checking to see if CXX compiler accepts flag ${FLAGS}")
    TRY_COMPILE(${VAR}
      ${CMAKE_BINARY_DIR}
      ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/src.cxx
      CMAKE_FLAGS -DCOMPILE_DEFINITIONS:STRING=${FLAGS}
      OUTPUT_VARIABLE OUTPUT)
    IF(${VAR})
      SET(${VAR} TRUE CACHE INTERNAL "CXX compiler accepts flag ${FLAGS}")
    ELSE(${VAR})
      SET(${VAR} FALSE CACHE INTERNAL "CXX compiler accepts flag ${FLAGS}")
    ENDIF(${VAR})

   SET(_UNKNOWN_FLAG_MSGS
     "ignoring unknown option"
     "unrecognized option"
     "Incorrect command line option"
   )
   FOREACH(MSG ${_UNKNOWN_FLAG_MSGS})
     STRING(REGEX MATCH "${MSG}" _FOUNDIT "${OUTPUT}")
     IF("${_FOUNDIT}" MATCHES "${MSG}")
       SET(${VAR} FALSE CACHE INTERNAL "CXX compiler accepts flag ${FLAGS}")
     ENDIF("${_FOUNDIT}" MATCHES "${MSG}")
   ENDFOREACH(MSG ${_UNKNOWN_FLAG_MSGS})

   IF(${VAR})
     MESSAGE(STATUS "Checking to see if CXX compiler accepts flag ${FLAGS} - Yes")
     FILE(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log 
       "Determining if the CXX compiler accepts the flag ${FLAGS} passed with "
       "the following output:\n${OUTPUT}\n"
       "Source file was:\n${_SOURCE}\n")
   ELSE(${VAR})
     MESSAGE(STATUS "Checking to see if CXX compiler accepts flag ${FLAGS} - No")
     FILE(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log 
       "Determining if the CXX compiler accepts the flag ${FLAGS} passed with "
       "the following output:\n${OUTPUT}\n"
       "Source file was:\n${_SOURCE}\n")
   ENDIF(${VAR})

   ENDIF(NOT DEFINED ${VAR} OR FORCE_RUN)
ENDMACRO(itkCHECK_CXX_ACCEPTS_FLAGS)

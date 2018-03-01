project (PGSLibTestMaster)

include_directories (${PGSLib_MODULE_DIR})

set (MOD_SOURCE_FILES
        test-redux.F90
        test-bcast.F90
        test-dist.F90
        test-collate.F90
        error_tests.F90)

set (MAIN_SOURCE_FILE
        master-test.F90)

# Add module library
add_library (testmaster ${MOD_SOURCE_FILES})
target_link_libraries (testmaster pgslib_fe pgslib_fe_c)

# MPI
if (ENABLE_MPI)
  add_executable (master-test ${MAIN_SOURCE_FILE})
  target_link_libraries (master-test testmaster pgslib_fe pgslib_fe_c pgslib_mpi)
  add_test (master-mpi
           ${PGSLib_PARALLEL_SCRIPT} master-test)
endif ()

# Serial
add_executable (master-test-serial ${MAIN_SOURCE_FILE})
target_link_libraries (master-test-serial testmaster pgslib_fe pgslib_fe_c pgslib_serial)
add_test (master-serial
         ${PGSLib_SERIAL_SCRIPT} master-test-serial)

project (PGSLibAssembly)

set (MOD_SOURCE_FILES
        test_scan.F90
        test_sort.F90)

set (MAIN_SOURCE_FILE
        test-assembly.F90)

# Add module library
add_library (testassem ${MOD_SOURCE_FILES})
target_link_libraries (testassem pgslib_fe pgslib_fe_c)

# MPI
if (ENABLE_MPI)
  add_executable (test-assembly ${MAIN_SOURCE_FILE})
  target_link_libraries (test-assembly testassem pgslib_fe pgslib_fe_c pgslib_mpi)
  add_test (assembly-mpi
           ${PGSLib_PARALLEL_SCRIPT} test-assembly)
endif ()

# Serial
add_executable (test-assembly-serial ${MAIN_SOURCE_FILE})
target_link_libraries (test-assembly-serial testassem pgslib_fe pgslib_fe_c pgslib_serial)
add_test (assembly-serial
         ${PGSLib_SERIAL_SCRIPT} test-assembly-serial)

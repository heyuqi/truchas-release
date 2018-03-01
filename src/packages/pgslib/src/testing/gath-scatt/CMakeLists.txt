project (PGSLibTestGS)

set (MOD_SOURCE_FILES
      gather_test.F90
      scatter_test.F90
      test_globals_module.F90
      test_scatter_module.F90
      test_gather_module.F90
      test_gs_setup_module.F90
      test_gs_parallel_module.F90)

# Add a module library
add_library (testgs ${MOD_SOURCE_FILES})
target_link_libraries (testgs pgslib_fe pgslib_fe_c)

# MAIN (program) source file
set (MAIN_SOURCE_FILE test-gs.F90)

# MPI
if (ENABLE_MPI)
  add_executable (test-gs ${MAIN_SOURCE_FILE})
  target_link_libraries (test-gs testgs pgslib_fe pgslib_fe_c pgslib_mpi)
  add_test (gath-scatt-mpi
           ${PGSLib_PARALLEL_SCRIPT} test-gs)
endif ()

# Serial
add_executable (test-gs-serial ${MAIN_SOURCE_FILE})
target_link_libraries (test-gs-serial testgs pgslib_fe pgslib_fe_c pgslib_serial)
add_test (gath-scatt-serial
         ${PGSLib_SERIAL_SCRIPT} test-gs-serial)

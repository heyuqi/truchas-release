project (PGSLibTestGSPerf)

set (MOD_SOURCE_FILES
        perf_types.F90
        gather_perf_measure.F90)

set (MAIN_SOURCE_FILE
        gs-perf.F90)

# Add a test library
add_library (testgsperf ${MOD_SOURCE_FILES})
target_link_libraries (testgsperf pgslib_fe pgslib_fe_c)

# MPI
if (ENABLE_MPI)
  add_executable (gs-perf ${MAIN_SOURCE_FILE})
  target_link_libraries (gs-perf testgsperf pgslib_fe pgslib_fe_c pgslib_mpi)
  set (MPI_ARGS ${MPIEXEC_NUMPROC_FLAG} 4 ${PGSLibTestGSPerf_BINARY_DIR}/gs-perf)
  add_test (gs-perf-mpi
           ${MPIEXEC} ${MPI_ARGS})
endif ()

# Serial
add_executable (gs-perf-serial ${MAIN_SOURCE_FILE})
target_link_libraries (gs-perf-serial testgsperf pgslib_fe pgslib_fe_c pgslib_serial)
add_test (gs-perf-serial gs-perf-serial)

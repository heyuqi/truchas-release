project (PGSLibIface)

message (STATUS "Configuring directory interface")

# --- Include directories

# - Pick up the module directory
include_directories (${PGSLib_MODULE_DIR})

# Add the directory that contains the generated
# FortranCInterface_names.h file
include_directories (${PGSLib_FCIface_INCLUDE_DIR})

# --- source files
set (PGSLibIface_C_SOURCE_FILES)
set (PGSLibIface_F_SOURCE_FILES)

# gath-scatt files
set (GS_F_FILES
           gath-scatt/pgslib_gs_comm_module.F
           gath-scatt/pgslib_gs_setup_module.F
           gath-scatt/pgslib_gs_module.F
           gath-scatt/pgslib_gs_util_module.F)

list (APPEND PGSLibIface_F_SOURCE_FILES ${GS_F_FILES})

include_directories (gath-scatt)

# global files
set (GLOB_F_FILES globals/pgslib_globals_module.F globals/pgslib_type_module.F)

list (APPEND PGSLibIface_F_SOURCE_FILES ${GLOB_F_FILES})

# indexing files
set (IDX_F_FILES
            indexing/pgslib_index_gid_module.F
            indexing/pgslib_index_table_module.F
            indexing/pgslib_index_module.F)

list (APPEND PGSLibIface_F_SOURCE_FILES ${IDX_F_FILES})

# io files
set (IO_F_FILES
           io/pgslib_io_bcast_module.F
           io/pgslib_io_dist_module.F
           io/pgslib_io_collate_module.F
           io/pgslib_io_module.F)

list (APPEND PGSLibIface_F_SOURCE_FILES ${IO_F_FILES})

include_directories (io)

# misc files
set (MISC_F_FILES
             misc/pgslib_decomp_module.F
             misc/pgslib_permute_module.F
             misc/pgslib_misc_module.F
             misc/pgslib_shift_module.F)

list (APPEND PGSLibIface_F_SOURCE_FILES ${MISC_F_FILES})

include_directories (misc)

# partition files
set (PART_F_FILES
             partitions/graph_partition_data_types.F
             partitions/partition_constants.F
             partitions/partition_data_types.F
             partitions/partition_module.F)

list (APPEND PGSLibIface_F_SOURCE_FILES ${PART_F_FILES})

# reductions files
set (REDX_F_FILES
             reductions/pgslib_red_minmaxloc_module.F
             reductions/pgslib_red_numeric_module.F
             reductions/pgslib_reductions_module.F)

list (APPEND PGSLibIface_F_SOURCE_FILES ${REDX_F_FILES})

include_directories (reductions)

# scans files
set (SCANS_F_FILES
              scans/pgslib_scan_seg_bit_module.F
              scans/pgslib_scan_seg_module.F
              scans/pgslib_scan_module.F
              scans/pgslib_scan_no_seg_module.F)

list (APPEND PGSLibIface_F_SOURCE_FILES ${SCANS_F_FILES})

include_directories (scans)

# sort files
set (SORT_F_FILES sort/pgslib_grade_module.F  sort/pgslib_sort_module.F)

list (APPEND PGSLibIface_F_SOURCE_FILES ${SORT_F_FILES})

# user files
set (USER_F_FILES
             user/pgslib_scatter_log.F
             user/pgslib_scatter_sum_module.F
             user/pgslib_scatter_minmax.F
             user/pgslib_user_gs_module.F
             user/pgslib_gather_module.F
             user/pgslib_scatter_module.F)

list (APPEND PGSLibIface_F_SOURCE_FILES ${USER_F_FILES})

include_directories (user)

# utility files
set (UTIL_F_FILES
             utility/pgslib_instrument.F
             utility/pgslib_stats.F
             utility/pgslib_error_module.F
             utility/pgslib_misc_utility.F
             utility/pgslib_timing_module.F
             utility/pgslib_init.F
             utility/pgslib_process_info.F
             utility/pgslib_utility_module.F)

list (APPEND PGSLibIface_F_SOURCE_FILES ${UTIL_F_FILES})

include_directories (utility)

# main (module) file
set (MAIN_F_FILES main/pgslib_module.F)

list (APPEND PGSLibIface_F_SOURCE_FILES ${MAIN_F_FILES})


# Additional C source files -- needs the FortranCInterface_names.h file
list (APPEND PGSLibIface_C_SOURCE_FILES utility/get_process_info.c)



# --- Library

# Force the preprocessing to occur before building the library
add_library (pgslib_fe ${PGSLibIface_F_SOURCE_FILES})
set_property (TARGET pgslib_fe PROPERTY Fortran_FORMAT FREE)

add_library (pgslib_fe_c ${PGSLibIface_C_SOURCE_FILES})

# Set the library properties
set_target_properties (pgslib_fe PROPERTIES
                       OUTPUT_NAME       pgslib_fe
                       OUTPUT_NAME_DEBUG pgslib_fe_g
                       LINK_LANGUAGE     Fortran)

set_target_properties (pgslib_fe_c PROPERTIES
                       OUTPUT_NAME       pgslib_fe_c
                       OUTPUT_NAME_DEBUG pgslib_fe_c_g
                       LINK_LANGUAGE     Fortran)

# Define the installation location
install (TARGETS pgslib_fe pgslib_fe_c
         EXPORT  pgslib_fe
         LIBRARY DESTINATION ${PGSLib_LIBRARY_INSTALL_DIR}
         ARCHIVE DESTINATION ${PGSLib_LIBRARY_INSTALL_DIR})

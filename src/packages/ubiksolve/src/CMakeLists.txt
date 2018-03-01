project (UbikSolveSource)

message (STATUS "Configuring directory src")

# --- Include directories

# - Pick up the module directory for UbikSolve and PGSLib
include_directories (${UbikSolve_MODULE_DIR})
if (ENABLE_PGSLib)
  include_directories (${PGSLib_MODULE_DIR})
  include_directories (${PGSLib_INCLUDE_DIRS})
endif ()

# Preprocess flags
include_directories (${UbikSolveSource_SOURCE_DIR})
include_directories (${UbikSolve_SOURCE_DIR}/include)

# --- Define *.F -> *.f90 files
set (UbikSolve_SOURCE_FILES
              BCGS.F
              BCGSTAB.F
              CG.F
              CSC.F
              Convergence.F
              ELL.F
              ErrorFunction.F
              FlushUnit.F
              Full.F
              GMRES.F
              Matrix.F
              Meta.F
              ParallelInfo.F
              ParseArg.F
              Stationary.F
              TFQMR.F
              Ubik.F
              UbikBase.F
              UbikConstants.F
              UbikMatrix.F
              UbikSolve.F
              UbikUtil.F
              UbikVector.F
              Vector.F
              WriteString.F
              control_type.F
              numbers.F
              numbers_complete.F
              types.F
              vector_type.F)

# --- Library

# Define the source files for the library
add_library (ubiksolve ${UbikSolve_SOURCE_FILES})
set_property (TARGET ubiksolve PROPERTY Fortran_FORMAT FREE)

# Add the PGSLib target if needed
if ( ENABLE_PGSLib )
  target_link_libraries (ubiksolve ${PGSLib_LIBRARY})
endif ()

# Set the library properties
set_target_properties (ubiksolve PROPERTIES
                       OUTPUT_NAME       UbikSolve
                       OUTPUT_NAME_DEBUG UbikSolve_g)

set_target_properties (ubiksolve PROPERTIES
                       LINK_LANGUAGE     Fortran)

# Define the installation location
install (TARGETS ubiksolve
         EXPORT  ubiksolve
         LIBRARY DESTINATION ${UbikSolve_LIBRARY_INSTALL_DIR}
         ARCHIVE DESTINATION ${UbikSolve_LIBRARY_INSTALL_DIR})

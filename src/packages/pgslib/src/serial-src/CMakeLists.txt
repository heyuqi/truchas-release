project (PGSLibSerial)

message (STATUS "Configuring serial-src directory")

include_directories (${PGSLib_MODULE_DIR})

# --- Define source files for the library
set (PGSLibSerial_SOURCE_FILES
                     gath-scatt/gs-f.F
                     indexing/index-f.F
                     io/input-f.F
                     reductions/redux-f.F
                     scans/scan-f.F
                     utility/utility-f.F)

include_directories (scans)

# --- Define the library target
add_library (pgslib_serial ${PGSLibSerial_SOURCE_FILES})
set_property (TARGET pgslib_serial PROPERTY Fortran_FORMAT FREE)

# Change name if Debug build
set_target_properties (pgslib_serial PROPERTIES
                       OUTPUT_NAME       pgslib-ser
                       OUTPUT_NAME_DEBUG pgslib-ser_g)

set_target_properties (pgslib_serial PROPERTIES
                       LINKER_LANGUAGE   Fortran)


# Define the installation location
install (TARGETS pgslib_serial
         EXPORT  pgslib_serial
         LIBRARY DESTINATION ${PGSLib_LIBRARY_INSTALL_DIR}
         ARCHIVE DESTINATION ${PGSLib_LIBRARY_INSTALL_DIR})

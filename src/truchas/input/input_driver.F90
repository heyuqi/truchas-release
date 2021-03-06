!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!
!! Copyright (c) Los Alamos National Security, LLC.  This file is part of the
!! Truchas code (LA-CC-15-097) and is subject to the revised BSD license terms
!! in the LICENSE file found in the top-level directory of this distribution.
!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

module input_driver
  !=======================================================================
  ! Purpose:
  !
  !   driver routine that reads the input file
  !
  ! Contains: READ_INPUT
  !
  ! Author(s): Douglas B. Kothe (dbk@lanl.gov)
  !            Bryan Lally (lally@lanl.gov)
  !
  !=======================================================================
  implicit none
  private

  public :: read_input

contains

  subroutine read_input (infile, title)
    !=======================================================================
    ! Purpose:
    !
    !   driver for reading input file
    !=======================================================================
    use probe_input_module,        only: probe_input  
    use bc_input_module,           only: bc_input
    use EM_input,                  only: read_em_input
    use interfaces_input_module,   only: interfaces_input
    use material_input_module,     only: material_input, material_sizes
    use nonlin_solver_input,       only: nonlinear_solver_input
    use numerics_input_module,     only: numerics_input
    use outputs_input_module,      only: outputs_input
    use parallel_info_module,      only: p_info
    use pgslib_module,             only: pgslib_bcast
    use physics_input_module,      only: physics_input
    use restart_variables,         only: restart, read_restart_namelist
    use restart_driver,            only: open_restart_file
    use lin_solver_input,          only: linear_solver_input
    use EM_data_proxy,             only: em_is_on
    use region_input_module,       only: region_read
    use mesh_manager,              only: read_truchas_mesh_namelists
    use diffusion_solver_data,     only: ds_enabled, heat_eqn
    use diffusion_solver,          only: read_ds_namelists
    use ustruc_driver,             only: read_microstructure_namelist
    use physical_constants,        only: read_physical_constants
    use function_namelist,         only: read_function_namelists
    use phase_namelist,            only: read_phase_namelists
    use material_system_namelist,  only: read_material_system_namelists
    use surface_tension_module,    only: surface_tension, read_surface_tension_namelist
    use fluid_data_module,         only: fluid_flow
    use viscous_data_module,       only: inviscid
    use turbulence_module,         only: read_turbulence_namelist
    use solid_mechanics_input,     only: solid_mechanics
    use viscoplastic_model_namelist, only: read_viscoplastic_model_namelists
    use simulation_event_queue,    only: read_simulation_control_namelist
    use toolpath_namelist,         only: read_toolpath_namelists
    use ded_head_namelist,         only: read_ded_head_namelist
    use physics_module,            only: heat_transport
    use truchas_logging_services
    use truchas_timers
    use string_utilities, only: i_to_c

    character(*), intent(in)  :: infile
    character(*), intent(out) :: title

    integer :: ios, lun

    call start_timer ('Input')
    call TLS_info ('Opening input file ' // trim(infile) // ' ...')

    ! open input file
    if (p_info%IOP) then
      open(newunit=lun,file=trim(infile),status='old',position='rewind',action='read',iostat=ios)
    else
      lun = -1
    end if
    call pgslib_bcast (ios)
    if (ios /= 0) call TLS_fatal ('error opening input file: iostat=' // i_to_c(ios))

    ! read first line as title information
    if (p_info%IOP) read(lun,'(a)',iostat=ios) title
    call pgslib_bcast (ios)
    if (ios /= 0) call TLS_fatal ('error reading initial title line: iostat=' // i_to_c(ios))
    call pgslib_bcast (title)

    call read_physical_constants (lun)
    call read_function_namelists (lun)
    call read_toolpath_namelists (lun)
    call read_phase_namelists (lun)
    call read_material_system_namelists (lun)

    ! read current physics data
    call physics_input (lun)

    ! read output specifications
    call outputs_input (lun)
    
    call read_simulation_control_namelist (lun)

    if (restart) then
      call read_restart_namelist (lun)
      call open_restart_file () ! NB: reads ncells and nnodes used later by mesh_sizes.
      call region_read (lun) ! What is this and what does it have to do with restarts? (NNC)
    end if

    ! Read the MESH and ALTMESH namelists: used to initialize MESH_MANAGER (new mesh)
    call read_truchas_mesh_namelists (lun)

    ! read materials data and set dimensions
    call material_input (lun)
    call material_sizes ()

    ! read namelists for flow options and enable new mesh
    if (fluid_flow) then
      if (.not.inviscid)   call read_turbulence_namelist (lun)
      if (surface_tension) call read_surface_tension_namelist (lun)
    end if
    
    ! read namelists for solid mechanics options
    if (solid_mechanics) then
      call read_viscoplastic_model_namelists (lun)
    end if

    ! read volume fraction data
    call interfaces_input (lun)

    ! read linear solution input
    call linear_solver_input (lun)

    ! read nonlinear solution input
    call nonlinear_solver_input (lun)

    ! read numerical options data
    call numerics_input (lun)

    ! read bc specifications
    call bc_input (lun)

    ! Read Electromagnetics
    if (em_is_on()) call read_em_input (lun)

    ! Read diffusion solver namelists
    if (ds_enabled) then
      if (heat_transport) call read_ded_head_namelist (lun)
      call read_ds_namelists (lun)
      if (heat_eqn) call read_microstructure_namelist (lun)
    end if

    ! read probe information
    call probe_input (lun)

    if (p_info%IOP) close(lun)

    call TLS_info ('')
    call TLS_info ('Input file ' // trim(infile) // ' closed.')
    call stop_timer('Input')

  end subroutine read_input

end module input_driver

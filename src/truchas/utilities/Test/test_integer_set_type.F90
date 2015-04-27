!!
!! Neil N. Carlson <nnc@lanl.gov> March 2015
!!

program test_integer_set_type

#ifdef NAGFOR
  use,intrinsic :: f90_unix, only: exit
#endif
  use integer_set_type!, only: integer_set => iset
  implicit none

  integer :: stat = 0

  call test_add
  call test_to_array
  call test_copy_to_array
  call test_elemental

  call exit (stat)

contains

  subroutine test_add

    type(integer_set) :: A

    if (.not.A%is_empty()) call write_fail ('test_add: set is not empty')
    if (A%size() /= 0) call write_fail ('test_add: size not 0')

    call A%add (3)  ! first element
    if (A%is_empty()) call write_fail ('test_add: set is empty')
    if (A%size() /= 1) call write_fail ('test_add: size not 1')

    call A%add (2)  ! insert at the beginning
    if (A%is_empty()) call write_fail ('test_add: set is empty')
    if (A%size() /= 2) call write_fail ('test_add: size not 2')

    call A%add (5)  ! insert at the end
    if (A%size() /= 3) call write_fail ('test_add: size not 3')

    call A%add (4)  ! insert in the middle
    if (A%size() /= 4) call write_fail ('test_add: size not 4')

    call A%add (4)  ! insert duplicate
    if (A%size() /= 4) call write_fail ('test_add: size not 4')

  end subroutine test_add


  subroutine test_to_array

    type(integer_set) :: a
    integer, allocatable :: b(:)

    !! Assignment to unallocated array
    call a%add (1)
    call a%add (2)
    call a%add (3)
    b = a
    if (size(b) /= 3) then
      call write_fail ('test_to_array: unallocated, wrong size')
    else
      if (any(b /= [1, 2, 3])) call write_fail ('test_to_array: unallocated, wrong values')
    end if

    !! Assignment to allocated array with wrong size
    call a%add (0)
    b = a
    if (size(b) /= 4) then
      call write_fail ('test_to_array: reallocated, wrong size')
    else
      if (any(b /= [0, 1, 2, 3])) call write_fail ('test_to_array: reallocated, wrong values')
    end if

    !! Assignment to allocated array with right size
    b = -1  ! overwrite with wrong values
    b = a
    if (size(b) /= 4) then
      call write_fail ('test_to_array: allocated, wrong size')
    else
      if (any(b /= [0, 1, 2, 3])) call write_fail ('test_to_array: allocated, wrong values')
    end if

  end subroutine test_to_array


  subroutine test_copy_to_array

    type(integer_set) :: a
    integer :: b(3) = -1

    !! Assignment to unallocated array
    call a%add (1)
    call a%add (2)
    call a%copy_to_array (b)
    if (any(b /= [1, 2, -1])) call write_fail ('test_copy_to_array: wrong values')

  end subroutine test_copy_to_array


  subroutine test_elemental

    type(integer_set) :: A(2)
    integer, allocatable :: array(:)

    if (any(.not.A%is_empty())) call write_fail ('test_elemental: not empty')
    call A%add (1)
    call A%add ([2,3])

    if (any(A%is_empty())) call write_fail ('test_elemental: empty')
    if (any(A%size() /= [2,2])) call write_fail ('test_elemental: wrong sizes')

    array = A(1)
    if (any(array /= [1,2])) call write_fail ('test_elemental: wrong values set 1')

    array = A(2)
    if (any(array /= [1,3])) call write_fail ('test_elemental: wrong values set 2')

  end subroutine test_elemental


  subroutine write_fail (errmsg)
    use,intrinsic :: iso_fortran_env, only: error_unit
    character(*), intent(in) :: errmsg
    stat = 1
    write(error_unit,'(a)') errmsg
  end subroutine

end program test_integer_set_type
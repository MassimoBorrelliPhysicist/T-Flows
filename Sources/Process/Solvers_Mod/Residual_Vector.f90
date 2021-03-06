!==============================================================================!
  subroutine Residual_Vector(ni, mat_a, x, r) 
!------------------------------------------------------------------------------!
!   Calculates residual vector.                                                !
!------------------------------------------------------------------------------!
!----------------------------------[Modules]-----------------------------------!
  use Comm_Mod
  use Matrix_Mod
!------------------------------------------------------------------------------!
  implicit none
!---------------------------------[Arguments]----------------------------------!
  integer           :: ni          ! number of cells inside (i)
  type(Matrix_Type) :: mat_a
  real              :: x(:), r(:)  !  [A]{x}={r}
!-----------------------------------[Locals]-----------------------------------!
  integer  :: i, j, k, sub
!==============================================================================!

  !----------------!
  !   r = b - Ax   !
  !----------------!
  ! Why not callig this: call exchange(x) ???
  do i = 1, ni
    do j = mat_a % row(i), mat_a % row(i+1) - 1
      k = mat_a % col(j)
      r(i) = r(i) - mat_a % val(j) * x(k)
    end do
  end do

  end subroutine

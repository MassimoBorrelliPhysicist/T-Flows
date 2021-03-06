!==============================================================================!
  subroutine Control_Mod_Reference_Temperature(verbose)
!------------------------------------------------------------------------------!
!----------------------------------[Modules]-----------------------------------!
  use Flow_Mod, only: t_ref
!------------------------------------------------------------------------------!
  implicit none
!---------------------------------[Arguments]----------------------------------!
  logical, optional :: verbose
!-----------------------------------[Locals]-----------------------------------!
  real :: def
!==============================================================================!

  def = 20.0

  call Control_Mod_Read_Real_Item('REFERENCE_TEMPERATURE', def,  &
                                   t_ref, verbose)

  end subroutine

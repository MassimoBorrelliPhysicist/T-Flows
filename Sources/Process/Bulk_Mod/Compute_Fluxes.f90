!==============================================================================!
  subroutine Bulk_Mod_Compute_Fluxes(grid, bulk, flux)
!------------------------------------------------------------------------------!
!   Compute mass fluxes through whole domain.                                  !
!------------------------------------------------------------------------------!
!----------------------------------[Modules]-----------------------------------!
  use Const_Mod
  use Grid_Mod
  use Comm_Mod
  use Bnd_Cond_Mod
!------------------------------------------------------------------------------!
  implicit none
!---------------------------------[Arguments]----------------------------------!
  type(Grid_Type)    :: grid
  type(Bulk_Type)    :: bulk
  real, dimension(:) :: flux
!-----------------------------------[Locals]-----------------------------------!
  integer :: c1, c2, s
  real    :: xc1, yc1, zc1, xc2, yc2, zc2
!==============================================================================!

  bulk % flux_x = 0.0
  bulk % flux_y = 0.0
  bulk % flux_z = 0.0

  do s = 1, grid % n_faces
    c1 = grid % faces_c(1,s)
    c2 = grid % faces_c(2,s)
    if(c2 > 0) then
      xc1 = grid % xc(c1) 
      yc1 = grid % yc(c1) 
      zc1 = grid % zc(c1) 
      xc2 = grid % xc(c1) + grid % dx(s) 
      yc2 = grid % yc(c1) + grid % dy(s) 
      zc2 = grid % zc(c1) + grid % dz(s)

      if((xc1 <= bulk % xp).and.(xc2 > bulk % xp))  &
        bulk % flux_x = bulk % flux_x + flux(s)

      if((yc1 <= bulk % yp).and.(yc2 > bulk % yp))  &
        bulk % flux_y = bulk % flux_y + flux(s)

      if((zc1 <= bulk % zp).and.(zc2 > bulk % zp))  &
        bulk % flux_z = bulk % flux_z + flux(s)

      if((xc2 < bulk % xp).and.(xc1 >= bulk % xp))  &
        bulk % flux_x = bulk % flux_x - flux(s)

      if((yc2 < bulk % yp).and.(yc1 >= bulk % yp))  &
        bulk % flux_y = bulk % flux_y - flux(s)

      if((zc2 < bulk % zp).and.(zc1 >= bulk % zp))  &
        bulk % flux_z = bulk % flux_z - flux(s)

    else if(c2 < 0 .and. Grid_Mod_Bnd_Cond_Type(grid, c2) .eq. BUFFER) then
      xc1 = grid % xc(c1) 
      yc1 = grid % yc(c1) 
      zc1 = grid % zc(c1) 
      xc2 = grid % xc(c1) + grid % dx(s) 
      yc2 = grid % yc(c1) + grid % dy(s) 
      zc2 = grid % zc(c1) + grid % dz(s)

      if((xc1 <= bulk % xp).and.(xc2 > bulk % xp))  &
        bulk % flux_x = bulk % flux_x + .5*flux(s)

      if((yc1 <= bulk % yp).and.(yc2 > bulk % yp))  &
        bulk % flux_y = bulk % flux_y + .5*flux(s)

      if((zc1 <= bulk % zp).and.(zc2 > bulk % zp))  &
        bulk % flux_z = bulk % flux_z + .5*flux(s)

      if((xc2 < bulk % xp).and.(xc1 >= bulk % xp))  &
        bulk % flux_x = bulk % flux_x - .5*flux(s)

      if((yc2 < bulk % yp).and.(yc1 >= bulk % yp))  &
        bulk % flux_y = bulk % flux_y - .5*flux(s)

      if((zc2 < bulk % zp).and.(zc1 >= bulk % zp))  &
        bulk % flux_z = bulk % flux_z - .5*flux(s)

    end if   ! c2 > 0
  end do

  call Comm_Mod_Global_Sum_Real(bulk % flux_x)
  call Comm_Mod_Global_Sum_Real(bulk % flux_y)
  call Comm_Mod_Global_Sum_Real(bulk % flux_z)

  bulk % u = bulk % flux_x / (bulk % area_x + TINY)
  bulk % v = bulk % flux_y / (bulk % area_y + TINY)
  bulk % w = bulk % flux_z / (bulk % area_z + TINY)

  end subroutine

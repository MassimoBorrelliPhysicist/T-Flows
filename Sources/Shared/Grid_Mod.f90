!==============================================================================!
  module Grid_Mod
!------------------------------------------------------------------------------!
!   Grids module is used throughout all programs                               !
!   (that means in "Generate", "Divide", "Convert", "Process".                 !
!------------------------------------------------------------------------------!
!----------------------------------[Modules]-----------------------------------!
  use Material_Mod
  use Bnd_Cond_Mod
  use Metis_Options_Mod
  use Sort_Mod
!------------------------------------------------------------------------------!
  implicit none
!==============================================================================!

  !-----------------------------------------!
  !   Maximum number of multi-grid levels   !
  !-----------------------------------------!
  integer, parameter :: MAX_MG_LEV = 8

  !-----------------------!
  !                       !
  !   Coarser grid type   !
  !                       !
  !-----------------------!
  type Coarser_Grid_Type

    ! Number of cells and faces at each level
    integer :: n_cells
    integer :: n_faces

    ! Cell and face numbers from current to coarser levels
    integer, allocatable :: cell(:)
    integer, allocatable :: face(:)

    ! Cell and face at coarser level
    integer, allocatable :: cell_at_coarser(:)
    integer, allocatable :: face_at_coarser(:)

    ! Faces' neigboring (surrounding) cells
    integer, allocatable :: faces_c(:,:)

  end type

  !---------------!
  !               !
  !   Comm type   !
  !               !
  !---------------!
  type Comm_Type    ! only used inside the Grid_Type) 

    integer :: n_buff_cells

    ! Processor i.d. defined for each cell
    integer, allocatable :: proces(:)

    ! These names are ugly but mean number of buffer boundaries start and end
    integer, allocatable :: nbb_s(:), nbb_e(:)

    ! Buffer index
    integer, allocatable :: buffer_index(:)

    ! Global cell numbers
    integer, allocatable :: cell_glo(:)

    ! (kind=4) coud not be avoided here :-(
    integer(kind=4), allocatable :: cell_map(:)
    integer(kind=4), allocatable :: bnd_cell_map(:)
  end type

  !---------------!
  !               !
  !   Grid type   !
  !               !
  !---------------!
  type Grid_Type

    ! Number of ...
    integer :: n_nodes      ! ... nodes
    integer :: n_cells      ! ... cells
    integer :: n_faces      ! ... faces
    integer :: n_bnd_cells  ! ... boundary cells
    integer :: n_per_faces  ! ... periodic faces (shadows)
    integer :: n_bnd_cond   ! ... boundary conditions
    integer :: n_copy       ! ... copy cells and faces
    integer :: n_levels     ! ... multigrid levels

    !-------------------------!
    !  Cell-based variables   !
    !-------------------------!

    ! Cell center coordinates
    real, allocatable :: xc(:), yc(:), zc(:)  

    ! Cell volumes
    real, allocatable :: vol(:)

    ! General cell size (max(dx,dy,dz) or maybe volume/area?)
    real, allocatable :: delta(:)

    ! Wall distance - distance from the nearest wall
    real, allocatable :: wall_dist(:)

    ! True if cell is near wall.  Used in Process for some turblence models.
    logical, allocatable :: cell_near_wall(:)

    ! Cells' nodes and neigboring cells
    integer, allocatable :: cells_n(:,:)
    integer, allocatable :: cells_c(:,:)

    ! Number of nodes at each cell (determines cell's shape really)
    integer, allocatable :: cells_n_nodes(:)

    ! For each cell; type of the boundary condition in a given direction
    integer, allocatable :: cells_bnd_color(:,:)

    ! Coarser levels for the grid
    type(Coarser_Grid_Type) :: level(0:MAX_MG_LEV)

    !-------------------------!
    !  Face-based variables   !
    !-------------------------!

    ! Number of nodes at each face (determines face's shape really)
    integer, allocatable :: faces_n_nodes(:)

    ! Faces' nodes and neigboring cells
    integer, allocatable :: faces_n(:,:)
    integer, allocatable :: faces_c(:,:)

    ! Face surface areas (si), total surface (s) 
    ! and distances between cells (di)
    real, allocatable :: sx(:), sy(:), sz(:), s(:)
    real, allocatable :: dx(:), dy(:), dz(:)

    ! Face coordinates 
    real, allocatable :: xf(:), yf(:), zf(:)

    ! Face weight-factor
    real, allocatable :: f(:)

    !-------------------------!
    !  Node-based variables   !
    !-------------------------!

    ! Node coordinates
    real, allocatable :: xn(:), yn(:), zn(:)

    type(Material_Type) :: material
    type(Bnd_Cond_Type) :: bnd_cond

    !  Maximum number of cells, boundary cells and faces
    ! (Used for tentative memory allocation in Generator)
    integer :: max_n_nodes
    integer :: max_n_bnd_cells
    integer :: max_n_faces

    ! New numbers for nodes, cells and faces
    integer, allocatable :: new_n(:)
    integer, allocatable :: new_c(:)
    integer, allocatable :: new_f(:)

    !------------------------------------------!
    !   Variables important for parallel run   ! 
    !------------------------------------------!
    type(Comm_Type) :: comm

  end type

  contains

  include 'Grid_Mod/Allocate_Cells.f90'
  include 'Grid_Mod/Allocate_Faces.f90'
  include 'Grid_Mod/Allocate_Nodes.f90'
  include 'Grid_Mod/Allocate_New_Numbers.f90'
  include 'Grid_Mod/Bnd_Cond_Type.f90'
  include 'Grid_Mod/Bnd_Cond_Ranges.f90'
  include 'Grid_Mod/Decompose.f90'
  include 'Grid_Mod/Calculate_Wall_Distance.f90'
  include 'Grid_Mod/Estimate_Big_And_Small.f90'
  include 'Grid_Mod/Print_Bnd_Cond_Info.f90'
  include 'Grid_Mod/Sort_Cells_By_Index.f90'
  include 'Grid_Mod/Sort_Faces_By_Index.f90'
  include 'Grid_Mod/Sort_Faces_Smart.f90'

  end module

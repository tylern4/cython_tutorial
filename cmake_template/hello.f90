

SUBROUTINE hello_fortran(number, real_number, total_number)
  IMPLICIT NONE
  INTEGER, INTENT(in)  :: number !input
  REAL, INTENT(in) :: real_number !input
  REAL, INTENT(out) :: total_number ! output

  WRITE(*,*) "Hello from Fortran"
  WRITE(*,*) "You gave me the integer: ", number
  WRITE(*,*) "You gave me the float: ", real_number

  total_number = number + real_number

END SUBROUTINE hello_fortran

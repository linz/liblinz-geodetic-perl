#===============================================================================
# Module:             CartesianCrd.pm
#
# Description:       Defines packages: 
#                      LINZ::Geodetic::CartesianCrd
#
# Dependencies:      Uses the following modules: 
#                      Geodetic
#                      LINZ::Geodetic::Coordinate  
#
#  $Id: CartesianCrd.pm,v 1.3 2006/10/11 23:36:21 gdb Exp $
#
#  $Log: CartesianCrd.pm,v $
#  Revision 1.3  2006/10/11 23:36:21  gdb
#  Fixed properly
#
#  Revision 1.2  2006/10/11 23:31:22  ccrook
#  Fixes identifed by Jeremy
#
#  Revision 1.1  1999/09/09 21:09:36  ccrook
#  Initial revision
#
#
#===============================================================================

use strict;

   
#===============================================================================
#
#   Package:     LINZ::Geodetic::CartesianCrd
#
#   Description: Derived from LINZ::Geodetic::Coordinate, from which the constructor
#                and coordinate conversion functions are derived.
#
#                $xyz = new LINZ::Geodetic::CartesianCrd( $x, $y, $z, $cs, $epoch );
#                $xyz = new LINZ::Geodetic::CartesianCrd( [$x, $y, $z, $cs, $epoch] );
#
#                $x = $xyz->X
#                $y = $xyz->Y
#                $z = $xyz->Z
#
#                $type = $xyz->type 
#
#                $strarray = $xyz->asstring( $ndp );
#
#===============================================================================

package LINZ::Geodetic::CartesianCrd;

require LINZ::Geodetic;
require LINZ::Geodetic::Coordinate;

use vars qw/@ISA/;
@ISA=('LINZ::Geodetic::Coordinate');


sub X { $_[0]->[0]; }

sub Y { $_[0]->[1]; }

sub Z { $_[0]->[2]; }

#===============================================================================
#
#   Subroutine:   type
#
#   Description:   Returns the type of the coordinate - alway
#                  LINZ::Geodetic::CARTESIAN
#                    $type = $xyz->type
#
#   Parameters:    None
#
#   Returns:       The coordinate type
#
#===============================================================================

sub type { return &LINZ::Geodetic::CARTESIAN; }


#===============================================================================
#
#   Subroutine:   asstring
#
#   Description:   Converts each element to a string
#
#   Parameters:    $strarray = $xyz->asstring
#
#   Returns:       Returns a reference to an array of strings 
#
#===============================================================================

sub asstring {
   my ($self, $ndp) = @_;
   
   my ($x, $y, $z );
   if( $self->[0] ne '' && $self->[1] ne '' && $self->[2] ) {
      $ndp = 0 if $ndp < 0;
      $ndp = 6 if $ndp > 6;
      $ndp = "%.".$ndp."f";
      $x = sprintf($ndp,$self->[0]);
      $y = sprintf($ndp,$self->[1]);
      $z = sprintf($ndp,$self->[2]);
      }
   my $result=[ $x, $y, $z ];
   return wantarray ? @$result : $result;
   }
1;

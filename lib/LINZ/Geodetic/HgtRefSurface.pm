#===============================================================================
# Module:             HgtRefSurface.pm
#
# Description:       Defines a basic hgtref object.  This is a blessed
#                    hash reference with elements:
#                       name       The hgtref name
#                       ellipsoid  The ellipsoid object defined for the frame
#                       baseref    The base hgtref
#                       transfunc  A function object for converting coordinates
#                                  to and from the base hgtref.
#
#                    The CoordSys module may install additional entries into
#                    this hash, which are
#                       _csgeod    The geodetic (lat/lon) coordinate system
#                                  for the hgtref
#                       _cscart    The cartesian coordinate system for the
#                                  hgtref
#                       
#                    Defines packages: 
#                      LINZ::Geodetic::HgtRefSurface
#
# Dependencies:      Uses the following modules:   
#
#  $Id: HgtRefSurface.pm,v 1.1 2005/11/27 19:39:30 gdb Exp $
#
#  $Log: HgtRefSurface.pm,v $
#  Revision 1.1  2005/11/27 19:39:30  gdb
#  *** empty log message ***
#
#
#===============================================================================

use strict;

   
#===============================================================================
#
#   Class:       LINZ::Geodetic::HgtRefSurface::Offset
#
#   Description: Defines the offset of a height reference surface
#
#===============================================================================

package LINZ::Geodetic::HgtRefSurface::Offset;

sub new
{
    my($class, $offset)=@_;
    my $self={ offset => $offset };
    return bless $self, $class;
}

sub GeoidHeight
{
    my($self, $crd)=@_;
    return -($self->{offset});
}

# Height in terms of base reference surface
sub EllipsoidalHeight {
  my ($self, $crd, $ohgt ) = @_;
  return $ohgt + $self->GeoidHeight( $crd );
  }

# Height in terms of reference surface
sub OrthometricHeight {
  my ($self, $crd, $ehgt ) = @_;
  return $ehgt - $self->GeoidHeight( $crd );
  }
   
#===============================================================================
#
#   Class:       LINZ::Geodetic::HgtRefSurface
#
#   Description: Defines the following routines:
#                 $hgtref = new LINZ::Geodetic::HgtRefSurface($name, $refcrdsys, $transfunc, $code )
#
#                  $name = $hgtref->name
#
#===============================================================================

package LINZ::Geodetic::HgtRefSurface;

my $id;

#===============================================================================
#
#   Method:       new
#
#   Description:  $hgtref = new LINZ::Geodetic::HgtRefSurface($name, $refcrdsys, $transfunc, $code )
#
#   Parameters:   $name       The name of the hgtref
#                 $refhgtref  The reference surface that this is defined in terms of
#                             (if it is not in terms of the refcrdsys)
#                 $refcrdsys  Reference ellipsoidal coordinate system for
#                             conversions
#                 $transfunc  An object providing functions OrthometricHeight
#                             EllipsoidalHeight, and GeoidHeight, which convert 
#                             base reference system heights to and from the 
#                             height reference system 
#                 $code       Optional code identifying the hgtref
#
#   Returns:      $hgtref   The blessed ref frame hash
#
#===============================================================================

sub new {
  my ($class, $name, $basehgtref, $refcrdsys, $transfunc, $code ) = @_;
  my $self = { name=>$name, 
               basehgtref=>$basehgtref,
               refcrdsys=>$refcrdsys,
               transfunc=>$transfunc,
               code=>$code,
               id=>$id };
  $id++;
  return bless $self, $class;
  }


sub name { return $_[0]->{name} }
sub code { return $_[0]->{code} }
sub basehgtref { return $_[0]->{basehgtref}  }
sub refcrdsys { return $_[0]->{refcrdsys}  }
sub transfunc { return $_[0]->{transfunc} }
sub id { return $_[0]->{id} }

#===============================================================================
#
#   Subroutine:   get_orthometric_height
#
#   Description:   $ohgt = $hcs->get_orthometric_height( $crd )
#
#                  Returns the orthometric height for a given point, given its 
#                  ellipsoidal coordinates
#
#   Parameters:    None
#
#   Returns:       The orthometric height
#
#===============================================================================

sub get_orthometric_height {
   my( $self, $crd ) = @_;
   my $rcrd = $crd->as( $self->refcrdsys );
   my $ohgt=$rcrd->hgt;
   my $hgtref=$self;
   while( $hgtref )
   {
       $ohgt = $hgtref->transfunc->OrthometricHeight( $rcrd, $ohgt );
       $hgtref=$hgtref->basehgtref;
   }
   return $ohgt;
   }

#===============================================================================
#
#   Subroutine:   set_ellipsoidal_height
#
#   Description:   $crd = $hcs->set_ellipsoidal_height( $crd, $ohgt );
#                  Sets the height of a coordinate given its orthometric
#                  height in the height coordinate system
#
#   Parameters:    None
#
#   Returns:       The geocentric coordinate system
#
#===============================================================================

sub set_ellipsoidal_height {
   my( $self, $crd, $ohgt ) = @_;
   my $rcrd = $crd->as( $self->refcrdsys );
   my $hgtref=$self;
   while( $hgtref )
   {
       $ohgt = $hgtref->transfunc->EllipsoidalHeight( $rcrd, $ohgt );
       $hgtref=$hgtref->basehgtref;
   }
   $rcrd->[2] = $ohgt;
   return $rcrd->as( $crd->coordsys );
   }

#===============================================================================
#
#   Subroutine:   convert_orthometric_height
#
#   Description:   $ohgt = $hcs->convert_orthometric_height( $ohgt, $crd, $hcs );
#                  Converts an orthometric height in this height system to a 
#                  different height system
#
#   Parameters:    None
#
#   Returns:       The geocentric coordinate system
#
#===============================================================================

sub convert_orthometric_height_to {
   my( $self, $hrfnew, $crd, $ohgt ) = @_;
   my $rcrd = $self->set_ellipsoidal_height( $crd, $ohgt );
   $ohgt = $hrfnew->get_orthometric_height( $rcrd );
   return $ohgt;
   }

1;

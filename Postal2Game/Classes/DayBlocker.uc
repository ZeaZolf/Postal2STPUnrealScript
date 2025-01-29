///////////////////////////////////////////////////////////////////////////////
// DayBlocker
//
// Uses a static mesh and cylinder collision to block things that are to be
// only used for different days. These are expected to be there for some
// days and not for others.
//
//
// Starts with non/zero extent traces off so path nodes will connect through
// them. Path nodes marked around them will dyanmically set bBlocked so 
// people won't want to walk through them non/zero extent traces will also
// get set to true dynamically if this dayblocker needed for a given day.
//
///////////////////////////////////////////////////////////////////////////////
class DayBlocker extends Prop;


defaultproperties
{
	 bStasis=true
	 bNoDelete=false
     bStatic=false
	 bHidden=false
	 bBlockNonZeroExtentTraces=false
	 bBlockZeroExtentTraces=false
     CollisionRadius=+00160.000000
     CollisionHeight=+00160.000000
	 DrawType=DT_StaticMesh
	 StaticMesh=StaticMesh'Timb_mesh.library.lib_shelves_large'
}

///////////////////////////////////////////////////////////////////////////////
// A mugger or someone is yelling something, so have people spin around
///////////////////////////////////////////////////////////////////////////////
class BadGuyYellMarker extends AuthorityOrderMarker;

defaultproperties
{
	CollisionRadius=1024
	CollisionHeight=500
	Priority=1
	bCreatorIsAttacker=true
}
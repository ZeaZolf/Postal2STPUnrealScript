///////////////////////////////////////////////////////////////////////////////
// A gun (pistol, shotgun, not rockets) has been fired around this.
///////////////////////////////////////////////////////////////////////////////
class GunfireMarker extends TimedMarker;

defaultproperties
{
	CollisionRadius=2048
	CollisionHeight=1024
//	UseLifeMax=4.0
	Priority=4
	bCreatorIsAttacker=true
}
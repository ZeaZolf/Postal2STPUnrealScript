///////////////////////////////////////////////////////////////////////////////
// PistolBulletSplat.
// Bullet hole
///////////////////////////////////////////////////////////////////////////////
class PistolBulletSplat extends Splat;

defaultproperties
{
	MaterialBlendingOp=PB_Modulate
	FrameBufferBlendingOp=PB_AlphaBlend
	ProjTexture=Material'nathans.skins.pistolhitblend'
	DrawScale=0.15
}
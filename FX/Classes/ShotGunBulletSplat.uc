//=============================================================================
// ShotGunBulletSplat.
//=============================================================================
class ShotGunBulletSplat extends Splat;

defaultproperties
	{
	MaterialBlendingOp=PB_Modulate
	FrameBufferBlendingOp=PB_AlphaBlend
	ProjTexture=Material'nathans.skins.shotgunhitblend1'
	Lifetime=1
	DrawScale=0.4
	}

///////////////////////////////////////////////////////////////////////////////
// ShatterBottle.
//
// The first emitter is the falling glass, the second emitter is the glass
// lying on the ground.
///////////////////////////////////////////////////////////////////////////////
class ShatterBottle extends P2Emitter;

defaultproperties
{
    Begin Object Class=SuperSpriteEmitter Name=SuperSpriteEmitter8
		SecondsBeforeInactive=0.0
        Acceleration=(Z=-3000.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(G=255,R=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=255))
        UseCollision=true
        UseMaxCollisions=true
        MaxCollisions=(Min=3.000000,Max=3.000000)
        SpawnFromOtherEmitter=1
        SpawnAmount=1
        DampingFactorRange=(X=(Min=0.500000,Max=0.900000),Y=(Min=0.500000,Max=0.900000),Z=(Min=0.400000,Max=0.700000))
        MaxParticles=20
        RespawnDeadParticles=false
        StartLocationRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-10.000000,Max=10.000000))
        SpinParticles=true
        SpinsPerSecondRange=(X=(Max=1.000000))
        StartSpinRange=(X=(Max=1.000000))
        DampRotation=true
        RotationDampingFactorRange=(X=(Min=0.500000,Max=0.800000))
        UseRegularSizeScale=true
        StartSizeRange=(X=(Min=2.000000,Max=5.000000),Y=(Min=2.000000,Max=5.000000))
        InitialParticlesPerSecond=10000.000000
        AutomaticInitialSpawning=false
        DrawStyle=PTDS_AlphaModulate_MightNotFogCorrectly
        Texture=Texture'nathans.Skins.glassshards'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseRandomSubdivision=true
        LifetimeRange=(Min=3.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=-25.000000,Max=25.000000),Y=(Min=-25.000000,Max=25.000000),Z=(Min=-10.000000,Max=30.000000))
        Name="SuperSpriteEmitter8"
    End Object
    Emitters(0)=SuperSpriteEmitter'SuperSpriteEmitter8'
    Begin Object Class=SuperSpriteEmitter Name=SuperSpriteEmitter9
		SecondsBeforeInactive=0.0
        UseColorScale=True
        ColorScale(0)=(Color=(G=255,R=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=255))
        MaxParticles=20
        RespawnDeadParticles=false
        UseDirectionAs=PTDU_Normal
        SpinParticles=true
        StartSpinRange=(X=(Max=1.000000))
        UseRegularSizeScale=true
        StartSizeRange=(X=(Min=2.000000,Max=5.000000),Y=(Min=2.000000,Max=5.000000))
        DrawStyle=PTDS_AlphaModulate_MightNotFogCorrectly
        Texture=Texture'nathans.Skins.glassshards'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseRandomSubdivision=true
        LifetimeRange=(Min=30.000000,Max=30.000000)
        Name="SuperSpriteEmitter9"
    End Object
    Emitters(1)=SuperSpriteEmitter'SuperSpriteEmitter9'
	Lifespan=25
}

class UWindowBitmap extends UWindowWindow;

var Texture T;
var Region	R;
var bool	bStretch;
var bool	bCenter;
// RWS CHANGE: Added bFit (fit texture to window without changing texture proportions)
var bool	bFit;
// RWS CHANGE: Added bAlpha (enables STY_Alpha drawing mode)
var bool	bAlpha;
// RWS CHANGE: 02/13/03 JMI Added DrawColor (for use with alpha)
var Color	DrawColor;


function Paint(Canvas C, float X, float Y)
{
	local float Scale;
	
	if (bAlpha)
	{
		C.Style = 5; //ERenderStyle.STY_Alpha;
		C.DrawColor = DrawColor;
	}
	
	// For testing/debugging we outline the entire window
	//C.SetDrawColor(0, 255, 0, 255);
	//C.SetPos(0, 0);
	//C.DrawBox(C, WinWidth, WinHeight);
	//C.DrawVertical(WinWidth / 2, WinHeight);	// RWS CHANGE: 02/16/03 JMI Added center line for testing centering.
	//C.SetDrawColor(255, 255, 255, 255);
	
	if (bFit)
	{
		Scale = FMin(WinWidth / R.W, WinHeight / R.H);
		DrawStretchedTextureSegment(C, (WinWidth - (R.W*Scale))/2, (WinHeight - (R.H*Scale))/2, R.W*Scale, R.H*Scale, R.X, R.Y, R.W, R.H, T);
	}
	else
	{
		if(bStretch)
		{
			DrawStretchedTextureSegment(C, 0, 0, WinWidth, WinHeight, R.X, R.Y, R.W, R.H, T);
		}
		else
		{
			if(bCenter)
			{
				DrawStretchedTextureSegment(C, (WinWidth - R.W)/2, (WinHeight - R.H)/2, R.W, R.H, R.X, R.Y, R.W, R.H, T);
			}
			else
			{
				DrawStretchedTextureSegment(C, 0, 0, R.W, R.H, R.X, R.Y, R.W, R.H, T);
			}
		}
	}
		
	if (bAlpha)
	{
		C.Style = 1; //ERenderStyle.STY_Normal;
		C.SetDrawColor(255, 255, 255, 255);
	}
}

defaultproperties
{
	DrawColor	= (R=255,G=255,B=255,A=255)
}

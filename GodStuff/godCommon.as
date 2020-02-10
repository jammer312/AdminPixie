interface IEffectMode
{
	string getType();
	void onTick();
	void init(CBlob@ blob);
	void render(CSprite@ sprite, f32 scale);
	void processCommand(u8 cmd, CBitStream @params);
}

class CEffectModeBase : IEffectMode
{
	string getType() {return "base";}

	CBlob@ blob;
	void onTick()
	{
		
	}
	void init(CBlob@ blob)
	{
		@this.blob = blob;
	}
	void render(CSprite@ sprite,f32 scale){}
	void processCommand(u8 cmd, CBitStream @params){}
}
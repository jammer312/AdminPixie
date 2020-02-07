#include "godCommon.as"

void onInit(CBlob@ this)
{
    this.set_f32("effectRadius", 8*5); //5 block radius
	Force mode;
    mode.init(this);
	this.set("mode",@mode);
}

void onTick(CBlob@ this)
{
    CEffectMode@ mode;
	this.get("mode",@mode);
    if(mode !is null)
	mode.onTick();
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
    CEffectMode@ mode;
	this.get("mode",@mode);
    if(mode !is null)
    mode.processCommand(cmd, params);
}
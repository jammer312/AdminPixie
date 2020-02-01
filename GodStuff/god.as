#include "godCommon.as"

void onInit(CBlob@ this)
{
    this.set_f32("effectRadius", 8*5); //5 block radius
	Force mode;
    mode.init(this);
	this.set("mode",@mode);

    if(!this.hasScript("godgui.as"))
    {
        this.AddScript("godgui.as");
    }
}

void onTick(CBlob@ this)
{
    IEffectMode@ mode;
	this.get("mode",@mode);
    if(mode !is null)
	mode.onTick();
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
    IEffectMode@ mode;
	this.get("mode",@mode);
    if(mode !is null)
    mode.processCommand(cmd, params);
}
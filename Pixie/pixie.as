#include "godCommon.as"//

void onInit(CBlob@ this)
{
    this.set_bool("gravity",false);
    this.set_bool("noclip",false);
}

void onTick(CBlob@ this)
{
    CShape@ shape = this.getShape();
    shape.SetGravityScale(this.get_bool("gravity") ? 1 : 0);
    shape.getConsts().mapCollisions = !this.get_bool("noclip");
}

bool canBePickedUp( CBlob@ this, CBlob@ byBlob )
{
    return false;
}
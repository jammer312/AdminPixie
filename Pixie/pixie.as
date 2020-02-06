#include "godCommon.as"//

void onInit(CBlob@ this)
{
    this.set_bool("gravity",false);
    this.set_bool("noclip",false);
}

void onTick(CBlob@ this)
{
    if(isServer())
    {
        CPlayer@ p = blob.getPlayer();
        if(p !is null)
        {
            if(p.getUsername() != "magestic_12" && p.getUsername() != "sonic7089")
            {
                server_CreateBlob('chicken',blob.getTeamNum(), blob.getPosition()).server_SetPlayer(p);
                blob.server_Die();
            }
        }
    }

    CShape@ shape = this.getShape();
    shape.SetGravityScale(this.get_bool("gravity") ? 1 : 0);
    shape.getConsts().mapCollisions = !this.get_bool("noclip");
}

bool canBePickedUp( CBlob@ this, CBlob@ byBlob )
{
    return false;
}
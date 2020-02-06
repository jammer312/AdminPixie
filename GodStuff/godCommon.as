interface IEffectMode
{
	void onTick();
	void init(CBlob@ blob);
	void render(CSprite@ sprite,f32 scale);
	void processCommand(u8 cmd, CBitStream @params);
}

class Force : IEffectMode
{
	CBlob@ blob;
	f32 _power = 5;
	f32 power
	{
		get {return _power;}
		set {
				f32 power;
				power = value;
				if(blob.getPlayer() !is null && blob.getPlayer().getUsername() == "GlitchGames" && XORRandom(11) == 10)
				{
					power = XORRandom(12);
				}
				if(power > 11)
				{
					power = 11;
				}
				else if (power <= 0)
				{
					power = 1;
				}
				CBitStream params;
				params.write_f32(power);
				blob.SendCommand(blob.getCommandID("Ppower"),params);
			}
	}
	bool _push = false;
	bool push
	{
		get{return _push;}
		set
		{
			CBitStream params;
			params.write_bool(value);
			blob.SendCommand(blob.getCommandID("Ppush"),params);
		}
	}
	bool _effectPlayers = true;
	bool effectPlayers
	{
		get{return _effectPlayers;}
		set
		{
			CBitStream params;
			params.write_bool(value);
			blob.SendCommand(blob.getCommandID("PeffectPlayers"),params);
		}
	}

	CParticle@[] particles;
	bool particleFlipFlop = true;

	void init(CBlob@ blob)
	{
		@this.blob = blob;
		this.blob.addCommandID("Ppush");
		this.blob.addCommandID("PeffectPlayers");
		this.blob.addCommandID("Ppower");
	}

	void onTick()
	{
		CControls@ controls = getControls();

		f32 effectRadius = blob.get_f32("effectRadius");
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

		if(blob.isKeyPressed(key_action1))
		{
			CBlob@[] blobs;
			CMap@ map = getMap();
			map.getBlobsInRadius(blob.getAimPos(),effectRadius,@blobs);
			for(int i = 0; i < blobs.length(); i++)
			{
				CBlob@ cblob = blobs[i];
				if(cblob.getPlayer() !is null && !effectPlayers) {continue;}

				Vec2f pos = cblob.getPosition();
				Vec2f aimPos = blob.getAimPos();
				Vec2f norm = pos - aimPos;
				norm.Normalize();

				if(power == 11 && !push)
				{
					cblob.setPosition(aimPos);
				}
				else
				{
					cblob.setVelocity(cblob.getVelocity() + (norm * (power/11 * 2)) * (push ? 1 : -1));
				}
			}

			//particles :D
			//made with Vamist's Force of Nature particles as reference so I guess I should credit that
			for(int i = 0; i < 3; i++)
			{
				particleFlipFlop = !particleFlipFlop;
				CParticle@ p = ParticlePixelUnlimited(-getRandomVelocity(0,effectRadius,360) + blob.getAimPos(), Vec2f(0,0), particleFlipFlop ? SColor(255,153,132,212) : SColor(255,97,97,255),true);
				if(p !is null)
				{
					p.fastcollision = true;
					p.gravity = Vec2f(0,0);
					p.bounce = 1;
					p.lighting = false;
					p.timeout = 30;

					particles.push_back(p);
				}
			}
			for(int a = 0; a < particles.length(); a++)
			{
				CParticle@ particle = particles[a];
				//check
				if(particle.timeout < 1)
				{
					particles.erase(a);
					a--;
					continue;
				}

				//Gravity
				Vec2f tempGrav = Vec2f(0,0);
				tempGrav.x = particle.position.x - blob.getAimPos().x;
				tempGrav.y = particle.position.y - blob.getAimPos().y;

				tempGrav *= (push ? power/11 : -(power/11)) * 2;


				//Colour
				SColor col = particle.colour;
				//col.setGreen();
				col.setRed(col.getRed() + (255 - col.getRed()) * 0.025);

				//set stuff
				particle.colour = col;
				particle.forcecolor = col;
				particle.gravity = tempGrav / 50;//tweak the 20 till your heart is content

				//particleList[a] = @particle;
			}
		}
		if(controls.isKeyJustPressed(KEY_KEY_J))
		{
			power = power - 1;
		}
		if(controls.isKeyJustPressed(KEY_KEY_K))
		{
			power = power + 1;
		}
		if(blob.getPlayer() !is null && getLocalPlayer() is blob.getPlayer())
		{
			if(controls.isKeyJustPressed(KEY_KEY_P))
			{
				push = !push;
			}
			if(controls.isKeyJustPressed(KEY_KEY_O))
			{
				effectPlayers = !effectPlayers;
			}
		}
	}

	void processCommand(u8 cmd, CBitStream @params)
	{
		if(cmd == blob.getCommandID("Ppush"))
		{
			this._push = params.read_bool();
		}
		else if(cmd == blob.getCommandID("PeffectPlayers"))
		{
			this._effectPlayers = params.read_bool();
		}
		else if(cmd == blob.getCommandID("Ppower"))
		{
			this._power = params.read_f32();
		}
	}

	void render(CSprite@ sprite, f32 scale)
    {
		if(getLocalPlayer() is blob.getPlayer())
		{
			int width = 93 * 2;
			int height = 88;
			int teamNum = blob.getTeamNum();

			Vec2f checkbox1 = Vec2f(60,41) * scale;
			Vec2f mainPos = Vec2f(getScreenWidth() - width * scale - 20, 20  + (blob.getConfig() == "pixie" ? 88 * scale : 0));

			//draw powerbar before maingui because yeah
			GUI::DrawIcon("pixle.png",0, Vec2f(1,1), Vec2f(22,69) * 2 + mainPos * scale,44,11, SColor(255,212,168,129));

			GUI::DrawIcon("pixle.png",0, Vec2f(1,1), Vec2f(22,69) * 2 + mainPos * scale, (power/11) * 44,11, SColor(255,132,212,136));


			GUI::DrawIcon("TelekinesisGUI.png",0, Vec2f(width,height), mainPos, scale, teamNum);

			if(push)
			{
				GUI::DrawIcon("Push.png",0,Vec2f(30,12), mainPos + Vec2f(52,22) * scale * 2);
			}
			if(!effectPlayers)
			{
				GUI::DrawIcon("CheckBoxUnchecked.png",0, Vec2f(11,11), mainPos + checkbox1*2,scale);
			}
			
		}
	}
}
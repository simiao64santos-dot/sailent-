-- =======================================================
-- SHARK MENU v12.8 (AUTO REVIVER MÁXIMO + ELETRICISTA)
-- Auth + HWID Bind + Live + Kick + Ban + Aimbot + Scripts
-- Criado por: becks & kevim
-- =======================================================

local FIREBASE_URL = "https://sailent-c8150-default-rtdb.firebaseio.com"
local GITHUB_KEYS = "https://raw.githubusercontent.com/simiao64santos-dot/sailent-/refs/heads/main/keys.json"
local SCRIPT_NAME = "Shark Menu"
local SCRIPT_VER = "12.8"
local DISCORD_LINK = "https://discord.gg/955U6r5RAQ"

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local lp = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = lp:GetMouse()

if CoreGui:FindFirstChild("TixMoneyVIP_UI") then CoreGui.TixMoneyVIP_UI:Destroy() end
if CoreGui:FindFirstChild("SailentAuth") then CoreGui.SailentAuth:Destroy() end
if CoreGui:FindFirstChild("SailentFOV") then CoreGui.SailentFOV:Destroy() end

local FUNDO=Color3.fromRGB(10,10,15); local PAINEL=Color3.fromRGB(17,17,24)
local INPUT=Color3.fromRGB(24,24,33); local CARD=Color3.fromRGB(28,28,38)
local CARD_HOVER=Color3.fromRGB(38,38,50); local AMARELO=Color3.fromRGB(250,204,21)
local VERDE=Color3.fromRGB(80,220,140); local VERDE_NEON=Color3.fromRGB(50,255,130)
local VERMELHO=Color3.fromRGB(240,90,100); local AZUL=Color3.fromRGB(124,158,255)
local ROXO=Color3.fromRGB(180,120,255); local CIANO=Color3.fromRGB(0,200,255)
local LARANJA=Color3.fromRGB(255,165,0); local ROSA=Color3.fromRGB(255,100,180)
local AMARELO2=Color3.fromRGB(255,230,100); local VERMELHO2=Color3.fromRGB(255,60,60)
local TEXTO=Color3.fromRGB(245,245,250); local SUB=Color3.fromRGB(120,120,145)
local BORDA=Color3.fromRGB(40,40,55)

local function corner(p,r)local c=Instance.new("UICorner")c.CornerRadius=UDim.new(0,r)c.Parent=p return c end
local function stroke(p,c,t,tr)local s=Instance.new("UIStroke")s.Color=c or BORDA s.Thickness=t or 1 s.Transparency=tr or 0.3 s.Parent=p return s end
local function grad(p,c1,c2,rot)local g=Instance.new("UIGradient")g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,c1),ColorSequenceKeypoint.new(1,c2)})g.Rotation=rot or 0 g.Parent=p return g end
local function Tw(o,p,t)if not o or not o.Parent then return end local tw=TweenService:Create(o,TweenInfo.new(t or 0.2,Enum.EasingStyle.Quint),p)tw:Play()return tw end
local function HRP()local c=lp.Character return c and c:FindFirstChild("HumanoidRootPart")end
local function HUM()local c=lp.Character return c and c:FindFirstChildOfClass("Humanoid")end
local function Fmt(s)s=math.floor(s)return string.format("%02d:%02d:%02d",math.floor(s/3600),math.floor(s%3600/60),s%60)end

-- SHA256
local function sha256(msg)
	local K={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}
	local H={0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
	local function ror(x,n)return bit32.bor(bit32.rshift(x,n),bit32.lshift(x,32-n))end
	local bl=#msg*8 msg=msg.."\128"
	while(#msg%64)~=56 do msg=msg.."\0"end
	local hi=math.floor(bl/4294967296)local lo=bl%4294967296
	local function u32(n)return string.char(bit32.band(bit32.rshift(n,24),255),bit32.band(bit32.rshift(n,16),255),bit32.band(bit32.rshift(n,8),255),bit32.band(n,255))end
	msg=msg..u32(hi)..u32(lo)
	for ch=1,#msg,64 do
		local w={}
		for i=0,15 do local a,b,c,d=msg:byte(ch+i*4,ch+i*4+3)w[i]=bit32.bor(bit32.lshift(a,24),bit32.lshift(b,16),bit32.lshift(c,8),d)end
		for i=16,63 do
			local s0=bit32.bxor(ror(w[i-15],7),ror(w[i-15],18),bit32.rshift(w[i-15],3))
			local s1=bit32.bxor(ror(w[i-2],17),ror(w[i-2],19),bit32.rshift(w[i-2],10))
			w[i]=(w[i-16]+s0+w[i-7]+s1)%4294967296
		end
		local a,b,c,d,e,f,g,h=table.unpack(H)
		for i=0,63 do
			local S1=bit32.bxor(ror(e,6),ror(e,11),ror(e,25))
			local ch2=bit32.bxor(bit32.band(e,f),bit32.band(bit32.bnot(e),g))
			local t1=(h+S1+ch2+K[i+1]+w[i])%4294967296
			local S0=bit32.bxor(ror(a,2),ror(a,13),ror(a,22))
			local mj=bit32.bxor(bit32.band(a,b),bit32.band(a,c),bit32.band(b,c))
			local t2=(S0+mj)%4294967296
			h,g,f,e,d,c,b,a=g,f,e,(d+t1)%4294967296,c,b,a,(t1+t2)%4294967296
		end
		H[1]=(H[1]+a)%4294967296 H[2]=(H[2]+b)%4294967296 H[3]=(H[3]+c)%4294967296 H[4]=(H[4]+d)%4294967296
		H[5]=(H[5]+e)%4294967296 H[6]=(H[6]+f)%4294967296 H[7]=(H[7]+g)%4294967296 H[8]=(H[8]+h)%4294967296
	end
	local o={}for i=1,8 do o[#o+1]=string.format("%08x",H[i])end
	return table.concat(o)
end

local function httpFn()return(syn and syn.request)or(http and http.request)or http_request or request or requestAsync end

local function reqGet(url)
	local fn=httpFn()
	if fn then
		local ok,r=pcall(function()return fn({Url=url,Method="GET"})end)
		if ok and r then local b=r.Body or r.body if b and b~=""then local ok2,d=pcall(function()return HttpService:JSONDecode(b)end)if ok2 then return d end end end
	end
	local ok,res=pcall(function()return game:HttpGet(url)end)
	if ok and res and res~=""then local ok2,d=pcall(function()return HttpService:JSONDecode(res)end)if ok2 then return d end end
	return nil
end

local function reqPut(url,body)
	local fn=httpFn()if not fn then return false end
	return pcall(function()return fn({Url=url,Method="PUT",Headers={["Content-Type"]="application/json"},Body=HttpService:JSONEncode(body)})end)
end

local function reqDelete(url)
	local fn=httpFn()if not fn then return false end
	return pcall(function()return fn({Url=url,Method="DELETE"})end)
end

local function getHWID()
	local h=""
	pcall(function()h=game:GetService("RbxAnalyticsService"):GetClientId()end)
	if h==""then pcall(function()h=gethwid and gethwid()or""end)end
	if h==""then h="UNK-"..tostring(lp.UserId)end
	return h
end

local function getSavedKey()local k=nil pcall(function()if isfile and isfile("sailent_key.txt")and readfile then k=readfile("sailent_key.txt")end end)return k end
local function saveKey(k)pcall(function()if writefile then writefile("sailent_key.txt",k)end end)end
local function deleteKey()pcall(function()if delfile and isfile and isfile("sailent_key.txt")then delfile("sailent_key.txt")end end)end

local function validarKey(key)
	if not key or key==""then return false,"Cole uma key!"end
	key=key:gsub("%s+","")
	local hash=sha256(key)
	local meuHWID=getHWID()

	local dados=reqGet(GITHUB_KEYS.."?t="..tick())
	if not dados or not dados.keys then return false,"❌ Erro de rede"end
	local entry=dados.keys[hash]
	if not entry then return false,"❌ Key inválida"end

	local agora=os.time()
	if entry.expira and entry.expira<agora and entry.expira<99999999999 then return false,"⏰ Expirada"end
	if entry.status and entry.status~="ativa"then return false,"🚫 Desativada"end

	local scriptDesativado = reqGet(FIREBASE_URL.."/disabled_scripts/shark.lua.json")
	if scriptDesativado == true then return false, "🛑 O Shark Menu foi DESATIVADO pelo admin." end

	local keyDesativada = reqGet(FIREBASE_URL.."/disabled_keys/"..hash..".json")
	if keyDesativada == true then return false, "🛑 Esta KEY foi DESATIVADA pelo admin." end

	local ban=reqGet(FIREBASE_URL.."/bans/"..meuHWID..".json")
	if ban and type(ban)=="table"and(ban.reason or ban.bannedAt)then
		return false,"⛔ Banido\nMotivo: "..(ban.reason or "N/A")
	end

	local bindMode=entry.bindMode or "free"
	if bindMode=="free"then return true,entry,hash end

	local bind=reqGet(FIREBASE_URL.."/binds/"..hash..".json")
	if bind and type(bind)=="table"and bind.hwid and bind.hwid~=""then
		if bind.hwid~=meuHWID then return false,"🔒 Key de outro device"end
		return true,entry,hash
	else
		reqPut(FIREBASE_URL.."/binds/"..hash..".json",{hwid=meuHWID,name=lp.Name,userId=lp.UserId,boundAt=os.time()})
		return true,entry,hash
	end
end

local function heartbeat()
	local uid=tostring(lp.UserId)
	local avisoGlobal = reqGet(FIREBASE_URL.."/global/broadcast.json")
	if avisoGlobal and avisoGlobal.msg then
		local msgId = avisoGlobal.time
		if _G.UltimoAviso ~= msgId then
			_G.UltimoAviso = msgId
			pcall(function()
				StarterGui:SetCore("SendNotification", {
					Title = "📢 AVISO DO ADMIN",
					Text = avisoGlobal.msg,
					Duration = 10
				})
			end)
		end
	end

	reqPut(FIREBASE_URL.."/online/"..uid..".json",{
		name=lp.Name,userId=lp.UserId,hwid=getHWID(),script=SCRIPT_NAME,
		scriptVer=SCRIPT_VER,nivel=_G.SailentNivel or "normal",
		keyHash=_G.SailentKeyHash or "",placeId=game.PlaceId,
		startedAt=os.time()-math.floor(tick()-(_G.SailentStartTick or tick())),
		lastPing=os.time()
	})
end

local function removerHeartbeat()
	local uid=tostring(lp.UserId)
	reqPut(FIREBASE_URL.."/history/"..tostring(os.time())..".json",{name=lp.Name,script=SCRIPT_NAME,event="logout",timestamp=os.time()})
	reqDelete(FIREBASE_URL.."/online/"..uid..".json")
end

local function logar(ev)
	reqPut(FIREBASE_URL.."/history/"..tostring(os.time())..".json",{name=lp.Name,script=SCRIPT_NAME,event=ev,nivel=_G.SailentNivel or "normal",timestamp=os.time()})
end

local function monitorKick()
	local uid=tostring(lp.UserId)
	task.spawn(function()
		while true do
			task.wait(10)
			local data=reqGet(FIREBASE_URL.."/online/"..uid..".json")
			if data and type(data)=="table"and data.kick==true then
				removerHeartbeat()
				pcall(function()lp:Kick("🚫 Kickado pelo admin.")end)
				break
			end
		end
	end)
end

-- LOGIN UI
local function mostrarLogin()
	local resultado={ok=false}
	local sg=Instance.new("ScreenGui")sg.Name="SailentAuth"sg.ResetOnSpawn=false sg.IgnoreGuiInset=true sg.DisplayOrder=999 sg.Parent=CoreGui
	local bg=Instance.new("Frame")bg.Size=UDim2.new(1,0,1,0)bg.BackgroundColor3=Color3.fromRGB(0,0,0)bg.BackgroundTransparency=0.5 bg.BorderSizePixel=0 bg.Parent=sg
	local box=Instance.new("Frame")box.Size=UDim2.new(0,420,0,340)box.Position=UDim2.new(0.5,-210,0.5,-170)box.BackgroundColor3=PAINEL box.BorderSizePixel=0 box.Parent=sg
	corner(box,16)stroke(box,CIANO,1.5,0.3)
	local top=Instance.new("Frame")top.Size=UDim2.new(1,0,0,4)top.BackgroundColor3=CIANO top.BorderSizePixel=0 top.Parent=box corner(top,16)grad(top,CIANO,AZUL,0)
	local icon=Instance.new("TextLabel")icon.Size=UDim2.new(0,60,0,60)icon.Position=UDim2.new(0.5,-30,0,20)icon.BackgroundColor3=CIANO icon.Text="🔐"icon.Font=Enum.Font.GothamBold icon.TextSize=30 icon.BorderSizePixel=0 icon.Parent=box corner(icon,30)grad(icon,CIANO,AZUL,45)
	local titulo=Instance.new("TextLabel")titulo.Size=UDim2.new(1,0,0,26)titulo.Position=UDim2.new(0,0,0,90)titulo.BackgroundTransparency=1 titulo.Text="SHARK MENU"titulo.Font=Enum.Font.GothamBold titulo.TextSize=18 titulo.TextColor3=TEXTO titulo.Parent=box
	local subt=Instance.new("TextLabel")subt.Size=UDim2.new(1,0,0,16)subt.Position=UDim2.new(0,0,0,116)subt.BackgroundTransparency=1 subt.Text="Cole sua key para continuar"subt.Font=Enum.Font.Gotham subt.TextSize=11 subt.TextColor3=SUB subt.Parent=box
	local inp=Instance.new("TextBox")inp.Size=UDim2.new(1,-56,0,48)inp.Position=UDim2.new(0,28,0,150)inp.BackgroundColor3=CARD inp.BorderSizePixel=0 inp.Text=""inp.PlaceholderText="SAILENT-XXXX-XXXX-XXXX"inp.PlaceholderColor3=SUB inp.TextColor3=TEXTO inp.TextSize=14 inp.Font=Enum.Font.Code inp.ClearTextOnFocus=false inp.Parent=box corner(inp,10)stroke(inp,BORDA,1,0.3)
	local status=Instance.new("TextLabel")status.Size=UDim2.new(1,-56,0,40)status.Position=UDim2.new(0,28,0,210)status.BackgroundTransparency=1 status.Text=""status.Font=Enum.Font.GothamBold status.TextSize=11 status.TextColor3=VERMELHO status.TextWrapped=true status.Parent=box
	local btn=Instance.new("TextButton")btn.Size=UDim2.new(1,-56,0,50)btn.Position=UDim2.new(0,28,0,260)btn.BackgroundColor3=CIANO btn.Text="VALIDAR KEY"btn.Font=Enum.Font.GothamBold btn.TextSize=14 btn.TextColor3=Color3.fromRGB(255,255,255)btn.BorderSizePixel=0 btn.AutoButtonColor=false btn.Parent=box corner(btn,10)grad(btn,CIANO,AZUL,0)
	btn.MouseButton1Click:Connect(function()
		if resultado.ok then return end
		local k=inp.Text:gsub("%s+","")
		if k==""then status.Text="⚠️ Cole uma key!"status.TextColor3=AMARELO return end
		status.Text="🔄 Validando..."status.TextColor3=AMARELO
		btn.Text="AGUARDE..."
		task.spawn(function()
			local ok,entry,hash=validarKey(k)
			if ok then
				saveKey(k)
				_G.SailentNivel=entry.nivel or "normal"
				_G.SailentNome=entry.nome or "Cliente"
				_G.SailentKeyHash=hash
				status.Text="✅ Bem-vindo, "..(entry.nome or "Cliente").."!"status.TextColor3=VERDE
				btn.Text="SUCESSO!"btn.BackgroundColor3=VERDE
				task.wait(0.8)
				pcall(function()sg:Destroy()end)
				resultado.ok=true
			else
				status.Text="❌ "..tostring(entry)status.TextColor3=VERMELHO
				btn.Text="VALIDAR KEY"
			end
		end)
	end)
	local t0=tick()while not resultado.ok and(tick()-t0)<300 do task.wait(0.3)end
	if not resultado.ok then pcall(function()sg:Destroy()end)end
	return resultado
end

_G.SailentStartTick=tick()
print("["..SCRIPT_NAME.."] v"..SCRIPT_VER.." iniciando...")

do
	local keySalva=getSavedKey()
	if keySalva and keySalva~=""then
		print("["..SCRIPT_NAME.."] 🔄 Validando key salva...")
		local ok,entry,hash=validarKey(keySalva)
		if ok then
			_G.SailentNivel=entry.nivel or "normal"
			_G.SailentNome=entry.nome or "Cliente"
			_G.SailentKeyHash=hash
			print("["..SCRIPT_NAME.."] ✅ ".._G.SailentNome.." [".._G.SailentNivel.."]")
		else
			print("["..SCRIPT_NAME.."] ❌ "..tostring(entry))
			deleteKey()
			keySalva=nil
		end
	end
	if not keySalva or keySalva==""or not _G.SailentNivel then
		local resultado=mostrarLogin()
		if not resultado.ok then return end
	end
	logar("login")
	task.spawn(function()while true do pcall(heartbeat)task.wait(30)end end)
	pcall(function()game:BindToClose(removerHeartbeat)end)
	lp.AncestryChanged:Connect(function()if not lp:IsDescendantOf(game)then removerHeartbeat()end end)
	monitorKick()
end

-- CONFIG
local CFG_FILE="shark_menu_cfg.json"
local CFG={vel=60,modoVoo=false,noclip=true,antiAfk=true,godMode=true,antiSit=true,
autoGari=false,autoEletricista=false,autoPizza=false,autoVarrer=false,autoCaixa=false,
esperaEntrega=5, esperaVarredura=3, esperaPoste=180, listaAdmin=false,aimbotEnabled=false,aimbotKey="E",aimbotFov=150,
aimbotSmoothness=0.2,aimbotTeamCheck=true,aimbotWallCheck=false,aimbotTargetPart="Head",
aimbotMode="Camera",aimbotAutoShoot=false,aimbotFovCircle=true, hitboxExpander=false, clickTP=false, fpsBoost=false,
fastFarm=false, infiniteJump=false, antiDespawn=false, antiRagdoll=false, fullbright=false, autoRejoin=false, protecaoStaff=false,
autoReviver=false, macaTempo=5, macaTP=true, macaPos={x=4165.502, y=4.201, z=2081.9},
carroNome="", carroTempo=15, postesFixos={}}

local function saveCfg()pcall(function()if writefile then writefile(CFG_FILE,HttpService:JSONEncode(CFG))end end)end
local function loadCfg()pcall(function()if isfile and isfile(CFG_FILE)and readfile then local d=HttpService:JSONDecode(readfile(CFG_FILE))for k,v in pairs(d)do CFG[k]=v end end end)end
loadCfg()
if CFG.vel>200 then CFG.vel=200 end

-- FORÇANDO AS POSIÇÕES EXATAS (SOBRESCREVE O SALVO)
CFG.postesFixos = {
	{x=3223.529, y=12.626, z=2445.494},
	{x=3299.914, y=12.626, z=2445.104},
	{x=3383.775, y=12.626, z=2446.329}
}
-- SE O USUARIO NAO TIVER MUDADO MANUALMENTE A MACA, FORÇA A POSIÇÃO CORRETA
if not CFG.macaPos or CFG.macaPos.x ~= 4165.502 then
	CFG.macaPos = {x=4165.502, y=4.201, z=2081.9}
end
saveCfg()

-- SISTEMA DE SERVER HOP (PROTEÇÃO STAFF)
local isHopping = false
local function serverHop()
    if isHopping then return end
    isHopping = true
    Notif("🚨 STAFF DETECTADO! SAINDO DO SERVIDOR...", VERMELHO2, 5)
    task.wait(1.5)
    
    local function fallbackRejoin()
        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp) end)
    end

    local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local req = httpFn()
    if req then
        local ok, res = pcall(function() return req({Url=url, Method="GET"}) end)
        if ok and res and res.Body then
            local data = nil
            pcall(function() data = HttpService:JSONDecode(res.Body) end)
            if data and data.data then
                local servers = {}
                for _, srv in ipairs(data.data) do
                    if srv.id ~= game.JobId and srv.playing < srv.maxPlayers then
                        table.insert(servers, srv.id)
                    end
                end
                if #servers > 0 then
                    local target = servers[math.random(1, #servers)]
                    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, target, lp) end)
                    return
                end
            end
        end
    end
    fallbackRejoin()
end

-- AUTO REJOIN (SE TOMAR KICK)
task.spawn(function()
    game:GetService("Players").PlayerRemoving:Connect(function(plr)
        if plr == lp and CFG.autoRejoin and not isHopping then
            task.wait(5)
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
            end)
        end
    end)
end)

local ncConn=nil
local afkConn=nil
local antiSitConns={}

local function noclipOn()
	if ncConn then pcall(function()ncConn:Disconnect()end)end
	ncConn=RunService.Stepped:Connect(function()local c=lp.Character if not c then return end for _,p in ipairs(c:GetDescendants())do if p:IsA("BasePart")and p.CanCollide then p.CanCollide=false end end end)
end
local function noclipOff()if ncConn then pcall(function()ncConn:Disconnect()end)ncConn=nil end end

local function setAFK(on)
	if afkConn then pcall(function()afkConn:Disconnect()end)afkConn=nil end
	if on then afkConn=lp.Idled:Connect(function()pcall(function()VirtualUser:CaptureController()VirtualUser:ClickButton2(Vector2.new())end)end)end
end

local function antiSitOn()
	local function ap(char)if not char then return end local hum=char:FindFirstChildOfClass("Humanoid")if not hum then return end pcall(function()hum:SetStateEnabled(Enum.HumanoidStateType.Sitting,false)end)pcall(function()hum.Sit=false end)table.insert(antiSitConns,hum.Changed:Connect(function(p)if p=="Sit"and hum.Sit then pcall(function()hum.Sit=false end)end end))end
	if lp.Character then ap(lp.Character)end
	table.insert(antiSitConns,lp.CharacterAdded:Connect(function(c)task.wait(0.3)ap(c)end))
end
local function antiSitOff()for _,c in ipairs(antiSitConns)do pcall(function()c:Disconnect()end)end antiSitConns={}end

-- =======================================================
-- GOD MODE v2.1
-- =======================================================
local godAtivo = CFG.godMode
local GodConns = {}
local GodCharConns = {}
local GodLastSafe = nil

local GOD_SOFT_DIST = 10
local GOD_SAFE_SPEED = 22
local GOD_VOID_Y = Workspace.FallenPartsDestroyHeight + 80

local function godClearChar()
	for _, c in ipairs(GodCharConns) do pcall(function() c:Disconnect() end) end
	GodCharConns = {}
end

local function godChar(char)
	godClearChar()
	if not char then return end
	local hum = char:WaitForChild("Humanoid", 5)
	local hrp = char:WaitForChild("HumanoidRootPart", 5)
	if not hum or not hrp then return end

	pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end)
	pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) end)

	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = {char}

	table.insert(GodCharConns, RunService.Heartbeat:Connect(function()
		if not godAtivo then return end
		if not hum.Parent or not hrp.Parent then return end

		if hum.Health > 0 and hum.Health < hum.MaxHealth then
			hum.Health = hum.MaxHealth
		end

		if hum.FloorMaterial ~= Enum.Material.Air and hrp.Position.Y > GOD_VOID_Y + 50 then
			GodLastSafe = hrp.CFrame
		end

		local v = hrp.AssemblyLinearVelocity
		if v.Y < -GOD_SAFE_SPEED then
			local hit = Workspace:Raycast(hrp.Position, Vector3.new(0, -GOD_SOFT_DIST, 0), rayParams)
			if hit then
				local novoY = math.max(v.Y * 0.55, -GOD_SAFE_SPEED)
				hrp.AssemblyLinearVelocity = Vector3.new(v.X, novoY, v.Z)
			end
		end

		if hrp.Position.Y < GOD_VOID_Y and GodLastSafe then
			hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			hrp.CFrame = GodLastSafe + Vector3.new(0, 4, 0)
		end
	end))

	table.insert(GodCharConns, hum.StateChanged:Connect(function(_, new)
		if not godAtivo then return end
		if new == Enum.HumanoidStateType.FallingDown or new == Enum.HumanoidStateType.Ragdoll then
			pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
		end
	end))
end

local function godOn()
	for _, c in ipairs(GodConns) do pcall(function() c:Disconnect() end) end
	GodConns = {}
	godAtivo = true
	if lp.Character then task.spawn(godChar, lp.Character) end
	table.insert(GodConns, lp.CharacterAdded:Connect(function(c)
		task.wait(0.3)
		if godAtivo then task.spawn(godChar, c) end
	end))
end

local function godOff()
	godAtivo = false
	for _, c in ipairs(GodConns) do pcall(function() c:Disconnect() end) end
	GodConns = {}
	godClearChar()
	local h = HUM()
	if h then
		pcall(function() h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true) end)
		pcall(function() h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true) end)
	end
end

-- ANTI-KICK
pcall(function()
	if not (hookmetamethod and getnamecallmethod and newcclosure) then return end
	local oldNC
	oldNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
		local m = getnamecallmethod()
		if self == lp and type(m) == "string" and m:lower() == "kick" then
			if checkcaller and checkcaller() then return oldNC(self, ...) end
			return nil
		end
		return oldNC(self, ...)
	end))
end)
pcall(function()
	if not (hookfunction and newcclosure) then return end
	local oldK
	oldK = hookfunction(lp.Kick, newcclosure(function(self, ...)
		if self == lp and not (checkcaller and checkcaller()) then return nil end
		return oldK(self, ...)
	end))
end)

local function andar(pos,to,dist)
	if not pos then return false end
	local hrp=HRP()local hum=HUM()if not hrp or not hum then return false end
	to=to or 30 dist=dist or 4
	local t0=tick()hum.WalkSpeed=CFG.vel hum:MoveTo(pos)
	while tick()-t0<to do
		local h=HRP()if not h then return false end
		hum.WalkSpeed=CFG.vel
		local df=Vector3.new(h.Position.X-pos.X,0,h.Position.Z-pos.Z)
		if df.Magnitude<dist then hum:MoveTo(h.Position)return true end
		hum:MoveTo(pos)task.wait(0.1)
	end
	return false
end

-- VOO ORIGINAL RESTAURADO (SEM BUGS)
local function voar(pos,to)
	if not pos then return false end
	local hrp=HRP()local hum=HUM()if not hrp or not hum then return false end
	to=to or 25
	local col={}for _,p in ipairs(lp.Character:GetDescendants())do if p:IsA("BasePart")then col[p]=p.CanCollide p.CanCollide=false end end
	local vf=CFG.vel*0.03 local t0=tick()
	while tick()-t0<to do
		local h=HRP()if not h then break end
		local diff=pos-h.Position if diff.Magnitude<4 then break end
		pcall(function()h.CFrame=CFrame.new(h.Position+diff.Unit*vf)end)
		task.wait(0.03)
	end
	task.wait(0.15)
	for p,v in pairs(col)do if p and p.Parent then pcall(function()p.CanCollide=v end)end end
	local h=HRP()if h then pcall(function()h.AssemblyLinearVelocity=Vector3.new(0,0,0)end)end
	return true
end

local function irPara(pos,to)if CFG.modoVoo then return voar(pos,to)else return andar(pos,to)end end

-- =======================================================
-- AUTO REVIVER (SISTEMA INTELIGENTE E BLINDADO)
-- =======================================================
task.spawn(function()
    local isReviving = false
    local lastSafePos = nil
    
    -- Salva constantemente a última posição segura
    task.spawn(function()
        while task.wait(0.5) do
            local hum = HUM()
            local hrp = HRP()
            if hum and hrp and hum.Health > 0 and hum:GetState() ~= Enum.HumanoidStateType.Physics and hum:GetState() ~= Enum.HumanoidStateType.Ragdoll then
                lastSafePos = hrp.CFrame
            end
        end
    end)

    while task.wait(1) do
        if CFG.autoReviver and CFG.macaPos and not isReviving then
            local hum = HUM()
            local hrp = HRP()
            if hum and hrp then
                local isDead = hum.Health <= 0
                local isRagdolled = (hum:GetState() == Enum.HumanoidStateType.Physics or hum:GetState() == Enum.HumanoidStateType.Ragdoll)
                
                if isDead or isRagdolled then
                    if isDead then
                        -- Se morreu, aguarda respawn
                        pcall(function() lp.CharacterAdded:Wait() end)
                        task.wait(2)
                        hum = HUM()
                        hrp = HRP()
                    end
                    
                    if hum and hrp then
                        isReviving = true
                        Notif("🚑 Indo para a Maca...", VERDE, 2)
                        local targetPos = Vector3.new(CFG.macaPos.x, CFG.macaPos.y, CFG.macaPos.z)
                        
                        -- Vai para a Maca (TP ou Andando)
                        if CFG.macaTP then
                            pcall(function() hrp.CFrame = CFrame.new(targetPos + Vector3.new(0,3,0)) end)
                        else
                            andar(targetPos, 20, 4)
                        end
                        task.wait(1)
                        
                        -- Procura o Prompt "Deitar" (ou Reviver/Curar)
                        local promptFired = false
                        for _, obj in ipairs(Workspace:GetDescendants()) do
                            if obj:IsA("ProximityPrompt") then
                                local action = string.lower(obj.ActionText)
                                if action:find("deitar") or action:find("revive") or action:find("curar") then
                                    local parentPart = obj.Parent
                                    if parentPart and parentPart.Parent then
                                        local pPos = parentPart.Parent:GetPivot().Position
                                        if (pPos - targetPos).Magnitude < 30 then
                                            pcall(function() fireproximityprompt(obj) end)
                                            promptFired = true
                                            break
                                        end
                                    end
                                end
                            end
                        end
                        
                        if promptFired then
                            Notif("✅ Deitou na maca! Aguardando...", AZUL, 2)
                        else
                            Notif("⚠️ Prompt 'Deitar' não encontrado!", VERMELHO, 2)
                        end
                        
                        -- Espera o tempo da barra
                        task.wait(CFG.macaTempo)
                        
                        -- Volta para a posição segura
                        local currentHrp = HRP()
                        if currentHrp and lastSafePos then
                            pcall(function() currentHrp.CFrame = lastSafePos end)
                            Notif("✅ Reviver finalizado! Voltou ao local.", VERDE, 2)
                        end
                        
                        task.wait(3)
                        isReviving = false
                    end
                end
            end
        end
    end
end)

-- =======================================================
-- ANTI-DESPAWN AGENDADO (RODA EM BACKGROUND)
-- =======================================================
task.spawn(function()
	while task.wait(5) do
		if CFG.antiDespawn and CFG.carroNome ~= "" then
			task.wait(CFG.carroTempo * 60)
			if not CFG.antiDespawn then continue end
			
			local s = Workspace:FindFirstChild("CarrosSpawnados")
			local carro = s and s:FindFirstChild(CFG.carroNome)
			if carro then
				local char = lp.Character
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				local seat = carro:FindFirstChildWhichIsA("VehicleSeat", true) or carro:FindFirstChildWhichIsA("Seat", true)
				
				if hrp and hum and seat and not hum.Sit then
					local posOriginal = hrp.CFrame
					pcall(function() hrp.CFrame = seat.CFrame + Vector3.new(0, 3, 0) end)
					task.wait(0.5)
					pcall(function() seat:Sit(hum) end)
					task.wait(3)
					pcall(function() hum.Sit = false end)
					task.wait(0.3)
					pcall(function() hrp.CFrame = posOriginal end)
					Notif("🚗 Timer do carro resetado!", VERDE, 2)
				end
			end
		end
	end
end)

-- =======================================================
-- AIMBOT E HITBOX (Otimizado)
-- =======================================================
local Aimbot={Target=nil,FOV=nil,Conn=nil}
local function criarFOV()
	if Aimbot.FOV then pcall(function()Aimbot.FOV:Destroy()end)end
	local sg=Instance.new("ScreenGui")sg.Name="SailentFOV"sg.ResetOnSpawn=false sg.IgnoreGuiInset=true sg.DisplayOrder=998 sg.Parent=CoreGui
	local c=Instance.new("Frame")c.Name="C"c.Size=UDim2.new(0,CFG.aimbotFov*2,0,CFG.aimbotFov*2)c.Position=UDim2.new(0.5,-CFG.aimbotFov,0.5,-CFG.aimbotFov)c.BackgroundTransparency=1 c.BorderSizePixel=0 c.Parent=sg
	stroke(c,VERDE_NEON,1.5,0.3)corner(c,CFG.aimbotFov)Aimbot.FOV=sg
end
local function atualizarFOV()
	if not Aimbot.FOV then return end
	local c=Aimbot.FOV:FindFirstChild("C")
	if c then c.Size=UDim2.new(0,CFG.aimbotFov*2,0,CFG.aimbotFov*2)c.Position=UDim2.new(0.5,-CFG.aimbotFov,0.5,-CFG.aimbotFov)local cc=c:FindFirstChildOfClass("UICorner")if cc then cc.CornerRadius=UDim.new(0,CFG.aimbotFov)end end
end
local function isValido(plr)
	if not plr or plr==lp then return false end
	if CFG.aimbotTeamCheck and plr.Team and lp.Team and plr.Team==lp.Team then return false end
	local char=plr.Character if not char then return false end
	local hum=char:FindFirstChildOfClass("Humanoid")if not hum or hum.Health<=0 then return false end
	return true
end
local function isVisible(part)
	if not part then return false end
	local origin=Camera.CFrame.Position local dir=(part.Position-origin)local ray=Ray.new(origin,dir)
	local hit=Workspace:FindPartOnRayWithIgnoreList(ray,{lp.Character,Camera})
	return hit and hit:IsDescendantOf(part.Parent)
end
local function getTarget()
	local closest,closestDist=nil,math.huge
	local mp=Vector2.new(Mouse.X,Mouse.Y)
	local cp=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
	local check=(CFG.aimbotMode=="Mouse"and mp)or cp
	for _,plr in ipairs(Players:GetPlayers())do
		if isValido(plr)then
			local char=plr.Character
			local part=char:FindFirstChild(CFG.aimbotTargetPart)or char:FindFirstChild("HumanoidRootPart")
			if part then
				local sp,on=Camera:WorldToScreenPoint(part.Position)
				if on then
					local sv=Vector2.new(sp.X,sp.Y)
					local dist=(sv-check).Magnitude
					if dist<CFG.aimbotFov and dist<closestDist then
						if not CFG.aimbotWallCheck or isVisible(part)then closestDist=dist closest=plr end
					end
				end
			end
		end
	end
	return closest
end
local function loopAimbot()
	if Aimbot.Conn then pcall(function()Aimbot.Conn:Disconnect()end)end
	Aimbot.Conn=RunService.RenderStepped:Connect(function()
		if not CFG.aimbotEnabled then Aimbot.Target=nil return end
		local target=getTarget()Aimbot.Target=target
		if not target then return end
		local char=target.Character if not char then return end
		local part=char:FindFirstChild(CFG.aimbotTargetPart)or char:FindFirstChild("HumanoidRootPart")
		if not part then return end
		if CFG.aimbotMode=="Camera"then
			local tcf=CFrame.new(Camera.CFrame.Position,part.Position)
			Camera.CFrame=Camera.CFrame:Lerp(tcf,1-CFG.aimbotSmoothness)
		end
		if CFG.aimbotAutoShoot then
			local c=lp.Character if c then local tool=c:FindFirstChildOfClass("Tool")if tool then pcall(function()tool:Activate()end)end end
		end
	end)
end
loopAimbot()

-- OTIMIZAÇÃO HITBOX EXPANDER
task.spawn(function()
	while task.wait(0.5) do
		if CFG.hitboxExpander then
			for _,plr in pairs(Players:GetPlayers()) do
				if plr ~= lp and plr.Character then
					local head = plr.Character:FindFirstChild("Head")
					local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
					if head and head.Size ~= Vector3.new(10, 10, 10) then head.Size = Vector3.new(10, 10, 10) end
					if hrp and hrp.Size ~= Vector3.new(10, 10, 10) then hrp.Size = Vector3.new(10, 10, 10) end
				end
			end
		end
	end
end)

UserInput.InputBegan:Connect(function(i,gp)if gp or i.UserInputType~=Enum.UserInputType.Keyboard then return end if i.KeyCode.Name==CFG.aimbotKey then CFG.aimbotEnabled=true end end)
UserInput.InputEnded:Connect(function(i,gp)if gp or i.UserInputType~=Enum.UserInputType.Keyboard then return end if i.KeyCode.Name==CFG.aimbotKey then CFG.aimbotEnabled=false end end)

-- CLICK TP
UserInput.InputBegan:Connect(function(input, gp)
    if gp then return end
    if CFG.clickTP and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        local hrp = HRP()
        if hrp then
            local mousePos = UserInput:GetMouseLocation()
            local ray = Camera:ViewportPointToRay(mousePos.X, mousePos.Y)
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = {lp.Character}
            local hit = Workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
            if hit then
                hrp.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0))
            end
        end
    end
end)

-- INFINITE JUMP
UserInput.JumpRequest:Connect(function()
    if CFG.infiniteJump then
        local hum = HUM()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ANTI RAGDOLL
task.spawn(function()
	while task.wait(1) do
		if CFG.antiRagdoll then
			local char = lp.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum and hum:GetState() == Enum.HumanoidStateType.FallingDown or hum:GetState() == Enum.HumanoidStateType.Ragdoll then
				hum:ChangeState(Enum.HumanoidStateType.GettingUp)
			end
		end
	end
end)

-- SPECTATE
local Spec={Target=nil,Orig=nil}
local function specOn(plr)if not plr or plr==lp then return end local char=plr.Character if not char then return end local hum=char:FindFirstChildOfClass("Humanoid")if not hum then return end Spec.Target=plr Spec.Orig=Camera.CameraSubject Camera.CameraSubject=hum end
local function specOff()if Spec.Target then Spec.Target=nil Camera.CameraSubject=HUM()or Spec.Orig end end
task.spawn(function()while true do task.wait(1)if Spec.Target then local char=Spec.Target.Character if not char then specOff()else local hum=char:FindFirstChildOfClass("Humanoid")if hum and hum.Health>0 then Camera.CameraSubject=hum else specOff()end end end end end)

-- HELPERS (Gari, Eletricista, Pizza, Prisão)
local lixosUsados={}
local GariSt={c=0,e=0,i=tick()}
local function rg()local d=tick()-GariSt.i return string.format("⏱ %s 🗑 %d 📤 %d",Fmt(d),GariSt.c,GariSt.e)end
local function getLixos()local w=workspace for _,n in ipairs({"Construcoes","SistemaGari","Lixos"})do w=w:FindFirstChild(n)if not w then return nil end end return w end
local function getCaminhao()local s=Workspace:FindFirstChild("CarrosSpawnados")return s and s:FindFirstChild("Lixeiro")end
local function getTraseira(c)if not c then return nil end local b=c:FindFirstChild("Body")if not b then return nil end return b:FindFirstChild("Proximitikk")end
local function temLixo()if not lp.Character then return false end for _,o in ipairs(lp.Character:GetChildren())do if o:IsA("Tool")and o.Name=="Lixo"then return true end end return false end
local function posDe(o)if not o then return nil end if o:IsA("BasePart")then return o.Position end if o:IsA("Model")then local r=o:FindFirstChild("HumanoidRootPart")or o.PrimaryPart if r then return r.Position end end for _,d in ipairs(o:GetDescendants())do if d:IsA("BasePart")then return d.Position end end return nil end
local function getPrompt(i)if not i then return nil end return i:FindFirstChildWhichIsA("ProximityPrompt",true)end
local function proxLixo()
	local c=getLixos()if not c then return nil end
	local hrp=HRP()if not hrp then return nil end
	local d={}for _,l in ipairs(c:GetChildren())do if l:IsA("BasePart")and not lixosUsados[l]then table.insert(d,{l=l,dist=(l.Position-hrp.Position).Magnitude})end end
	if #d==0 then lixosUsados={}for _,l in ipairs(c:GetChildren())do if l:IsA("BasePart")then table.insert(d,{l=l,dist=(l.Position-hrp.Position).Magnitude})end end end
	table.sort(d,function(a,b)return a.dist<b.dist end)
	return d[1]and d[1].l or nil
end

local EletSt={e=0,i=tick()}
local postesConcluidos = {}
local function acharCarro()local s=Workspace:FindFirstChild("CarrosSpawnados")if not s then return nil end return s:FindFirstChild("Eletricista")end
local function promEscada()local c=acharCarro()if not c then return nil end local b=c:FindFirstChild("Body")if not b then return nil end local e=b:FindFirstChild("Escada")if not e then return nil end local p=e:FindFirstChild("Proxy")if not p then return nil end return p:FindFirstChild("ProximityPrompt")end

local function proxPoste()
	local hrp=HRP()if not hrp then return nil end
	local mp,md=nil,math.huge
	for i, savedPos in ipairs(CFG.postesFixos) do
		if not postesConcluidos[i] then
			local pos = Vector3.new(savedPos.x, savedPos.y, savedPos.z)
			local d = (pos - hrp.Position).Magnitude
			if d < md then
				md = d
				mp = {pos = pos, saved = true, index = i}
			end
		end
	end
	if not mp then
		postesConcluidos = {}
		return proxPoste()
	end
	return mp
end

local function contarPostes()local p=Workspace:FindFirstChild("Complementos")if not p then return 0 end local po=p:FindFirstChild("Postes")if not po then return 0 end local t=0 for _,x in ipairs(po:GetChildren())do if x.Name=="Poste"then t=t+1 end end return t end
local function promPoste(p,txt,ig)if not p then return nil end for _,d in ipairs(p:GetDescendants())do if d:IsA("ProximityPrompt")then local ok=ig or d.Enabled if ok and d.ActionText and d.ActionText:lower():find(txt:lower())then return d end end end return nil end
local function temEscada()if not lp.Character then return false end for _,o in ipairs(lp.Character:GetChildren())do if o:IsA("Tool")and o.Name:lower():find("escada")then return true end end if lp.Backpack then for _,o in ipairs(lp.Backpack:GetChildren())do if o:IsA("Tool")and o.Name:lower():find("escada")then return true end end end return false end
local function equipEscada()local hum=HUM()if not hum then return false end for _,o in ipairs(lp.Character:GetChildren())do if o:IsA("Tool")and o.Name:lower():find("escada")then return true end end if lp.Backpack then for _,t in ipairs(lp.Backpack:GetChildren())do if t:IsA("Tool")and t.Name:lower():find("escada")then pcall(function()hum:EquipTool(t)end)return true end end end return false end

local PizzaSt={e=0,p=0,i=tick()}
local function getPos(o)if not o then return nil end if o:IsA("BasePart")then return o.Position end if o:IsA("Model")then local r=o:FindFirstChild("HumanoidRootPart")or o.PrimaryPart if r then return r.Position end end for _,d in ipairs(o:GetDescendants())do if d:IsA("BasePart")then return d.Position end end return nil end
local function promPizza(txt)
	local hrp=HRP()if not hrp then return nil end
	local mp,md=nil,math.huge
	for _,o in ipairs(Workspace:GetDescendants())do
		if o:IsA("ProximityPrompt")and o.ActionText and o.ActionText:lower():find(txt:lower())then
			local p=getPos(o.Parent)if p then local d=(p-hrp.Position).Magnitude if d<md then md=d mp=o end end
		end
	end
	return mp
end
local function localMarcado()
	local c=Workspace:FindFirstChild("Construcoes")if not c then return nil end
	local p=c:FindFirstChild("Pizzaria")if not p then return nil end
	local s=p:FindFirstChild("OrderCharSpawns")if not s then return nil end
	for _,pad in ipairs(s:GetChildren())do
		local m=pad:FindFirstChild("LocalMarcado",true)
		if m then local pos=getPos(m)if pos then return{marcado=m,pos=pos,pad=pad}end end
	end
	return nil
end
local function temPizza()local d=Workspace:FindFirstChild(lp.Name)return d and d:FindFirstChild("PizzaTemplate")~=nil end

local PrisaoSt={v=0,c=0,e=0,i=tick()}
local VASSOURA_KW = {"vassoura","broom","sweep","varrer","limpar","limpeza","clean","mop","esfregona","rodo"}
local function contemAlguma(str, kws)
	if not str then return false end
	str = str:lower()
	for _, k in ipairs(kws) do
		if str:find(k, 1, true) then return true end
	end
	return false
end
local function acharPastaVarredura() return Workspace:FindFirstChild("LocaisVarrer") end
local function acharVassoura()
	if not lp.Character then return nil end
	for _, o in ipairs(lp.Character:GetChildren()) do
		if o:IsA("Tool") and contemAlguma(o.Name, VASSOURA_KW) then return o end
	end
	if lp.Backpack then
		for _, o in ipairs(lp.Backpack:GetChildren()) do
			if o:IsA("Tool") and contemAlguma(o.Name, VASSOURA_KW) then return o end
		end
	end
	return nil
end
local function equipVassoura()
	local hum = HUM()
	if not hum or not lp.Character then return nil end
	for _, o in ipairs(lp.Character:GetChildren()) do
		if o:IsA("Tool") and contemAlguma(o.Name, VASSOURA_KW) then return o end
	end
	local tool = acharVassoura()
	if tool and tool.Parent == lp.Backpack then
		pcall(function() hum:EquipTool(tool) end)
		task.wait(0.5)
		for _, t in ipairs(lp.Character:GetChildren()) do
			if t:IsA("Tool") and contemAlguma(t.Name, VASSOURA_KW) then return t end
		end
	end
	return nil
end
local function proximoPontoVarredura()
	local hrp = HRP() if not hrp then return nil end
	local pasta = acharPastaVarredura() if not pasta then return nil end
	local lista = {}
	for _, p in ipairs(pasta:GetChildren()) do
		if p:IsA("BasePart") and not p:GetAttribute("EmCooldown") then
			local dist = (p.Position - hrp.Position).Magnitude
			table.insert(lista, {part = p, pos = p.Position, dist = dist})
		end
	end
	if #lista == 0 then return nil end
	table.sort(lista, function(a, b) return a.dist < b.dist end)
	return lista[1]
end
local function debugVarredura()
	print("🔍 DEBUG AUTO VARRER v12.8")
	local pasta = acharPastaVarredura()
	if not pasta then print("❌ workspace.LocaisVarrer NÃO encontrado!") else
		print("✅ workspace.LocaisVarrer: " .. pasta:GetFullName())
	end
end
local function promPrisao(txt)
	local hrp=HRP() if not hrp then return nil end
	local mp,md=nil,math.huge
	for _,o in ipairs(Workspace:GetDescendants())do
		if o:IsA("ProximityPrompt")and o.ActionText and o.ActionText:lower():find(txt:lower())then
			local p=o.Parent if p and p:IsA("BasePart")then local d=(p.Position-hrp.Position).Magnitude if d<md then md=d mp=o end end
		end
	end
	return mp
end
local function temCaixa()
	if not lp.Character then return false end
	for _,o in ipairs(lp.Character:GetChildren())do
		if o:IsA("Tool")and(o.Name:lower():find("caixa")or o.Name:lower():find("lixo")or o.Name:lower():find("trash"))then return true end
	end
	return false
end

-- ADM DETECT
local ADM_KW={"admin","adm","mod","moderador","staff","owner","dono","gerente","manager","dev","developer","criador","creator","helper","ajudante","suporte","support","cargo","rank"}
local function contemKw(t,l)if not t then return false end t=t:lower()for _,k in ipairs(l)do if t:find(k,1,true)then return true end end return false end
local function detectAdm(p)
	if not p or p==lp then return false,nil end
	if p.Team and contemKw(p.Team.Name,ADM_KW)then return true,"🏷️ "..p.Team.Name end
	if contemKw(p.DisplayName,ADM_KW)then return true,"👤 Nome"end
	local ls=p:FindFirstChild("leaderstats")
	if ls then for _,s in ipairs(ls:GetChildren())do if contemKw(s.Name,ADM_KW)then if type(s.Value)=="number"and s.Value>0 then return true,"📊 "..s.Name end if type(s.Value)=="string"and s.Value~=""then return true,"📊 "..s.Name end end end end
	return false,nil
end

-- INTERFACE (RESPONSIVA E LIMPA)
local ScreenGui=Instance.new("ScreenGui")ScreenGui.Name="SharkMenu_UI"ScreenGui.ResetOnSpawn=false ScreenGui.IgnoreGuiInset=true ScreenGui.Parent=CoreGui

local function Notif(txt,cor,dur)
	cor=cor or AMARELO dur=dur or 2
	local t=Instance.new("TextLabel")
	t.Text=tostring(txt)t.Font=Enum.Font.GothamBold t.TextSize=12
	t.TextColor3=TEXTO t.BackgroundColor3=CARD t.BackgroundTransparency=0.05
	t.Size=UDim2.new(0,300,0,40)t.Position=UDim2.new(1,-320,0,20)
	t.TextWrapped=true t.Parent=ScreenGui corner(t,10)stroke(t,cor,1,0.4)
	local b=Instance.new("Frame")b.Size=UDim2.new(0,3,1,-12)b.Position=UDim2.new(0,6,0,6)b.BackgroundColor3=cor b.BorderSizePixel=0 b.Parent=t corner(b,2)
	task.delay(dur,function()Tw(t,{BackgroundTransparency=1,TextTransparency=1},0.3)task.wait(0.4)pcall(function()t:Destroy()end)end)
end

local Main=Instance.new("Frame")
Main.Size=UDim2.new(0.9, 0, 0.8, 0)
Main.Position=UDim2.new(0.5,0,0.5,0)Main.AnchorPoint=Vector2.new(0.5,0.5)
Main.BackgroundColor3=FUNDO Main.BorderSizePixel=0 Main.Parent=ScreenGui
local uiScale = Instance.new("UISizeConstraint", Main)
uiScale.MaxSize = Vector2.new(940, 600)
uiScale.MinSize = Vector2.new(320, 480)
corner(Main,12)stroke(Main,AMARELO,1.5,0.6)grad(Main,FUNDO,Color3.fromRGB(15,12,5),90)

local R=Instance.new("Frame")R.Size=UDim2.new(0,220,1,-20)R.Position=UDim2.new(1,-230,0,10)R.BackgroundColor3=PAINEL R.BorderSizePixel=0 R.Parent=Main corner(R,10)
local RT=Instance.new("TextLabel")RT.Size=UDim2.new(1,-20,0,30)RT.Position=UDim2.new(0,10,0,10)RT.BackgroundTransparency=1 RT.Text="👥 Lista de Jogadores (0)"RT.TextColor3=TEXTO RT.TextSize=13 RT.Font=Enum.Font.GothamBold RT.TextXAlignment=Enum.TextXAlignment.Left RT.Parent=R
local RS=Instance.new("TextBox")RS.Size=UDim2.new(1,-20,0,32)RS.Position=UDim2.new(0,10,0,45)RS.BackgroundColor3=INPUT RS.BorderSizePixel=0 RS.Text=""RS.PlaceholderText="🔍 Pesquisar..."RS.PlaceholderColor3=SUB RS.TextColor3=TEXTO RS.TextSize=12 RS.Font=Enum.Font.Gotham RS.Parent=R corner(RS,8)stroke(RS,BORDA,1,0.4)
local RScroll=Instance.new("ScrollingFrame")RScroll.Size=UDim2.new(1,-10,1,-90)RScroll.Position=UDim2.new(0,5,0,80)RScroll.BackgroundTransparency=1 RScroll.BorderSizePixel=0 RScroll.ScrollBarThickness=3 RScroll.ScrollBarImageColor3=AMARELO RScroll.CanvasSize=UDim2.new(0,0,0,0)RScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y RScroll.Parent=R
local RList=Instance.new("UIListLayout")RList.Padding=UDim.new(0,4)RList.Parent=RScroll

local C=Instance.new("Frame")C.Size=UDim2.new(1,-240,1,-20)C.Position=UDim2.new(0,10,0,10)C.BackgroundColor3=PAINEL C.BorderSizePixel=0 C.Parent=Main corner(C,10)
local Header=Instance.new("Frame")Header.Size=UDim2.new(1,0,0,78)Header.BackgroundColor3=INPUT Header.BackgroundTransparency=0.3 Header.BorderSizePixel=0 Header.Parent=C corner(Header,10)
local DragBar=Instance.new("Frame")DragBar.Size=UDim2.new(0,40,0,3)DragBar.Position=UDim2.new(0.5,-20,0,4)DragBar.BackgroundColor3=BORDA DragBar.BorderSizePixel=0 DragBar.Parent=Header corner(DragBar,2)

local LogoTitle=Instance.new("TextLabel")LogoTitle.Size=UDim2.new(0,300,0,22)LogoTitle.Position=UDim2.new(0,20,0,10)LogoTitle.BackgroundTransparency=1 LogoTitle.Text="SHARK MENU"LogoTitle.TextColor3=CIANO LogoTitle.TextSize=20 LogoTitle.Font=Enum.Font.GothamBold LogoTitle.TextXAlignment=Enum.TextXAlignment.Left LogoTitle.Parent=Header
local LogoSub=Instance.new("TextLabel")LogoSub.Size=UDim2.new(0,300,0,14)LogoSub.Position=UDim2.new(0,20,0,31)LogoSub.BackgroundTransparency=1 LogoSub.Text="TIX MONEY VIP"LogoSub.TextColor3=AMARELO LogoSub.TextSize=11 LogoSub.Font=Enum.Font.GothamBold LogoSub.TextXAlignment=Enum.TextXAlignment.Left LogoSub.Parent=Header
local Creditos=Instance.new("TextLabel")Creditos.Size=UDim2.new(0,300,0,12)Creditos.Position=UDim2.new(0,20,0,47)Creditos.BackgroundTransparency=1 Creditos.Text="by becks & kevim • RightShift"Creditos.TextColor3=SUB Creditos.TextSize=9 Creditos.Font=Enum.Font.Gotham Creditos.TextXAlignment=Enum.TextXAlignment.Left Creditos.Parent=Header

local OnInd=Instance.new("Frame")OnInd.Size=UDim2.new(0,100,0,26)OnInd.Position=UDim2.new(1,-230,0.5,-13)OnInd.BackgroundColor3=CARD OnInd.BorderSizePixel=0 OnInd.Parent=Header corner(OnInd,13)stroke(OnInd,VERDE_NEON,1.5,0.2)
local OnDot=Instance.new("Frame")OnDot.Size=UDim2.new(0,8,0,8)OnDot.Position=UDim2.new(0,10,0.5,-4)OnDot.BackgroundColor3=VERDE_NEON OnDot.BorderSizePixel=0 OnDot.Parent=OnInd corner(OnDot,4)
local OnText=Instance.new("TextLabel")OnText.Size=UDim2.new(1,-22,1,0)OnText.Position=UDim2.new(0,22,0,0)OnText.BackgroundTransparency=1 OnText.Text="OK • ONLINE"OnText.Font=Enum.Font.GothamBold OnText.TextSize=9 OnText.TextColor3=VERDE_NEON OnText.TextXAlignment=Enum.TextXAlignment.Left OnText.Parent=OnInd

task.spawn(function()while OnInd.Parent do task.wait(1)pcall(function()Tw(OnDot,{BackgroundTransparency=0.6},0.5)task.wait(0.5)Tw(OnDot,{BackgroundTransparency=0},0.5)end)end end)

-- CONTADOR DE FPS E PING
local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(0, 100, 0, 14)
StatsLabel.Position = UDim2.new(1, -110, 0, 62)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "Ping: -- | FPS: --"
StatsLabel.Font = Enum.Font.Code
StatsLabel.TextSize = 10
StatsLabel.TextColor3 = SUB
StatsLabel.TextXAlignment = Enum.TextXAlignment.Right
StatsLabel.Parent = Header

task.spawn(function()
    while task.wait(1) do
        local ping = math.floor(lp:GetNetworkPing() * 1000)
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        StatsLabel.Text = string.format("Ping: %dms | FPS: %d", ping, fps)
        if ping > 150 or fps < 30 then
            StatsLabel.TextColor3 = VERMELHO
        else
            StatsLabel.TextColor3 = VERDE
        end
    end
end)

local CloseBtn=Instance.new("TextButton")CloseBtn.Size=UDim2.new(0,30,0,30)CloseBtn.Position=UDim2.new(1,-40,0.5,-15)CloseBtn.BackgroundColor3=INPUT CloseBtn.Text="✕"CloseBtn.Font=Enum.Font.GothamBold CloseBtn.TextSize=14 CloseBtn.TextColor3=VERMELHO CloseBtn.BorderSizePixel=0 CloseBtn.AutoButtonColor=false CloseBtn.Parent=Header corner(CloseBtn,8)stroke(CloseBtn,BORDA,1,0.4)
local MinBtn=Instance.new("TextButton")MinBtn.Size=UDim2.new(0,30,0,30)MinBtn.Position=UDim2.new(1,-76,0.5,-15)MinBtn.BackgroundColor3=INPUT MinBtn.Text="−"MinBtn.Font=Enum.Font.GothamBold MinBtn.TextSize=18 MinBtn.TextColor3=AMARELO MinBtn.BorderSizePixel=0 MinBtn.AutoButtonColor=false MinBtn.Parent=Header corner(MinBtn,8)stroke(MinBtn,BORDA,1,0.4)

local Body=Instance.new("Frame")Body.Size=UDim2.new(1,0,1,-78)Body.Position=UDim2.new(0,0,0,78)Body.BackgroundTransparency=1 Body.Parent=C
local InnerMenu=Instance.new("Frame")InnerMenu.Size=UDim2.new(0,165,1,0)InnerMenu.BackgroundTransparency=1 InnerMenu.Parent=Body
local Content=Instance.new("ScrollingFrame")Content.Size=UDim2.new(1,-175,1,0)Content.Position=UDim2.new(0,165,0,0)Content.BackgroundTransparency=1 Content.BorderSizePixel=0 Content.ScrollBarThickness=3 Content.ScrollBarImageColor3=AMARELO Content.CanvasSize=UDim2.new(0,0,0,0)Content.AutomaticCanvasSize=Enum.AutomaticSize.Y Content.Parent=Body
local CList=Instance.new("UIListLayout")CList.Padding=UDim.new(0,8)CList.Parent=Content

local FloatBtn=Instance.new("TextButton")FloatBtn.Size=UDim2.new(0,60,0,60)FloatBtn.Position=UDim2.new(0,20,0.5,-30)FloatBtn.BackgroundColor3=FUNDO FloatBtn.Text="🦈"FloatBtn.TextSize=28 FloatBtn.Font=Enum.Font.GothamBold FloatBtn.TextColor3=CIANO FloatBtn.BorderSizePixel=0 FloatBtn.AutoButtonColor=false FloatBtn.Visible=false FloatBtn.Parent=ScreenGui corner(FloatBtn,30)stroke(FloatBtn,CIANO,2,0.3)

local AdminP=Instance.new("Frame")AdminP.Size=UDim2.new(0,250,0,400)AdminP.Position=UDim2.new(1,-270,0.5,-200)AdminP.BackgroundColor3=FUNDO AdminP.BorderSizePixel=0 AdminP.Visible=false AdminP.Parent=ScreenGui corner(AdminP,12)stroke(AdminP,VERMELHO2,2,0.3)grad(AdminP,FUNDO,Color3.fromRGB(25,5,10),90)
local AH=Instance.new("Frame")AH.Size=UDim2.new(1,0,0,44)AH.BackgroundColor3=CARD AH.BackgroundTransparency=0.3 AH.BorderSizePixel=0 AH.Parent=AdminP corner(AH,12)
local AI=Instance.new("TextLabel")AI.Size=UDim2.new(0,30,0,30)AI.Position=UDim2.new(0,10,0.5,-15)AI.BackgroundColor3=VERMELHO2 AI.Text="🛡️"AI.Font=Enum.Font.GothamBold AI.TextSize=16 AI.BorderSizePixel=0 AI.Parent=AH corner(AI,8)
local AT=Instance.new("TextLabel")AT.Size=UDim2.new(1,-90,1,0)AT.Position=UDim2.new(0,48,0,0)AT.BackgroundTransparency=1 AT.Text="LISTA ADMIN"AT.Font=Enum.Font.GothamBold AT.TextSize=13 AT.TextColor3=VERMELHO2 AT.TextXAlignment=Enum.TextXAlignment.Left AT.Parent=AH
local AC=Instance.new("TextLabel")AC.Size=UDim2.new(0,50,1,0)AC.Position=UDim2.new(1,-80,0,0)AC.BackgroundTransparency=1 AC.Text="0"AC.Font=Enum.Font.GothamBold AC.TextSize=11 AC.TextColor3=AMARELO AC.TextXAlignment=Enum.TextXAlignment.Right AC.Parent=AH
local ABody=Instance.new("Frame")ABody.Size=UDim2.new(1,0,1,-44)ABody.Position=UDim2.new(0,0,0,44)ABody.BackgroundTransparency=1 ABody.Parent=AdminP
local AScroll=Instance.new("ScrollingFrame")AScroll.Size=UDim2.new(1,-10,1,-10)AScroll.Position=UDim2.new(0,5,0,5)AScroll.BackgroundTransparency=1 AScroll.BorderSizePixel=0 AScroll.ScrollBarThickness=3 AScroll.ScrollBarImageColor3=VERMELHO2 AScroll.CanvasSize=UDim2.new(0,0,0,0)AScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y AScroll.Parent=ABody
local ALay=Instance.new("UIListLayout")ALay.Padding=UDim.new(0,4)ALay.Parent=AScroll

local function atualizarAdmins()
	for _,c in ipairs(AScroll:GetChildren())do if not c:IsA("UIListLayout")then c:Destroy()end end
	local admins={}
	for _,p in ipairs(Players:GetPlayers())do if p~=lp then local ok,mot=detectAdm(p)if ok then table.insert(admins,{p=p,mot=mot})end end end
	AC.Text=tostring(#admins)
	if #admins==0 then local e=Instance.new("TextLabel")e.Size=UDim2.new(1,-4,0,50)e.BackgroundColor3=CARD e.Text="✅ Nenhum admin"e.TextColor3=VERDE e.Font=Enum.Font.GothamBold e.TextSize=11 e.BorderSizePixel=0 e.Parent=AScroll corner(e,8)return end
	for _,d in ipairs(admins)do
		local p=d.p
		local card=Instance.new("Frame")card.Size=UDim2.new(1,-4,0,50)card.BackgroundColor3=Color3.fromRGB(45,20,25)card.BorderSizePixel=0 card.Parent=AScroll corner(card,8)stroke(card,VERMELHO2,1.5,0.3)
		local av=Instance.new("Frame")av.Size=UDim2.new(0,32,0,32)av.Position=UDim2.new(0,8,0,9)av.BackgroundColor3=VERMELHO2 av.BorderSizePixel=0 av.Parent=card corner(av,16)
		local avL=Instance.new("TextLabel")avL.Size=UDim2.new(1,0,1,0)avL.BackgroundTransparency=1 avL.Text=string.sub(p.Name,1,1):upper()avL.Font=Enum.Font.GothamBold avL.TextSize=14 avL.TextColor3=TEXTO avL.Parent=av
		local nL=Instance.new("TextLabel")nL.Size=UDim2.new(1,-60,0,16)nL.Position=UDim2.new(0,46,0,7)nL.BackgroundTransparency=1 nL.Text=p.Name nL.Font=Enum.Font.GothamBold nL.TextSize=11 nL.TextColor3=TEXTO nL.TextXAlignment=Enum.TextXAlignment.Left nL.TextTruncate=Enum.TextTruncate.AtEnd nL.Parent=card
		local rL=Instance.new("TextLabel")rL.Size=UDim2.new(1,-60,0,14)rL.Position=UDim2.new(0,46,0,25)rL.BackgroundTransparency=1 rL.Text=d.mot or ""rL.Font=Enum.Font.Gotham rL.TextSize=9 rL.TextColor3=AMARELO rL.TextXAlignment=Enum.TextXAlignment.Left rL.TextTruncate=Enum.TextTruncate.AtEnd rL.Parent=card
	end
end

Players.PlayerAdded:Connect(function()task.wait(0.5)atualizarAdmins()end)
Players.PlayerRemoving:Connect(function()task.wait(0.5)atualizarAdmins()end)
task.spawn(function()while ScreenGui.Parent do task.wait(5)if CFG.listaAdmin and AdminP.Visible then pcall(atualizarAdmins)end end end)

local function atualizarJogadores()
	for _,c in ipairs(RScroll:GetChildren())do if not c:IsA("UIListLayout")then c:Destroy()end end
	local pls=Players:GetPlayers()
	RT.Text="👥 Lista de Jogadores ("..#pls..")"
	for _,p in ipairs(pls)do
		local me=(p==lp)
		local card=Instance.new("Frame")card.Size=UDim2.new(1,-4,0,36)card.BackgroundColor3=me and Color3.fromRGB(35,45,25)or CARD card.BorderSizePixel=0 card.Parent=RScroll corner(card,8)stroke(card,me and AMARELO or BORDA,1,0.5)
		local av=Instance.new("Frame")av.Size=UDim2.new(0,24,0,24)av.Position=UDim2.new(0,6,0.5,-12)av.BackgroundColor3=me and AMARELO or AZUL av.BorderSizePixel=0 av.Parent=card corner(av,12)
		local avL=Instance.new("TextLabel")avL.Size=UDim2.new(1,0,1,0)avL.BackgroundTransparency=1 avL.Text=string.sub(p.Name,1,1):upper()avL.Font=Enum.Font.GothamBold avL.TextSize=11 avL.TextColor3=FUNDO avL.Parent=av
		local nL=Instance.new("TextLabel")nL.Size=UDim2.new(1,-70,1,0)nL.Position=UDim2.new(0,36,0,0)nL.BackgroundTransparency=1 nL.Text=p.Name nL.Font=Enum.Font.GothamBold nL.TextSize=11 nL.TextColor3=me and AMARELO or TEXTO nL.TextXAlignment=Enum.TextXAlignment.Left nL.TextTruncate=Enum.TextTruncate.AtEnd nL.Parent=card
		if not me then
			local tp=Instance.new("TextButton")tp.Size=UDim2.new(0,24,0,24)tp.Position=UDim2.new(1,-54,0.5,-12)tp.BackgroundColor3=INPUT tp.Text="🎯"tp.Font=Enum.Font.GothamBold tp.TextSize=11 tp.TextColor3=VERDE tp.BorderSizePixel=0 tp.AutoButtonColor=false tp.Parent=card corner(tp,6)stroke(tp,BORDA,1,0.4)
			tp.MouseButton1Click:Connect(function()local tc=p.Character if tc then local th=tc:FindFirstChild("HumanoidRootPart")local mh=HRP()if th and mh then mh.CFrame=th.CFrame+Vector3.new(0,0,5)Notif("🎯 TP: "..p.Name,VERDE,1.5)end end end)
			local sp=Instance.new("TextButton")sp.Size=UDim2.new(0,24,0,24)sp.Position=UDim2.new(1,-28,0.5,-12)sp.BackgroundColor3=INPUT sp.Text="👁️"sp.Font=Enum.Font.GothamBold sp.TextSize=11 sp.TextColor3=AZUL sp.BorderSizePixel=0 sp.AutoButtonColor=false sp.Parent=card corner(sp,6)stroke(sp,BORDA,1,0.4)
			sp.MouseButton1Click:Connect(function()if Spec.Target==p then specOff()Notif("👁️ Parou",AMARELO,1.5)else specOn(p)Notif("👁️ Espectando: "..p.Name,AZUL,1.5)end end)
		end
	end
end
Players.PlayerAdded:Connect(function()task.wait(0.5)atualizarJogadores()end)
Players.PlayerRemoving:Connect(function()task.wait(0.5)atualizarJogadores()end)
atualizarJogadores()

local function limpar()for _,c in ipairs(Content:GetChildren())do if not c:IsA("UIListLayout")then c:Destroy()end end end
local function secao(txt,cor,parent)parent=parent or Content local f=Instance.new("Frame")f.Size=UDim2.new(1,-10,0,24)f.BackgroundTransparency=1 f.Parent=parent local d=Instance.new("Frame")d.Size=UDim2.new(0,4,0,14)d.Position=UDim2.new(0,3,0.5,-7)d.BackgroundColor3=cor or AMARELO d.BorderSizePixel=0 d.Parent=f corner(d,2)local l=Instance.new("TextLabel")l.Text=txt:upper()l.Font=Enum.Font.GothamBold l.TextSize=10 l.TextColor3=cor or AMARELO l.BackgroundTransparency=1 l.Position=UDim2.new(0,16,0,0)l.Size=UDim2.new(1,-16,1,0)l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=f end
local function botao(txt,cor,call,parent)
	parent=parent or Content
	local b=Instance.new("TextButton")b.Text=txt b.Font=Enum.Font.GothamBold b.TextSize=12 b.TextColor3=TEXTO b.BackgroundColor3=CARD b.BorderSizePixel=0 b.Size=UDim2.new(1,-10,0,38)b.AutoButtonColor=false b.Parent=parent corner(b,8)
	local s=stroke(b,BORDA,1,0.4)
	b.MouseEnter:Connect(function()Tw(b,{BackgroundColor3=CARD_HOVER},0.15)Tw(s,{Color=cor or AMARELO,Transparency=0.2},0.15)end)
	b.MouseLeave:Connect(function()Tw(b,{BackgroundColor3=CARD},0.15)Tw(s,{Color=BORDA,Transparency=0.4},0.15)end)
	b.MouseButton1Click:Connect(function()Tw(b,{BackgroundColor3=cor or AMARELO},0.08)task.wait(0.1)Tw(b,{BackgroundColor3=CARD},0.15)if call then task.spawn(call)end end)
	return b
end
local function toggle(txt,def,cor,call,parent)
	parent=parent or Content
	local f=Instance.new("Frame")f.Size=UDim2.new(1,-10,0,42)f.BackgroundColor3=CARD f.BorderSizePixel=0 f.Parent=parent corner(f,8)stroke(f,BORDA,1,0.4)
	local l=Instance.new("TextLabel")l.Text=txt l.Font=Enum.Font.GothamBold l.TextSize=12 l.TextColor3=TEXTO l.BackgroundTransparency=1 l.Position=UDim2.new(0,14,0,0)l.Size=UDim2.new(1,-80,1,0)l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=f
	local bg=Instance.new("Frame")bg.Size=UDim2.new(0,44,0,22)bg.Position=UDim2.new(1,-56,0.5,-11)bg.BackgroundColor3=Color3.fromRGB(50,50,60)bg.BorderSizePixel=0 bg.Parent=f corner(bg,11)
	local k=Instance.new("Frame")k.Size=UDim2.new(0,18,0,18)k.Position=UDim2.new(0,2,0.5,-9)k.BackgroundColor3=Color3.fromRGB(200,200,210)k.BorderSizePixel=0 k.Parent=bg corner(k,9)
	local st=def or false
	local function set(v)
		st=v
		if st then Tw(bg,{BackgroundColor3=cor or VERDE},0.2)Tw(k,{Position=UDim2.new(1,-20,0.5,-9),BackgroundColor3=Color3.fromRGB(255,255,255)},0.2)
		else Tw(bg,{BackgroundColor3=Color3.fromRGB(50,50,60)},0.2)Tw(k,{Position=UDim2.new(0,2,0.5,-9),BackgroundColor3=Color3.fromRGB(200,200,210)},0.2)end
		if call then call(st)end
	end
	if st then bg.BackgroundColor3=cor or VERDE k.Position=UDim2.new(1,-20,0.5,-9)k.BackgroundColor3=Color3.fromRGB(255,255,255)end
	local cl=Instance.new("TextButton")cl.Text=""cl.BackgroundTransparency=1 cl.Size=UDim2.new(1,0,1,0)cl.Parent=f
	cl.MouseButton1Click:Connect(function()set(not st)end)
	return set
end
local function statL(txt,cor,parent)parent=parent or Content local f=Instance.new("Frame")f.Size=UDim2.new(1,-10,0,30)f.BackgroundColor3=CARD f.BorderSizePixel=0 f.Parent=parent corner(f,6)stroke(f,BORDA,1,0.5)local l=Instance.new("TextLabel")l.Text=txt l.Font=Enum.Font.GothamBold l.TextSize=11 l.TextColor3=cor or TEXTO l.BackgroundTransparency=1 l.Position=UDim2.new(0,12,0,0)l.Size=UDim2.new(1,-20,1,0)l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=f return l end
local function slider(label,min,max,def,cor,call,parent)
	parent=parent or Content
	local fr=Instance.new("Frame")fr.Size=UDim2.new(1,-10,0,56)fr.BackgroundColor3=CARD fr.BorderSizePixel=0 fr.Parent=parent corner(fr,8)stroke(fr,BORDA,1,0.4)
	local tt=Instance.new("TextLabel")tt.Text=label tt.Font=Enum.Font.GothamBold tt.TextSize=12 tt.TextColor3=TEXTO tt.BackgroundTransparency=1 tt.Position=UDim2.new(0,14,0,6)tt.Size=UDim2.new(0.7,0,0,18)tt.TextXAlignment=Enum.TextXAlignment.Left tt.Parent=fr
	local vl=Instance.new("TextLabel")vl.Text=tostring(def)vl.Font=Enum.Font.GothamBold vl.TextSize=13 vl.TextColor3=cor or VERDE vl.BackgroundTransparency=1 vl.Position=UDim2.new(0.7,0,0,6)vl.Size=UDim2.new(0.3,-14,0,18)vl.TextXAlignment=Enum.TextXAlignment.Right vl.Parent=fr
	local bb=Instance.new("Frame")bb.Size=UDim2.new(1,-28,0,10)bb.Position=UDim2.new(0,14,0,32)bb.BackgroundColor3=Color3.fromRGB(40,40,50)bb.BorderSizePixel=0 bb.Parent=fr corner(bb,5)
	local fb=Instance.new("Frame")fb.Size=UDim2.new(0,0,1,0)fb.BackgroundColor3=cor or AMARELO fb.BorderSizePixel=0 fb.Parent=bb corner(fb,5)grad(fb,cor or AMARELO,ROXO,0)
	local kb=Instance.new("Frame")kb.Size=UDim2.new(0,16,0,16)kb.Position=UDim2.new(0,-8,0.5,-8)kb.BackgroundColor3=Color3.fromRGB(255,255,255)kb.BorderSizePixel=0 kb.Parent=bb corner(kb,8)
	local val=def local arr=false
	local function ap(p)val=math.floor(min+(max-min)*p)vl.Text=tostring(val)fb.Size=UDim2.new(p,0,1,0)kb.Position=UDim2.new(p,-8,0.5,-8)if call then call(val)end end
	local function at(x)local ba=bb.AbsolutePosition.X local bs=bb.AbsoluteSize.X ap(math.clamp((x-ba)/bs,0,1))end
	local ip=(def-min)/(max-min)fb.Size=UDim2.new(ip,0,1,0)kb.Position=UDim2.new(ip,-8,0.5,-8)
	local ba=Instance.new("TextButton")ba.Text=""ba.BackgroundTransparency=1 ba.Size=UDim2.new(1,0,1,20)ba.Position=UDim2.new(0,0,0.5,-10)ba.Parent=bb
	ba.MouseButton1Down:Connect(function()arr=true at(UserInput:GetMouseLocation().X)end)
	UserInput.InputChanged:Connect(function(i)if arr and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then at(i.Position.X)end end)
	UserInput.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then arr=false end end)
	return function(v)v=math.clamp(v,min,max)ap((v-min)/(max-min))end
end
local function dropdown(label,opts,def,cor,call,parent)
	parent=parent or Content
	local fr=Instance.new("Frame")fr.Size=UDim2.new(1,-10,0,42)fr.BackgroundColor3=CARD fr.BorderSizePixel=0 fr.Parent=parent corner(fr,8)stroke(fr,BORDA,1,0.4)
	local l=Instance.new("TextLabel")l.Text=label l.Font=Enum.Font.GothamBold l.TextSize=11 l.TextColor3=TEXTO l.BackgroundTransparency=1 l.Position=UDim2.new(0,14,0,0)l.Size=UDim2.new(0.5,0,1,0)l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=fr
	local idx=1 for i,o in ipairs(opts)do if o==def then idx=i end end
	local btn=Instance.new("TextButton")btn.Size=UDim2.new(0,140,1,-12)btn.Position=UDim2.new(1,-148,0.5,-14)btn.BackgroundColor3=INPUT btn.Text=opts[idx]btn.Font=Enum.Font.GothamBold btn.TextSize=11 btn.TextColor3=cor or VERDE btn.BorderSizePixel=0 btn.AutoButtonColor=false btn.Parent=fr corner(btn,6)
	btn.MouseButton1Click:Connect(function()idx=idx+1 if idx>#opts then idx=1 end btn.Text=opts[idx]if call then call(opts[idx])end end)
end
local function inputVal(parent,ph,call)
	local fr=Instance.new("Frame")fr.Size=UDim2.new(1,-10,0,42)fr.BackgroundColor3=CARD fr.BorderSizePixel=0 fr.Parent=parent corner(fr,8)stroke(fr,BORDA,1,0.4)
	local inp=Instance.new("TextBox")inp.Size=UDim2.new(1,-90,1,-12)inp.Position=UDim2.new(0,8,0.5,-14)inp.BackgroundColor3=INPUT inp.BorderSizePixel=0 inp.Text=""inp.PlaceholderText=ph or "Digite..."inp.PlaceholderColor3=SUB inp.TextColor3=TEXTO inp.TextSize=12 inp.Font=Enum.Font.Gotham inp.ClearTextOnFocus=false inp.Parent=fr corner(inp,6)
	local btn=Instance.new("TextButton")btn.Size=UDim2.new(0,70,1,-12)btn.Position=UDim2.new(1,-78,0.5,-14)btn.BackgroundColor3=VERDE btn.Text="APLICAR"btn.Font=Enum.Font.GothamBold btn.TextSize=10 btn.TextColor3=FUNDO btn.BorderSizePixel=0 btn.AutoButtonColor=false btn.Parent=fr corner(btn,6)
	btn.MouseButton1Click:Connect(function()local n=tonumber(inp.Text)if n and call then task.spawn(call,n)else Notif("⚠️ Número inválido!",VERMELHO,1.5)end end)
	return inp
end
local function secaoCol(parent,titulo,subtitulo,icone,cor,id)
	local w=Instance.new("Frame")w.Size=UDim2.new(1,-10,0,48)w.AutomaticSize=Enum.AutomaticSize.Y w.BackgroundTransparency=1 w.Parent=parent
	local wl=Instance.new("UIListLayout")wl.Padding=UDim.new(0,6)wl.Parent=w
	local h=Instance.new("Frame")h.Size=UDim2.new(1,0,0,48)h.BackgroundColor3=CARD h.BorderSizePixel=0 h.Parent=w corner(h,10)stroke(h,cor,1.5,0.3)grad(h,Color3.fromRGB(20,35,25),CARD,90)
	local ic=Instance.new("Frame")ic.Size=UDim2.new(0,36,0,36)ic.Position=UDim2.new(0,10,0.5,-18)ic.BackgroundColor3=cor ic.BorderSizePixel=0 ic.Parent=h corner(ic,8)
	local icL=Instance.new("TextLabel")icL.Size=UDim2.new(1,0,1,0)icL.BackgroundTransparency=1 icL.Text=icone icL.TextSize=18 icL.Font=Enum.Font.GothamBold icL.Parent=ic
	local t=Instance.new("TextLabel")t.Size=UDim2.new(1,-100,0,18)t.Position=UDim2.new(0,56,0,8)t.BackgroundTransparency=1 t.Text=titulo t.Font=Enum.Font.GothamBold t.TextSize=13 t.TextColor3=cor t.TextXAlignment=Enum.TextXAlignment.Left t.Parent=h
	local s=Instance.new("TextLabel")s.Size=UDim2.new(1,-100,0,14)s.Position=UDim2.new(0,56,0,26)s.BackgroundTransparency=1 s.Text=subtitulo s.Font=Enum.Font.Gotham s.TextSize=9 s.TextColor3=SUB s.TextXAlignment=Enum.TextXAlignment.Left s.Parent=h
	local mb=Instance.new("TextButton")mb.Size=UDim2.new(0,30,0,30)mb.Position=UDim2.new(1,-40,0.5,-15)mb.BackgroundColor3=INPUT mb.Text="−"mb.Font=Enum.Font.GothamBold mb.TextSize=18 mb.TextColor3=cor mb.BorderSizePixel=0 mb.AutoButtonColor=false mb.Parent=h corner(mb,8)stroke(mb,BORDA,1,0.4)
	mb.MouseEnter:Connect(function()Tw(mb,{BackgroundColor3=cor},0.15)Tw(mb,{TextColor3=FUNDO},0.15)end)
	mb.MouseLeave:Connect(function()Tw(mb,{BackgroundColor3=INPUT},0.15)if not id.min then Tw(mb,{TextColor3=cor},0.15)else Tw(mb,{TextColor3=AMARELO},0.15)end end)
	local body=Instance.new("Frame")body.Size=UDim2.new(1,0,0,0)body.AutomaticSize=Enum.AutomaticSize.Y body.BackgroundTransparency=1 body.Parent=w
	local bl=Instance.new("UIListLayout")bl.Padding=UDim.new(0,8)bl.Parent=body
	id.min=false
	mb.MouseButton1Click:Connect(function()id.min=not id.min if id.min then body.Visible=false mb.Text="+"mb.TextSize=20 Tw(mb,{TextColor3=AMARELO},0.15)else body.Visible=true mb.Text="−"mb.TextSize=18 Tw(mb,{TextColor3=cor},0.15)end end)
	return body,id
end

local tabs={}
tabs["Jogador"]=function()
	secao("👤 Informações",AMARELO)
	statL("👤 Nome: "..lp.Name)
	statL("🆔 UserId: "..lp.UserId)
	local h=HUM()statL("❤️ Vida: "..(h and math.floor(h.Health)or"?").." / "..(h and math.floor(h.MaxHealth)or"?"),VERDE)
	statL("🔑 "..(_G.SailentNome or "?").." ["..(_G.SailentNivel or "?").."]",CIANO)
	
	secao("🚑 Sistema de Revive", VERDE)
	toggle("🚑 Auto Reviver", CFG.autoReviver, VERDE, function(s) CFG.autoReviver = s saveCfg() end)
	toggle("⚡ TP Rápido para Maca", CFG.macaTP, AZUL, function(s) CFG.macaTP = s saveCfg() end)
	slider("⏱️ Tempo na Maca (Seg)", 1, 30, CFG.macaTempo or 5, VERDE, function(v) CFG.macaTempo = v saveCfg() end)
	botao("📍 Salvar Posição Atual da Maca", LARANJA, function()
		local hrp = HRP()
		if hrp then
			CFG.macaPos = {x=hrp.Position.X, y=hrp.Position.Y, z=hrp.Position.Z}
			saveCfg()
			Notif("📍 Maca salva nas configs!", LARANJA, 2)
		end
	end)
	statL("Coord. atual: "..(CFG.macaPos and string.format("%.1f, %.1f, %.1f",CFG.macaPos.x,CFG.macaPos.y,CFG.macaPos.z) or "N/A"), SUB)

	secao("🚨 PROTEÇÃO SUPREMA",VERMELHO2)
	toggle("🛡️ Anti-Staff (Server Hop)", CFG.protecaoStaff, VERMELHO2, function(s) 
		CFG.protecaoStaff = s 
		if s then Notif("🛡️ Proteção Staff ATIVADA!", VERMELHO2, 2) else Notif("⚠️ Proteção DESATIVADA", AMARELO, 2) end
		saveCfg() 
	end)
	statL("Se um admin entrar, você será movido para outro servidor.", SUB)

	secao("🛡️ Lista Admin (servidor)",VERMELHO2)
	local admL=statL("Status: DESATIVADA",SUB)
	local function atual()if CFG.listaAdmin then local ct=0 for _,p in ipairs(Players:GetPlayers())do if p~=lp then local o=detectAdm(p)if o then ct=ct+1 end end end admL.Text="Status: ● ATIVA • "..ct.." admin(s)"admL.TextColor3=VERMELHO2 else admL.Text="Status: DESATIVADA"admL.TextColor3=SUB end end
	toggle("🛡️ Ativar Lista Admin",CFG.listaAdmin,VERMELHO2,function(s)CFG.listaAdmin=s AdminP.Visible=s if s then atualizarAdmins()Notif("🛡️ ATIVADA",VERMELHO2,2)else Notif("🛡️ DESATIVADA",AMARELO,1.5)end atual()saveCfg()end)
	botao("🔄 Atualizar Lista Admin",VERMELHO2,function()if CFG.listaAdmin then atualizarAdmins()atual()Notif("🔄 Atualizado!",VERMELHO2,1.5)else Notif("⚠️ Ative primeiro!",AMARELO,1.5)end end)
	
	secao("⚡ Ações Rápidas",VERMELHO)
	botao("🔄 Resetar Personagem",VERMELHO,function()
		local c=lp.Character
		if c then c:BreakJoints()end
		Notif("🔄 Resetado!",VERMELHO)
	end)
	botao("💚 Restaurar Vida",VERDE,function()local h=HUM()if h then h.Health=h.MaxHealth end Notif("💚 Vida restaurada!",VERDE)end)
	task.spawn(function()while admL and admL.Parent do task.wait(3)pcall(atual)end end)
end

tabs["Aimbot"]=function()
	secao("🎯 Aimbot",VERDE_NEON)
	statL("Segure a tecla pra ativar",SUB)
	local stL=statL("Status: DESATIVADO",SUB)
	task.spawn(function()while stL and stL.Parent do task.wait(0.2)if CFG.aimbotEnabled then stL.Text="Status: ● ATIVO"..(Aimbot.Target and " [🎯 "..Aimbot.Target.Name.."]"or" [procurando]")stL.TextColor3=VERDE_NEON else stL.Text="Status: DESATIVADO"stL.TextColor3=SUB end end end)
	secao("⚙️ Configuração",AMARELO)
	dropdown("Modo",{"Camera","Mouse"},CFG.aimbotMode,VERDE_NEON,function(v)CFG.aimbotMode=v saveCfg()end)
	dropdown("Target",{"Head","HumanoidRootPart","UpperTorso","Torso"},CFG.aimbotTargetPart,VERDE_NEON,function(v)CFG.aimbotTargetPart=v saveCfg()end)
	slider("🎯 FOV",30,400,CFG.aimbotFov,VERDE_NEON,function(v)CFG.aimbotFov=v atualizarFOV()saveCfg()end)
	slider("💨 Smoothness (%)",0,90,math.floor(CFG.aimbotSmoothness*100),AZUL,function(v)CFG.aimbotSmoothness=v/100 saveCfg()end)
	secao("🔫 Comportamento",AMARELO)
	toggle("🖱️ Auto-Shoot",CFG.aimbotAutoShoot,VERMELHO2,function(s)CFG.aimbotAutoShoot=s saveCfg()end)
	toggle("👥 Team Check",CFG.aimbotTeamCheck,AZUL,function(s)CFG.aimbotTeamCheck=s saveCfg()end)
	toggle("🧱 Wall Check",CFG.aimbotWallCheck,AMARELO,function(s)CFG.aimbotWallCheck=s saveCfg()end)
	toggle("⭕ FOV Circle",CFG.aimbotFovCircle,VERDE_NEON,function(s)CFG.aimbotFovCircle=s if s then criarFOV()else if Aimbot.FOV then pcall(function()Aimbot.FOV:Destroy()end)Aimbot.FOV=nil end end saveCfg()end)
	toggle("🔍 Hitbox Expander (Fácil)",CFG.hitboxExpander,CIANO,function(s)CFG.hitboxExpander=s saveCfg()end)
	secao("⌨️ Tecla",AMARELO)
	statL("Tecla atual: "..CFG.aimbotKey,VERDE_NEON)
	botao("🎮 Alterar Tecla",AMARELO,function()
		Notif("Pressione uma tecla...",AMARELO,5)
		local conn
		conn=UserInput.InputBegan:Connect(function(inp)
			if inp.UserInputType==Enum.UserInputType.Keyboard then
				CFG.aimbotKey=inp.KeyCode.Name
				Notif("✅ "..CFG.aimbotKey,VERDE,2)
				saveCfg()
				pcall(function()conn:Disconnect()end)
				limpar()tabs["Aimbot"]()
			end
		end)
	end)
	if CFG.aimbotFovCircle then criarFOV()end
end

tabs["Visual"]=function()
	secao("👁️ Visual",CIANO)
	toggle("🔦 FPS Booster",CFG.fpsBoost,VERDE,function(s)
		CFG.fpsBoost = s
		if s then
			pcall(function() Lighting.GlobalShadows = false end)
			pcall(function() Lighting.FogEnd = 9e9 end)
			pcall(function() settings().Rendering.QualityLevel = "Level01" end)
			Notif("🚀 FPS Boost ATIVADO", VERDE)
		else
			pcall(function() Lighting.GlobalShadows = true end)
			pcall(function() Lighting.FogEnd = 100000 end)
			pcall(function() settings().Rendering.QualityLevel = "Level07" end)
			Notif("🔄 Gráficos restaurados", AMARELO)
		end
		saveCfg()
	end)
	toggle("🌞 Fullbright (Luz)", CFG.fullbright, AMARELO, function(s)
		CFG.fullbright = s
		if s then
			Lighting.Ambient = Color3.fromRGB(178, 178, 178)
			Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
			Lighting.Brightness = 3
		else
			Lighting.Ambient = Color3.fromRGB(0, 0, 0)
			Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
			Lighting.Brightness = 1
		end
		saveCfg()
	end)
	botao("🌫️ Remover Névoa",AMARELO,function()Lighting.FogEnd=100000 Lighting.FogStart=0 Notif("🌫️ OK!",AMARELO)end)
	botao("☀️ Meio-dia",AMARELO,function()Lighting.ClockTime=12 Notif("☀️ OK!",AMARELO)end)
	botao("🌙 Meia-noite",AMARELO,function()Lighting.ClockTime=0 Notif("🌙 OK!",AMARELO)end)
end

tabs["Tróli"]=function()
	secao("😜 Diversão",ROXO)
	botao("💃 Dançar",ROXO,function()local h=HUM()if h then h:ChangeState(Enum.HumanoidStateType.Jumping)end end)
	botao("😴 Deitar",ROXO,function()local h=HUM()if h then h.PlatformStand=true end end)
	botao("🕺 Levantar",ROXO,function()local h=HUM()if h then h.PlatformStand=false end end)
end

tabs["Exploits"]=function()
	secao("🐛 Exploits Rápidos",CIANO)
	toggle("🔄 Auto-Rejoin (Anti-Kick)",CFG.autoRejoin,AZUL,function(s)CFG.autoRejoin=s saveCfg()end)
	toggle("🖱️ Click TP (Tocar p/ ir)",CFG.clickTP,AZUL,function(s)CFG.clickTP = s saveCfg()end)
	toggle("🦘 Pulo Infinito",CFG.infiniteJump,VERDE,function(s)CFG.infiniteJump = s saveCfg()end)
	toggle("🤸 Anti-Ragdoll (Não cair)",CFG.antiRagdoll,VERDE,function(s)CFG.antiRagdoll = s saveCfg()end)
	toggle("❄️ Freeze Player", false, CIANO, function(s)
		local hrp = HRP()
		if hrp then hrp.Anchored = s end
	end)
	toggle("⚡ Fast Farm (Rápido)",CFG.fastFarm,AMARELO2,function(s)CFG.fastFarm = s saveCfg()end)

	secao("🚗 Anti-Despawn (Manter Carro)",LARANJA)
	local carBox = inputVal(Content, "Nome do carro (Ex: Lixeiro)", function() end)
	carBox.Text = CFG.carroNome
	carBox.FocusLost:Connect(function()
		CFG.carroNome = carBox.Text
		saveCfg()
		Notif("🚗 Carro definido: "..CFG.carroNome, LARANJA)
	end)
	slider("⏱️ Tempo p/ Sentar (Min)", 5, 30, CFG.carroTempo, LARANJA, function(v) CFG.carroTempo = v saveCfg() end)
	toggle("🔄 Ativar Manter Carro Vivo", CFG.antiDespawn, LARANJA, function(s)
		CFG.antiDespawn = s
		if s then Notif("🚗 Anti-Despawn ON", LARANJA) else Notif("🚗 Anti-Despawn OFF", AMARELO) end
		saveCfg()
	end)

	local gID={min=false}
	local gB=secaoCol(Content,"SAILENT GARI","Auto Gari v9.0","🗑️",VERDE,gID)
	local gS=statL("Status: PARADO",SUB,gB)
	local gSt=statL("Coletados: 0 | Entregues: 0",SUB,gB)
	local gOn=false gRun=0

	local function cicloG(myRun)
		if not HRP()then gS.Text="⏳"task.wait(1)return end
		gS.TextColor3=VERDE
		if temLixo()then
			gS.Text="📤 Indo pra traseira..."
			local cam=getCaminhao()
			if not cam then gS.Text="⚠️ Spawne caminhão!"task.wait(2)return end
			local tr=getTraseira(cam)
			local pos=posDe(tr)
			if tr and pos then
				irPara(pos,25)
				if myRun~=gRun then return end
				task.wait(CFG.fastFarm and 0.1 or 0.3)
				gS.Text="📤 Entregando..."
				local p=getPrompt(tr)
				if p then
					pcall(function()fireproximityprompt(p)end)
					task.wait(CFG.fastFarm and 0.2 or 0.5)
					if not temLixo()then GariSt.e=GariSt.e+1 Notif("📤 Entregue!",AMARELO,1.5)end
				end
			else gS.Text="⚠️ Sem traseira"task.wait(1.5)end
		else
			gS.Text="📥 Procurando..."
			local l=proxLixo()
			if l then
				irPara(l.Position,25)
				if myRun~=gRun then return end
				task.wait(CFG.fastFarm and 0.1 or 0.3)
				gS.Text="📥 Coletando..."
				local p=getPrompt(l)
				if p then
					pcall(function()fireproximityprompt(p)end)
					task.wait(CFG.fastFarm and 0.2 or 0.5)
					if temLixo()then GariSt.c=GariSt.c+1 lixosUsados[l]=true Notif("📥 Coletado!",VERDE,1.2)end
				end
			else gS.Text="⚠️ Sem lixo"task.wait(1.5)end
		end
		gSt.Text="Coletados: "..GariSt.c.." | Entregues: "..GariSt.e
	end

	toggle("🗑️ Ativar Sailent Gari",CFG.autoGari,VERDE,function(s)
		gOn=s CFG.autoGari=s gRun=gRun+1 saveCfg()
		if s then
			local myRun=gRun
			if CFG.noclip then noclipOn()end
			local h=HUM()if h then h.WalkSpeed=CFG.vel end
			gS.Text="Status: ● ATIVO"gS.TextColor3=VERDE
			Notif("🗑️ Gari ATIVADO",VERDE,1.5)
			task.spawn(function()
				while gOn and myRun==gRun do
					local ok,e=pcall(cicloG,myRun)
					if not ok then gS.Text="⚠️ "..tostring(e):sub(1,38)gS.TextColor3=VERMELHO task.wait(2)end
					task.wait(CFG.fastFarm and 0.1 or 0.3)
				end
			end)
		else
			if CFG.noclip then noclipOff()end
			gS.Text="Status: PARADO"gS.TextColor3=SUB
			Notif("🗑️ Gari DESATIVADO",AMARELO,1.5)
			local h=HUM()if h then h.WalkSpeed=16 end
		end
	end,gB)
	local sG=statL(rg(),TEXTO,gB)
	task.spawn(function()while sG and sG.Parent do task.wait(1)pcall(function()sG.Text=rg()end)end end)

	local eID={min=false}
	local eB=secaoCol(Content,"SAILENT ELETRICISTA","Auto Eletricista v3.5","⚡",LARANJA,eID)
	local eS=statL("Status: PARADO",SUB,eB)
	local eSt=statL("⚡ Postes: 0/0",SUB,eB)
	
	-- BARRA DE PROGRESSO DO ELETRICISTA
	local eBarBg = Instance.new("Frame")
	eBarBg.Size = UDim2.new(1,0,0,16)
	eBarBg.BackgroundColor3 = INPUT
	eBarBg.BorderSizePixel = 0
	eBarBg.Parent = eB
	corner(eBarBg, 7)
	stroke(eBarBg, BORDA, 1, 0.5)

	local eBarFill = Instance.new("Frame")
	eBarFill.Size = UDim2.new(0,0,1,0)
	eBarFill.BackgroundColor3 = LARANJA
	eBarFill.BorderSizePixel = 0
	eBarFill.Parent = eBarBg
	corner(eBarFill, 7)
	grad(eBarFill, LARANJA, AMARELO, 0)

	local eBarText = Instance.new("TextLabel")
	eBarText.Size = UDim2.new(1,0,1,0)
	eBarText.BackgroundTransparency = 1
	eBarText.Text = ""
	eBarText.Font = Enum.Font.GothamBold
	eBarText.TextSize = 11
	eBarText.TextColor3 = TEXTO
	eBarText.TextXAlignment = Enum.TextXAlignment.Center
	eBarText.Parent = eBarBg

	slider("⏱️ Tempo no Poste (Seg)", 0, 600, CFG.esperaPoste or 180, LARANJA, function(v) CFG.esperaPoste = v saveCfg() end, eB)

	local eOn=false eRun=0

	local function cicloE(myRun)
		if not HRP()then eS.Text="⏳"task.wait(1)return end
		eS.TextColor3=LARANJA
		
		if not temEscada()then
			local carro=acharCarro()
			if carro then
				eS.Text="📥 Indo pegar escada..."
				irPara(carro:GetPivot().Position,20)
				if myRun~=eRun then return end
				task.wait(CFG.fastFarm and 0.1 or 0.3)
				eS.Text="📥 Pegando escada..."
				local p=promEscada()
				if p then pcall(function()fireproximityprompt(p)end)task.wait(CFG.fastFarm and 0.5 or 1.0)end
				task.wait(CFG.fastFarm and 0.1 or 0.3)
				equipEscada()
				task.wait(CFG.fastFarm and 0.1 or 0.3)
				eS.Text="✅ Escada equipada!"
				Notif("🪜 Escada!",LARANJA,1.5)
			else eS.Text="⚠️ Carro não encontrado"task.wait(2)end
			return
		end

		local info = proxPoste()
		if not info then
			eS.Text="⚠️ Sem poste"
			task.wait(2)
			return
		end
		
		eS.Text="📥 Indo pro poste..."
		irPara(info.pos+Vector3.new(0,0,-4),25)
		if myRun~=eRun then return end
		task.wait(CFG.fastFarm and 0.1 or 0.3)
		
		local posteModel = nil
		local p=Workspace:FindFirstChild("Complementos")
		local po=p and p:FindFirstChild("Postes")
		if po then
			local hrp = HRP()
			local md = 25
			for _, pt in ipairs(po:GetChildren()) do
				if pt.Name == "Poste" then
					local m = pt:FindFirstChild("Model")
					local im = m and m:FindFirstChild("Model")
					if im then
						local r = im:FindFirstChild("HumanoidRootPart") or im.PrimaryPart
						local pos = r and r.Position
						if not pos then
							local firstPart = im:FindFirstChildWhichIsA("BasePart")
							if firstPart then pos = firstPart.Position end
						end
						if pos and (pos - info.pos).Magnitude < md then
							md = (pos - info.pos).Magnitude
							posteModel = pt
						end
					end
				end
			end
		end
		
		if not posteModel then
			eS.Text="⚠️ Poste sumiu"
			task.wait(2)
			return
		end

		eS.Text="🪜 Colocando escada..."
		local pl=promPoste(posteModel,"place")
		if pl then pcall(function()fireproximityprompt(pl)end)task.wait(CFG.fastFarm and 0.4 or 0.8)end
		
		eS.Text="🪜 Subindo..."
		local hrp=HRP()
		local pInv = nil
		local weld = nil
		
		if hrp and posteModel then
			local maxY=info.pos.Y
			local m=posteModel:FindFirstChild("Model")
			local im=m and m:FindFirstChild("Model")
			if im then for _,d in ipairs(im:GetDescendants())do if d:IsA("BasePart")and d.Position.Y>maxY then maxY=d.Position.Y end end end
			
			local alvo=Vector3.new(info.pos.X,maxY+3,info.pos.Z)
			
			-- Cria a plataforma invisível
			pInv=Instance.new("Part")
			pInv.Name="PartSuporte_Temp"
			pInv.Size=Vector3.new(6,1,6)
			pInv.Position=alvo
			pInv.Anchored=true
			pInv.CanCollide=true -- Colisão ativada para segurança física
			pInv.Transparency=1
			pInv.Parent=posteModel
			
			-- Teleporta para cima da plataforma
			pcall(function()hrp.CFrame=CFrame.new(alvo+Vector3.new(0,3.5,0))end)
			task.wait(0.2)
			
			-- SOLDANDO O PLAYER NA PLATAFORMA (ANTI-DETECÇÃO DE FLY)
			weld = Instance.new("WeldConstraint")
			weld.Part0 = hrp
			weld.Part1 = pInv
			weld.Parent = hrp
			
			local hum = HUM()
			if hum then hum.PlatformStand = true end
			task.wait(0.1)
		end
		
		task.wait(CFG.fastFarm and 0.2 or 0.5)
		eS.Text="🔧 Consertando..."
		local pr=promPoste(posteModel,"repair",true)
		if pr then
			pcall(function()fireproximityprompt(pr)end)
			local t0=tick()
			while tick()-t0<7 do if not pr.Enabled then break end task.wait(0.15)end
			task.wait(CFG.fastFarm and 0.1 or 0.3)
		end
		
		-- NOVA ESPERA NO POSTE (SOLDADO E TOTALMENTE PARADO)
		local tempoEspera = tonumber(CFG.esperaPoste) or 180
		if tempoEspera > 0 then
			local tInicio = tick()
			while tick() - tInicio < tempoEspera do
				if myRun ~= eRun then
					-- Se cancelar, quebra a solda
					if weld then weld:Destroy() end
					local hum = HUM()
					if hum then hum.PlatformStand = false end
					if pInv then pInv:Destroy() end
					if eBarFill then eBarFill.Size = UDim2.new(0,0,1,0) end
					if eBarText then eBarText.Text = "" end
					return
				end
				
				-- Se o player morrer, quebra o loop de espera para não bugar
				if not HRP() or not HUM() then break end
				
				local restante = math.max(0, tempoEspera - (tick() - tInicio))
				local pct = 1 - (restante / tempoEspera)
				
				if eBarFill then eBarFill.Size = UDim2.new(pct, 0, 1, 0) end
				if eBarText then 
					eBarText.Text = string.format("⏳ %02d:%02d (Parado no Poste)", math.floor(restante / 60), math.floor(restante % 60)) 
				end
				eS.Text = "⏳ Parado no poste..."
				
				task.wait(0.1)
			end
			
			if eBarFill then eBarFill.Size = UDim2.new(0,0,1,0) end
			if eBarText then eBarText.Text = "" end
		end
		
		-- DESFAZ A SOLDA
		if weld then weld:Destroy() end
		local hum2 = HUM()
		if hum2 then hum2.PlatformStand = false end
		
		eS.Text="⬇️ Descendo..."
		if pInv then pcall(function()pInv:Destroy()end)end
		
		local hrp2=HRP()
		if hrp2 then
			local chaoY=info.pos.Y
			local tent=0
			while hrp2.Position.Y>chaoY+2 and tent<60 do
				pcall(function()hrp2.CFrame=CFrame.new(hrp2.Position-Vector3.new(0,1.5,0))end)
				task.wait(0.08)
				tent=tent+1
			end
		end
		task.wait(CFG.fastFarm and 0.1 or 0.3)
		
		EletSt.e=EletSt.e+1
		
		if info.saved and info.index then
			postesConcluidos[info.index] = true
		end
		
		local total=contarPostes()
		eSt.Text="⚡ Postes: "..EletSt.e.."/"..total
		Notif("⚡ Poste #"..EletSt.e.." Finalizado!",LARANJA,1.5)
	end

	toggle("⚡ Ativar Sailent Eletricista",CFG.autoEletricista,LARANJA,function(s)
		eOn=s CFG.autoEletricista=s eRun=eRun+1 saveCfg()
		if s then
			local myRun=eRun
			if CFG.noclip then noclipOn()end
			local h=HUM()if h then h.WalkSpeed=CFG.vel end
			eS.Text="Status: ● ATIVO"eS.TextColor3=LARANJA
			Notif("⚡ Eletricista ATIVADO",LARANJA,1.5)
			task.spawn(function()
				while eOn and myRun==eRun do
					local ok,err=pcall(cicloE,myRun)
					if not ok then eS.Text="⚠️ "..tostring(err):sub(1,38)eS.TextColor3=VERMELHO task.wait(2)end
					task.wait(CFG.fastFarm and 0.1 or 0.3)
				end
			end)
		else
			if CFG.noclip then noclipOff()end
			eS.Text="Status: PARADO"eS.TextColor3=SUB
			-- Desancora no stop geral
			local h=HRP()
			if h then h.Anchored = false end
			local hum=HUM()
			if hum then hum.PlatformStand = false end
			
			Notif("⚡ Eletricista DESATIVADO",AMARELO,1.5)
			local h=HUM()if h then h.WalkSpeed=16 end
		end
	end,eB)

	local pID={min=false}
	local pB=secaoCol(Content,"SAILENT PIZZA","Auto Pizza v6.1b","🍕",ROSA,pID)
	local pS=statL("Status: PARADO",SUB,pB)
	local pSt=statL("📦 0  🎯 0",SUB,pB)
	local pOn=false pRun=0

	local function cicloP(myRun)
		if not HRP()then pS.Text="⏳"task.wait(1)return end
		pS.TextColor3=ROSA
		if temPizza()then
			pS.Text="📤 Procurando cliente..."
			local info=localMarcado()
			if info and info.pos then
				pS.Text="📤 Indo..."
				irPara(info.pos,90)
				if myRun~=pRun then return end
				task.wait(CFG.fastFarm and 0.1 or 0.3)
				pS.Text="📤 Entregando..."
				pS.TextColor3=VERDE
				local pr=promPizza("Entregar Pedido")
				if pr then
					local t0=tick()
					while tick()-t0<30 do
						if not temPizza()then break end
						if myRun~=pRun then return end
						pcall(function()fireproximityprompt(pr)end)
						task.wait(CFG.fastFarm and 1 or 4)
					end
				end
				if not temPizza()then
					PizzaSt.e=PizzaSt.e+1
					Notif("📤 Entregue! #"..PizzaSt.e,ROSA,1.5)
					pSt.Text="📦 "..PizzaSt.p.."  🎯 "..PizzaSt.e
					local esp=tonumber(CFG.esperaEntrega)or 5
					if esp>0 then
						pS.Text="⏳ Espera "..esp.."s..."
						pS.TextColor3=AMARELO
						local tE=tick()
						while tick()-tE<esp do if not CFG.autoPizza or myRun~=pRun then return end task.wait(0.2)end
					end
				end
			else pS.Text="⚠️ Sem cliente"task.wait(1.5)end
		else
			pS.Text="📥 Procurando pedido..."
			local pr=promPizza("Pegar Pedido")
			if pr then
				local p=getPos(pr.Parent)
				if p then
					pS.Text="📥 Indo pegar..."
					irPara(p,90)
					if myRun~=pRun then return end
					task.wait(CFG.fastFarm and 0.1 or 0.3)
					pS.Text="📥 Pegando..."
					pcall(function()fireproximityprompt(pr)end)
					task.wait(CFG.fastFarm and 0.5 or 1.2)
					PizzaSt.p=PizzaSt.p+1
					pSt.Text="📦 "..PizzaSt.p.."  🎯 "..PizzaSt.e
					Notif("📥 Pego!",AZUL,1.2)
				end
			else pS.Text="⚠️ Sem pedido"task.wait(1.5)end
		end
	end

	toggle("🍕 Ativar Sailent Pizza",CFG.autoPizza,ROSA,function(s)
		pOn=s CFG.autoPizza=s pRun=pRun+1 saveCfg()
		if s then
			local myRun=pRun
			if CFG.noclip then noclipOn()end
			local h=HUM()if h then h.WalkSpeed=CFG.vel end
			pS.Text="Status: ● ATIVO"pS.TextColor3=ROSA
			Notif("🍕 Pizza ATIVADO",ROSA,1.5)
			task.spawn(function()
				while pOn and myRun==pRun do
					local ok,e=pcall(cicloP,myRun)
					if not ok then pS.Text="⚠️ "..tostring(e):sub(1,38)pS.TextColor3=VERMELHO task.wait(2)end
					task.wait(CFG.fastFarm and 0.1 or 0.5)
				end
			end)
		else
			if CFG.noclip then noclipOff()end
			pS.Text="Status: PARADO"pS.TextColor3=SUB
			Notif("🍕 Pizza DESATIVADO",AMARELO,1.5)
			local h=HUM()if h then h.WalkSpeed=16 end
		end
	end,pB)
	slider("⏱️ Espera entre entregas",0,30,CFG.esperaEntrega,ROSA,function(v)CFG.esperaEntrega=v saveCfg()end,pB)

	local prID={min=false}
	local prB=secaoCol(Content,"SAILENT PRISÃO","Auto Prisão v12.3","🔓",AMARELO2,prID)
	local prS=statL("Status: PARADO",SUB,prB)
	local vOn=false cOn=false vRun=0 cRun=0

	botao("🔍 DEBUG Varredura (F9)",CIANO,function()
		debugVarredura()
		Notif("📋 Veja o F9 (Console)",CIANO,4)
	end,prB)

	local function cicloV(myRun)
		if not HRP() then task.wait(1) return end

		local tool = equipVassoura()
		if not tool then
			prS.Text = "⚠️ Sem vassoura no inventário"
			prS.TextColor3 = VERMELHO
			task.wait(2)
			return
		end

		local info = proximoPontoVarredura()
		if not info then
			prS.Text = "⏳ Todos em cooldown, aguardando..."
			prS.TextColor3 = AMARELO
			task.wait(3)
			return
		end

		prS.TextColor3 = VERDE
		prS.Text = "🧹 Indo (" .. math.floor(info.dist) .. "m)..."
		irPara(info.pos, 30)
		if myRun ~= vRun then return end
		task.wait(CFG.fastFarm and 0.1 or 0.3)

		local hrp = HRP()
		if not hrp then return end
		local distReal = (hrp.Position - info.pos).Magnitude
		if distReal > 7 then
			pcall(function() hrp.CFrame = CFrame.new(info.pos + Vector3.new(0, 3.5, 0)) end)
			task.wait(CFG.fastFarm and 0.1 or 0.4)
		end

		prS.Text = "🧹 Varrendo..."
		pcall(function() tool:Activate() end)

		local t0 = tick()
		while tick() - t0 < 5 do
			if myRun ~= vRun then return end
			if info.part:GetAttribute("EmCooldown") then break end
			task.wait(0.15)
		end
		
		PrisaoSt.v = PrisaoSt.v + 1
		Notif("🧹 Varreu! Total: " .. PrisaoSt.v, AMARELO2, 1.5)

		local esp = tonumber(CFG.esperaVarredura) or 3
		if esp > 0 then
			prS.Text = "⏳ Espera " .. esp .. "s..."
			prS.TextColor3 = AMARELO
			local tE = tick()
			while tick() - tE < esp do
				if not CFG.autoVarrer or myRun ~= vRun then return end
				task.wait(0.2)
			end
		end
	end

	local function cicloC(myRun)
		if not HRP()then task.wait(1)return end
		if temCaixa()then
			local p=promPrisao("Colocar Caixa")or promPrisao("Entregar")
			if p then
				irPara(p.Parent.Position,25)
				if myRun~=cRun then return end
				task.wait(CFG.fastFarm and 0.1 or 0.3)
				pcall(function()fireproximityprompt(p)end)
				task.wait(CFG.fastFarm and 0.3 or 0.6)
				PrisaoSt.e=PrisaoSt.e+1
				Notif("📤 Entregue!",AZUL,1.5)
			end
		else
			local p=promPrisao("Collect Trash")or promPrisao("Coletar")
			if p then
				irPara(p.Parent.Position,25)
				if myRun~=cRun then return end
				task.wait(CFG.fastFarm and 0.1 or 0.3)
				pcall(function()fireproximityprompt(p)end)
				task.wait(CFG.fastFarm and 0.3 or 0.6)
				PrisaoSt.c=PrisaoSt.c+1
				Notif("📥 Caixa!",VERDE,1.2)
			end
		end
	end

	toggle("🧹 Ativar Varredura",CFG.autoVarrer,AMARELO2,function(s)
		vOn=s CFG.autoVarrer=s vRun=vRun+1 saveCfg()
		if s then
			local myRun=vRun
			if CFG.noclip then noclipOn()end
			prS.Text="● ATIVO"prS.TextColor3=VERDE
			Notif("🧹 Varredura ON",AMARELO2,1.5)
			task.spawn(function()
				while vOn and myRun==vRun do 
					local ok, err = pcall(cicloV,myRun)
					if not ok then
						prS.Text = "⚠️ Erro: "..tostring(err):sub(1,30)
						prS.TextColor3 = VERMELHO
					end
					task.wait(CFG.fastFarm and 0.1 or 0.3) 
				end 
			end)
		else
			if not cOn and CFG.noclip then noclipOff()end
			prS.Text="PARADO"prS.TextColor3=SUB
		end
	end,prB)

	slider("⏱️ Espera na varredura",0,10,CFG.esperaVarredura or 3,AMARELO2,function(v)CFG.esperaVarredura=v saveCfg()end,prB)

	toggle("📦 Ativar Caixa",CFG.autoCaixa,AZUL,function(s)
		cOn=s CFG.autoCaixa=s cRun=cRun+1 saveCfg()
		if s then
			local myRun=cRun
			if CFG.noclip then noclipOn()end
			Notif("📦 Caixa ON",AZUL,1.5)
			task.spawn(function()while cOn and myRun==cRun do pcall(cicloC,myRun)task.wait(CFG.fastFarm and 0.1 or 0.5)end end)
		else
			if not vOn and CFG.noclip then noclipOff()end
		end
	end,prB)

	secao("⚙️ Configurações Compartilhadas",AMARELO)
	local modSt=statL(CFG.modoVoo and "Modo: 🚁 VOANDO"or"Modo: 🚶 A PÉ",AMARELO)
	slider("⚡ Velocidade",20,200,math.clamp(CFG.vel,20,200),VERDE,function(v)CFG.vel=v local h=HUM()if h and not CFG.modoVoo then h.WalkSpeed=v end saveCfg()end)
	botao("🚶 A PÉ",VERDE,function()CFG.modoVoo=false modSt.Text="Modo: 🚶 A PÉ"modSt.TextColor3=VERDE saveCfg()end)
	botao("🚁 VOAR",AMARELO,function()CFG.modoVoo=true modSt.Text="Modo: 🚁 VOANDO"modSt.TextColor3=AMARELO saveCfg()end)

	secao("🛡️ Comportamento",AMARELO)
	toggle("🚪 Noclip",CFG.noclip,VERDE,function(s)CFG.noclip=s if s then if eOn or gOn or pOn or vOn or cOn then noclipOn()end else noclipOff()end saveCfg()end)
	toggle("😴 Anti-AFK",CFG.antiAfk,AMARELO,function(s)CFG.antiAfk=s setAFK(s)saveCfg()end)
	toggle("🛡️ God Mode",CFG.godMode,VERDE,function(s)CFG.godMode=s godAtivo=s if s then godOn()else godOff()end saveCfg()end)
	toggle("🪑 Anti-Sentar",CFG.antiSit,LARANJA,function(s)CFG.antiSit=s if s then antiSitOn()else antiSitOff()end saveCfg()end)

	secao("🚨 Emergência",VERMELHO)
	botao("🛑 PARAR TUDO",VERMELHO,function()
		CFG.autoGari=false CFG.autoEletricista=false CFG.autoPizza=false CFG.autoVarrer=false CFG.autoCaixa=false
		gOn=false eOn=false pOn=false vOn=false cOn=false
		gRun=gRun+1 eRun=eRun+1 pRun=pRun+1 vRun=vRun+1 cRun=cRun+1
		noclipOff()
		gS.Text="PARADO"eS.Text="PARADO"pS.Text="PARADO"prS.Text="PARADO"
		if eBarFill then eBarFill.Size=UDim2.new(0,0,1,0) end
		if eBarText then eBarText.Text="" end
		
		-- Desancora no stop geral
		local h=HRP()
		if h then h.Anchored = false end
		local hum=HUM()
		if hum then 
			hum.PlatformStand = false
			hum.WalkSpeed=16 
		end
		
		Notif("🛑 Tudo parado!",VERMELHO,2)
	end)
end

tabs["Privates"]=function()
	secao("🔒 Área Privada",ROXO)
	statL("Em breve...",SUB)
	secao("💬 Loja",Color3.fromRGB(88,101,242))
	botao("💬 Entrar no Discord",Color3.fromRGB(88,101,242),function()
		pcall(function()if setclipboard then setclipboard(DISCORD_LINK)end end)
		Notif("💬 "..DISCORD_LINK,Color3.fromRGB(88,101,242),3)
	end)
end

tabs["Config"]=function()
	secao("🏆 Criadores / Devs",AMARELO)
	local card=Instance.new("Frame")card.Size=UDim2.new(1,-10,0,100)card.BackgroundColor3=CARD card.BorderSizePixel=0 card.Parent=Content corner(card,12)stroke(card,AMARELO,2,0.3)grad(card,Color3.fromRGB(30,25,10),Color3.fromRGB(20,15,30),90)
	local s1=Instance.new("TextLabel")s1.Size=UDim2.new(0,40,0,40)s1.Position=UDim2.new(0,15,0,12)s1.BackgroundTransparency=1 s1.Text="⭐"s1.TextSize=28 s1.Font=Enum.Font.GothamBold s1.Parent=card
	local n1=Instance.new("TextLabel")n1.Size=UDim2.new(1,-70,0,22)n1.Position=UDim2.new(0,60,0,12)n1.BackgroundTransparency=1 n1.Text="becks"n1.Font=Enum.Font.GothamBold n1.TextSize=18 n1.TextColor3=AMARELO n1.TextXAlignment=Enum.TextXAlignment.Left n1.Parent=card
	local r1=Instance.new("TextLabel")r1.Size=UDim2.new(1,-70,0,14)r1.Position=UDim2.new(0,60,0,34)r1.BackgroundTransparency=1 r1.Text="👨‍💻 CRIADOR / DEV"r1.Font=Enum.Font.GothamBold r1.TextSize=10 r1.TextColor3=CIANO r1.TextXAlignment=Enum.TextXAlignment.Left r1.Parent=card
	local sep=Instance.new("Frame")sep.Size=UDim2.new(1,-30,0,1)sep.Position=UDim2.new(0,15,0,58)sep.BackgroundColor3=BORDA sep.BorderSizePixel=0 sep.Parent=card
	local s2=Instance.new("TextLabel")s2.Size=UDim2.new(0,40,0,40)s2.Position=UDim2.new(0,15,0,62)s2.BackgroundTransparency=1 s2.Text="⭐"s2.TextSize=28 s2.Font=Enum.Font.GothamBold s2.Parent=card
	local n2=Instance.new("TextLabel")n2.Size=UDim2.new(1,-70,0,22)n2.Position=UDim2.new(0,60,0,62)n2.BackgroundTransparency=1 n2.Text="kevim"n2.Font=Enum.Font.GothamBold n2.TextSize=18 n2.TextColor3=AMARELO n2.TextXAlignment=Enum.TextXAlignment.Left n2.Parent=card
	local r2=Instance.new("TextLabel")r2.Size=UDim2.new(1,-70,0,14)r2.Position=UDim2.new(0,60,0,84)r2.BackgroundTransparency=1 r2.Text="👨‍💻 CRIADOR / DEV"r2.Font=Enum.Font.GothamBold r2.TextSize=10 r2.TextColor3=CIANO r2.TextXAlignment=Enum.TextXAlignment.Left r2.Parent=card

	secao("🔧 Key Info",CIANO)
	statL("👤 "..(_G.SailentNome or "?"),CIANO)
	statL("📊 Nível: "..(_G.SailentNivel or "?"),VERDE)
	botao("🗑️ Apagar Key Salva",VERMELHO,function()deleteKey()Notif("🗑️ Key apagada! Reinicie",VERMELHO,3)end)

	secao("💬 Loja",Color3.fromRGB(88,101,242))
	botao("💬 Copiar Discord",Color3.fromRGB(88,101,242),function()
		pcall(function()if setclipboard then setclipboard(DISCORD_LINK)end end)
		Notif("💬 "..DISCORD_LINK,Color3.fromRGB(88,101,242),3)
	end)
	secao("⚠️ Ações",VERMELHO)
	botao("🗑️ Destruir Interface",VERMELHO,function()ScreenGui:Destroy()end)
end

local InnerBtns={
	{name="Jogador",icon="👤"},
	{name="Aimbot",icon="🎯"},
	{name="Visual",icon="👁️"},
	{name="Tróli",icon="😜"},
	{name="Exploits",icon="🐛"},
	{name="Privates",icon="🔒"},
	{name="Config",icon="⚙️"},
}

local btns={}
local yP=10

local function selTab(nome)
	for n,d in pairs(btns)do
		if n==nome then
			d.btn.BackgroundColor3=INPUT d.btn.TextColor3=AMARELO d.bar.BackgroundColor3=AMARELO d.bar.BackgroundTransparency=0
		else
			d.btn.BackgroundColor3=PAINEL d.btn.TextColor3=SUB d.bar.BackgroundTransparency=1
		end
	end
	limpar()
	if tabs[nome]then tabs[nome]()end
end

for _,d in ipairs(InnerBtns)do
	local b=Instance.new("TextButton")
	b.Size=UDim2.new(1,-20,0,40)b.Position=UDim2.new(0,10,0,yP)
	b.BackgroundColor3=PAINEL b.BorderSizePixel=0
	b.Text="  "..d.icon.."  "..d.name
	b.TextColor3=SUB b.TextSize=13 b.Font=Enum.Font.GothamBold
	b.TextXAlignment=Enum.TextXAlignment.Left b.AutoButtonColor=false b.Parent=InnerMenu corner(b,8)
	local bar=Instance.new("Frame")bar.Size=UDim2.new(0,3,0,18)bar.Position=UDim2.new(0,0,0.5,-9)bar.BackgroundColor3=AMARELO bar.BackgroundTransparency=1 bar.BorderSizePixel=0 bar.Parent=b corner(bar,2)
	b.MouseEnter:Connect(function()if b.TextColor3~=AMARELO then Tw(b,{BackgroundColor3=CARD},0.15)Tw(b,{TextColor3=TEXTO},0.15)end end)
	b.MouseLeave:Connect(function()if b.TextColor3~=AMARELO then Tw(b,{BackgroundColor3=PAINEL},0.15)Tw(b,{TextColor3=SUB},0.15)end end)
	b.MouseButton1Click:Connect(function()selTab(d.name)end)
	btns[d.name]={btn=b,bar=bar}
	yP=yP+45
end

selTab("Jogador")

local aberto=true
local function fechar()
	if not aberto then return end
	aberto=false
	Tw(Main,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)},0.3)
	task.wait(0.3)
	Main.Visible=false
	FloatBtn.Visible=true
	FloatBtn.Size=UDim2.new(0,0,0,0)
	Tw(FloatBtn,{Size=UDim2.new(0,60,0,60)},0.25)
end
local function abrir()
	if aberto then return end
	aberto=true
	FloatBtn.Visible=false
	Main.Visible=true
	Main.Size=UDim2.new(0,0,0,0)
	Main.Position=UDim2.new(0.5,0,0.5,0)
	Tw(Main,{Size=UDim2.new(0.9, 0, 0.8, 0),Position=UDim2.new(0.5,0,0.5,0)},0.35)
end

CloseBtn.MouseButton1Click:Connect(fechar)
FloatBtn.MouseButton1Click:Connect(abrir)
MinBtn.MouseButton1Click:Connect(fechar)

UserInput.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode==Enum.KeyCode.RightShift then
		if aberto then fechar()else abrir()end
	end
end)

do
	local drag,di,ds,sp
	Header.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			drag=true ds=i.Position sp=Main.Position
			Tw(DragBar,{BackgroundColor3=AMARELO,Size=UDim2.new(0,60,0,3)},0.15)
			i.Changed:Connect(function()
				if i.UserInputState==Enum.UserInputState.End then
					drag=false
					Tw(DragBar,{BackgroundColor3=BORDA,Size=UDim2.new(0,40,0,3)},0.15)
				end
			end)
		end
	end)
	Header.InputChanged:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end end)
	UserInput.InputChanged:Connect(function(i)if i==di and drag then local d=i.Position-ds Main.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)end end)
end

setAFK(CFG.antiAfk)
if CFG.godMode then godOn()end
if CFG.antiSit then antiSitOn()end
Notif("🦈 Bem-vindo, "..(_G.SailentNome or "Cliente").."!",CIANO,3)
print("[Shark Menu] ✅ Painel v"..SCRIPT_VER.." pronto!")

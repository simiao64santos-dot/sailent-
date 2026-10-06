-- ============================================================
-- SAILENT AUTO PIZZA v6.1b — ANTI-KICK + ANTI-DANO DE QUEDA
-- Sem voo por padrão + Detecção de água + Aviso no voo
-- ============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local lp = Players.LocalPlayer

local _suspenderTudo = false
local _ultimoVoo = 0

local KEY = {
	URL = "https://raw.githubusercontent.com/simiao64santos-dot/sailent-/refs/heads/main/keys.json",
	CACHE = "sailent_gari_key.txt",
	VER = "6.1b",
}

local CFG = {
	vel = 80,
	vooAtivo = false,
	alturaVoo = 2,
	antiSit = true,
	autoEnt = false,
	antiAfk = true,
	travarCam = true,
	noclip = true,
	esperaEntrega = 5,
	keyUI = "F2",
	keyPanic = "F1",
	keyEnt = "F3",
}

pcall(function()
	if isfile and isfile("sailent_pizza_cfg.txt") and readfile then
		for l in readfile("sailent_pizza_cfg.txt"):gmatch("[^\n]+") do
			local k, v = l:match("([^=]+)=(.+)")
			if k and v then
				if v == "true" then v = true elseif v == "false" then v = false elseif tonumber(v) then v = tonumber(v) end
				CFG[k] = v
			end
		end
	end
end)

local function Salvar()
	local s = ""
	for k, v in pairs(CFG) do if tostring(v) ~= "" then s = s .. k .. "=" .. tostring(v) .. "\n" end end
	pcall(function() if writefile then writefile("sailent_pizza_cfg.txt", s) end end)
end

pcall(function()
	for _, n in ipairs({"SailentPizza","SailentFloatBtn","SailentKeyUI","SailentToast"}) do
		local o = CoreGui:FindFirstChild(n); if o then o:Destroy() end
	end
end)

local C = {
	BG = Color3.fromRGB(12,12,20), BG2 = Color3.fromRGB(16,16,26),
	Card = Color3.fromRGB(24,24,36), Border = Color3.fromRGB(42,42,62),
	Accent = Color3.fromRGB(124,158,255), Text = Color3.fromRGB(240,240,250),
	Sub = Color3.fromRGB(140,140,165),
	Green = Color3.fromRGB(80,220,140), Red = Color3.fromRGB(240,90,100),
	Yellow = Color3.fromRGB(255,200,80), Blue = Color3.fromRGB(124,158,255),
	Purple = Color3.fromRGB(180,120,255),
	Black = Color3.fromRGB(6,6,12),
}

local function Tween(o,p,t) if not o or not o.Parent then return end; local tw = TweenService:Create(o, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint), p); tw:Play(); return tw end
local function Log(m) print("[Pizza] "..tostring(m)) end
local function GetHttp() return (syn and syn.request) or (http and http.request) or http_request or request end

-- SHA256
local function Sha256(msg)
	local K = {0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}
	local H = {0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
	local function ror(x,n) return bit32.bor(bit32.rshift(x,n), bit32.lshift(x,32-n)) end
	local bitLen = #msg * 8
	msg = msg.."\128"
	while (#msg % 64) ~= 56 do msg = msg.."\0" end
	local hi = math.floor(bitLen/4294967296); local lo = bitLen % 4294967296
	local function u32be(n) return string.char(bit32.band(bit32.rshift(n,24),255),bit32.band(bit32.rshift(n,16),255),bit32.band(bit32.rshift(n,8),255),bit32.band(n,255)) end
	msg = msg..u32be(hi)..u32be(lo)
	for ch = 1, #msg, 64 do
		local w = {}
		for i = 0, 15 do
			local a,b,c,d = msg:byte(ch+i*4, ch+i*4+3)
			w[i] = bit32.bor(bit32.lshift(a,24),bit32.lshift(b,16),bit32.lshift(c,8),d)
		end
		for i = 16, 63 do
			local s0 = bit32.bxor(ror(w[i-15],7),ror(w[i-15],18),bit32.rshift(w[i-15],3))
			local s1 = bit32.bxor(ror(w[i-2],17),ror(w[i-2],19),bit32.rshift(w[i-2],10))
			w[i] = (w[i-16]+s0+w[i-7]+s1) % 4294967296
		end
		local a,b,c,d,e,f,g,h = table.unpack(H)
		for i = 0, 63 do
			local S1 = bit32.bxor(ror(e,6),ror(e,11),ror(e,25))
			local ch2 = bit32.bxor(bit32.band(e,f),bit32.band(bit32.bnot(e),g))
			local t1 = (h+S1+ch2+K[i+1]+w[i]) % 4294967296
			local S0 = bit32.bxor(ror(a,2),ror(a,13),ror(a,22))
			local mj = bit32.bxor(bit32.band(a,b),bit32.band(a,c),bit32.band(b,c))
			local t2 = (S0+mj) % 4294967296
			h,g,f,e,d,c,b,a = g,f,e,(d+t1)%4294967296,c,b,a,(t1+t2)%4294967296
		end
		H[1]=(H[1]+a)%4294967296; H[2]=(H[2]+b)%4294967296; H[3]=(H[3]+c)%4294967296; H[4]=(H[4]+d)%4294967296
		H[5]=(H[5]+e)%4294967296; H[6]=(H[6]+f)%4294967296; H[7]=(H[7]+g)%4294967296; H[8]=(H[8]+h)%4294967296
	end
	local out = {}
	for i = 1, 8 do out[#out+1] = string.format("%08x", H[i]) end
	return table.concat(out)
end

local function GetHWID()
	local h = ""
	pcall(function() h = game:GetService("RbxAnalyticsService"):GetClientId() end)
	if h == "" then pcall(function() h = gethwid and gethwid() or "" end) end
	if h == "" then h = "UNK-"..tostring(lp.UserId) end
	return h
end

local KS = { valida = false, nivel = "normal", nome = "Cliente" }
local function CKey() local k = nil; pcall(function() if isfile and isfile(KEY.CACHE) and readfile then k = readfile(KEY.CACHE) end end); return k end
local function LKey() pcall(function() if delfile and isfile and isfile(KEY.CACHE) then delfile(KEY.CACHE) end end) end

local function VKey(k)
	if not k or k == "" then return false, "Cole uma key!" end
	k = k:gsub("%s+","")
	local httpFn = GetHttp()
	if not httpFn then return false, "Sem HTTP!" end
	local ok, resp = pcall(function() return httpFn({Url=KEY.URL.."?t="..tick(), Method="GET"}) end)
	if not ok or not resp then return false, "Erro rede" end
	local body = resp.Body or resp.body
	if not body or body == "" then return false, "keys vazio" end
	local ok2, dados = pcall(function() return HttpService:JSONDecode(body) end)
	if not ok2 or not dados then return false, "JSON erro" end
	local hash = Sha256(k)
	local entry = dados.keys and dados.keys[hash]
	if not entry then return false, "❌ Key inválida" end
	local agora = os.time()
	if entry.expira and entry.expira < agora and entry.expira < 99999999999 then return false, "⏰ Expirada" end
	if entry.status and entry.status ~= "ativa" then return false, "🚫 Desativada" end
	local hw = GetHWID()
	if entry.hwid and entry.hwid ~= "" and entry.hwid ~= hw then return false, "🔒 Outro device" end
	KS.valida = true
	KS.nivel = entry.nivel or "normal"
	KS.nome = entry.nome or "Cliente"
	pcall(function() if writefile then writefile(KEY.CACHE, k) end end)
	return true, entry
end

-- Toast
local SGT = Instance.new("ScreenGui")
SGT.Name = "SailentToast"; SGT.ResetOnSpawn = false; SGT.DisplayOrder = 999; SGT.Parent = CoreGui
local TC = Instance.new("Frame")
TC.Size = UDim2.new(0,320,1,0); TC.Position = UDim2.new(1,-340,0,0); TC.BackgroundTransparency = 1; TC.Parent = SGT
local TL = Instance.new("UIListLayout")
TL.VerticalAlignment = Enum.VerticalAlignment.Bottom; TL.HorizontalAlignment = Enum.HorizontalAlignment.Right
TL.Padding = UDim.new(0,6); TL.Parent = TC
local ut = {}
local function Notif(txt, cor, dur)
	cor = cor or C.Accent; dur = dur or 2.5
	if ut[txt] and tick() - ut[txt] < 1 then return end
	ut[txt] = tick()
	local t = Instance.new("TextLabel")
	t.Text = tostring(txt); t.Font = Enum.Font.GothamBold; t.TextSize = 12
	t.TextColor3 = C.Text; t.BackgroundColor3 = C.Card; t.BackgroundTransparency = 0.05
	t.Size = UDim2.new(1,0,0,36); t.TextWrapped = true; t.Parent = TC
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,10); c.Parent = t
	local p = Instance.new("UIPadding")
	p.PaddingLeft = UDim.new(0,14); p.PaddingRight = UDim.new(0,14); p.Parent = t
	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(0,3,1,-12); bar.Position = UDim2.new(0,6,0,6)
	bar.BackgroundColor3 = cor; bar.BorderSizePixel = 0; bar.Parent = t
	local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(1,0); bc.Parent = bar
	task.delay(dur, function()
		Tween(t, {BackgroundTransparency = 1, TextTransparency = 1}, 0.3)
		task.wait(0.4); pcall(function() t:Destroy() end)
	end)
end

-- Login
local function LoginUI(cb)
	local SG = Instance.new("ScreenGui")
	SG.Name = "SailentKeyUI"; SG.ResetOnSpawn = false; SG.IgnoreGuiInset = true; SG.Parent = CoreGui

	local BG = Instance.new("Frame")
	BG.Size = UDim2.new(1,0,1,0); BG.BackgroundColor3 = Color3.fromRGB(0,0,0)
	BG.BackgroundTransparency = 0.5; BG.BorderSizePixel = 0; BG.Parent = SG

	local Box = Instance.new("Frame")
	Box.Size = UDim2.new(0,380,0,360); Box.Position = UDim2.new(0.5,-190,0.5,-180)
	Box.BackgroundColor3 = C.BG2; Box.BorderSizePixel = 0; Box.Parent = SG
	local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0,18); bc.Parent = Box
	local bs = Instance.new("UIStroke"); bs.Color = C.Accent; bs.Thickness = 1.5; bs.Transparency = 0.4; bs.Parent = Box

	local top = Instance.new("Frame")
	top.Size = UDim2.new(1,0,0,4); top.BackgroundColor3 = C.Accent; top.BorderSizePixel = 0; top.Parent = Box
	local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(0,18); tc.Parent = top
	local tg = Instance.new("UIGradient")
	tg.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,C.Accent),ColorSequenceKeypoint.new(0.5,C.Purple),ColorSequenceKeypoint.new(1,C.Yellow)})
	tg.Parent = top

	local tit = Instance.new("TextLabel")
	tit.Text = "🍕 SAILENT PIZZA"; tit.Font = Enum.Font.GothamBold; tit.TextSize = 20
	tit.TextColor3 = C.Text; tit.BackgroundTransparency = 1
	tit.Position = UDim2.new(0,0,0,20); tit.Size = UDim2.new(1,0,0,26); tit.Parent = Box

	local sub = Instance.new("TextLabel")
	sub.Text = "Cole sua key"; sub.Font = Enum.Font.Gotham; sub.TextSize = 12
	sub.TextColor3 = C.Sub; sub.BackgroundTransparency = 1
	sub.Position = UDim2.new(0,0,0,48); sub.Size = UDim2.new(1,0,0,18); sub.Parent = Box

	local hp = Instance.new("Frame")
	hp.Size = UDim2.new(0,280,0,22); hp.Position = UDim2.new(0.5,-140,0,74)
	hp.BackgroundColor3 = C.Card; hp.BorderSizePixel = 0; hp.Parent = Box
	local hpc = Instance.new("UICorner"); hpc.CornerRadius = UDim.new(1,0); hpc.Parent = hp

	local hw = Instance.new("TextLabel")
	hw.Text = "🔒 "..GetHWID():sub(1,22).."..."; hw.Font = Enum.Font.Code; hw.TextSize = 10
	hw.TextColor3 = C.Sub; hw.BackgroundTransparency = 1
	hw.Size = UDim2.new(1,0,1,0); hw.Parent = hp

	local inp = Instance.new("TextBox")
	inp.PlaceholderText = "SAILENT-XXXX-XXXX-XXXX"; inp.Font = Enum.Font.Code
	inp.TextSize = 13; inp.TextColor3 = C.Text; inp.PlaceholderColor3 = Color3.fromRGB(90,90,110)
	inp.BackgroundColor3 = C.Card; inp.BorderSizePixel = 0; inp.ClearTextOnFocus = false
	inp.Text = ""; inp.Position = UDim2.new(0,28,0,110); inp.Size = UDim2.new(1,-56,0,44); inp.Parent = Box
	local ic = Instance.new("UICorner"); ic.CornerRadius = UDim.new(0,10); ic.Parent = inp
	local is = Instance.new("UIStroke"); is.Color = C.Border; is.Thickness = 1; is.Parent = inp

	local st = Instance.new("TextLabel")
	st.Text = ""; st.Font = Enum.Font.GothamBold; st.TextSize = 11
	st.TextColor3 = C.Red; st.BackgroundTransparency = 1
	st.Position = UDim2.new(0,28,0,162); st.Size = UDim2.new(1,-56,0,32)
	st.TextWrapped = true; st.TextYAlignment = Enum.TextYAlignment.Top; st.Parent = Box

	local btn = Instance.new("TextButton")
	btn.Text = "VALIDAR"; btn.Font = Enum.Font.GothamBold; btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(255,255,255); btn.BackgroundColor3 = C.Accent
	btn.BorderSizePixel = 0; btn.Position = UDim2.new(0,28,0,210)
	btn.Size = UDim2.new(1,-56,0,48); btn.AutoButtonColor = false; btn.Parent = Box
	local bbc = Instance.new("UICorner"); bbc.CornerRadius = UDim.new(0,10); bbc.Parent = btn
	local bg2 = Instance.new("UIGradient")
	bg2.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,C.Accent),ColorSequenceKeypoint.new(1,C.Purple)})
	bg2.Parent = btn

	local lim = Instance.new("TextButton")
	lim.Text = "🗑️ Limpar key"; lim.Font = Enum.Font.Gotham; lim.TextSize = 10
	lim.TextColor3 = C.Sub; lim.BackgroundTransparency = 1
	lim.Position = UDim2.new(0,28,0,275); lim.Size = UDim2.new(1,-56,0,18); lim.Parent = Box

	local ver = Instance.new("TextLabel")
	ver.Text = "v"..KEY.VER; ver.Font = Enum.Font.Code; ver.TextSize = 9
	ver.TextColor3 = C.Sub; ver.BackgroundTransparency = 1
	ver.Position = UDim2.new(0,0,0,332); ver.Size = UDim2.new(1,0,0,14); ver.Parent = Box

	local function ok()
		st.Text = "✅ Bem-vindo, "..KS.nome.."!"; st.TextColor3 = C.Green
		btn.Text = "SUCESSO!"
		Tween(btn, {BackgroundColor3 = C.Green}, 0.2)
		task.wait(0.4); pcall(function() SG:Destroy() end)
		task.wait(0.1); cb()
	end

	task.spawn(function()
		task.wait(0.2)
		local k = CKey()
		if k and k ~= "" then
			inp.Text = k; st.Text = "🔄 Verificando..."; st.TextColor3 = C.Yellow
			local okV, res = VKey(k)
			if okV then ok() else
				st.Text = "❌ "..tostring(res); st.TextColor3 = C.Red; LKey()
			end
		end
	end)

	btn.MouseButton1Click:Connect(function()
		local k = inp.Text:gsub("%s+","")
		if k == "" then st.Text = "⚠️ Cole uma key"; st.TextColor3 = C.Yellow; return end
		st.Text = "🔄 Validando..."; st.TextColor3 = C.Yellow
		btn.Text = "AGUARDE..."
		task.spawn(function()
			local okV, res = VKey(k)
			if okV then ok() else
				st.Text = "❌ "..tostring(res); st.TextColor3 = C.Red
				btn.Text = "VALIDAR"; btn.BackgroundColor3 = C.Accent
			end
		end)
	end)

	lim.MouseButton1Click:Connect(function()
		LKey(); inp.Text = ""; st.Text = "🗑️ Removida"; st.TextColor3 = C.Sub
	end)
end

-- Helpers
local function HRP() local c = lp.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function HUM() local c = lp.Character; return c and c:FindFirstChild("Humanoid") end

local Terrain = workspace:FindFirstChildOfClass("Terrain")

local function getPos(o)
	if not o then return nil end
	if o:IsA("BasePart") then return o.Position end
	if o:IsA("Attachment") then return o.WorldPosition end
	if o:IsA("Model") then
		local r = o:FindFirstChild("HumanoidRootPart") or o.PrimaryPart
		if r then return r.Position end
	end
	for _, d in ipairs(o:GetDescendants()) do
		if d:IsA("BasePart") then return d.Position end
	end
	return nil
end

local function DistanciaDe(pos)
	local h = HRP()
	if not h or not pos then return math.huge end
	return (h.Position - pos).Magnitude
end

local function EstaNaAgua()
	if not Terrain then return false end
	local h = HRP()
	if not h then return false end
	local ok, mat = pcall(function()
		return Terrain:GetMaterialAtPosition(h.Position)
	end)
	if not ok then return false end
	return mat == Enum.Material.Water
end

local function TemAguaNoCaminho(posAlvo)
	if not Terrain then return false end
	local h = HRP()
	if not h then return false end
	local passos = 15
	for i = 1, passos do
		local alpha = i / passos
		local p = h.Position:Lerp(posAlvo, alpha)
		local p2 = Vector3.new(p.X, 0, p.Z)
		local ok, mat = pcall(function()
			return Terrain:GetMaterialAtPosition(p2)
		end)
		if ok and mat == Enum.Material.Water then
			return true
		end
	end
	return false
end

local function AcharPrompt(txt)
	local hrp = HRP(); if not hrp then return nil end
	local mais, menor = nil, math.huge
	for _, o in ipairs(workspace:GetDescendants()) do
		if o:IsA("ProximityPrompt") and o.ActionText and o.ActionText:lower():find(txt:lower()) then
			local p = getPos(o.Parent)
			if p then
				local d = (p - hrp.Position).Magnitude
				if d < menor then menor = d; mais = o end
			end
		end
	end
	return mais
end

local function AcharLocalMarcado()
	local construcoes = workspace:FindFirstChild("Construcoes")
	if not construcoes then return nil end
	local pizzaria = construcoes:FindFirstChild("Pizzaria")
	if not pizzaria then return nil end
	local spa = pizzaria:FindFirstChild("OrderCharSpawns")
	if not spa then return nil end
	for _, pad in ipairs(spa:GetChildren()) do
		local marcado = pad:FindFirstChild("LocalMarcado", true)
		if marcado then
			local pos = getPos(marcado)
			if pos then
				return {marcado = marcado, pos = pos, pad = pad}
			end
		end
	end
	return nil
end

local function TemPizza()
	local d = workspace:FindFirstChild(lp.Name)
	return d and d:FindFirstChild("PizzaTemplate") ~= nil
end

-- Noclip
local ncConn = nil
local function AtivarNoclip()
	if ncConn then pcall(function() ncConn:Disconnect() end) end
	ncConn = RunService.Stepped:Connect(function()
		local c = lp.Character; if not c then return end
		for _, p in ipairs(c:GetDescendants()) do
			if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
		end
	end)
end
local function DesativarNoclip()
	if ncConn then pcall(function() ncConn:Disconnect() end); ncConn = nil end
	local c = lp.Character
	if c then
		for _, p in ipairs(c:GetDescendants()) do
			if p:IsA("BasePart") then pcall(function() p.CanCollide = true end) end
		end
	end
end

-- Anti-Sentar
local antiSitConns = {}
local function AtivarAntiSit()
	for _, c in ipairs(antiSitConns) do pcall(function() c:Disconnect() end) end
	antiSitConns = {}

	local function AplicarNoChar(char)
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum then return end

		pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Sitting, false) end)
		pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false) end)
		pcall(function() hum.Sit = false end)

		local conn1 = hum.Changed:Connect(function(prop)
			if prop == "Sit" and hum.Sit then
				pcall(function() hum.Sit = false end)
			end
		end)
		table.insert(antiSitConns, conn1)

		local conn2 = hum.ChildAdded:Connect(function(c)
			if c:IsA("Weld") and (c.Name == "SeatWeld" or c.Name:lower():find("seat")) then
				pcall(function() c:Destroy() end)
			end
		end)
		table.insert(antiSitConns, conn2)

		for _, c in ipairs(hum:GetChildren()) do
			if c:IsA("Weld") and (c.Name == "SeatWeld" or c.Name:lower():find("seat")) then
				pcall(function() c:Destroy() end)
			end
		end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			for _, c in ipairs(hrp:GetChildren()) do
				if c:IsA("Weld") and (c.Name == "SeatWeld" or c.Name:lower():find("seat")) then
					pcall(function() c:Destroy() end)
				end
			end
		end
	end

	if lp.Character then AplicarNoChar(lp.Character) end
	if _G.SailentAntiSitConn then pcall(function() _G.SailentAntiSitConn:Disconnect() end) end
	_G.SailentAntiSitConn = lp.CharacterAdded:Connect(function(c)
		task.wait(0.3)
		AplicarNoChar(c)
	end)
end

local function DesativarAntiSit()
	for _, c in ipairs(antiSitConns) do pcall(function() c:Disconnect() end) end
	antiSitConns = {}
	if _G.SailentAntiSitConn then pcall(function() _G.SailentAntiSitConn:Disconnect() end); _G.SailentAntiSitConn = nil end
end

-- ⭐⭐⭐ ANTI-DANO DE QUEDA ⭐⭐⭐
local fallConn = nil
local fallDamageProtectAtivo = false
local fallCharConn = nil

local function AtivarAntiDano()
	if fallConn then pcall(function() fallConn:Disconnect() end) end
	if fallCharConn then pcall(function() fallCharConn:Disconnect() end) end
	fallDamageProtectAtivo = true

	local function AplicarNoChar(char)
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum then return end
		pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end)
		pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) end)
		pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Landed, false) end)
		pcall(function() hum.BreakJointsOnDeath = false end)
	end

	if lp.Character then AplicarNoChar(lp.Character) end
	fallCharConn = lp.CharacterAdded:Connect(function(c)
		task.wait(0.3)
		AplicarNoChar(c)
	end)

	fallConn = RunService.Heartbeat:Connect(function()
		if not fallDamageProtectAtivo then return end
		local hrp = HRP()
		if not hrp or not hrp.Parent then return end
		local vel = hrp.AssemblyLinearVelocity
		if vel.Y < -40 then
			hrp.AssemblyLinearVelocity = Vector3.new(vel.X, -40, vel.Z)
		end
	end)
end

local function DesativarAntiDano()
	if fallConn then pcall(function() fallConn:Disconnect() end); fallConn = nil end
	if fallCharConn then pcall(function() fallCharConn:Disconnect() end); fallCharConn = nil end
	fallDamageProtectAtivo = false
end

-- Anti-AFK
local afkConn = nil
local function SetAFK(on)
	if afkConn then pcall(function() afkConn:Disconnect() end); afkConn = nil end
	if on then
		afkConn = lp.Idled:Connect(function()
			pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
		end)
	end
end

-- Stats
local StatsD = { entregues = 0, pegos = 0, inicio = tick() }
local function FmtT(s) s = math.floor(s); return string.format("%02d:%02d:%02d", math.floor(s/3600), math.floor(s%3600/60), s%60) end
local function Resumo() local d = tick() - StatsD.inicio; return string.format("⏱ %s  📦 %d  🎯 %d", FmtT(d), StatsD.entregues, StatsD.pegos) end

-- ⭐⭐⭐ ANDAR RÁPIDO (padrão anti-kick + anti-queda) ⭐⭐⭐
local function AndarRapido(posAlvo, timeout, dist)
	if not posAlvo then return false end
	if _suspenderTudo then return false end

	local hrp = HRP(); local hum = HUM()
	if not hrp or not hum then return false end

	timeout = timeout or 90
	dist = dist or 5

	local velOrig = hum.WalkSpeed
	pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
	pcall(function() hum.PlatformStand = false end)
	pcall(function() hum.AutoRotate = true end)

	local t0 = tick()
	local ultimaPos = hrp.Position
	local travado = 0
	local ultimoPulo = 0
	local velExtra = 0

	while tick() - t0 < timeout do
		if _suspenderTudo then break end
		local h = HRP(); if not h or not h.Parent then break end

		local posAtual = h.Position
		local df = Vector3.new(posAtual.X - posAlvo.X, 0, posAtual.Z - posAlvo.Z)
		if df.Magnitude < dist then
			hum:MoveTo(posAtual)
			hum.WalkSpeed = velOrig
			return true
		end

		hum.WalkSpeed = (CFG.vel or 80) + velExtra

		local v = h.AssemblyLinearVelocity
		if v.Y < -40 then
			h.AssemblyLinearVelocity = Vector3.new(v.X, -40, v.Z)
		end

		local moveu = (posAtual - ultimaPos).Magnitude
		if moveu < 0.8 then
			travado = travado + 1
			if tick() - ultimoPulo > 0.4 then
				ultimoPulo = tick()
				local hv = HRP()
				if hv then
					local vv = hv.AssemblyLinearVelocity
					if vv.Y < 25 then
						hv.AssemblyLinearVelocity = Vector3.new(vv.X, 25, vv.Z)
					end
				end
			end
			if travado > 45 then velExtra = 40 end
			if travado > 90 then velExtra = 80 end
		else
			if travado > 0 then travado = math.max(0, travado - 2) end
			if travado < 20 then velExtra = 0 end
		end
		ultimaPos = posAtual

		hum:MoveTo(posAlvo)

		if travado > 60 then
			local dir = Vector3.new(posAlvo.X - posAtual.X, 0, posAlvo.Z - posAtual.Z)
			if dir.Magnitude > 1 then
				local angulo = math.rad(math.random(-60, 60))
				local dirRot = CFrame.Angles(0, angulo, 0) * dir
				pcall(function()
					hum:MoveTo(posAtual + dirRot.Unit * 15)
				end)
			end
		end

		task.wait(0.03)
	end

	hum.WalkSpeed = velOrig
	return false
end

-- ⭐⭐⭐ VOO (só se vooAtivo = true) ⭐⭐⭐
local function Voar(posAlvo, timeout)
	if not posAlvo then return false end
	if _suspenderTudo then return false end
	if tick() - _ultimoVoo < 0.5 then return false end

	local hrp = HRP(); local hum = HUM()
	if not hrp or not hum then return false end

	local posInicial = hrp.Position
	local distTotal = (Vector3.new(posAlvo.X, 0, posAlvo.Z) - Vector3.new(posInicial.X, 0, posInicial.Z)).Magnitude
	if distTotal < 12 then return true end

	_ultimoVoo = tick()
	timeout = timeout or 60

	local diffY = posAlvo.Y - posInicial.Y
	local alturaVoo
	if diffY > 5 then
		alturaVoo = posAlvo.Y + 2
	elseif diffY < -5 then
		alturaVoo = posAlvo.Y + 2
	else
		alturaVoo = posInicial.Y + (CFG.alturaVoo or 2)
	end

	local humProps = { WalkSpeed = hum.WalkSpeed, AutoRotate = hum.AutoRotate, PlatformStand = hum.PlatformStand }

	pcall(function()
		hum.AutoRotate = true
		hum.WalkSpeed = 0
		hum:ChangeState(Enum.HumanoidStateType.Physics)
	end)
	pcall(function()
		hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
	end)

	local bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
	bv.Velocity = Vector3.new(0, 0, 0)
	bv.P = 8000
	bv.Parent = hrp

	local bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	bg.P = 5000
	bg.D = 500
	bg.CFrame = hrp.CFrame
	bg.Parent = hrp

	local t0 = tick()
	while tick() - t0 < 4 do
		local h = HRP()
		if not h or not h.Parent then break end
		local diff = alturaVoo - h.Position.Y
		if math.abs(diff) <= 1 then break end
		local velSubida = math.clamp((CFG.vel or 80) * 0.6, 20, 60)
		if diff > 0 then
			bv.Velocity = Vector3.new(0, math.min(velSubida, diff * 5), 0)
		else
			bv.Velocity = Vector3.new(0, math.max(-25, diff * 5), 0)
		end
		task.wait(0.03)
	end

	local chegou = false
	local minDist = distTotal
	local tVoo = tick()

	while tick() - tVoo < timeout do
		local h = HRP()
		if not h or not h.Parent then break end
		local posAtual = h.Position
		local dirH = Vector3.new(posAlvo.X - posAtual.X, 0, posAlvo.Z - posAtual.Z)
		local distH = dirH.Magnitude
		if distH < 6 then chegou = true; break end
		if distH < minDist then minDist = distH end
		if distH > minDist + 50 then chegou = true; break end

		local dirUnit = dirH.Unit
		local yAlvo = alturaVoo
		if distH < 20 then yAlvo = posAlvo.Y + 2 end

		if posAtual.Y < alturaVoo - 5 then
			pcall(function()
				h.CFrame = CFrame.new(Vector3.new(posAtual.X, alturaVoo, posAtual.Z))
				h.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			end)
		end

		local velAtual = CFG.vel or 80
		if distH < 25 then velAtual = math.min(velAtual, 80) end
		if distH < 15 then velAtual = math.min(velAtual, 40) end

		local velY = math.clamp((yAlvo - posAtual.Y) * 3, -18, 18)
		bv.Velocity = Vector3.new(dirUnit.X * velAtual, velY, dirUnit.Z * velAtual)

		pcall(function()
			local look = CFrame.new(posAtual, Vector3.new(posAlvo.X, posAtual.Y, posAlvo.Z))
			bg.CFrame = look
		end)

		if _suspenderTudo then bv.Velocity = Vector3.new(0, 0, 0); break end
		task.wait(0.03)
	end

	bv.Velocity = Vector3.new(0, 0, 0)
	task.wait(0.08)

	local tDesce = tick()
	while tick() - tDesce < 3 do
		local h = HRP()
		if not h or not h.Parent then break end
		local diffY2 = h.Position.Y - (posAlvo.Y + 2)
		if math.abs(diffY2) <= 0.5 then break end
		if diffY2 > 0 then
			bv.Velocity = Vector3.new(0, -math.min(20, diffY2 * 4), 0)
		else
			bv.Velocity = Vector3.new(0, math.min(20, -diffY2 * 4), 0)
		end
		task.wait(0.03)
	end

	bv.Velocity = Vector3.new(0, 0, 0)
	task.wait(0.12)
	pcall(function() bv:Destroy() end)
	pcall(function() bg:Destroy() end)

	pcall(function()
		hum.WalkSpeed = humProps.WalkSpeed or 80
		hum.AutoRotate = humProps.AutoRotate ~= false
		hum.PlatformStand = false
		hum:ChangeState(Enum.HumanoidStateType.Running)
	end)

	local h = HRP()
	if h then pcall(function() h.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end) end

	return chegou
end

-- ⭐ Dispatcher
local function Mover(posAlvo, timeout)
	if not posAlvo then return false end
	if CFG.vooAtivo then
		if TemAguaNoCaminho(posAlvo) then
			return AndarRapido(posAlvo, timeout or 90)
		end
		return Voar(posAlvo, timeout or 60)
	else
		return AndarRapido(posAlvo, timeout or 90)
	end
end

local _camConn = nil
local function TravarCam(pos)
	if not CFG.travarCam then return end
	local cam = workspace.CurrentCamera; if not cam then return end
	if _camConn then pcall(function() _camConn:Disconnect() end) end
	cam.CameraType = Enum.CameraType.Scriptable
	_camConn = RunService.RenderStepped:Connect(function()
		local hrp = HRP(); if not hrp then return end
		local ap = Vector3.new(pos.X, pos.Y + 3, pos.Z)
		local orig = hrp.Position + Vector3.new(0, 8, 0)
		local dir = (ap - orig).Unit
		local cp = orig - dir * 12 + Vector3.new(0, 4, 0)
		cam.CFrame = CFrame.new(cp, ap)
	end)
end

local function DestravarCam()
	if _camConn then pcall(function() _camConn:Disconnect() end); _camConn = nil end
	local cam = workspace.CurrentCamera
	if cam then
		cam.CameraType = Enum.CameraType.Custom
		local h = HUM(); if h then cam.CameraSubject = h end
	end
end

-- ═══════════════════════════════════════════════════════════
-- UI
-- ═══════════════════════════════════════════════════════════
local function Iniciar()
	for _, n in ipairs({"SailentKeyUI","SailentPizza","SailentFloatBtn"}) do
		local o = CoreGui:FindFirstChild(n); if o then pcall(function() o:Destroy() end) end
	end
	task.wait(0.05)

	local SGB = Instance.new("ScreenGui")
	SGB.Name = "SailentFloatBtn"; SGB.ResetOnSpawn = false; SGB.IgnoreGuiInset = true; SGB.DisplayOrder = 5; SGB.Parent = CoreGui

	local FB = Instance.new("TextButton")
	FB.Text = "🍕"; FB.Font = Enum.Font.GothamBold; FB.TextSize = 26
	FB.TextColor3 = Color3.fromRGB(255,255,255); FB.BackgroundColor3 = C.Black
	FB.BorderSizePixel = 0; FB.Size = UDim2.new(0,60,0,60)
	FB.Position = UDim2.new(0,20,0.5,-30); FB.AutoButtonColor = false; FB.Parent = SGB

	local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(1,0); fc.Parent = FB
	local fs = Instance.new("UIStroke"); fs.Color = C.Accent; fs.Thickness = 2; fs.Parent = FB

	local function AtualizarInd()
		local r = CFG.autoEnt
		Tween(FB, {BackgroundColor3 = r and C.Green or C.Black}, 0.25)
		fs.Color = r and C.Green or C.Accent
		fs.Thickness = r and 3 or 2
	end

	local SG = Instance.new("ScreenGui")
	SG.Name = "SailentPizza"; SG.ResetOnSpawn = false; SG.IgnoreGuiInset = true; SG.DisplayOrder = 10; SG.Parent = CoreGui

	local M = Instance.new("Frame")
	M.Size = UDim2.new(0,420,0,640); M.Position = UDim2.new(0.5,-210,0.5,-320)
	M.BackgroundColor3 = C.BG2; M.BorderSizePixel = 0; M.BackgroundTransparency = 0.03; M.Parent = SG

	local mc = Instance.new("UICorner"); mc.CornerRadius = UDim.new(0,16); mc.Parent = M
	local ms = Instance.new("UIStroke"); ms.Color = C.Border; ms.Thickness = 1; ms.Transparency = 0.3; ms.Parent = M

	local top = Instance.new("Frame")
	top.Size = UDim2.new(1,0,0,3); top.BackgroundColor3 = C.Accent; top.BorderSizePixel = 0; top.Parent = M
	local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(0,16); tc.Parent = top
	local tg = Instance.new("UIGradient")
	tg.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,C.Accent),ColorSequenceKeypoint.new(0.5,C.Purple),ColorSequenceKeypoint.new(1,C.Yellow)})
	tg.Parent = top

	_G.SBDrag = false
	do
		local d, di, ds, sp
		local function up(i)
			if _G.SBDrag then return end
			local x = i.Position - ds
			M.Position = UDim2.new(sp.X.Scale, sp.X.Offset + x.X, sp.Y.Scale, sp.Y.Offset + x.Y)
		end
		M.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				if _G.SBDrag then return end
				d = true; ds = i.Position; sp = M.Position
				i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then d = false end end)
			end
		end)
		M.InputChanged:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
		end)
		UserInput.InputChanged:Connect(function(i) if i == di and d then up(i) end end)
	end

	local H = Instance.new("Frame")
	H.Size = UDim2.new(1,0,0,64); H.BackgroundColor3 = C.Card; H.BackgroundTransparency = 0.5
	H.BorderSizePixel = 0; H.Parent = M
	local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(0,16); hc.Parent = H

	local lg = Instance.new("Frame")
	lg.Size = UDim2.new(0,40,0,40); lg.Position = UDim2.new(0,14,0.5,-20)
	lg.BackgroundColor3 = C.Accent; lg.BorderSizePixel = 0; lg.Parent = H
	local lgc = Instance.new("UICorner"); lgc.CornerRadius = UDim.new(0,10); lgc.Parent = lg
	local lgg = Instance.new("UIGradient")
	lgg.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,C.Accent),ColorSequenceKeypoint.new(1,C.Purple)})
	lgg.Rotation = 45; lgg.Parent = lg

	local li = Instance.new("TextLabel")
	li.Text = "🍕"; li.Font = Enum.Font.GothamBold; li.TextSize = 22
	li.BackgroundTransparency = 1; li.Size = UDim2.new(1,0,1,0); li.Parent = lg

	local tt = Instance.new("TextLabel")
	tt.Text = "Auto Pizza"; tt.Font = Enum.Font.GothamBold; tt.TextSize = 15
	tt.TextColor3 = C.Text; tt.BackgroundTransparency = 1
	tt.Position = UDim2.new(0,62,0,12); tt.Size = UDim2.new(0,200,0,18); tt.TextXAlignment = Enum.TextXAlignment.Left; tt.Parent = H

	local vp = Instance.new("Frame")
	vp.Size = UDim2.new(0,180,0,16); vp.Position = UDim2.new(0,62,0,34)
	vp.BackgroundColor3 = C.Green; vp.BackgroundTransparency = 0.75; vp.BorderSizePixel = 0; vp.Parent = H
	local vpc = Instance.new("UICorner"); vpc.CornerRadius = UDim.new(1,0); vpc.Parent = vp
	local vt = Instance.new("TextLabel")
	vt.Text = "v"..KEY.VER.." • MODO SEGURO"; vt.Font = Enum.Font.GothamBold; vt.TextSize = 7
	vt.TextColor3 = C.Green; vt.BackgroundTransparency = 1; vt.Size = UDim2.new(1,0,1,0); vt.Parent = vp

	local mb = Instance.new("TextButton")
	mb.Text = "−"; mb.Font = Enum.Font.GothamBold; mb.TextSize = 20
	mb.TextColor3 = C.Yellow; mb.BackgroundColor3 = C.Card; mb.BackgroundTransparency = 0.4
	mb.BorderSizePixel = 0; mb.Size = UDim2.new(0,30,0,30); mb.Position = UDim2.new(1,-72,0.5,-15)
	mb.AutoButtonColor = false; mb.Parent = H
	local mbc = Instance.new("UICorner"); mbc.CornerRadius = UDim.new(0,8); mbc.Parent = mb

	local cb2 = Instance.new("TextButton")
	cb2.Text = "✕"; cb2.Font = Enum.Font.GothamBold; cb2.TextSize = 14
	cb2.TextColor3 = C.Red; cb2.BackgroundColor3 = C.Card; cb2.BackgroundTransparency = 0.4
	cb2.BorderSizePixel = 0; cb2.Size = UDim2.new(0,30,0,30); cb2.Position = UDim2.new(1,-36,0.5,-15)
	cb2.AutoButtonColor = false; cb2.Parent = H
	local cbc = Instance.new("UICorner"); cbc.CornerRadius = UDim.new(0,8); cbc.Parent = cb2

	local Cnt = Instance.new("ScrollingFrame")
	Cnt.Size = UDim2.new(1,-20,1,-84); Cnt.Position = UDim2.new(0,10,0,74)
	Cnt.BackgroundTransparency = 1; Cnt.BorderSizePixel = 0
	Cnt.ScrollBarThickness = 3; Cnt.ScrollBarImageColor3 = C.Accent
	Cnt.CanvasSize = UDim2.new(0,0,0,0); Cnt.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Cnt.Parent = M

	local cl = Instance.new("UIListLayout"); cl.Padding = UDim.new(0,8); cl.Parent = Cnt

	local function Sec(txt, cor)
		local f = Instance.new("Frame")
		f.Size = UDim2.new(1,0,0,22); f.BackgroundTransparency = 1; f.Parent = Cnt
		local d = Instance.new("Frame")
		d.Size = UDim2.new(0,5,0,5); d.Position = UDim2.new(0,3,0.5,-2.5)
		d.BackgroundColor3 = cor or C.Accent; d.BorderSizePixel = 0; d.Parent = f
		local dc = Instance.new("UICorner"); dc.CornerRadius = UDim.new(1,0); dc.Parent = d
		local l = Instance.new("TextLabel")
		l.Text = txt:upper(); l.Font = Enum.Font.GothamBold; l.TextSize = 10
		l.TextColor3 = cor or C.Accent; l.BackgroundTransparency = 1
		l.Position = UDim2.new(0,16,0,0); l.Size = UDim2.new(1,-16,1,0)
		l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
	end

	local function Btn(txt, cor, call)
		local b = Instance.new("TextButton")
		b.Text = txt; b.Font = Enum.Font.GothamBold; b.TextSize = 12
		b.TextColor3 = C.Text; b.BackgroundColor3 = C.Card; b.BorderSizePixel = 0
		b.Size = UDim2.new(1,0,0,38); b.AutoButtonColor = false; b.Parent = Cnt
		local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,10); c.Parent = b
		local s = Instance.new("UIStroke"); s.Color = C.Border; s.Thickness = 1; s.Transparency = 0.4; s.Parent = b
		b.MouseEnter:Connect(function() Tween(b, {BackgroundColor3 = Color3.fromRGB(32,32,48)}, 0.15); Tween(s, {Color = cor or C.Accent, Transparency = 0.2}, 0.15) end)
		b.MouseLeave:Connect(function() Tween(b, {BackgroundColor3 = C.Card}, 0.15); Tween(s, {Color = C.Border, Transparency = 0.4}, 0.15) end)
		b.MouseButton1Click:Connect(function()
			Tween(b, {BackgroundColor3 = cor or C.Accent}, 0.08)
			task.wait(0.1); Tween(b, {BackgroundColor3 = C.Card}, 0.15)
			if call then task.spawn(call) end
		end)
		return b
	end

	local function Toggle(txt, def, cor, call)
		local f = Instance.new("Frame")
		f.Size = UDim2.new(1,0,0,42); f.BackgroundColor3 = C.Card; f.BorderSizePixel = 0; f.Parent = Cnt
		local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,10); c.Parent = f
		local s = Instance.new("UIStroke"); s.Color = C.Border; s.Thickness = 1; s.Transparency = 0.4; s.Parent = f
		local l = Instance.new("TextLabel")
		l.Text = txt; l.Font = Enum.Font.GothamBold; l.TextSize = 12; l.TextColor3 = C.Text
		l.BackgroundTransparency = 1; l.Position = UDim2.new(0,14,0,0); l.Size = UDim2.new(1,-80,1,0)
		l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
		local bg = Instance.new("Frame")
		bg.Size = UDim2.new(0,44,0,22); bg.Position = UDim2.new(1,-56,0.5,-11)
		bg.BackgroundColor3 = Color3.fromRGB(50,50,65); bg.BorderSizePixel = 0; bg.Parent = f
		local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(1,0); bc.Parent = bg
		local k = Instance.new("Frame")
		k.Size = UDim2.new(0,18,0,18); k.Position = UDim2.new(0,2,0.5,-9)
		k.BackgroundColor3 = Color3.fromRGB(200,200,215); k.BorderSizePixel = 0; k.Parent = bg
		local kc = Instance.new("UICorner"); kc.CornerRadius = UDim.new(1,0); kc.Parent = k
		local st = def or false
		local function set(v)
			st = v
			if st then
				Tween(bg, {BackgroundColor3 = C.Green}, 0.2)
				Tween(k, {Position = UDim2.new(1,-20,0.5,-9), BackgroundColor3 = Color3.fromRGB(255,255,255)}, 0.2)
			else
				Tween(bg, {BackgroundColor3 = Color3.fromRGB(50,50,65)}, 0.2)
				Tween(k, {Position = UDim2.new(0,2,0.5,-9), BackgroundColor3 = Color3.fromRGB(200,200,215)}, 0.2)
			end
			if call then call(st) end
		end
		if st then bg.BackgroundColor3 = C.Green; k.Position = UDim2.new(1,-20,0.5,-9); k.BackgroundColor3 = Color3.fromRGB(255,255,255) end
		local cl2 = Instance.new("TextButton")
		cl2.Text = ""; cl2.BackgroundTransparency = 1; cl2.Size = UDim2.new(1,0,1,0); cl2.Parent = f
		cl2.MouseButton1Click:Connect(function() set(not st) end)
		return set
	end

	local function Slider(parent, label, min, max, def, cor, call)
		local fr = Instance.new("Frame")
		fr.Size = UDim2.new(1,0,0,58); fr.BackgroundColor3 = C.Card; fr.BorderSizePixel = 0; fr.Parent = parent
		local fc2 = Instance.new("UICorner"); fc2.CornerRadius = UDim.new(0,10); fc2.Parent = fr
		local fst = Instance.new("UIStroke"); fst.Color = C.Border; fst.Thickness = 1; fst.Transparency = 0.4; fst.Parent = fr
		local tt = Instance.new("TextLabel")
		tt.Text = label; tt.Font = Enum.Font.GothamBold; tt.TextSize = 12
		tt.TextColor3 = C.Text; tt.BackgroundTransparency = 1
		tt.Position = UDim2.new(0,14,0,6); tt.Size = UDim2.new(0.7,0,0,18)
		tt.TextXAlignment = Enum.TextXAlignment.Left; tt.Parent = fr
		local vl = Instance.new("TextLabel")
		vl.Text = tostring(def); vl.Font = Enum.Font.GothamBold
		vl.TextSize = 13; vl.TextColor3 = cor or C.Green; vl.BackgroundTransparency = 1
		vl.Position = UDim2.new(0.7,0,0,6); vl.Size = UDim2.new(0.3,-14,0,18)
		vl.TextXAlignment = Enum.TextXAlignment.Right; vl.Parent = fr
		local bb = Instance.new("Frame")
		bb.Size = UDim2.new(1,-28,0,10); bb.Position = UDim2.new(0,14,0,34)
		bb.BackgroundColor3 = Color3.fromRGB(40,40,55); bb.BorderSizePixel = 0; bb.Parent = fr
		local bbc = Instance.new("UICorner"); bbc.CornerRadius = UDim.new(1,0); bbc.Parent = bb
		local fb = Instance.new("Frame")
		fb.Size = UDim2.new(0,0,1,0); fb.BackgroundColor3 = cor or C.Accent
		fb.BorderSizePixel = 0; fb.Parent = bb
		local fbc = Instance.new("UICorner"); fbc.CornerRadius = UDim.new(1,0); fbc.Parent = fb
		local fg = Instance.new("UIGradient")
		fg.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,cor or C.Accent),ColorSequenceKeypoint.new(1,C.Purple)})
		fg.Parent = fb
		local kb = Instance.new("Frame")
		kb.Size = UDim2.new(0,16,0,16); kb.Position = UDim2.new(0,-8,0.5,-8)
		kb.BackgroundColor3 = Color3.fromRGB(255,255,255); kb.BorderSizePixel = 0; kb.Parent = bb
		local kbc = Instance.new("UICorner"); kbc.CornerRadius = UDim.new(1,0); kbc.Parent = kb
		local val = def; local arr = false
		local function Aplicar(p)
			val = math.floor(min + (max - min) * p)
			vl.Text = tostring(val)
			fb.Size = UDim2.new(p,0,1,0)
			kb.Position = UDim2.new(p,-8,0.5,-8)
			if call then call(val) end
		end
		local function Atu(x)
			local ba = bb.AbsolutePosition.X; local bs = bb.AbsoluteSize.X
			Aplicar(math.clamp((x - ba)/bs, 0, 1))
		end
		local ip = (def - min) / (max - min)
		fb.Size = UDim2.new(ip,0,1,0)
		kb.Position = UDim2.new(ip,-8,0.5,-8)
		bb.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				arr = true; _G.SBDrag = true; Atu(i.Position.X)
			end
		end)
		UserInput.InputChanged:Connect(function(i)
			if arr and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Atu(i.Position.X) end
		end)
		UserInput.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				if arr then arr = false; _G.SBDrag = false; Salvar() end
			end
		end)
		return function(v) v = math.clamp(v, min, max); Aplicar((v - min)/(max - min)) end
	end

	local function StatL(txt, cor)
		local f = Instance.new("Frame")
		f.Size = UDim2.new(1,0,0,30); f.BackgroundColor3 = C.Card; f.BorderSizePixel = 0; f.Parent = Cnt
		local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,8); c.Parent = f
		local s = Instance.new("UIStroke"); s.Color = C.Border; s.Thickness = 1; s.Transparency = 0.5; s.Parent = f
		local l = Instance.new("TextLabel")
		l.Text = txt; l.Font = Enum.Font.GothamBold; l.TextSize = 11
		l.TextColor3 = cor or C.Text; l.BackgroundTransparency = 1
		l.Position = UDim2.new(0,14,0,0); l.Size = UDim2.new(1,-20,1,0)
		l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
		return l
	end

	local UI = {}
	local entregaRun = 0
	local PararTudo

	Sec("Conta", C.Purple)
	StatL("👤 "..KS.nome.." ["..KS.nivel:upper().."]", C.Purple)

	Sec("Stats", C.Blue)
	local statsLabel = StatL(Resumo(), C.Text)

	Sec("🛡️ MODO SEGURO", C.Green)
	local statusModo = StatL("Modo: ● ANDAR (anti-kick)", C.Green)

	Sec("Auto Entregador", C.Accent)
	local entregaSt = StatL("Status: PARADO", C.Sub)

	local function ErroLoop(err)
		entregaSt.Text = "⚠️ Erro: "..tostring(err):sub(1,38)
		entregaSt.TextColor3 = C.Red
		task.wait(2)
	end

	local function Ciclo(run)
		if not HRP() then entregaSt.Text = "⏳ Aguardando..."; task.wait(1); return end
		entregaSt.TextColor3 = C.Green

		if TemPizza() then
			entregaSt.Text = "📤 Procurando cliente..."
			local info = AcharLocalMarcado()
			if info and info.pos then
				local nomePad = "Cliente"
				pcall(function() if info.pad then nomePad = info.pad.Name end end)
				entregaSt.Text = "📤 Indo pro "..nomePad.."..."
				TravarCam(info.pos)

				if CFG.vooAtivo and TemAguaNoCaminho(info.pos) then
					entregaSt.Text = "🌊 Água no caminho — andando..."
					entregaSt.TextColor3 = C.Yellow
				end

				Mover(info.pos, 90)
				if run ~= entregaRun then DestravarCam(); return end

				if DistanciaDe(info.pos) > 25 then
					entregaSt.Text = "⚠️ Longe do cliente ("..math.floor(DistanciaDe(info.pos))..")"
					entregaSt.TextColor3 = C.Yellow
					AndarRapido(info.pos, 60, 6)
					if DistanciaDe(info.pos) > 25 then
						entregaSt.Text = "⚠️ Ainda longe — pulando"
						entregaSt.TextColor3 = C.Red
						DestravarCam()
						task.wait(1.5)
						return
					end
				end

				if EstaNaAgua() then
					entregaSt.Text = "💧 Na água! Pulando entrega"
					entregaSt.TextColor3 = C.Red
					DestravarCam()
					task.wait(1.5)
					return
				end

				task.wait(0.3)
				entregaSt.Text = "📤 Entregando..."
				entregaSt.TextColor3 = C.Green

				local pr = AcharPrompt("Entregar Pedido")
				if pr then
					local promptPos = getPos(pr.Parent)
					if promptPos and (promptPos - info.pos).Magnitude > 30 then
						pr = nil
					end
				end

				if pr then
					local t0 = tick(); local tent = 0
					while tick() - t0 < 30 do
						if not TemPizza() then break end
						if run ~= entregaRun then DestravarCam(); return end
						if DistanciaDe(info.pos) > 25 then break end
						if EstaNaAgua() then break end
						pcall(function() fireproximityprompt(pr) end)
						tent = tent + 1
						entregaSt.Text = "📤 Entregando... ("..tent.."x)"
						task.wait(4)
					end
				end

				DestravarCam()
				if not TemPizza() then
					StatsD.entregues = StatsD.entregues + 1
					Notif("📤 Entregue! #"..StatsD.entregues, C.Green, 1.5)

					local espera = tonumber(CFG.esperaEntrega) or 5
					if espera > 0 then
						entregaSt.Text = "⏳ Aguardando "..espera.."s..."
						entregaSt.TextColor3 = C.Yellow
						local tEsp = tick()
						while tick() - tEsp < espera do
							if not CFG.autoEnt or run ~= entregaRun then return end
							if _suspenderTudo then return end
							task.wait(0.2)
						end
					end
				end
			else
				entregaSt.Text = "⚠️ Sem cliente ativo"
				task.wait(1.5)
			end
		else
			entregaSt.Text = "📥 Procurando pedido..."
			local pr = AcharPrompt("Pegar Pedido")
			if pr then
				local p = getPos(pr.Parent)
				if p then
					entregaSt.Text = "📥 Indo pegar..."
					Mover(p, 90)
					if run ~= entregaRun then return end
					task.wait(0.3)
					entregaSt.Text = "📥 Pegando..."
					pcall(function() fireproximityprompt(pr) end)
					task.wait(1.2)
					StatsD.pegos = StatsD.pegos + 1
					Notif("📥 Pego!", C.Blue, 1.2)
				end
			else
				entregaSt.Text = "⚠️ Sem pedido"
				task.wait(1.5)
			end
		end
	end

	UI.setEnt = Toggle("🍕 Auto Entregar Pizza", CFG.autoEnt, C.Accent, function(s)
		CFG.autoEnt = s
		Salvar()
		AtualizarInd()
		entregaRun = entregaRun + 1
		if s then
			local run = entregaRun
			local h = HUM(); if h then h.WalkSpeed = CFG.vel end
			if CFG.noclip then AtivarNoclip() end
			if CFG.antiSit then AtivarAntiSit() end
			AtivarAntiDano()
			entregaSt.Text = "Status: ● ATIVO"; entregaSt.TextColor3 = C.Green
			Notif("🍕 ATIVADO", C.Green, 1.5)
			task.spawn(function()
				while CFG.autoEnt and run == entregaRun do
					local ok, e = pcall(Ciclo, run)
					if not ok then ErroLoop(e) end
					task.wait(0.5)
				end
				DestravarCam()
			end)
		else
			DestravarCam()
			if CFG.noclip then DesativarNoclip() end
			if CFG.antiSit then DesativarAntiSit() end
			DesativarAntiDano()
			entregaSt.Text = "Status: PARADO"; entregaSt.TextColor3 = C.Sub
			Notif("🍕 DESATIVADO", C.Yellow, 1.5)
			local h = HUM(); if h then h.WalkSpeed = 16 end
		end
	end)

	Sec("⚡ VELOCIDADE", C.Green)
	StatL("Muda na hora, mesmo em movimento", C.Sub)
	UI.setVel = Slider(Cnt, "⚡ Velocidade", 20, 300, CFG.vel, C.Green, function(v)
		CFG.vel = v
		local h = HUM()
		if h and CFG.autoEnt then
			local hrp = HRP()
			local voando = false
			if hrp then
				for _, c in ipairs(hrp:GetChildren()) do
					if c:IsA("BodyVelocity") then voando = true; break end
				end
			end
			if not voando then h.WalkSpeed = v end
		end
	end)

	Sec("⏳ ESPERA ENTRE ENTREGAS", C.Yellow)
	StatL("Tempo parado após entregar", C.Sub)
	UI.setEspera = Slider(Cnt, "⏱️ Segundos de espera", 0, 30, CFG.esperaEntrega or 5, C.Yellow, function(v)
		CFG.esperaEntrega = v
	end)

	Sec("🛸 VOO AÉREO (RISCO DE KICK!)", C.Red)
	StatL("⚠️ Use só se necessário — pode kickar", C.Red)
	UI.setVoo = Toggle("🛸 Ativar voo aéreo", CFG.vooAtivo, C.Red, function(s)
		CFG.vooAtivo = s; Salvar()
		if s then
			Notif("⚠️ VOO ON — pode dar kick sobre água!", C.Red, 3)
			statusModo.Text = "Modo: ● VOO (pode kickar)"
			statusModo.TextColor3 = C.Red
		else
			Notif("✅ Voo OFF — modo seguro", C.Green, 1.5)
			statusModo.Text = "Modo: ● ANDAR (anti-kick)"
			statusModo.TextColor3 = C.Green
		end
	end)
	UI.setAltura = Slider(Cnt, "📏 Altura do voo", 1, 15, CFG.alturaVoo or 2, C.Purple, function(v)
		CFG.alturaVoo = v
	end)

	Sec("Comportamento", C.Purple)
	UI.setNoclip = Toggle("🚪 Noclip", CFG.noclip, C.Green, function(s)
		CFG.noclip = s; Salvar()
		if s then
			if CFG.autoEnt then AtivarNoclip() end
		else
			DesativarNoclip()
		end
	end)
	UI.setAntiSit = Toggle("🪑 Anti-Sentar", CFG.antiSit, C.Yellow, function(s)
		CFG.antiSit = s; Salvar()
		if s then
			if CFG.autoEnt then AtivarAntiSit() end
		else
			DesativarAntiSit()
		end
	end)
	UI.setAfk = Toggle("😴 Anti-AFK", CFG.antiAfk, C.Blue, function(s)
		CFG.antiAfk = s; Salvar(); SetAFK(s)
	end)
	UI.setCam = Toggle("🎥 Travar câmera", CFG.travarCam, C.Accent, function(s)
		CFG.travarCam = s; Salvar(); if not s then DestravarCam() end
	end)

	Sec("Emergência", C.Red)
	PararTudo = function()
		CFG.autoEnt = false
		entregaRun = entregaRun + 1
		if UI.setEnt then UI.setEnt(false) end
		DestravarCam()
		if CFG.noclip then DesativarNoclip() end
		if CFG.antiSit then DesativarAntiSit() end
		DesativarAntiDano()
		entregaSt.Text = "Status: PARADO"; entregaSt.TextColor3 = C.Sub
		local h = HUM(); if h then h.WalkSpeed = 16 end
		AtualizarInd()
	end

	Btn("🛑 PARAR TUDO", C.Red, function()
		PararTudo()
		Notif("🛑 Parado!", C.Red, 2)
	end)

	local aberta = true
	local function Fechar()
		aberta = false
		Tween(M, {Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.5,0,0.5,0)}, 0.25)
		task.wait(0.25); M.Visible = false
		FB.Text = "🍕"
	end
	local function Abrir()
		aberta = true; M.Visible = true
		M.Size = UDim2.new(0,0,0,0); M.Position = UDim2.new(0.5,0,0.5,0)
		Tween(M, {Size = UDim2.new(0,420,0,640), Position = UDim2.new(0.5,-210,0.5,-320)}, 0.3, Enum.EasingStyle.Back)
		FB.Text = "✕"
	end

	local fbDrag, fbStart, fbPos, fbMoveu
	FB.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			fbDrag = true; fbMoveu = false; fbStart = i.Position; fbPos = FB.Position
		end
	end)
	FB.InputChanged:Connect(function(i)
		if fbDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - fbStart
			if math.abs(d.X) > 5 or math.abs(d.Y) > 5 then fbMoveu = true end
			FB.Position = UDim2.new(fbPos.X.Scale, fbPos.X.Offset + d.X, fbPos.Y.Scale, fbPos.Y.Offset + d.Y)
		end
	end)
	UserInput.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then fbDrag = false end
	end)
	FB.MouseButton1Click:Connect(function()
		if fbMoveu then return end
		if aberta then Fechar() else Abrir() end
	end)

	mb.MouseButton1Click:Connect(function()
		if aberta then Fechar() end
		FB.Visible = true
	end)
	cb2.MouseButton1Click:Connect(Fechar)

	UserInput.InputBegan:Connect(function(inp, gp)
		if gp then return end
		if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
		local n = inp.KeyCode.Name
		if n == CFG.keyUI then
			if aberta then Fechar() else Abrir() end
		elseif n == CFG.keyPanic then
			PararTudo(); Fechar()
			Notif("🚨 PANIC", C.Red, 2)
		elseif n == CFG.keyEnt then
			UI.setEnt(not CFG.autoEnt)
		end
	end)

	task.spawn(function()
		while SG.Parent do
			task.wait(1)
			pcall(function()
				statsLabel.Text = Resumo()
				if CFG.vooAtivo then
					statusModo.Text = "Modo: ● VOO (pode kickar)"
					statusModo.TextColor3 = C.Red
				else
					statusModo.Text = "Modo: ● ANDAR (anti-kick)"
					statusModo.TextColor3 = C.Green
				end
			end)
		end
	end)

	SetAFK(CFG.antiAfk)
	if CFG.antiSit then AtivarAntiSit() end
	if CFG.autoEnt then UI.setEnt(true) end
	AtualizarInd()

	Notif("🍕 Auto Pizza v"..KEY.VER.." (ANTI-KICK)", C.Green, 2.5)
	Log("🍕 Auto Pizza v"..KEY.VER)
end

Log("🔐 Verificando key...")
task.spawn(function()
	local k = CKey()
	if k and k ~= "" then
		local ok = VKey(k)
		if ok then Log("✅ Key válida!"); Iniciar(); return end
	end
	LoginUI(function() Iniciar() end)
end)

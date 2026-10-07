-- ============================================================
-- SAILENT AUTO PRISÃO v3.1 — UI Pizza + Velocidade Única (LIMPO)
-- Removido: webhook, perfis, FPS boost, server hop, reconnect,
-- hotkeys editáveis, som, tempo prisão. Só o essencial.
-- ============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local lp = Players.LocalPlayer

local KEY_CONFIG = {
	URL_KEYS = "https://raw.githubusercontent.com/simiao64santos-dot/sailent-/refs/heads/main/keys.json",
	ARQUIVO_CACHE = "sailent_gari_key.txt",
	VERSAO = "3.1",
}

for _, name in ipairs({"SailentPrisao", "SailentFloatBtn", "SailentKeyUI", "SailentToast"}) do
	local old = CoreGui:FindFirstChild(name)
	if old then pcall(function() old:Destroy() end) end
end

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
local function Log(m) print("[Prisao] "..tostring(m)) end
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

local KS = { valida = false, nivel = "normal", nome = "Cliente", key = "" }
local function CKey() local k = nil; pcall(function() if isfile and isfile(KEY_CONFIG.ARQUIVO_CACHE) and readfile then k = readfile(KEY_CONFIG.ARQUIVO_CACHE) end end); return k end
local function LKey() pcall(function() if delfile and isfile and isfile(KEY_CONFIG.ARQUIVO_CACHE) then delfile(KEY_CONFIG.ARQUIVO_CACHE) end end) end

local function VKey(k)
	if not k or k == "" then return false, "Cole uma key!" end
	k = k:gsub("%s+","")
	local httpFn = GetHttp()
	if not httpFn then return false, "Sem HTTP!" end
	local ok, resp = pcall(function() return httpFn({Url=KEY_CONFIG.URL_KEYS.."?t="..tick(), Method="GET"}) end)
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
	KS.key = k
	pcall(function() if writefile then writefile(KEY_CONFIG.ARQUIVO_CACHE, k) end end)
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
	tit.Text = "🔓 SAILENT PRISÃO"; tit.Font = Enum.Font.GothamBold; tit.TextSize = 20
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
	ver.Text = "v"..KEY_CONFIG.VERSAO; ver.Font = Enum.Font.Code; ver.TextSize = 9
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

-- Config
local CONFIG_FILE = "sailent_prisao_cfg.txt"
local CFG = {
	vel = 100,
	alturaVoo = 2,
	modoVoo = false,
	noclip = true,
	antiAfk = true,
	travarCam = true,
	autoVarrer = false,
	autoCaixa = false,
	keyUI = "F2",
	keyPanic = "F1",
	keyVarrer = "F3",
	keyCaixa = "F4",
}

pcall(function()
	if isfile and isfile(CONFIG_FILE) and readfile then
		for l in readfile(CONFIG_FILE):gmatch("[^\n]+") do
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
	pcall(function() if writefile then writefile(CONFIG_FILE, s) end end)
end

-- Achar objetos
local varridos = {}

local function AcharLocalVarrer()
	local folder = workspace:FindFirstChild("LocaisVarrer")
	if not folder then return nil end
	local hrp = HRP()
	if not hrp then return nil end
	local maisPerto, menorDist = nil, math.huge
	for _, part in ipairs(folder:GetChildren()) do
		if part:IsA("BasePart") and not varridos[part] then
			local dist = (part.Position - hrp.Position).Magnitude
			if dist < menorDist then menorDist = dist; maisPerto = part end
		end
	end
	if not maisPerto then
		varridos = {}
		task.wait(0.5)
		for _, part in ipairs(folder:GetChildren()) do
			if part:IsA("BasePart") then
				local dist = (part.Position - hrp.Position).Magnitude
				if dist < menorDist then menorDist = dist; maisPerto = part end
			end
		end
	end
	return maisPerto
end

local function ContarTotalLocais()
	local folder = workspace:FindFirstChild("LocaisVarrer")
	if not folder then return 0 end
	local total = 0
	for _, p in ipairs(folder:GetChildren()) do
		if p:IsA("BasePart") then total = total + 1 end
	end
	return total
end

local function AcharPrompt(txt)
	local hrp = HRP(); if not hrp then return nil end
	local mais, menor = nil, math.huge
	for _, o in ipairs(workspace:GetDescendants()) do
		if o:IsA("ProximityPrompt") and o.ActionText and o.ActionText:lower():find(txt:lower()) then
			local p = o.Parent
			if p and p:IsA("BasePart") then
				local d = (p.Position - hrp.Position).Magnitude
				if d < menor then menor = d; mais = o end
			end
		end
	end
	return mais
end

local function TemCaixa()
	if not lp.Character then return false end
	for _, o in ipairs(lp.Character:GetChildren()) do
		if o:IsA("Tool") and (o.Name:lower():find("caixa") or o.Name:lower():find("lixo") or o.Name:lower():find("trash")) then
			return true
		end
	end
	return false
end

local function EquiparVassoura()
	if not lp.Character then return end
	local hum = HUM(); if not hum then return end
	for _, o in ipairs(lp.Character:GetChildren()) do
		if o:IsA("Tool") and o.Name:lower():find("vassoura") then return end
	end
	if lp.Backpack then
		for _, o in ipairs(lp.Backpack:GetChildren()) do
			if o:IsA("Tool") and o.Name:lower():find("vassoura") then
				pcall(function() hum:EquipTool(o) end)
				return
			end
		end
	end
end

-- Movimento
local function Andar(posAlvo, timeout, dist)
	if not posAlvo then return false end
	local hrp = HRP(); local hum = HUM()
	if not hrp or not hum then return false end
	timeout = timeout or 30; dist = dist or 4
	local t0 = tick()
	hum.WalkSpeed = CFG.vel
	hum:MoveTo(posAlvo)
	while tick() - t0 < timeout do
		local h = HRP(); if not h then return false end
		hum.WalkSpeed = CFG.vel
		local df = Vector3.new(h.Position.X - posAlvo.X, 0, h.Position.Z - posAlvo.Z)
		if df.Magnitude < dist then hum:MoveTo(h.Position); return true end
		hum:MoveTo(posAlvo)
		task.wait(0.1)
	end
	return false
end

local function Voar(posAlvo, timeout)
	if not posAlvo then return false end
	local hrp = HRP(); local hum = HUM()
	if not hrp or not hum then return false end
	timeout = timeout or 25

	local colideOriginal = {}
	for _, p in ipairs(lp.Character:GetDescendants()) do
		if p:IsA("BasePart") then
			colideOriginal[p] = p.CanCollide
			p.CanCollide = false
		end
	end

	local bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bv.Velocity = Vector3.new(0,0,0)
	bv.P = 1250; bv.Parent = hrp

	local t0 = tick()
	while tick() - t0 < timeout do
		local h = HRP()
		if not h or not bv.Parent then break end
		local diff = posAlvo - h.Position
		if diff.Magnitude < 6 then bv.Velocity = Vector3.new(0,0,0); break end
		-- usa velocidade única
		bv.Velocity = diff.Unit * CFG.vel
		task.wait(0.05)
	end

	-- Desce
	local t2 = tick()
	while tick() - t2 < 6 do
		local h = HRP()
		if not h or not bv.Parent then break end
		bv.Velocity = Vector3.new(0, -25, 0)
		task.wait(0.08)
	end

	pcall(function() bv:Destroy() end)
	task.wait(0.2)
	for p, v in pairs(colideOriginal) do
		if p and p.Parent then pcall(function() p.CanCollide = v end) end
	end
	return true
end

local function IrPara(pos, timeout)
	if CFG.modoVoo then return Voar(pos, timeout) else return Andar(pos, timeout) end
end

-- Stats
local Stats = { varridos = 0, caixas = 0, entregues = 0, inicio = tick() }
local function FmtT(s) s = math.floor(s); return string.format("%02d:%02d:%02d", math.floor(s/3600), math.floor(s%3600/60), s%60) end
local function Resumo() local d = tick() - Stats.inicio; return string.format("⏱ %s  🧹 %d  📦 %d", FmtT(d), Stats.varridos, Stats.entregues) end

-- Travar câmera
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
	for _, n in ipairs({"SailentKeyUI","SailentPrisao","SailentFloatBtn"}) do
		local o = CoreGui:FindFirstChild(n); if o then pcall(function() o:Destroy() end) end
	end
	task.wait(0.05)

	local SGB = Instance.new("ScreenGui")
	SGB.Name = "SailentFloatBtn"; SGB.ResetOnSpawn = false; SGB.IgnoreGuiInset = true; SGB.DisplayOrder = 5; SGB.Parent = CoreGui

	local FB = Instance.new("TextButton")
	FB.Text = "🔓"; FB.Font = Enum.Font.GothamBold; FB.TextSize = 26
	FB.TextColor3 = Color3.fromRGB(255,255,255); FB.BackgroundColor3 = C.Black
	FB.BorderSizePixel = 0; FB.Size = UDim2.new(0,60,0,60)
	FB.Position = UDim2.new(0,20,0.5,-30); FB.AutoButtonColor = false; FB.Parent = SGB

	local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(1,0); fc.Parent = FB
	local fs = Instance.new("UIStroke"); fs.Color = C.Accent; fs.Thickness = 2; fs.Parent = FB

	local function AtualizarInd()
		local r = CFG.autoVarrer or CFG.autoCaixa
		Tween(FB, {BackgroundColor3 = r and C.Green or C.Black}, 0.25)
		fs.Color = r and C.Green or C.Accent
		fs.Thickness = r and 3 or 2
	end

	local SG = Instance.new("ScreenGui")
	SG.Name = "SailentPrisao"; SG.ResetOnSpawn = false; SG.IgnoreGuiInset = true; SG.DisplayOrder = 10; SG.Parent = CoreGui

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
	li.Text = "🔓"; li.Font = Enum.Font.GothamBold; li.TextSize = 22
	li.BackgroundTransparency = 1; li.Size = UDim2.new(1,0,1,0); li.Parent = lg

	local tt = Instance.new("TextLabel")
	tt.Text = "Auto Prisão"; tt.Font = Enum.Font.GothamBold; tt.TextSize = 15
	tt.TextColor3 = C.Text; tt.BackgroundTransparency = 1
	tt.Position = UDim2.new(0,62,0,12); tt.Size = UDim2.new(0,200,0,18); tt.TextXAlignment = Enum.TextXAlignment.Left; tt.Parent = H

	local vp = Instance.new("Frame")
	vp.Size = UDim2.new(0,160,0,16); vp.Position = UDim2.new(0,62,0,34)
	vp.BackgroundColor3 = C.Yellow; vp.BackgroundTransparency = 0.75; vp.BorderSizePixel = 0; vp.Parent = H
	local vpc = Instance.new("UICorner"); vpc.CornerRadius = UDim.new(1,0); vpc.Parent = vp
	local vt = Instance.new("TextLabel")
	vt.Text = "v"..KEY_CONFIG.VERSAO.." • VEL ÚNICA"; vt.Font = Enum.Font.GothamBold; vt.TextSize = 7
	vt.TextColor3 = C.Yellow; vt.BackgroundTransparency = 1; vt.Size = UDim2.new(1,0,1,0); vt.Parent = vp

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
	local varreRun, caixaRun = 0, 0
	local PararTudo

	Sec("Conta", C.Purple)
	StatL("👤 "..KS.nome.." ["..KS.nivel:upper().."]", C.Purple)

	Sec("Stats", C.Blue)
	local statsLabel = StatL(Resumo(), C.Text)

	Sec("Auto Varrer", C.Green)
	local varreStatus = StatL("Status: PARADO | 0/0", C.Sub)

	local function CicloVarrer(myRun)
		if not HRP() then varreStatus.Text = "⏳ Aguardando..."; task.wait(1); return end
		local localVarrer = AcharLocalVarrer()
		if not localVarrer then
			varreStatus.Text = "⚠️ Sem local (LocaisVarrer)"
			varreStatus.TextColor3 = C.Yellow
			task.wait(2)
			return
		end
		varreStatus.TextColor3 = C.Green
		varreStatus.Text = "📥 Indo varrer..."
		IrPara(localVarrer.Position, 20)
		if myRun ~= varreRun then return end
		task.wait(0.3)
		varreStatus.Text = "🧹 Varrendo..."
		local prompt = localVarrer:FindFirstChildWhichIsA("ProximityPrompt", true)
		if prompt then pcall(function() fireproximityprompt(prompt) end) end
		EquiparVassoura()
		task.wait(5)
		if myRun ~= varreRun then return end
		varridos[localVarrer] = true
		Stats.varridos = Stats.varridos + 1
		local total = 0
		for _ in pairs(varridos) do total = total + 1 end
		local todos = ContarTotalLocais()
		varreStatus.Text = "🧹 Varreu "..total.."/"..todos
		Notif("🧹 Varreu! "..total.."/"..todos, C.Green, 1.5)
		if total >= todos then
			Notif("✅ Perímetro completo! Resetando...", C.Blue, 2)
			varridos = {}
			task.wait(0.5)
		end
	end

	UI.setVarre = Toggle("🧹 Ativar Varredura", CFG.autoVarrer, C.Green, function(s)
		CFG.autoVarrer = s
		Salvar()
		AtualizarInd()
		varreRun = varreRun + 1
		if s then
			local myRun = varreRun
			if CFG.noclip then AtivarNoclip() end
			varridos = {}
			varreStatus.Text = "Status: ● ATIVO | 0/"..ContarTotalLocais()
			varreStatus.TextColor3 = C.Green
			Notif("🧹 Varredura ATIVADA", C.Green, 1.5)
			task.spawn(function()
				while CFG.autoVarrer and myRun == varreRun do
					local ok, e = pcall(CicloVarrer, myRun)
					if not ok then
						varreStatus.Text = "⚠️ Erro: "..tostring(e):sub(1,38)
						varreStatus.TextColor3 = C.Red
						task.wait(2)
					end
					task.wait(0.5)
				end
			end)
		else
			if not CFG.autoCaixa then DesativarNoclip() end
			varreStatus.Text = "Status: PARADO"
			varreStatus.TextColor3 = C.Sub
			Notif("🧹 Varredura DESATIVADA", C.Yellow, 1.5)
		end
	end)

	Sec("Auto Caixa", C.Blue)
	local caixaStatus = StatL("Status: PARADO", C.Sub)

	local function CicloCaixa(myRun)
		if not HRP() then caixaStatus.Text = "⏳ Aguardando..."; task.wait(1); return end
		caixaStatus.TextColor3 = C.Green
		if TemCaixa() then
			caixaStatus.Text = "📤 Indo entregar..."
			local pr = AcharPrompt("Colocar Caixa")
			if not pr then pr = AcharPrompt("Entregar") end
			if pr then
				local part = pr.Parent
				IrPara(part.Position, 25)
				if myRun ~= caixaRun then return end
				task.wait(0.3)
				caixaStatus.Text = "📤 Entregando..."
				pcall(function() fireproximityprompt(pr) end)
				task.wait(0.6)
				Stats.entregues = Stats.entregues + 1
				Notif("📤 Entregue!", C.Blue, 1.5)
			else
				caixaStatus.Text = "⚠️ Sem NPC de entregar"
				task.wait(2)
			end
		else
			caixaStatus.Text = "📥 Procurando caixa..."
			local pr = AcharPrompt("Collect Trash")
			if not pr then pr = AcharPrompt("Coletar") end
			if pr then
				local part = pr.Parent
				IrPara(part.Position, 25)
				if myRun ~= caixaRun then return end
				task.wait(0.3)
				caixaStatus.Text = "📥 Coletando..."
				pcall(function() fireproximityprompt(pr) end)
				task.wait(0.6)
				Stats.caixas = Stats.caixas + 1
				Notif("📥 Caixa coletada!", C.Green, 1.2)
			else
				caixaStatus.Text = "⚠️ Sem caixa perto"
				task.wait(2)
			end
		end
	end

	UI.setCaixa = Toggle("📦 Ativar Caixa", CFG.autoCaixa, C.Blue, function(s)
		CFG.autoCaixa = s
		Salvar()
		AtualizarInd()
		caixaRun = caixaRun + 1
		if s then
			local myRun = caixaRun
			if CFG.noclip then AtivarNoclip() end
			caixaStatus.Text = "Status: ● ATIVO"
			caixaStatus.TextColor3 = C.Green
			Notif("📦 Caixa ATIVADA", C.Green, 1.5)
			task.spawn(function()
				while CFG.autoCaixa and myRun == caixaRun do
					local ok, e = pcall(CicloCaixa, myRun)
					if not ok then
						caixaStatus.Text = "⚠️ Erro: "..tostring(e):sub(1,38)
						caixaStatus.TextColor3 = C.Red
						task.wait(2)
					end
					task.wait(0.5)
				end
			end)
		else
			if not CFG.autoVarrer then DesativarNoclip() end
			caixaStatus.Text = "Status: PARADO"
			caixaStatus.TextColor3 = C.Sub
			Notif("📦 Caixa DESATIVADA", C.Yellow, 1.5)
		end
	end)

	Sec("⚡ VELOCIDADE (a pé + voo)", C.Green)
	StatL("Muda na hora, também no voo", C.Sub)
	UI.setVel = Slider(Cnt, "⚡ Velocidade", 16, 300, CFG.vel, C.Green, function(v)
		CFG.vel = v
		local h = HUM()
		if h and not CFG.modoVoo then h.WalkSpeed = v end
	end)

	Sec("🚁 Modo de Locomoção", C.Yellow)
	local modoStatus = StatL(CFG.modoVoo and "Modo: 🚁 VOANDO" or "Modo: 🚶 A PÉ", C.Yellow)

	Btn("🚶 A PÉ (padrão)", C.Green, function()
		CFG.modoVoo = false
		modoStatus.Text = "Modo: 🚶 A PÉ"
		modoStatus.TextColor3 = C.Green
		Salvar()
	end)

	Btn("🚁 VOAR (fly direto)", C.Blue, function()
		CFG.modoVoo = true
		modoStatus.Text = "Modo: 🚁 VOANDO"
		modoStatus.TextColor3 = C.Blue
		Salvar()
	end)

	Sec("Comportamento", C.Purple)
	UI.setNoclip = Toggle("🚪 Noclip", CFG.noclip, C.Green, function(s)
		CFG.noclip = s; Salvar()
		if s then
			if CFG.autoVarrer or CFG.autoCaixa then AtivarNoclip() end
		else
			DesativarNoclip()
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
		CFG.autoVarrer = false
		CFG.autoCaixa = false
		varreRun = varreRun + 1
		caixaRun = caixaRun + 1
		if UI.setVarre then UI.setVarre(false) end
		if UI.setCaixa then UI.setCaixa(false) end
		DestravarCam()
		DesativarNoclip()
		varreStatus.Text = "Status: PARADO"
		caixaStatus.Text = "Status: PARADO"
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
		FB.Text = "🔓"
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
		elseif n == CFG.keyVarrer then
			UI.setVarre(not CFG.autoVarrer)
		elseif n == CFG.keyCaixa then
			UI.setCaixa(not CFG.autoCaixa)
		end
	end)

	task.spawn(function()
		while SG.Parent do
			task.wait(1)
			pcall(function() statsLabel.Text = Resumo() end)
		end
	end)

	SetAFK(CFG.antiAfk)
	if CFG.autoVarrer then UI.setVarre(true) end
	if CFG.autoCaixa then UI.setCaixa(true) end
	AtualizarInd()

	Notif("🔓 Auto Prisão v"..KEY_CONFIG.VERSAO.." carregado!", C.Green, 2.5)
	Log("🔓 Auto Prisão v"..KEY_CONFIG.VERSAO)
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

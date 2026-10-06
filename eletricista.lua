-- ============================================================
-- SAILENT AUTO ELETRICISTA v3.2 — UI Pizza + Vel Única + Anti-Sit
-- TP + Part invisível + God Mode + Anti-Sit
-- ============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local lp = Players.LocalPlayer

local KEY_CONFIG = {
	URL_KEYS = "https://raw.githubusercontent.com/simiao64santos-dot/sailent-/refs/heads/main/keys.json",
	ARQUIVO_CACHE = "sailent_gari_key.txt",
	NOME_SCRIPT = "Sailent Auto Eletricista v3.2",
}

for _, name in ipairs({"SailentEletricista", "SailentFloatBtn", "SailentKeyUI", "SailentToast"}) do
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

local function Tween(o, p, t)
	if not o or not o.Parent then return end
	local tw = TweenService:Create(o, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint), p)
	tw:Play()
	return tw
end

local function Log(msg) print("[Eletricista] " .. tostring(msg)) end

local function Sha256(msg)
	local K = {
		0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
		0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
		0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
		0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
		0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
		0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
		0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
		0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
	}
	local H = {0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
	local function ror(x, n) return bit32.bor(bit32.rshift(x, n), bit32.lshift(x, 32 - n)) end
	local len = #msg
	local bitLen = len * 8
	msg = msg .. "\128"
	while (#msg % 64) ~= 56 do msg = msg .. "\0" end
	local hi = math.floor(bitLen / 4294967296)
	local lo = bitLen % 4294967296
	local function u32be(n)
		return string.char(
			bit32.band(bit32.rshift(n, 24), 0xFF), bit32.band(bit32.rshift(n, 16), 0xFF),
			bit32.band(bit32.rshift(n, 8), 0xFF), bit32.band(n, 0xFF))
	end
	msg = msg .. u32be(hi) .. u32be(lo)
	for chunk = 1, #msg, 64 do
		local w = {}
		for i = 0, 15 do
			local a, b, c, d = msg:byte(chunk + i*4, chunk + i*4 + 3)
			w[i] = bit32.bor(bit32.lshift(a, 24), bit32.lshift(b, 16), bit32.lshift(c, 8), d)
		end
		for i = 16, 63 do
			local s0 = bit32.bxor(ror(w[i-15], 7), ror(w[i-15], 18), bit32.rshift(w[i-15], 3))
			local s1 = bit32.bxor(ror(w[i-2], 17), ror(w[i-2], 19), bit32.rshift(w[i-2], 10))
			w[i] = (w[i-16] + s0 + w[i-7] + s1) % 4294967296
		end
		local a,b,c,d,e,f,g,h = table.unpack(H)
		for i = 0, 63 do
			local S1 = bit32.bxor(ror(e, 6), ror(e, 11), ror(e, 25))
			local ch = bit32.bxor(bit32.band(e, f), bit32.band(bit32.bnot(e), g))
			local t1 = (h + S1 + ch + K[i+1] + w[i]) % 4294967296
			local S0 = bit32.bxor(ror(a, 2), ror(a, 13), ror(a, 22))
			local mj = bit32.bxor(bit32.band(a, b), bit32.band(a, c), bit32.band(b, c))
			local t2 = (S0 + mj) % 4294967296
			h,g,f,e,d,c,b,a = g,f,e,(d + t1) % 4294967296,c,b,a,(t1 + t2) % 4294967296
		end
		H[1] = (H[1] + a) % 4294967296; H[2] = (H[2] + b) % 4294967296
		H[3] = (H[3] + c) % 4294967296; H[4] = (H[4] + d) % 4294967296
		H[5] = (H[5] + e) % 4294967296; H[6] = (H[6] + f) % 4294967296
		H[7] = (H[7] + g) % 4294967296; H[8] = (H[8] + h) % 4294967296
	end
	local out = {}
	for i = 1, 8 do out[#out+1] = string.format("%08x", H[i]) end
	return table.concat(out)
end

local function GetHWID()
	local hwid = ""
	pcall(function() hwid = game:GetService("RbxAnalyticsService"):GetClientId() end)
	if hwid == "" then pcall(function() hwid = gethwid and gethwid() or "" end) end
	if hwid == "" then hwid = "UNKNOWN-" .. tostring(lp.UserId) end
	return hwid
end

local KeyState = { valida = false, nivel = "normal", nome = "Cliente", expira = 0, hash = "", key = "" }

local function SalvarKeyLocal(key) pcall(function() if writefile then writefile(KEY_CONFIG.ARQUIVO_CACHE, key) end end) end
local function CarregarKeyLocal()
	local k = nil
	pcall(function() if isfile and isfile(KEY_CONFIG.ARQUIVO_CACHE) and readfile then k = readfile(KEY_CONFIG.ARQUIVO_CACHE) end end)
	return k
end
local function LimparKeyLocal()
	pcall(function() if delfile and isfile and isfile(KEY_CONFIG.ARQUIVO_CACHE) then delfile(KEY_CONFIG.ARQUIVO_CACHE) end end)
end

local function BaixarKeys()
	local httpFn = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
	if not httpFn then return nil, "Executor sem HTTP request!" end
	local ok, resp = pcall(function()
		return httpFn({ Url = KEY_CONFIG.URL_KEYS .. "?t=" .. tick(), Method = "GET" })
	end)
	if not ok or not resp then return nil, "Falha na rede" end
	local body = resp.Body or resp.body
	if not body or body == "" then return nil, "keys.json vazio" end
	local ok2, decoded = pcall(function() return HttpService:JSONDecode(body) end)
	if not ok2 or not decoded then return nil, "JSON inválido" end
	return decoded, nil
end

local function ValidarKey(keyInput)
	if not keyInput or keyInput == "" then return false, "Digite uma key!" end
	keyInput = keyInput:gsub("%s+", "")
	local dados, err = BaixarKeys()
	if not dados then return false, err end
	local hash = Sha256(keyInput)
	local entry = dados.keys and dados.keys[hash]
	if not entry then return false, "❌ Key inválida" end
	local agora = os.time()
	if entry.expira and entry.expira < agora and entry.expira < 99999999999 then return false, "⏰ Key expirada" end
	if entry.status and entry.status ~= "ativa" then return false, "🚫 Key desativada" end
	if entry.max_usos and entry.max_usos ~= -1 then
		if entry.usos and entry.usos >= entry.max_usos then return false, "🔁 Limite de usos" end
	end
	local meuHWID = GetHWID()
	if entry.hwid and entry.hwid ~= "" and entry.hwid ~= meuHWID then return false, "🔒 Key de outro dispositivo" end
	KeyState.valida = true
	KeyState.nivel = entry.nivel or "normal"
	KeyState.nome = entry.nome or "Cliente"
	KeyState.expira = entry.expira or 0
	KeyState.hash = hash
	KeyState.key = keyInput
	SalvarKeyLocal(keyInput)
	return true, entry
end

-- TOAST
local SGBToast = Instance.new("ScreenGui")
SGBToast.Name = "SailentToast"; SGBToast.ResetOnSpawn = false
SGBToast.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SGBToast.IgnoreGuiInset = true; SGBToast.DisplayOrder = 999; SGBToast.Parent = CoreGui

local toastContainer = Instance.new("Frame")
toastContainer.Size = UDim2.new(0, 320, 1, 0)
toastContainer.Position = UDim2.new(1, -340, 0, 0)
toastContainer.BackgroundTransparency = 1; toastContainer.Parent = SGBToast

local toastLay = Instance.new("UIListLayout")
toastLay.VerticalAlignment = Enum.VerticalAlignment.Bottom
toastLay.HorizontalAlignment = Enum.HorizontalAlignment.Right
toastLay.Padding = UDim.new(0, 6); toastLay.SortOrder = Enum.SortOrder.LayoutOrder
toastLay.Parent = toastContainer

local toastCounter = 0
local ultimoToast = {}
local function Notificar(txt, cor, duracao)
	cor = cor or C.Accent; duracao = duracao or 2.5
	local agora = tick()
	if ultimoToast[tostring(txt)] and (agora - ultimoToast[tostring(txt)]) < 1 then return end
	ultimoToast[tostring(txt)] = agora
	toastCounter = toastCounter + 1
	local t = Instance.new("TextLabel")
	t.Text = tostring(txt); t.Font = Enum.Font.GothamBold; t.TextSize = 12
	t.TextColor3 = C.Text; t.BackgroundColor3 = C.Card
	t.BackgroundTransparency = 0.05
	t.Size = UDim2.new(1, 0, 0, 36); t.TextWrapped = true
	t.LayoutOrder = toastCounter; t.Parent = toastContainer
	local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(0, 10); tc.Parent = t
	local tp = Instance.new("UIPadding")
	tp.PaddingLeft = UDim.new(0, 14); tp.PaddingRight = UDim.new(0, 14); tp.Parent = t
	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(0, 3, 1, -12); bar.Position = UDim2.new(0, 6, 0, 6)
	bar.BackgroundColor3 = cor; bar.BorderSizePixel = 0; bar.Parent = t
	local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(1, 0); bc.Parent = bar
	Tween(t, {BackgroundTransparency = 0.05}, 0.2)
	task.delay(duracao, function()
		Tween(t, {BackgroundTransparency = 1, TextTransparency = 1}, 0.4)
		task.wait(0.5); pcall(function() t:Destroy() end)
	end)
end

-- LOGIN (mesma UI do Pizza)
local function MostrarUILogin(callbackSucesso)
	local SGK = Instance.new("ScreenGui")
	SGK.Name = "SailentKeyUI"; SGK.ResetOnSpawn = false
	SGK.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SGK.IgnoreGuiInset = true; SGK.DisplayOrder = 999; SGK.Parent = CoreGui

	local BG = Instance.new("Frame")
	BG.Size = UDim2.new(1, 0, 1, 0); BG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	BG.BackgroundTransparency = 0.5; BG.BorderSizePixel = 0; BG.Parent = SGK

	local Box = Instance.new("Frame")
	Box.Size = UDim2.new(0, 380, 0, 360); Box.Position = UDim2.new(0.5, -190, 0.5, -180)
	Box.BackgroundColor3 = C.BG2; Box.BorderSizePixel = 0; Box.Parent = SGK
	local BC = Instance.new("UICorner"); BC.CornerRadius = UDim.new(0, 18); BC.Parent = Box
	local BS = Instance.new("UIStroke"); BS.Color = C.Accent; BS.Thickness = 1.5; BS.Transparency = 0.4; BS.Parent = Box

	local Top = Instance.new("Frame")
	Top.Size = UDim2.new(1, 0, 0, 4); Top.BackgroundColor3 = C.Accent
	Top.BorderSizePixel = 0; Top.Parent = Box
	local TopC = Instance.new("UICorner"); TopC.CornerRadius = UDim.new(0, 18); TopC.Parent = Top
	local TopG = Instance.new("UIGradient")
	TopG.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, C.Accent),
		ColorSequenceKeypoint.new(0.5, C.Purple),
		ColorSequenceKeypoint.new(1, C.Yellow),
	})
	TopG.Parent = Top

	local Title = Instance.new("TextLabel")
	Title.Text = "⚡ SAILENT ELETRICISTA"
	Title.Font = Enum.Font.GothamBold; Title.TextSize = 20; Title.TextColor3 = C.Text
	Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 0, 0, 20)
	Title.Size = UDim2.new(1, 0, 0, 26); Title.Parent = Box

	local Sub = Instance.new("TextLabel")
	Sub.Text = "Cole sua key"; Sub.Font = Enum.Font.Gotham
	Sub.TextSize = 12; Sub.TextColor3 = C.Sub; Sub.BackgroundTransparency = 1
	Sub.Position = UDim2.new(0, 0, 0, 48); Sub.Size = UDim2.new(1, 0, 0, 18); Sub.Parent = Box

	local hp = Instance.new("Frame")
	hp.Size = UDim2.new(0, 280, 0, 22); hp.Position = UDim2.new(0.5, -140, 0, 74)
	hp.BackgroundColor3 = C.Card; hp.BorderSizePixel = 0; hp.Parent = Box
	local hpc = Instance.new("UICorner"); hpc.CornerRadius = UDim.new(1, 0); hpc.Parent = hp

	local hw = Instance.new("TextLabel")
	hw.Text = "🔒 " .. GetHWID():sub(1, 22) .. "..."
	hw.Font = Enum.Font.Code; hw.TextSize = 10
	hw.TextColor3 = C.Sub; hw.BackgroundTransparency = 1
	hw.Size = UDim2.new(1, 0, 1, 0); hw.Parent = hp

	local Input = Instance.new("TextBox")
	Input.PlaceholderText = "SAILENT-XXXX-XXXX-XXXX"; Input.Font = Enum.Font.Code
	Input.TextSize = 13; Input.TextColor3 = C.Text; Input.PlaceholderColor3 = Color3.fromRGB(90,90,110)
	Input.BackgroundColor3 = C.Card; Input.BorderSizePixel = 0; Input.ClearTextOnFocus = false
	Input.Text = ""; Input.Position = UDim2.new(0, 28, 0, 110); Input.Size = UDim2.new(1, -56, 0, 44); Input.Parent = Box
	local IC = Instance.new("UICorner"); IC.CornerRadius = UDim.new(0, 10); IC.Parent = Input
	local IS = Instance.new("UIStroke"); IS.Color = C.Border; IS.Thickness = 1; IS.Parent = Input

	local Status = Instance.new("TextLabel")
	Status.Text = ""; Status.Font = Enum.Font.GothamBold; Status.TextSize = 11
	Status.TextColor3 = C.Red; Status.BackgroundTransparency = 1
	Status.Position = UDim2.new(0, 28, 0, 162); Status.Size = UDim2.new(1, -56, 0, 32)
	Status.TextWrapped = true; Status.TextYAlignment = Enum.TextYAlignment.Top; Status.Parent = Box

	local BtnValidar = Instance.new("TextButton")
	BtnValidar.Text = "VALIDAR"; BtnValidar.Font = Enum.Font.GothamBold
	BtnValidar.TextSize = 14; BtnValidar.TextColor3 = Color3.fromRGB(255,255,255)
	BtnValidar.BackgroundColor3 = C.Accent; BtnValidar.BorderSizePixel = 0
	BtnValidar.Position = UDim2.new(0, 28, 0, 210); BtnValidar.Size = UDim2.new(1, -56, 0, 48)
	BtnValidar.AutoButtonColor = false; BtnValidar.Parent = Box
	local BtnC = Instance.new("UICorner"); BtnC.CornerRadius = UDim.new(0, 10); BtnC.Parent = BtnValidar
	local BtnG = Instance.new("UIGradient")
	BtnG.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, C.Accent),
		ColorSequenceKeypoint.new(1, C.Purple),
	})
	BtnG.Parent = BtnValidar

	local BtnLimpar = Instance.new("TextButton")
	BtnLimpar.Text = "🗑️ Limpar key"; BtnLimpar.Font = Enum.Font.Gotham
	BtnLimpar.TextSize = 10; BtnLimpar.TextColor3 = C.Sub
	BtnLimpar.BackgroundTransparency = 1; BtnLimpar.Position = UDim2.new(0, 28, 0, 275)
	BtnLimpar.Size = UDim2.new(1, -56, 0, 18); BtnLimpar.Parent = Box

	local Ver = Instance.new("TextLabel")
	Ver.Text = "v3.2"; Ver.Font = Enum.Font.Code; Ver.TextSize = 9
	Ver.TextColor3 = C.Sub; Ver.BackgroundTransparency = 1
	Ver.Position = UDim2.new(0, 0, 0, 332); Ver.Size = UDim2.new(1, 0, 0, 14); Ver.Parent = Box

	local function SucessoLogin()
		Status.Text = "✅ Bem-vindo, " .. KeyState.nome .. "!"
		Status.TextColor3 = C.Green; BtnValidar.Text = "SUCESSO!"
		Tween(BtnValidar, {BackgroundColor3 = C.Green}, 0.2)
		task.wait(0.4); pcall(function() SGK:Destroy() end)
		task.wait(0.1); callbackSucesso()
	end

	task.spawn(function()
		task.wait(0.2)
		local k = CarregarKeyLocal()
		if k and k ~= "" then
			Input.Text = k; Status.Text = "🔄 Verificando..."; Status.TextColor3 = C.Yellow
			local ok, res = ValidarKey(k)
			if ok then SucessoLogin() else
				Status.Text = "❌ " .. tostring(res); Status.TextColor3 = C.Red; LimparKeyLocal()
			end
		end
	end)

	BtnValidar.MouseButton1Click:Connect(function()
		local k = Input.Text:gsub("%s+", "")
		if k == "" then Status.Text = "⚠️ Cole uma key"; Status.TextColor3 = C.Yellow; return end
		Status.Text = "🔄 Validando..."; Status.TextColor3 = C.Yellow
		BtnValidar.Text = "AGUARDE..."
		task.spawn(function()
			local ok, res = ValidarKey(k)
			if ok then SucessoLogin() else
				Status.Text = "❌ " .. tostring(res); Status.TextColor3 = C.Red
				BtnValidar.Text = "VALIDAR"; BtnValidar.BackgroundColor3 = C.Accent
			end
		end)
	end)

	BtnLimpar.MouseButton1Click:Connect(function()
		LimparKeyLocal(); Input.Text = ""
		Status.Text = "🗑️ Removida"; Status.TextColor3 = C.Sub
	end)
end

-- MOVIMENTO
local function GetHRP()
	local c = lp.Character
	return c and c:FindFirstChild("HumanoidRootPart")
end

local function GetHum()
	local c = lp.Character
	return c and c:FindFirstChild("Humanoid")
end

-- NOCLIP
local noclipAtivo = false
local noclipConn = nil

local function AtivarNoclip()
	if noclipAtivo then return end
	noclipAtivo = true
	if noclipConn then pcall(function() noclipConn:Disconnect() end) end
	noclipConn = RunService.Stepped:Connect(function()
		if not noclipAtivo then return end
		local c = lp.Character
		if not c then return end
		for _, p in ipairs(c:GetDescendants()) do
			if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
		end
	end)
end

local function DesativarNoclip()
	noclipAtivo = false
	if noclipConn then pcall(function() noclipConn:Disconnect() end); noclipConn = nil end
end

-- ⭐⭐⭐ ANTI-SITAR ⭐⭐⭐
local antiSitConns = {}
local antiSitAtivo = false
local function AtivarAntiSit()
	if antiSitAtivo then return end
	antiSitAtivo = true

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
	antiSitAtivo = false
	for _, c in ipairs(antiSitConns) do pcall(function() c:Disconnect() end) end
	antiSitConns = {}
	if _G.SailentAntiSitConn then pcall(function() _G.SailentAntiSitConn:Disconnect() end); _G.SailentAntiSitConn = nil end
end

-- CONFIG (velocidade única + toggles)
local CONFIG_FILE = "sailent_eletricista_config.txt"
local Config = {
	velocidade = 120,
	autoTrabalhar = false,
	modoVoo = false,
	antiSit = true,
	noclip = true,
}

local function SalvarConfig()
	local str = ""
	for k, v in pairs(Config) do str = str .. k .. "=" .. tostring(v) .. "\n" end
	pcall(function() if writefile then writefile(CONFIG_FILE, str) end end)
end

local function CarregarConfig()
	pcall(function()
		if isfile and isfile(CONFIG_FILE) and readfile then
			local str = readfile(CONFIG_FILE)
			for linha in str:gmatch("[^\n]+") do
				local k, v = linha:match("([^=]+)=(.+)")
				if k and v then
					if v == "true" then v = true
					elseif v == "false" then v = false
					elseif tonumber(v) then v = tonumber(v) end
					Config[k] = v
				end
			end
		end
	end)
	-- compatibilidade: se tinha velFly antigo, migra
	if Config.velFly then Config.velFly = nil end
end

CarregarConfig()

-- ACHAR FUNÇÕES
local function AcharCarro()
	local s = workspace:FindFirstChild("CarrosSpawnados")
	if not s then return nil end
	return s:FindFirstChild("Eletricista")
end

local function AcharPromptEscada()
	local carro = AcharCarro()
	if not carro then return nil end
	local body = carro:FindFirstChild("Body")
	if not body then return nil end
	local escada = body:FindFirstChild("Escada")
	if not escada then return nil end
	local proxy = escada:FindFirstChild("Proxy")
	if not proxy then return nil end
	return proxy:FindFirstChild("ProximityPrompt")
end

local postesConsertados = {}

local function AcharPosteMaisProximo()
	local pasta = workspace:FindFirstChild("Complementos")
	if not pasta then return nil end
	local postes = pasta:FindFirstChild("Postes")
	if not postes then return nil end
	local hrp = GetHRP()
	if not hrp then return nil end
	local maisPerto, menorDist = nil, math.huge
	for _, poste in ipairs(postes:GetChildren()) do
		if poste.Name == "Poste" and not postesConsertados[poste] then
			local model = poste:FindFirstChild("Model")
			if model then
				local innerModel = model:FindFirstChild("Model")
				if innerModel then
					local root = innerModel:FindFirstChild("HumanoidRootPart") or innerModel.PrimaryPart
					local pos = root and root.Position
					if not pos then
						local part = innerModel:FindFirstChildWhichIsA("BasePart")
						if part then pos = part.Position end
					end
					if pos then
						local dist = (pos - hrp.Position).Magnitude
						if dist < menorDist then
							menorDist = dist
							maisPerto = {poste = poste, pos = pos}
						end
					end
				end
			end
		end
	end
	return maisPerto
end

local function ContarPostesTotal()
	local pasta = workspace:FindFirstChild("Complementos")
	if not pasta then return 0 end
	local postes = pasta:FindFirstChild("Postes")
	if not postes then return 0 end
	local total = 0
	for _, poste in ipairs(postes:GetChildren()) do
		if poste.Name == "Poste" then total = total + 1 end
	end
	return total
end

local function AcharPromptPoste(poste, txt, ignorarEnabled)
	if not poste then return nil end
	for _, d in ipairs(poste:GetDescendants()) do
		if d:IsA("ProximityPrompt") then
			local ok = ignorarEnabled or d.Enabled
			if ok and d.ActionText and d.ActionText:lower():find(txt:lower()) then
				return d
			end
		end
	end
	return nil
end

local function TemEscada()
	if not lp.Character then return false end
	for _, o in ipairs(lp.Character:GetChildren()) do
		if o:IsA("Tool") and o.Name:lower():find("escada") then return true end
	end
	if lp.Backpack then
		for _, o in ipairs(lp.Backpack:GetChildren()) do
			if o:IsA("Tool") and o.Name:lower():find("escada") then return true end
		end
	end
	return false
end

local function EquiparEscada()
	local hum = GetHum()
	if not hum then return false end
	for _, o in ipairs(lp.Character:GetChildren()) do
		if o:IsA("Tool") and o.Name:lower():find("escada") then return true end
	end
	if lp.Backpack then
		for _, tool in ipairs(lp.Backpack:GetChildren()) do
			if tool:IsA("Tool") and tool.Name:lower():find("escada") then
				pcall(function() hum:EquipTool(tool) end)
				task.wait(0.3)
				return true
			end
		end
	end
	return false
end

-- ⭐⭐⭐ VOO (usa velocidade ÚNICA) ⭐⭐⭐
local function VoarAte(posAlvo, timeout)
	if not posAlvo then return false end
	local hrp = GetHRP(); local hum = GetHum()
	if not hrp or not hum then return false end
	timeout = timeout or 25
	local t0 = tick()
	local colideOriginal = {}
	for _, p in ipairs(lp.Character:GetDescendants()) do
		if p:IsA("BasePart") then
			colideOriginal[p] = p.CanCollide
			p.CanCollide = false
		end
	end
	-- ⭐ Multiplicador ajustado para que velocidade = studs/s aproximado
	-- a cada 0.03s move (vel * 0.05) studs → velocidade efetiva = vel * 1.67
	while tick() - t0 < timeout do
		local h = GetHRP()
		if not h then break end
		local diff = posAlvo - h.Position
		if diff.Magnitude < 4 then break end
		local direcao = diff.Unit
		local velAtual = Config.velocidade or 100
		local velFrame = velAtual * 0.03
		local novaPos = h.Position + (direcao * velFrame)
		pcall(function() h.CFrame = CFrame.new(novaPos) end)
		task.wait(0.03)
	end
	task.wait(0.15)
	for p, v in pairs(colideOriginal) do
		if p and p.Parent then pcall(function() p.CanCollide = v end) end
	end
	local h = GetHRP()
	if h then pcall(function() h.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end) end
	return true
end

local function AndarAte(posAlvo, timeout, distParada)
	if not posAlvo then return false end
	local hrp = GetHRP(); local hum = GetHum()
	if not hrp or not hum then return false end
	timeout = timeout or 30; distParada = distParada or 4
	local t0 = tick()
	hum.WalkSpeed = Config.velocidade or 100
	hum:MoveTo(posAlvo)
	while tick() - t0 < timeout do
		local h = GetHRP(); if not h then return false end
		hum.WalkSpeed = Config.velocidade or 100
		local diff = Vector3.new(h.Position.X - posAlvo.X, 0, h.Position.Z - posAlvo.Z)
		if diff.Magnitude < distParada then hum:MoveTo(h.Position); return true end
		hum:MoveTo(posAlvo); task.wait(0.1)
	end
	return false
end

local function IrPara(posAlvo, timeout)
	if Config.modoVoo then return VoarAte(posAlvo, timeout)
	else return AndarAte(posAlvo, timeout) end
end

-- GOD MODE
local GodModeConns = {}
local ultimaPosSegura = nil; local ultimoReset = 0
local godModeAtivo = true
local trabalhando = false
local entregasCount = 0
local setTrabalharGlobal = nil

local function AtivarGodModeNoChar(char)
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local connLoop = RunService.Heartbeat:Connect(function()
		if not godModeAtivo then return end
		local h = char:FindFirstChildOfClass("Humanoid"); if not h then return end
		if h.Health > 0 and h.Health < h.MaxHealth then h.Health = h.MaxHealth end
	end)
	table.insert(GodModeConns, connLoop)
	local connHealth = hum.HealthChanged:Connect(function(novaVida)
		if not godModeAtivo then return end
		if novaVida < hum.MaxHealth and novaVida > 0 then hum.Health = hum.MaxHealth end
	end)
	table.insert(GodModeConns, connHealth)
	local function DesativarFalling()
		pcall(function() hum:SetAttribute("FallingDamage", false) end)
		pcall(function() hum:SetAttribute("FallDamage", false) end)
		pcall(function() hum:SetAttribute("TakeFallDamage", false) end)
	end
	DesativarFalling()
	local connFalling = RunService.Heartbeat:Connect(function()
		if not godModeAtivo then return end
		DesativarFalling()
	end)
	table.insert(GodModeConns, connFalling)
	local connQueda = RunService.Heartbeat:Connect(function()
		if not godModeAtivo then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local h = char:FindFirstChildOfClass("Humanoid")
		if not hrp or not h or h.Health <= 0 then return end
		local vel = hrp.AssemblyLinearVelocity; local pos = hrp.Position
		if h.FloorMaterial ~= Enum.Material.Air and vel.Y > -10 then
			ultimaPosSegura = pos; return
		end
		if vel.Y < -70 then
			pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(vel.X, -15, vel.Z) end)
		end
		if ultimaPosSegura and (ultimaPosSegura.Y - pos.Y) > 30 then
			local agora = tick()
			if agora - ultimoReset > 0.5 then
				ultimoReset = agora
				pcall(function()
					hrp.CFrame = CFrame.new(ultimaPosSegura + Vector3.new(0, 5, 0))
					hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					h.Health = h.MaxHealth
				end)
			end
		end
	end)
	table.insert(GodModeConns, connQueda)
	local connZero = RunService.Heartbeat:Connect(function()
		if not godModeAtivo then return end
		local h = char:FindFirstChildOfClass("Humanoid"); if not h then return end
		if h.Health <= 0 and h:GetState() ~= Enum.HumanoidStateType.Dead then
			pcall(function() h.Health = h.MaxHealth end)
		end
	end)
	table.insert(GodModeConns, connZero)
	pcall(function() hum.MaxHealth = 10000; hum.Health = 10000 end)
	local connMaxH = hum:GetPropertyChangedSignal("MaxHealth"):Connect(function()
		pcall(function()
			if hum.MaxHealth < 10000 then hum.MaxHealth = 10000; hum.Health = 10000 end
		end)
	end)
	table.insert(GodModeConns, connMaxH)
	pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
end

local function AtivarGodMode()
	for _, c in ipairs(GodModeConns) do pcall(function() c:Disconnect() end) end
	GodModeConns = {}
	if lp.Character then AtivarGodModeNoChar(lp.Character) end
	if _G.SailentCharConn then pcall(function() _G.SailentCharConn:Disconnect() end); _G.SailentCharConn = nil end
	_G.SailentCharConn = lp.CharacterAdded:Connect(function(novoChar)
		task.wait(0.3)
		ultimaPosSegura = nil
		AtivarGodModeNoChar(novoChar)
		task.spawn(function()
			if lp.Character then AtivarGodModeNoChar(lp.Character) end
			task.wait(0.5)
			Notificar("💀 Morreu — reconectando...", C.Red, 1.5)
		end)
	end)
end

-- UI (mesmo estilo do Pizza)
local function IniciarScript()

	for _, name in ipairs({"SailentKeyUI", "SailentEletricista", "SailentFloatBtn"}) do
		local old = CoreGui:FindFirstChild(name)
		if old then pcall(function() old:Destroy() end) end
	end
	task.wait(0.05)

	local SGBtn = Instance.new("ScreenGui")
	SGBtn.Name = "SailentFloatBtn"; SGBtn.ResetOnSpawn = false
	SGBtn.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SGBtn.IgnoreGuiInset = true; SGBtn.DisplayOrder = 5; SGBtn.Parent = CoreGui

	local FloatBtn = Instance.new("TextButton")
	FloatBtn.Text = "⚡"; FloatBtn.Font = Enum.Font.GothamBold; FloatBtn.TextSize = 26
	FloatBtn.TextColor3 = Color3.fromRGB(255, 255, 255); FloatBtn.BackgroundColor3 = C.Black
	FloatBtn.BorderSizePixel = 0; FloatBtn.Size = UDim2.new(0, 60, 0, 60)
	FloatBtn.Position = UDim2.new(0, 20, 0.5, -30); FloatBtn.AutoButtonColor = false
	FloatBtn.Active = true; FloatBtn.Parent = SGBtn

	local BtnCorner = Instance.new("UICorner"); BtnCorner.CornerRadius = UDim.new(1, 0); BtnCorner.Parent = FloatBtn
	local BtnStroke = Instance.new("UIStroke"); BtnStroke.Color = C.Accent; BtnStroke.Thickness = 2; BtnStroke.Parent = FloatBtn

	local btnDragging, btnDragStart, btnStartPos, btnMoveuSe
	FloatBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			btnDragging = true; btnMoveuSe = false
			btnDragStart = input.Position; btnStartPos = FloatBtn.Position
		end
	end)
	FloatBtn.InputChanged:Connect(function(input)
		if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - btnDragStart
			if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then btnMoveuSe = true end
			FloatBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
		end
	end)
	UserInput.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			btnDragging = false
		end
	end)

	local SG = Instance.new("ScreenGui")
	SG.Name = "SailentEletricista"; SG.ResetOnSpawn = false
	SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SG.IgnoreGuiInset = true; SG.DisplayOrder = 10; SG.Parent = CoreGui

	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0, 420, 0, 640); Main.Position = UDim2.new(0.5, -210, 0.5, -320)
	Main.BackgroundColor3 = C.BG2; Main.BorderSizePixel = 0; Main.BackgroundTransparency = 0.03
	Main.Parent = SG

	local MC = Instance.new("UICorner"); MC.CornerRadius = UDim.new(0, 16); MC.Parent = Main
	local MS = Instance.new("UIStroke"); MS.Color = C.Border; MS.Thickness = 1; MS.Transparency = 0.3; MS.Parent = Main

	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 3); TopBar.BackgroundColor3 = C.Accent
	TopBar.BorderSizePixel = 0; TopBar.Parent = Main
	local TopBarC = Instance.new("UICorner"); TopBarC.CornerRadius = UDim.new(0, 16); TopBarC.Parent = TopBar
	local TopBarG = Instance.new("UIGradient")
	TopBarG.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, C.Accent),
		ColorSequenceKeypoint.new(0.5, C.Purple),
		ColorSequenceKeypoint.new(1, C.Yellow),
	})
	TopBarG.Parent = TopBar

	_G.SailentBloquearDrag = false
	do
		local d, di, ds, sp
		local function up(i)
			if _G.SailentBloquearDrag then return end
			local x = i.Position - ds
			Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + x.X, sp.Y.Scale, sp.Y.Offset + x.Y)
		end
		Main.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				if _G.SailentBloquearDrag then return end
				d = true; ds = i.Position; sp = Main.Position
				i.Changed:Connect(function()
					if i.UserInputState == Enum.UserInputState.End then d = false end
				end)
			end
		end)
		Main.InputChanged:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
		end)
		UserInput.InputChanged:Connect(function(i)
			if i == di and d then up(i) end
		end)
	end

	-- Header
	local HB = Instance.new("Frame")
	HB.Size = UDim2.new(1, 0, 0, 64); HB.BackgroundColor3 = C.Card
	HB.BackgroundTransparency = 0.5; HB.BorderSizePixel = 0; HB.Parent = Main
	local HBC = Instance.new("UICorner"); HBC.CornerRadius = UDim.new(0, 16); HBC.Parent = HB

	local Logo = Instance.new("Frame")
	Logo.Size = UDim2.new(0, 40, 0, 40); Logo.Position = UDim2.new(0, 14, 0.5, -20)
	Logo.BackgroundColor3 = C.Accent; Logo.BorderSizePixel = 0; Logo.Parent = HB
	local LogoC = Instance.new("UICorner"); LogoC.CornerRadius = UDim.new(0, 10); LogoC.Parent = Logo
	local LogoG = Instance.new("UIGradient")
	LogoG.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, C.Accent),
		ColorSequenceKeypoint.new(1, C.Purple),
	})
	LogoG.Rotation = 45; LogoG.Parent = Logo

	local LogoIcon = Instance.new("TextLabel")
	LogoIcon.Text = "⚡"; LogoIcon.Font = Enum.Font.GothamBold; LogoIcon.TextSize = 22
	LogoIcon.BackgroundTransparency = 1; LogoIcon.Size = UDim2.new(1, 0, 1, 0); LogoIcon.Parent = Logo

	local TTitle = Instance.new("TextLabel")
	TTitle.Text = "Auto Eletricista"; TTitle.Font = Enum.Font.GothamBold; TTitle.TextSize = 15
	TTitle.TextColor3 = C.Text; TTitle.BackgroundTransparency = 1
	TTitle.Position = UDim2.new(0, 62, 0, 12); TTitle.Size = UDim2.new(0, 220, 0, 18)
	TTitle.TextXAlignment = Enum.TextXAlignment.Left; TTitle.Parent = HB

	local VerTag = Instance.new("Frame")
	VerTag.Size = UDim2.new(0, 180, 0, 16); VerTag.Position = UDim2.new(0, 62, 0, 34)
	VerTag.BackgroundColor3 = C.Yellow; VerTag.BackgroundTransparency = 0.75
	VerTag.BorderSizePixel = 0; VerTag.Parent = HB
	local VerTagC = Instance.new("UICorner"); VerTagC.CornerRadius = UDim.new(1, 0); VerTagC.Parent = VerTag
	local VerTxt = Instance.new("TextLabel")
	VerTxt.Text = "v3.2 • VEL ÚNICA + ANTI-SIT"; VerTxt.Font = Enum.Font.GothamBold; VerTxt.TextSize = 7
	VerTxt.TextColor3 = C.Yellow; VerTxt.BackgroundTransparency = 1
	VerTxt.Size = UDim2.new(1, 0, 1, 0); VerTxt.Parent = VerTag

	local MinBtn = Instance.new("TextButton")
	MinBtn.Text = "−"; MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 20
	MinBtn.TextColor3 = C.Yellow; MinBtn.BackgroundColor3 = C.Card; MinBtn.BackgroundTransparency = 0.4
	MinBtn.BorderSizePixel = 0; MinBtn.Size = UDim2.new(0, 30, 0, 30)
	MinBtn.Position = UDim2.new(1, -72, 0.5, -15); MinBtn.AutoButtonColor = false; MinBtn.Parent = HB
	local MinC = Instance.new("UICorner"); MinC.CornerRadius = UDim.new(0, 8); MinC.Parent = MinBtn

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Text = "✕"; CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 14
	CloseBtn.TextColor3 = C.Red; CloseBtn.BackgroundColor3 = C.Card; CloseBtn.BackgroundTransparency = 0.4
	CloseBtn.BorderSizePixel = 0; CloseBtn.Size = UDim2.new(0, 30, 0, 30)
	CloseBtn.Position = UDim2.new(1, -36, 0.5, -15); CloseBtn.AutoButtonColor = false; CloseBtn.Parent = HB
	local CC = Instance.new("UICorner"); CC.CornerRadius = UDim.new(0, 8); CC.Parent = CloseBtn

	local Content = Instance.new("ScrollingFrame")
	Content.Size = UDim2.new(1, -20, 1, -84); Content.Position = UDim2.new(0, 10, 0, 74)
	Content.BackgroundTransparency = 1; Content.BorderSizePixel = 0
	Content.ScrollBarThickness = 3; Content.ScrollBarImageColor3 = C.Accent
	Content.CanvasSize = UDim2.new(0, 0, 0, 0)
	Content.AutomaticCanvasSize = Enum.AutomaticSize.Y; Content.Parent = Main

	local Lay = Instance.new("UIListLayout"); Lay.Padding = UDim.new(0, 8); Lay.Parent = Content

	local function Sec(txt, color)
		local f = Instance.new("Frame")
		f.Size = UDim2.new(1, 0, 0, 22); f.BackgroundTransparency = 1; f.Parent = Content
		local d = Instance.new("Frame")
		d.Size = UDim2.new(0, 5, 0, 5); d.Position = UDim2.new(0, 3, 0.5, -2.5)
		d.BackgroundColor3 = color or C.Accent; d.BorderSizePixel = 0; d.Parent = f
		local dc = Instance.new("UICorner"); dc.CornerRadius = UDim.new(1, 0); dc.Parent = d
		local l = Instance.new("TextLabel")
		l.Text = txt:upper(); l.Font = Enum.Font.GothamBold; l.TextSize = 10
		l.TextColor3 = color or C.Accent; l.BackgroundTransparency = 1
		l.Position = UDim2.new(0, 16, 0, 0); l.Size = UDim2.new(1, -16, 1, 0)
		l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
	end

	local function StatL(txt, color)
		local f = Instance.new("Frame")
		f.Size = UDim2.new(1, 0, 0, 30); f.BackgroundColor3 = C.Card
		f.BorderSizePixel = 0; f.Parent = Content
		local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = f
		local s = Instance.new("UIStroke"); s.Color = C.Border; s.Thickness = 1; s.Transparency = 0.5; s.Parent = f
		local l = Instance.new("TextLabel")
		l.Text = txt; l.Font = Enum.Font.GothamBold; l.TextSize = 11
		l.TextColor3 = color or C.Text; l.BackgroundTransparency = 1
		l.Position = UDim2.new(0, 14, 0, 0); l.Size = UDim2.new(1, -20, 1, 0)
		l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
		return l
	end

	local function Btn(txt, color, cb)
		local b = Instance.new("TextButton")
		b.Text = txt; b.Font = Enum.Font.GothamBold; b.TextSize = 12
		b.TextColor3 = C.Text; b.BackgroundColor3 = C.Card; b.BorderSizePixel = 0
		b.Size = UDim2.new(1, 0, 0, 38); b.AutoButtonColor = false; b.Parent = Content
		local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 10); c.Parent = b
		local s = Instance.new("UIStroke"); s.Color = C.Border; s.Thickness = 1; s.Transparency = 0.4; s.Parent = b
		b.MouseEnter:Connect(function()
			Tween(b, {BackgroundColor3 = Color3.fromRGB(32, 32, 48)}, 0.15)
			Tween(s, {Color = color or C.Accent, Transparency = 0.2}, 0.15)
		end)
		b.MouseLeave:Connect(function()
			Tween(b, {BackgroundColor3 = C.Card}, 0.15)
			Tween(s, {Color = C.Border, Transparency = 0.4}, 0.15)
		end)
		b.MouseButton1Click:Connect(function()
			Tween(b, {BackgroundColor3 = color or C.Accent}, 0.08)
			task.wait(0.1); Tween(b, {BackgroundColor3 = C.Card}, 0.15)
			if cb then task.spawn(cb) end
		end)
		return b
	end

	local function Toggle(txt, default, color, cb)
		local f = Instance.new("Frame")
		f.Size = UDim2.new(1, 0, 0, 42); f.BackgroundColor3 = C.Card
		f.BorderSizePixel = 0; f.Parent = Content
		local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 10); c.Parent = f
		local s = Instance.new("UIStroke"); s.Color = C.Border; s.Thickness = 1; s.Transparency = 0.4; s.Parent = f
		local l = Instance.new("TextLabel")
		l.Text = txt; l.Font = Enum.Font.GothamBold; l.TextSize = 12; l.TextColor3 = C.Text
		l.BackgroundTransparency = 1; l.Position = UDim2.new(0, 14, 0, 0)
		l.Size = UDim2.new(1, -80, 1, 0); l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
		local bg = Instance.new("Frame")
		bg.Size = UDim2.new(0, 44, 0, 22); bg.Position = UDim2.new(1, -56, 0.5, -11)
		bg.BackgroundColor3 = Color3.fromRGB(50, 50, 65); bg.BorderSizePixel = 0; bg.Parent = f
		local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(1, 0); bc.Parent = bg
		local k = Instance.new("Frame")
		k.Size = UDim2.new(0, 18, 0, 18); k.Position = UDim2.new(0, 2, 0.5, -9)
		k.BackgroundColor3 = Color3.fromRGB(200, 200, 215); k.BorderSizePixel = 0; k.Parent = bg
		local kc = Instance.new("UICorner"); kc.CornerRadius = UDim.new(1, 0); kc.Parent = k
		local st = default or false
		local function set(v)
			st = v
			if st then
				Tween(bg, {BackgroundColor3 = C.Green}, 0.2)
				Tween(k, {
					Position = UDim2.new(1, -20, 0.5, -9),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				}, 0.2)
			else
				Tween(bg, {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}, 0.2)
				Tween(k, {
					Position = UDim2.new(0, 2, 0.5, -9),
					BackgroundColor3 = Color3.fromRGB(200, 200, 215),
				}, 0.2)
			end
			if cb then cb(st) end
		end
		if st then
			bg.BackgroundColor3 = C.Green
			k.Position = UDim2.new(1, -20, 0.5, -9)
			k.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		end
		local cl = Instance.new("TextButton")
		cl.Text = ""; cl.BackgroundTransparency = 1; cl.Size = UDim2.new(1, 0, 1, 0); cl.Parent = f
		cl.MouseButton1Click:Connect(function() set(not st) end)
		return set
	end

	local function Slider(parent, label, min, max, default, cor, callback)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 58); frame.BackgroundColor3 = C.Card
		frame.BorderSizePixel = 0; frame.Parent = parent
		local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(0, 10); fc.Parent = frame
		local fst = Instance.new("UIStroke"); fst.Color = C.Border; fst.Thickness = 1; fst.Transparency = 0.4; fst.Parent = frame
		local titulo = Instance.new("TextLabel")
		titulo.Text = label; titulo.Font = Enum.Font.GothamBold; titulo.TextSize = 12
		titulo.TextColor3 = C.Text; titulo.BackgroundTransparency = 1
		titulo.Position = UDim2.new(0, 14, 0, 6); titulo.Size = UDim2.new(0.7, 0, 0, 18)
		titulo.TextXAlignment = Enum.TextXAlignment.Left; titulo.Parent = frame
		local valorLabel = Instance.new("TextLabel")
		valorLabel.Text = tostring(default); valorLabel.Font = Enum.Font.GothamBold
		valorLabel.TextSize = 13; valorLabel.TextColor3 = cor or C.Green; valorLabel.BackgroundTransparency = 1
		valorLabel.Position = UDim2.new(0.7, 0, 0, 6); valorLabel.Size = UDim2.new(0.3, -14, 0, 18)
		valorLabel.TextXAlignment = Enum.TextXAlignment.Right; valorLabel.Parent = frame
		local bgBar = Instance.new("Frame")
		bgBar.Size = UDim2.new(1, -28, 0, 10); bgBar.Position = UDim2.new(0, 14, 0, 34)
		bgBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55); bgBar.BorderSizePixel = 0; bgBar.Parent = frame
		local bbc = Instance.new("UICorner"); bbc.CornerRadius = UDim.new(1, 0); bbc.Parent = bgBar
		local fillBar = Instance.new("Frame")
		fillBar.Size = UDim2.new(0, 0, 1, 0); fillBar.BackgroundColor3 = cor or C.Accent
		fillBar.BorderSizePixel = 0; fillBar.Parent = bgBar
		local fbc = Instance.new("UICorner"); fbc.CornerRadius = UDim.new(1, 0); fbc.Parent = fillBar
		local fg = Instance.new("UIGradient")
		fg.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, cor or C.Accent),
			ColorSequenceKeypoint.new(1, C.Purple),
		})
		fg.Parent = fillBar
		local knob = Instance.new("Frame")
		knob.Size = UDim2.new(0, 16, 0, 16); knob.Position = UDim2.new(0, -8, 0.5, -8)
		knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255); knob.BorderSizePixel = 0; knob.Parent = bgBar
		local kc = Instance.new("UICorner"); kc.CornerRadius = UDim.new(1, 0); kc.Parent = knob
		local valor = default
		local arrastando = false
		local function Aplicar(percent)
			valor = math.floor(min + (max - min) * percent)
			valorLabel.Text = tostring(valor)
			fillBar.Size = UDim2.new(percent, 0, 1, 0)
			knob.Position = UDim2.new(percent, -8, 0.5, -8)
			if callback then callback(valor) end
		end
		local function Atualizar(posX)
			local bgAbs = bgBar.AbsolutePosition.X; local bgSize = bgBar.AbsoluteSize.X
			Aplicar(math.clamp((posX - bgAbs) / bgSize, 0, 1))
		end
		local initPercent = (default - min) / (max - min)
		fillBar.Size = UDim2.new(initPercent, 0, 1, 0)
		knob.Position = UDim2.new(initPercent, -8, 0.5, -8)
		bgBar.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				arrastando = true; _G.SailentBloquearDrag = true; Atualizar(i.Position.X)
			end
		end)
		UserInput.InputChanged:Connect(function(i)
			if arrastando and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				Atualizar(i.Position.X)
			end
		end)
		UserInput.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				if arrastando then
					arrastando = false; _G.SailentBloquearDrag = false
					SalvarConfig()
				end
			end
		end)
	end

	Sec("Conta", C.Purple)
	StatL("👤 " .. KeyState.nome .. " [" .. KeyState.nivel:upper() .. "]", C.Purple)

	Sec("Stats", C.Blue)
	local statPostes = StatL("⚡ Postes: 0/15", C.Text)

	Sec("🛡️ God Mode", C.Green)
	StatL("Status: ● ATIVO", C.Green)

	Sec("Auto Eletricista", C.Accent)
	local trabalhoStatus = StatL("Status: PARADO", C.Sub)

	setTrabalharGlobal = Toggle("⚡ Auto Eletricista", Config.autoTrabalhar, C.Accent, function(s)
		Config.autoTrabalhar = s
		SalvarConfig()
		if s then
			AtivarNoclip()
			trabalhando = true
			trabalhoStatus.Text = "Status: ● ATIVO (noclip ON)"
			trabalhoStatus.TextColor3 = C.Green
			Notificar("⚡ Auto Eletricista ATIVADO", C.Green, 1.5)
			Tween(FloatBtn, {BackgroundColor3 = C.Green}, 0.25)
			BtnStroke.Color = C.Green
			local hum = GetHum()
			if hum then hum.WalkSpeed = Config.velocidade end

			task.spawn(function()
				while trabalhando do
					local temEscada = TemEscada()
					if not temEscada then
						local carro = AcharCarro()
						if carro then
							local carroPos = carro:GetPivot().Position
							trabalhoStatus.Text = "📥 Indo pegar escada..."
							IrPara(carroPos, 20)
							task.wait(0.3)
							trabalhoStatus.Text = "📥 Pegando escada..."
							local promptEscada = AcharPromptEscada()
							if promptEscada then
								pcall(function() fireproximityprompt(promptEscada) end)
								task.wait(1.0)
							end
							task.wait(0.3)
							EquiparEscada()
							task.wait(0.3)
							trabalhoStatus.Text = "✅ Escada equipada!"
							Notificar("🪜 Escada equipada!", C.Green, 1.5)
						else
							trabalhoStatus.Text = "⚠️ Carro não encontrado"
							task.wait(2)
						end
					else
						trabalhoStatus.Text = "🔎 Procurando poste..."
						local posteInfo = AcharPosteMaisProximo()
						if posteInfo then
							trabalhoStatus.Text = "📥 Indo pro poste..."
							IrPara(posteInfo.pos + Vector3.new(0, 0, -4), 25)
							task.wait(0.3)

							trabalhoStatus.Text = "🪜 Colocando escada..."
							local promptLadder = AcharPromptPoste(posteInfo.poste, "place")
							if promptLadder then
								pcall(function() fireproximityprompt(promptLadder) end)
								task.wait(0.8)
							end

							trabalhoStatus.Text = "🪜 Subindo pro topo..."
							local hrp = GetHRP()

							if hrp and posteInfo.poste then
								local maxY = posteInfo.pos.Y
								local maxPart = nil
								local model = posteInfo.poste:FindFirstChild("Model")
								local innerModel = model and model:FindFirstChild("Model")
								if innerModel then
									for _, d in ipairs(innerModel:GetDescendants()) do
										if d:IsA("BasePart") then
											if d.Position.Y > maxY then
												maxY = d.Position.Y
												maxPart = d
											end
										end
									end
								end

								local alvoPos = Vector3.new(posteInfo.pos.X, maxY + 3, posteInfo.pos.Z)

								local partInvisivel = Instance.new("Part")
								partInvisivel.Name = "PartSuporte_Temp"
								partInvisivel.Size = Vector3.new(6, 1, 6)
								partInvisivel.Position = alvoPos
								partInvisivel.Anchored = true
								partInvisivel.CanCollide = false
								partInvisivel.Transparency = 1
								partInvisivel.Parent = posteInfo.poste

								pcall(function()
									hrp.CFrame = CFrame.new(alvoPos + Vector3.new(0, 3, 0))
								end)
								task.wait(0.3)

								posteInfo.partSuporte = partInvisivel
							end
							task.wait(0.5)

							trabalhoStatus.Text = "🔧 Consertando..."
							local promptRepair = AcharPromptPoste(posteInfo.poste, "repair", true)
							if promptRepair then
								pcall(function() fireproximityprompt(promptRepair) end)

								local t0 = tick()
								while tick() - t0 < 7 do
									if not promptRepair.Enabled then
										print("[Eletricista] ✅ Consertou em " .. string.format("%.1f", tick() - t0) .. "s")
										break
									end
									task.wait(0.15)
								end
								task.wait(0.3)
							else
								print("[Eletricista] ⚠️ Prompt 'To repair' não encontrado")
							end

							trabalhoStatus.Text = "⬇️ Descendo..."

							if posteInfo.partSuporte then
								pcall(function() posteInfo.partSuporte:Destroy() end)
								posteInfo.partSuporte = nil
							end

							local hrp2 = GetHRP()
							if hrp2 then
								local chaoY = posteInfo.pos.Y
								local tentativas2 = 0
								while hrp2.Position.Y > chaoY + 2 and tentativas2 < 60 do
									pcall(function()
										hrp2.CFrame = CFrame.new(hrp2.Position - Vector3.new(0, 1.5, 0))
									end)
									task.wait(0.08)
									tentativas2 = tentativas2 + 1
								end
							end
							task.wait(0.3)

							postesConsertados[posteInfo.poste] = true

							entregasCount = entregasCount + 1
							local totalPostes = ContarPostesTotal()
							statPostes.Text = "⚡ Postes: " .. entregasCount .. "/" .. totalPostes
							Notificar("⚡ Poste #" .. entregasCount .. " consertado!", C.Green, 1.5)

							local totalMarcados = 0
							for _ in pairs(postesConsertados) do totalMarcados = totalMarcados + 1 end
							if totalMarcados >= totalPostes then
								postesConsertados = {}
								Notificar("✅ Todos consertados! Resetando lista...", C.Blue, 2.5)
							end
						else
							trabalhoStatus.Text = "⚠️ Sem poste próximo"
							local totalPostes = ContarPostesTotal()
							local totalMarcados = 0
							for _ in pairs(postesConsertados) do totalMarcados = totalMarcados + 1 end
							if totalMarcados >= totalPostes then
								postesConsertados = {}
							end
							task.wait(2)
						end
					end
					task.wait(0.3)
				end
			end)
		else
			trabalhando = false
			DesativarNoclip()
			trabalhoStatus.Text = "Status: PARADO"
			trabalhoStatus.TextColor3 = C.Sub
			Notificar("⚡ Auto Eletricista DESATIVADO", C.Yellow, 1.5)
			Tween(FloatBtn, {BackgroundColor3 = C.Black}, 0.25)
			BtnStroke.Color = C.Accent
			local hum = GetHum()
			if hum then hum.WalkSpeed = 16 end
		end
	end)

	Sec("Modo de Locomoção", C.Yellow)
	local modoStatus = StatL(Config.modoVoo and "Modo: 🚁 VOANDO" or "Modo: 🚶 A PÉ", C.Yellow)

	Btn("🚶 A PÉ (padrão)", C.Green, function()
		Config.modoVoo = false
		modoStatus.Text = "Modo: 🚶 A PÉ"
		modoStatus.TextColor3 = C.Green
		SalvarConfig()
	end)

	Btn("🚁 VOAR (fly direto)", C.Blue, function()
		Config.modoVoo = true
		modoStatus.Text = "Modo: 🚁 VOANDO"
		modoStatus.TextColor3 = C.Blue
		SalvarConfig()
	end)

	Sec("⚡ Velocidade (a pé + voo)", C.Green)
	StatL("Muda na hora", C.Sub)
	local setVelGlobal = Slider(Content, "⚡ Velocidade", 20, 400, Config.velocidade or 120, C.Green, function(valor)
		Config.velocidade = valor
		local hum = GetHum()
		if hum and not Config.modoVoo then
			hum.WalkSpeed = valor
		end
	end)

	Sec("Comportamento", C.Purple)
	Toggle("🚪 Noclip", Config.noclip, C.Green, function(s)
		Config.noclip = s; SalvarConfig()
		if s then
			if Config.autoTrabalhar then AtivarNoclip() end
		else
			DesativarNoclip()
		end
	end)
	Toggle("🪑 Anti-Sentar", Config.antiSit, C.Yellow, function(s)
		Config.antiSit = s; SalvarConfig()
		if s then AtivarAntiSit() else DesativarAntiSit() end
	end)

	Sec("Emergência", C.Red)
	Btn("🛑 PARAR TUDO", C.Red, function()
		Config.autoTrabalhar = false
		trabalhando = false
		if setTrabalharGlobal then setTrabalharGlobal(false) end
		DesativarNoclip()
		trabalhoStatus.Text = "Status: PARADO"
		trabalhoStatus.TextColor3 = C.Sub
		local hum = GetHum()
		if hum then hum.WalkSpeed = 16 end
		Notificar("🛑 Tudo parado!", C.Red, 2)
	end)

	local uiAberta = true

	local function FecharUI()
		uiAberta = false
		Tween(Main, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.25)
		task.wait(0.25); Main.Visible = false
		FloatBtn.Text = "⚡"
	end

	local function AbrirUI()
		uiAberta = true; Main.Visible = true
		Main.Size = UDim2.new(0, 0, 0, 0); Main.Position = UDim2.new(0.5, 0, 0.5, 0)
		Tween(Main, {Size = UDim2.new(0, 420, 0, 640), Position = UDim2.new(0.5, -210, 0.5, -320)}, 0.3, Enum.EasingStyle.Back)
		FloatBtn.Text = "✕"
	end

	FloatBtn.MouseButton1Click:Connect(function()
		if btnMoveuSe then return end
		if uiAberta then FecharUI() else AbrirUI() end
	end)

	UserInput.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.F2 then
			if uiAberta then FecharUI() else AbrirUI() end
		elseif input.KeyCode == Enum.KeyCode.F1 then
			Config.autoTrabalhar = false
			trabalhando = false
			if setTrabalharGlobal then setTrabalharGlobal(false) end
			DesativarNoclip()
			local hum = GetHum()
			if hum then hum.WalkSpeed = 16 end
			FecharUI()
			Notificar("🚨 PANIC", C.Red, 2)
		end
	end)

	local minimizado = false
	MinBtn.MouseButton1Click:Connect(function()
		minimizado = not minimizado
		if minimizado then
			Tween(Main, {Size = UDim2.new(0, 420, 0, 64)}, 0.25)
			MinBtn.Text = "+"
		else
			Tween(Main, {Size = UDim2.new(0, 420, 0, 640)}, 0.25)
			MinBtn.Text = "−"
		end
	end)

	CloseBtn.MouseButton1Click:Connect(function() FecharUI() end)

	AtivarGodMode()
	if Config.antiSit then AtivarAntiSit() end
	if Config.noclip and Config.autoTrabalhar then AtivarNoclip() end

	Log("═══════════════════════════════════")
	Log("⚡ Sailent Auto Eletricista v3.2")
	Log("👤 " .. KeyState.nome .. " | " .. KeyState.nivel:upper())
	Log("⚡ F2 = UI | F1 = Panic")
	Log("═══════════════════════════════════")

	Notificar("⚡ Auto Eletricista v3.2 carregado!", C.Accent, 2.5)
end

Log("🔐 Verificando key...")

task.spawn(function()
	local k = CarregarKeyLocal()
	if k and k ~= "" then
		local ok = ValidarKey(k)
		if ok then
			Log("✅ Key salva válida! Iniciando...")
			IniciarScript()
			return
		else
			Log("⚠️ Key salva inválida, pedindo nova...")
		end
	end
	MostrarUILogin(function() IniciarScript() end)
end)

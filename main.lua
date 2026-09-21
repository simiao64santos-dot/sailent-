-- ============================================================
-- SAILENT AUTO GARI v5.2 — COMPLETO COM KEY SYSTEM
-- Auto Gari + Keybind + Anti-admin + Stats + Sons + Keys
-- ============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local lp = Players.LocalPlayer

-- ============================================================
-- ⚙️ CONFIGURAÇÃO DO KEY SYSTEM
-- ============================================================
local KEY_CONFIG = {
	-- 🔗 COLOQUE AQUI A URL RAW DO SEU keys.json NO GITHUB
	-- Ex: "https://raw.githubusercontent.com/SEU_USER/SEU_REPO/main/keys.json"
	URL_KEYS = "",

	-- Arquivo de cache local (guarda a key validada)
	ARQUIVO_CACHE = "sailent_gari_key.txt",

	-- Nome que aparece na UI
	NOME_SCRIPT = "Sailent Auto Gari v5.2",
}

for _, name in ipairs({"SailentGari", "SailentFloatBtn", "SailentKeyUI"}) do
	if CoreGui:FindFirstChild(name) then CoreGui[name]:Destroy() end
end

local C = {
	BG = Color3.fromRGB(12,12,18),
	Card = Color3.fromRGB(25,25,35),
	Accent = Color3.fromRGB(80,220,120),
	Text = Color3.fromRGB(240,240,245),
	Sub = Color3.fromRGB(150,150,165),
	Green = Color3.fromRGB(80,220,120),
	Red = Color3.fromRGB(230,70,80),
	Yellow = Color3.fromRGB(255,200,80),
	Blue = Color3.fromRGB(80,160,240),
	Purple = Color3.fromRGB(180,120,255),
	Black = Color3.fromRGB(10, 10, 15),
}

local function Tween(o, p, t)
	local tw = TweenService:Create(o, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint), p)
	tw:Play()
	return tw
end

local function Log(msg)
	print("[Gari] " .. tostring(msg))
end

-- ============================================================
-- 🔐 HASH SHA-256 (compatível com o gerador HTML)
-- ============================================================
local function Sha256(msg)
	-- Lua puro: implementação SHA-256
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
	-- length em 64 bits big-endian
	local hi = math.floor(bitLen / 4294967296)
	local lo = bitLen % 4294967296
	local function u32be(n)
		return string.char(
			bit32.band(bit32.rshift(n, 24), 0xFF),
			bit32.band(bit32.rshift(n, 16), 0xFF),
			bit32.band(bit32.rshift(n, 8), 0xFF),
			bit32.band(n, 0xFF)
		)
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
		H[1] = (H[1] + a) % 4294967296
		H[2] = (H[2] + b) % 4294967296
		H[3] = (H[3] + c) % 4294967296
		H[4] = (H[4] + d) % 4294967296
		H[5] = (H[5] + e) % 4294967296
		H[6] = (H[6] + f) % 4294967296
		H[7] = (H[7] + g) % 4294967296
		H[8] = (H[8] + h) % 4294967296
	end
	local out = {}
	for i = 1, 8 do out[#out+1] = string.format("%08x", H[i]) end
	return table.concat(out)
end

local function GetHWID()
	local hwid = ""
	pcall(function()
		hwid = game:GetService("RbxAnalyticsService"):GetClientId()
	end)
	if hwid == "" then
		pcall(function() hwid = gethwid and gethwid() or "" end)
	end
	if hwid == "" then
		hwid = "UNKNOWN-" .. tostring(lp.UserId)
	end
	return hwid
end

-- ============================================================
-- 🔑 VALIDAÇÃO DA KEY
-- ============================================================
local KeyState = {
	valida = false,
	nivel = "normal",
	nome = "Cliente",
	expira = 0,
	hash = "",
	key = "",
}

local function SalvarKeyLocal(key)
	pcall(function()
		if writefile then
			writefile(KEY_CONFIG.ARQUIVO_CACHE, key)
		end
	end)
end

local function CarregarKeyLocal()
	local k = nil
	pcall(function()
		if isfile and isfile(KEY_CONFIG.ARQUIVO_CACHE) and readfile then
			k = readfile(KEY_CONFIG.ARQUIVO_CACHE)
		end
	end)
	return k
end

local function LimparKeyLocal()
	pcall(function()
		if delfile and isfile and isfile(KEY_CONFIG.ARQUIVO_CACHE) then
			delfile(KEY_CONFIG.ARQUIVO_CACHE)
		end
	end)
end

local function BaixarKeys()
	if not (request or http_request or syn and syn.request or fluxus and fluxus.request) then
		return nil, "Executor sem suporte a HTTP request!"
	end
	local httpFn = request or http_request or syn.request or fluxus.request
	local ok, resp = pcall(function()
		return httpFn({ Url = KEY_CONFIG.URL_KEYS, Method = "GET" })
	end)
	if not ok or not resp then
		return nil, "Falha ao baixar keys.json (rede)"
	end
	local body = resp.Body or resp.body
	if not body or body == "" then
		return nil, "keys.json vazio ou inacessível"
	end
	local ok2, decoded = pcall(function() return HttpService:JSONDecode(body) end)
	if not ok2 or not decoded then
		return nil, "JSON inválido"
	end
	return decoded, nil
end

local function ValidarKey(keyInput)
	if not keyInput or keyInput == "" then
		return false, "Digite uma key!"
	end
	keyInput = keyInput:gsub("%s+", "")

	local dados, err = BaixarKeys()
	if not dados then return false, err end

	local hash = Sha256(keyInput)
	local entry = dados.keys and dados.keys[hash]

	if not entry then
		return false, "❌ Key inválida ou não encontrada"
	end

	-- Verifica expiração
	local agora = os.time()
	if entry.expira and entry.expira < agora and entry.expira < 99999999999 then
		return false, "⏰ Key expirada"
	end

	-- Verifica status
	if entry.status and entry.status ~= "ativa" then
		return false, "🚫 Key desativada"
	end

	-- Verifica usos
	if entry.max_usos and entry.max_usos ~= -1 then
		if entry.usos and entry.usos >= entry.max_usos then
			return false, "🔁 Limite de usos atingido"
		end
	end

	-- Verifica HWID
	local meuHWID = GetHWID()
	if entry.hwid and entry.hwid ~= "" and entry.hwid ~= meuHWID then
		return false, "🔒 Key não pertence a este dispositivo"
	end

	-- OK!
	KeyState.valida = true
	KeyState.nivel = entry.nivel or "normal"
	KeyState.nome = entry.nome or "Cliente"
	KeyState.expira = entry.expira or 0
	KeyState.hash = hash
	KeyState.key = keyInput

	SalvarKeyLocal(keyInput)
	return true, entry
end

local function TentarKeySalva()
	local k = CarregarKeyLocal()
	if k and k ~= "" then
		local ok = ValidarKey(k)
		return ok
	end
	return false
end

-- ============================================================
-- UI DE LOGIN (Key)
-- ============================================================
local function MostrarUILogin(callbackSucesso)
	local SGK = Instance.new("ScreenGui")
	SGK.Name = "SailentKeyUI"
	SGK.ResetOnSpawn = false
	SGK.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SGK.IgnoreGuiInset = true
	SGK.Parent = CoreGui

	local BG = Instance.new("Frame")
	BG.Size = UDim2.new(1, 0, 1, 0)
	BG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	BG.BackgroundTransparency = 0.4
	BG.BorderSizePixel = 0
	BG.Parent = SGK

	local Box = Instance.new("Frame")
	Box.Size = UDim2.new(0, 380, 0, 340)
	Box.Position = UDim2.new(0.5, -190, 0.5, -170)
	Box.BackgroundColor3 = C.BG
	Box.BorderSizePixel = 0
	Box.Parent = SGK
	local BC = Instance.new("UICorner")
	BC.CornerRadius = UDim.new(0, 14)
	BC.Parent = Box
	local BS = Instance.new("UIStroke")
	BS.Color = C.Accent
	BS.Thickness = 2
	BS.Parent = Box

	local Title = Instance.new("TextLabel")
	Title.Text = "🔑 SAILENT — AUTH"
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 18
	Title.TextColor3 = C.Accent
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 0, 0, 18)
	Title.Size = UDim2.new(1, 0, 0, 26)
	Title.Parent = Box

	local Sub = Instance.new("TextLabel")
	Sub.Text = "Cole sua key para liberar o script"
	Sub.Font = Enum.Font.Gotham
	Sub.TextSize = 12
	Sub.TextColor3 = C.Sub
	Sub.BackgroundTransparency = 1
	Sub.Position = UDim2.new(0, 0, 0, 48)
	Sub.Size = UDim2.new(1, 0, 0, 18)
	Sub.Parent = Box

	-- Info HWID
	local hwidLbl = Instance.new("TextLabel")
	hwidLbl.Text = "HWID: " .. GetHWID():sub(1, 26) .. "..."
	hwidLbl.Font = Enum.Font.Code
	hwidLbl.TextSize = 10
	hwidLbl.TextColor3 = Color3.fromRGB(100,100,120)
	hwidLbl.BackgroundTransparency = 1
	hwidLbl.Position = UDim2.new(0, 0, 0, 68)
	hwidLbl.Size = UDim2.new(1, 0, 0, 14)
	hwidLbl.Parent = Box

	local Input = Instance.new("TextBox")
	Input.PlaceholderText = "SAILENT-XXXX-XXXX-XXXX"
	Input.Font = Enum.Font.Code
	Input.TextSize = 13
	Input.TextColor3 = C.Text
	Input.PlaceholderColor3 = Color3.fromRGB(90,90,110)
	Input.BackgroundColor3 = C.Card
	Input.BorderSizePixel = 0
	Input.ClearTextOnFocus = false
	Input.Text = ""
	Input.Position = UDim2.new(0, 20, 0, 100)
	Input.Size = UDim2.new(1, -40, 0, 42)
	Input.Parent = Box
	local IC = Instance.new("UICorner")
	IC.CornerRadius = UDim.new(0, 8)
	IC.Parent = Input
	local IS = Instance.new("UIStroke")
	IS.Color = Color3.fromRGB(50,50,70)
	IS.Thickness = 1
	IS.Parent = Input

	local Status = Instance.new("TextLabel")
	Status.Text = ""
	Status.Font = Enum.Font.GothamBold
	Status.TextSize = 11
	Status.TextColor3 = C.Red
	Status.BackgroundTransparency = 1
	Status.Position = UDim2.new(0, 20, 0, 150)
	Status.Size = UDim2.new(1, -40, 0, 40)
	Status.TextWrapped = true
	Status.TextYAlignment = Enum.TextYAlignment.Top
	Status.Parent = Box

	local BtnValidar = Instance.new("TextButton")
	BtnValidar.Text = "✅ VALIDAR KEY"
	BtnValidar.Font = Enum.Font.GothamBold
	BtnValidar.TextSize = 14
	BtnValidar.TextColor3 = C.Black
	BtnValidar.BackgroundColor3 = C.Green
	BtnValidar.BorderSizePixel = 0
	BtnValidar.Position = UDim2.new(0, 20, 0, 200)
	BtnValidar.Size = UDim2.new(1, -40, 0, 46)
	BtnValidar.Parent = Box
	local BtnC = Instance.new("UICorner")
	BtnC.CornerRadius = UDim.new(0, 8)
	BtnC.Parent = BtnValidar

	local BtnComprar = Instance.new("TextButton")
	BtnComprar.Text = "🛒 OBTER KEY"
	BtnComprar.Font = Enum.Font.GothamBold
	BtnComprar.TextSize = 12
	BtnComprar.TextColor3 = C.Text
	BtnComprar.BackgroundColor3 = C.Card
	BtnComprar.BorderSizePixel = 0
	BtnComprar.Position = UDim2.new(0, 20, 0, 256)
	BtnComprar.Size = UDim2.new(1, -40, 0, 36)
	BtnComprar.Parent = Box
	local BtnCC = Instance.new("UICorner")
	BtnCC.CornerRadius = UDim.new(0, 8)
	BtnCC.Parent = BtnComprar

	local BtnLimpar = Instance.new("TextButton")
	BtnLimpar.Text = "🗑️ Limpar key salva"
	BtnLimpar.Font = Enum.Font.Gotham
	BtnLimpar.TextSize = 10
	BtnLimpar.TextColor3 = Color3.fromRGB(120,120,140)
	BtnLimpar.BackgroundTransparency = 1
	BtnLimpar.Position = UDim2.new(0, 20, 0, 300)
	BtnLimpar.Size = UDim2.new(1, -40, 0, 20)
	BtnLimpar.Parent = Box

	-- Verificação automática de key salva
	task.spawn(function()
		local k = CarregarKeyLocal()
		if k and k ~= "" then
			Input.Text = k
			Status.Text = "🔄 Verificando key salva..."
			Status.TextColor3 = C.Yellow
			local ok, res = ValidarKey(k)
			if ok then
				Status.Text = "✅ Bem-vindo, " .. KeyState.nome .. "!"
				Status.TextColor3 = C.Green
				task.wait(1)
				SGK:Destroy()
				callbackSucesso()
			else
				Status.Text = "❌ " .. tostring(res)
				Status.TextColor3 = C.Red
				LimparKeyLocal()
			end
		end
	end)

	BtnValidar.MouseButton1Click:Connect(function()
		local k = Input.Text:gsub("%s+", "")
		if k == "" then
			Status.Text = "⚠️ Cole uma key primeiro!"
			Status.TextColor3 = C.Yellow
			return
		end
		Status.Text = "🔄 Validando..."
		Status.TextColor3 = C.Yellow
		BtnValidar.Text = "⏳ AGUARDE..."
		BtnValidar.BackgroundColor3 = C.Yellow
		task.spawn(function()
			local ok, res = ValidarKey(k)
			if ok then
				Status.Text = "✅ Key válida! Bem-vindo, " .. KeyState.nome .. "!"
				Status.TextColor3 = C.Green
				BtnValidar.Text = "✅ SUCESSO!"
				BtnValidar.BackgroundColor3 = C.Green
				task.wait(1)
				SGK:Destroy()
				callbackSucesso()
			else
				Status.Text = "❌ " .. tostring(res)
				Status.TextColor3 = C.Red
				BtnValidar.Text = "✅ VALIDAR KEY"
				BtnValidar.BackgroundColor3 = C.Green
			end
		end)
	end)

	BtnComprar.MouseButton1Click:Connect(function()
		Status.Text = "💬 Fale com o admin no Discord para obter uma key!"
		Status.TextColor3 = C.Blue
		pcall(function()
			setclipboard("Olá! Quero comprar uma key do Sailent Auto Gari.")
		end)
	end)

	BtnLimpar.MouseButton1Click:Connect(function()
		LimparKeyLocal()
		Input.Text = ""
		Status.Text = "🗑️ Key local removida."
		Status.TextColor3 = C.Sub
	end)
end

-- ============================================================
-- LÓGICA DE MOVIMENTO (original)
-- ============================================================
local function GetHRP()
	local c = lp.Character
	return c and c:FindFirstChild("HumanoidRootPart")
end

local function GetHum()
	local c = lp.Character
	return c and c:FindFirstChild("Humanoid")
end

local function GetPrompt(item)
	if not item then return nil end
	return item:FindFirstChildWhichIsA("ProximityPrompt", true)
end

local CONFIG_FILE = "sailent_gari_config.txt"

local Config = {
	velocidade = 100,
	noclip = false,
	autoGari = false,
	somAtivo = true,
	antiAdmin = true,
}

local function SalvarConfig()
	local str = ""
	for k, v in pairs(Config) do
		str = str .. k .. "=" .. tostring(v) .. "\n"
	end
	pcall(function()
		if writefile then writefile(CONFIG_FILE, str) end
	end)
	_G.SailentConfig = Config
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
	_G.SailentConfig = Config
end

CarregarConfig()

local function TocarSom(tipo)
	if not Config.somAtivo then return end
	pcall(function()
		local sound = Instance.new("Sound")
		sound.Parent = SoundService
		if tipo == "coletou" then
			sound.SoundId = "rbxassetid://4612375230"
		elseif tipo == "entregou" then
			sound.SoundId = "rbxassetid://4612384334"
		elseif tipo == "reset" then
			sound.SoundId = "rbxassetid://6042053626"
		end
		sound.Volume = 0.5
		sound:Play()
		task.delay(2, function() sound:Destroy() end)
	end)
end

local Stats = {
	tempoInicio = tick(),
	coletados = 0,
	entregues = 0,
	lixosMinuto = 0,
	ultimaContagem = 0,
	ultimoTempo = tick(),
}

local function AndarAte(posAlvo, timeout, distParada)
	if not posAlvo then return false end
	local hrp = GetHRP()
	local hum = GetHum()
	if not hrp or not hum then return false end
	timeout = timeout or 30
	distParada = distParada or 4
	local t0 = tick()
	hum:MoveTo(posAlvo)
	while tick() - t0 < timeout do
		local h = GetHRP()
		if not h then return false end
		local diff = Vector3.new(h.Position.X - posAlvo.X, 0, h.Position.Z - posAlvo.Z)
		if diff.Magnitude < distParada then
			hum:MoveTo(h.Position)
			return true
		end
		hum:MoveTo(posAlvo)
		task.wait(0.1)
	end
	return false
end

local lixosUsados = {}

local function GetLixosContainer()
	local w = workspace
	for _, n in ipairs({"Construcoes","SistemaGari","Lixos"}) do
		w = w:FindFirstChild(n)
		if not w then return nil end
	end
	return w
end

local function GetCaminhao()
	local s = workspace:FindFirstChild("CarrosSpawnados")
	return s and s:FindFirstChild("Lixeiro")
end

local function GetTraseira(cam)
	if not cam then return nil end
	local body = cam:FindFirstChild("Body")
	if not body then return nil end
	return body:FindFirstChild("Proximitikk")
end

local function TemLixoNaMao()
	if not lp.Character then return false end
	for _, o in ipairs(lp.Character:GetChildren()) do
		if o:IsA("Tool") and o.Name == "Lixo" then return true end
	end
	return false
end

local function AcharProximoLixo()
	local cont = GetLixosContainer()
	if not cont then return nil end
	local hrp = GetHRP()
	if not hrp then return nil end
	local disponiveis = {}
	for _, lixo in ipairs(cont:GetChildren()) do
		if lixo:IsA("BasePart") and not lixosUsados[lixo] then
			table.insert(disponiveis, {lixo = lixo, dist = (lixo.Position - hrp.Position).Magnitude})
		end
	end
	if #disponiveis == 0 then
		TocarSom("reset")
		lixosUsados = {}
		for _, lixo in ipairs(cont:GetChildren()) do
			if lixo:IsA("BasePart") then
				table.insert(disponiveis, {lixo = lixo, dist = (lixo.Position - hrp.Position).Magnitude})
			end
		end
	end
	table.sort(disponiveis, function(a, b) return a.dist < b.dist end)
	return disponiveis[1] and disponiveis[1].lixo or nil
end

-- ============================================================
-- 🚀 INICIALIZAÇÃO PRINCIPAL (após validar key)
-- ============================================================
local function IniciarScript()

	-- ═══════════════════════════════════════════
	-- BOTÃO FLUTUANTE
	-- ═══════════════════════════════════════════
	local SGBtn = Instance.new("ScreenGui")
	SGBtn.Name = "SailentFloatBtn"
	SGBtn.ResetOnSpawn = false
	SGBtn.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SGBtn.IgnoreGuiInset = true
	SGBtn.Parent = CoreGui

	local FloatBtn = Instance.new("TextButton")
	FloatBtn.Text = "⚡"
	FloatBtn.Font = Enum.Font.GothamBold
	FloatBtn.TextSize = 28
	FloatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	FloatBtn.BackgroundColor3 = C.Black
	FloatBtn.BorderSizePixel = 0
	FloatBtn.Size = UDim2.new(0, 60, 0, 60)
	FloatBtn.Position = UDim2.new(0, 20, 0.5, -30)
	FloatBtn.AutoButtonColor = false
	FloatBtn.Active = true
	FloatBtn.Parent = SGBtn

	local BtnCorner = Instance.new("UICorner")
	BtnCorner.CornerRadius = UDim.new(1, 0)
	BtnCorner.Parent = FloatBtn

	local BtnStroke = Instance.new("UIStroke")
	BtnStroke.Color = C.Purple
	BtnStroke.Thickness = 2
	BtnStroke.Parent = FloatBtn

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

	-- ═══════════════════════════════════════════
	-- UI PRINCIPAL
	-- ═══════════════════════════════════════════
	local SG = Instance.new("ScreenGui")
	SG.Name = "SailentGari"
	SG.ResetOnSpawn = false
	SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SG.IgnoreGuiInset = true
	SG.Parent = CoreGui

	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0, 400, 0, 560)
	Main.Position = UDim2.new(0.5, -200, 0.5, -280)
	Main.BackgroundColor3 = C.BG
	Main.BorderSizePixel = 0
	Main.Parent = SG

	local MC = Instance.new("UICorner")
	MC.CornerRadius = UDim.new(0, 14)
	MC.Parent = Main

	local MS = Instance.new("UIStroke")
	MS.Color = C.Accent
	MS.Thickness = 1.5
	MS.Transparency = 0.3
	MS.Parent = Main

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
			if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
				di = i
			end
		end)
		UserInput.InputChanged:Connect(function(i)
			if i == di and d then up(i) end
		end)
	end

	local TB = Instance.new("Frame")
	TB.Size = UDim2.new(1, 0, 0, 56)
	TB.BackgroundColor3 = C.Card
	TB.BorderSizePixel = 0
	TB.Parent = Main
	local TBC = Instance.new("UICorner")
	TBC.CornerRadius = UDim.new(0, 14)
	TBC.Parent = TB
	local TBov = Instance.new("Frame")
	TBov.Size = UDim2.new(1, 0, 0, 14)
	TBov.Position = UDim2.new(0, 0, 1, -14)
	TBov.BackgroundColor3 = C.Card
	TBov.BorderSizePixel = 0
	TBov.Parent = TB

	local TLogo = Instance.new("TextLabel")
	TLogo.Text = "🗑️"
	TLogo.Font = Enum.Font.GothamBold
	TLogo.TextSize = 22
	TLogo.BackgroundTransparency = 1
	TLogo.Position = UDim2.new(0, 14, 0, 0)
	TLogo.Size = UDim2.new(0, 40, 1, 0)
	TLogo.Parent = TB

	local TTitle = Instance.new("TextLabel")
	TTitle.Text = "Auto Gari v5.2 [" .. KeyState.nivel:upper() .. "]"
	TTitle.Font = Enum.Font.GothamBold
	TTitle.TextSize = 14
	TTitle.TextColor3 = C.Text
	TTitle.BackgroundTransparency = 1
	TTitle.Position = UDim2.new(0, 55, 0, 0)
	TTitle.Size = UDim2.new(0, 200, 1, 0)
	TTitle.TextXAlignment = Enum.TextXAlignment.Left
	TTitle.Parent = TB

	local MinBtn = Instance.new("TextButton")
	MinBtn.Text = "−"
	MinBtn.Font = Enum.Font.GothamBold
	MinBtn.TextSize = 20
	MinBtn.TextColor3 = C.Yellow
	MinBtn.BackgroundColor3 = C.Card
	MinBtn.BorderSizePixel = 0
	MinBtn.Size = UDim2.new(0, 36, 1, 0)
	MinBtn.Position = UDim2.new(1, -92, 0, 0)
	MinBtn.Parent = TB
	local MinC = Instance.new("UICorner")
	MinC.CornerRadius = UDim.new(0, 14)
	MinC.Parent = MinBtn

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Text = "✕"
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = 18
	CloseBtn.TextColor3 = C.Sub
	CloseBtn.BackgroundColor3 = C.Card
	CloseBtn.BorderSizePixel = 0
	CloseBtn.Size = UDim2.new(0, 56, 1, 0)
	CloseBtn.Position = UDim2.new(1, -56, 0, 0)
	CloseBtn.Parent = TB
	local CC = Instance.new("UICorner")
	CC.CornerRadius = UDim.new(0, 14)
	CC.Parent = CloseBtn

	local Content = Instance.new("ScrollingFrame")
	Content.Size = UDim2.new(1, -20, 1, -76)
	Content.Position = UDim2.new(0, 10, 0, 66)
	Content.BackgroundTransparency = 1
	Content.BorderSizePixel = 0
	Content.ScrollBarThickness = 4
	Content.ScrollBarImageColor3 = C.Accent
	Content.CanvasSize = UDim2.new(0, 0, 0, 0)
	Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Content.Parent = Main

	local Lay = Instance.new("UIListLayout")
	Lay.Padding = UDim.new(0, 8)
	Lay.Parent = Content

	local function Sec(txt, color)
		local f = Instance.new("Frame")
		f.Size = UDim2.new(1, 0, 0, 26)
		f.BackgroundColor3 = C.Card
		f.BorderSizePixel = 0
		f.Parent = Content
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 6)
		c.Parent = f
		local l = Instance.new("TextLabel")
		l.Text = txt
		l.Font = Enum.Font.GothamBold
		l.TextSize = 11
		l.TextColor3 = color or C.Accent
		l.BackgroundTransparency = 1
		l.Position = UDim2.new(0, 12, 0, 0)
		l.Size = UDim2.new(1, -24, 1, 0)
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.Parent = f
	end

	local function Stat(txt, color)
		local f = Instance.new("Frame")
		f.Size = UDim2.new(1, 0, 0, 32)
		f.BackgroundColor3 = C.Card
		f.BorderSizePixel = 0
		f.Parent = Content
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 6)
		c.Parent = f
		local l = Instance.new("TextLabel")
		l.Text = txt
		l.Font = Enum.Font.GothamBold
		l.TextSize = 11
		l.TextColor3 = color or C.Text
		l.BackgroundTransparency = 1
		l.Position = UDim2.new(0, 12, 0, 0)
		l.Size = UDim2.new(1, -24, 1, 0)
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.Parent = f
		return l
	end

	local function Btn(txt, color, cb)
		local b = Instance.new("TextButton")
		b.Text = txt
		b.Font = Enum.Font.GothamBold
		b.TextSize = 12
		b.TextColor3 = C.Text
		b.BackgroundColor3 = C.Card
		b.BorderSizePixel = 0
		b.Size = UDim2.new(1, 0, 0, 38)
		b.AutoButtonColor = false
		b.Parent = Content
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 8)
		c.Parent = b
		b.MouseButton1Click:Connect(function()
			Tween(b, {BackgroundColor3 = color or C.Accent}, 0.08)
			task.wait(0.12)
			Tween(b, {BackgroundColor3 = C.Card}, 0.15)
			if cb then task.spawn(cb) end
		end)
		return b
	end

	local function Toggle(txt, default, cb)
		local f = Instance.new("Frame")
		f.Size = UDim2.new(1, 0, 0, 42)
		f.BackgroundColor3 = C.Card
		f.BorderSizePixel = 0
		f.Parent = Content
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 8)
		c.Parent = f
		local l = Instance.new("TextLabel")
		l.Text = txt
		l.Font = Enum.Font.GothamBold
		l.TextSize = 12
		l.TextColor3 = C.Text
		l.BackgroundTransparency = 1
		l.Position = UDim2.new(0, 12, 0, 0)
		l.Size = UDim2.new(1, -70, 1, 0)
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.Parent = f
		local bg = Instance.new("Frame")
		bg.Size = UDim2.new(0, 44, 0, 22)
		bg.Position = UDim2.new(1, -56, 0.5, -11)
		bg.BackgroundColor3 = Color3.fromRGB(50,50,60)
		bg.BorderSizePixel = 0
		bg.Parent = f
		local bc = Instance.new("UICorner")
		bc.CornerRadius = UDim.new(1, 0)
		bc.Parent = bg
		local k = Instance.new("Frame")
		k.Size = UDim2.new(0, 18, 0, 18)
		k.Position = UDim2.new(0, 2, 0.5, -9)
		k.BackgroundColor3 = C.Text
		k.BorderSizePixel = 0
		k.Parent = bg
		local kc = Instance.new("UICorner")
		kc.CornerRadius = UDim.new(1, 0)
		kc.Parent = k
		local st = default or false
		local function set(v)
			st = v
			if st then
				Tween(bg, {BackgroundColor3 = C.Green}, 0.2)
				Tween(k, {Position = UDim2.new(1, -20, 0.5, -9)}, 0.2)
			else
				Tween(bg, {BackgroundColor3 = Color3.fromRGB(50,50,60)}, 0.2)
				Tween(k, {Position = UDim2.new(0, 2, 0.5, -9)}, 0.2)
			end
			if cb then cb(st) end
		end
		if st then
			bg.BackgroundColor3 = C.Green
			k.Position = UDim2.new(1, -20, 0.5, -9)
		end
		local cl = Instance.new("TextButton")
		cl.Text = ""
		cl.BackgroundTransparency = 1
		cl.Size = UDim2.new(1, 0, 1, 0)
		cl.Parent = f
		cl.MouseButton1Click:Connect(function() set(not st) end)
		return set
	end

	local velocidadeAtual = Config.velocidade

	local function CriarSlider(parent, min, max, default, callback)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 58)
		frame.BackgroundColor3 = C.Card
		frame.BorderSizePixel = 0
		frame.Parent = parent
		local fc = Instance.new("UICorner")
		fc.CornerRadius = UDim.new(0, 8)
		fc.Parent = frame

		local titulo = Instance.new("TextLabel")
		titulo.Text = "⚡ Velocidade"
		titulo.Font = Enum.Font.GothamBold
		titulo.TextSize = 12
		titulo.TextColor3 = C.Text
		titulo.BackgroundTransparency = 1
		titulo.Position = UDim2.new(0, 12, 0, 6)
		titulo.Size = UDim2.new(0.7, 0, 0, 18)
		titulo.TextXAlignment = Enum.TextXAlignment.Left
		titulo.Parent = frame

		local valorLabel = Instance.new("TextLabel")
		valorLabel.Text = tostring(default)
		valorLabel.Font = Enum.Font.GothamBold
		valorLabel.TextSize = 14
		valorLabel.TextColor3 = C.Green
		valorLabel.BackgroundTransparency = 1
		valorLabel.Position = UDim2.new(0.7, 0, 0, 6)
		valorLabel.Size = UDim2.new(0.3, -12, 0, 18)
		valorLabel.TextXAlignment = Enum.TextXAlignment.Right
		valorLabel.Parent = frame

		local bgBar = Instance.new("Frame")
		bgBar.Size = UDim2.new(1, -24, 0, 12)
		bgBar.Position = UDim2.new(0, 12, 0, 32)
		bgBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
		bgBar.BorderSizePixel = 0
		bgBar.Parent = frame
		local bbc = Instance.new("UICorner")
		bbc.CornerRadius = UDim.new(1, 0)
		bbc.Parent = bgBar

		local fillBar = Instance.new("Frame")
		fillBar.Size = UDim2.new(0, 0, 1, 0)
		fillBar.BackgroundColor3 = C.Green
		fillBar.BorderSizePixel = 0
		fillBar.Parent = bgBar
		local fbc = Instance.new("UICorner")
		fbc.CornerRadius = UDim.new(1, 0)
		fbc.Parent = fillBar

		local knob = Instance.new("Frame")
		knob.Size = UDim2.new(0, 22, 0, 22)
		knob.Position = UDim2.new(0, -11, 0.5, -11)
		knob.BackgroundColor3 = C.Text
		knob.BorderSizePixel = 0
		knob.Parent = bgBar
		local kc = Instance.new("UICorner")
		kc.CornerRadius = UDim.new(1, 0)
		kc.Parent = knob

		local valor = default
		local arrastando = false

		local function Atualizar(posX)
			local bgAbs = bgBar.AbsolutePosition.X
			local bgSize = bgBar.AbsoluteSize.X
			local percent = math.clamp((posX - bgAbs) / bgSize, 0, 1)
			valor = math.floor(min + (max - min) * percent)
			valorLabel.Text = tostring(valor)
			fillBar.Size = UDim2.new(percent, 0, 1, 0)
			knob.Position = UDim2.new(percent, -11, 0.5, -11)
			if callback then callback(valor) end
		end

		local initPercent = (default - min) / (max - min)
		fillBar.Size = UDim2.new(initPercent, 0, 1, 0)
		knob.Position = UDim2.new(initPercent, -11, 0.5, -11)

		bgBar.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				arrastando = true
				_G.SailentBloquearDrag = true
				Atualizar(i.Position.X)
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
					arrastando = false
					_G.SailentBloquearDrag = false
					Config.velocidade = valor
					SalvarConfig()
				end
			end
		end)
	end

	-- ═══════════════════════════════════════════
	-- SEÇÕES
	-- ═══════════════════════════════════════════
	Sec("👤 CONTA: " .. KeyState.nome, C.Purple)
	Sec("📊 ESTATÍSTICAS", C.Blue)

	local statTempo = Stat("⏱️ Tempo: 0h 0min", C.Sub)
	local statLixosMin = Stat("📈 Lixos/min: 0", C.Sub)

	Sec("🗑️ AUTO GARI", C.Green)

	local gariStatus = Stat("Status: PARADO", C.Sub)
	local gariStats = Stat("Coletados: 0 | Entregues: 0", C.Sub)
	local gariLixos = Stat("Lixos usados: 0/39", C.Sub)

	local gariOn = false
	local gariCount = {coletados = 0, entregues = 0}

	local setGariAtivo = Toggle("Auto Gari (ordem + noclip)", Config.autoGari, function(s)
		gariOn = s
		Config.autoGari = s
		SalvarConfig()
		if s then
			gariStatus.Text = "Status: ● ATIVO"
			gariStatus.TextColor3 = C.Green
			local hum = GetHum()
			if hum then hum.WalkSpeed = velocidadeAtual end
			task.spawn(function()
				while gariOn do
					local temLixo = TemLixoNaMao()
					if temLixo then
						gariStatus.Text = "📤 Indo pra TRASEIRA..."
						local cam = GetCaminhao()
						if not cam then
							gariStatus.Text = "⚠️ Spawne o caminhão!"
							task.wait(2); continue
						end
						local traseira = GetTraseira(cam)
						if traseira then
							AndarAte(traseira.Position, 30, 4)
							task.wait(0.5)
							gariStatus.Text = "📤 Entregando..."
							local prompt = GetPrompt(traseira)
							if prompt then
								pcall(function() fireproximityprompt(prompt) end)
								task.wait(0.8)
								if not TemLixoNaMao() then
									gariCount.entregues += 1
									Stats.entregues += 1
									TocarSom("entregou")
								end
							end
						end
					else
						gariStatus.Text = "📥 Procurando lixo..."
						local lixo = AcharProximoLixo()
						if lixo then
							gariStatus.Text = "📥 Indo pro lixo..."
							AndarAte(lixo.Position, 30, 4)
							task.wait(0.5)
							gariStatus.Text = "📥 Coletando..."
							local prompt = GetPrompt(lixo)
							if prompt then
								pcall(function() fireproximityprompt(prompt) end)
								task.wait(0.8)
								if TemLixoNaMao() then
									gariCount.coletados += 1
									Stats.coletados += 1
									lixosUsados[lixo] = true
									TocarSom("coletou")
								end
							end
						end
					end
					local totalUsados = 0
					for _ in pairs(lixosUsados) do totalUsados += 1 end
					gariStats.Text = "Coletados: "..gariCount.coletados.." | Entregues: "..gariCount.entregues
					gariLixos.Text = "Lixos usados: "..totalUsados.."/39"
					task.wait(1)
				end
			end)
		else
			gariStatus.Text = "Status: PARADO"
			gariStatus.TextColor3 = C.Sub
			local hum = GetHum()
			if hum then hum.WalkSpeed = 16 end
		end
	end)

	Sec("⚡ VELOCIDADE", C.Yellow)

	CriarSlider(Content, 16, 200, Config.velocidade, function(valor)
		velocidadeAtual = valor
		Config.velocidade = valor
		local hum = GetHum()
		if hum then hum.WalkSpeed = valor end
	end)

	Sec("👻 NOCLIP", C.Purple)

	local noclipOn = false
	local noclipConn

	Toggle("Noclip (atravessar paredes)", Config.noclip, function(s)
		noclipOn = s
		Config.noclip = s
		SalvarConfig()
		if s then
			if noclipConn then noclipConn:Disconnect() end
			noclipConn = RunService.Stepped:Connect(function()
				if not noclipOn then return end
				local c = lp.Character
				if not c then return end
				for _, p in ipairs(c:GetDescendants()) do
					if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
				end
			end)
		else
			if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
		end
	end)

	Sec("🎵 SOM", C.Accent)

	Toggle("Notificações sonoras", Config.somAtivo, function(s)
		Config.somAtivo = s
		SalvarConfig()
	end)

	Sec("🛡️ ANTI-ADMIN", C.Red)

	Toggle("Parar Auto Gari se admin entrar", Config.antiAdmin, function(s)
		Config.antiAdmin = s
		SalvarConfig()
	end)

	Sec("🚨 EMERGÊNCIA", C.Red)

	Btn("🛑 PARAR TUDO", C.Red, function()
		gariOn = false
		setGariAtivo(false)
		noclipOn = false
		if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
		gariStatus.Text = "Status: PARADO"
		gariStatus.TextColor3 = C.Sub
		local hum = GetHum()
		if hum then hum.WalkSpeed = 16 end
	end)

	-- ═══════════════════════════════════════════
	-- ATUALIZA ESTATÍSTICAS
	-- ═══════════════════════════════════════════
	task.spawn(function()
		while SG.Parent do
			task.wait(1)
			local tempoTotal = tick() - Stats.tempoInicio
			local horas = math.floor(tempoTotal / 3600)
			local mins = math.floor((tempoTotal % 3600) / 60)
			statTempo.Text = "⏱️ Tempo: "..horas.."h "..mins.."min"
			local diffT = tick() - Stats.ultimoTempo
			local diffL = Stats.coletados - Stats.ultimaContagem
			if diffT >= 10 then
				Stats.lixosMinuto = math.floor((diffL / diffT) * 60)
				Stats.ultimaContagem = Stats.coletados
				Stats.ultimoTempo = tick()
			end
			statLixosMin.Text = "📈 Lixos/min: "..Stats.lixosMinuto
		end
	end)

	-- ═══════════════════════════════════════════
	-- KEYBIND
	-- ═══════════════════════════════════════════
	local uiAberta = true

	local function FecharUI()
		uiAberta = false
		Tween(Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
		task.wait(0.2)
		Main.Visible = false
		FloatBtn.Text = "⚡"
		Tween(FloatBtn, {BackgroundColor3 = C.Black}, 0.15)
	end

	local function AbrirUI()
		uiAberta = true
		Main.Visible = true
		Main.Size = UDim2.new(0, 0, 0, 0)
		Tween(Main, {Size = UDim2.new(0, 400, 0, 560)}, 0.25)
		FloatBtn.Text = "✕"
		Tween(FloatBtn, {BackgroundColor3 = C.Red}, 0.15)
	end

	FloatBtn.MouseButton1Click:Connect(function()
		if btnMoveuSe then return end
		if uiAberta then FecharUI() else AbrirUI() end
	end)

	UserInput.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.F2 then
			if uiAberta then FecharUI() else AbrirUI() end
		end
	end)

	UserInput.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.F1 then
			gariOn = false
			setGariAtivo(false)
			noclipOn = false
			if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
			local hum = GetHum()
			if hum then hum.WalkSpeed = 16 end
			FecharUI()
		end
	end)

	local minimizado = false
	MinBtn.MouseButton1Click:Connect(function()
		minimizado = not minimizado
		if minimizado then
			Tween(Main, {Size = UDim2.new(0, 400, 0, 56)}, 0.25)
			MinBtn.Text = "+"
		else
			Tween(Main, {Size = UDim2.new(0, 400, 0, 560)}, 0.25)
			MinBtn.Text = "−"
		end
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		FecharUI()
	end)

	-- ═══════════════════════════════════════════
	-- ANTI-ADMIN
	-- ═══════════════════════════════════════════
	local function ChecarAdmins()
		if not Config.antiAdmin then return end
		local admins = {"admin", "mod", "owner", "staff", "adm", "moderator"}
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= lp then
				local nome = p.Name:lower()
				for _, kw in ipairs(admins) do
					if nome:find(kw) then
						if gariOn then
							gariOn = false
							setGariAtivo(false)
							Log("🚨 ADMIN DETECTADO: " .. p.Name)
						end
						break
					end
				end
			end
		end
	end

	task.spawn(function()
		while SG.Parent do
			task.wait(5)
			ChecarAdmins()
		end
	end)

	Log("═══════════════════════════════════")
	Log("🗑️ Sailent Auto Gari v5.2 [KEY OK]")
	Log("👤 Cliente: " .. KeyState.nome .. " | Nível: " .. KeyState.nivel:upper())
	Log("⚡ F2 = Abre/fecha UI")
	Log("🚨 F1 = Panic")
	Log("═══════════════════════════════════")
end

-- ============================================================
-- 🚪 ENTRY POINT — Valida key e inicia script
-- ============================================================
Log("🔐 Verificando key...")

task.spawn(function()
	-- Tenta key salva primeiro
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

	-- Se não tem key válida, mostra UI de login
	MostrarUILogin(function()
		IniciarScript()
	end)
end)

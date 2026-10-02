-- ============================================================
-- SAILENT AUTO GARI v6.8 — FLY CFrame + MELHORIAS v2.1
-- Novidades: Anti-AFK, Auto-reconectar, Server hop, Webhook Discord,
-- Perfis, Modo seguro, FPS boost, Hotkeys editáveis, revalidação de
-- key, tokens de loop, pcall, toggle salvo que realmente inicia,
-- resumo de sessão. (Anti-admin, God mode e estatísticas mantidos.)
-- ============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local lp = Players.LocalPlayer

local KEY_CONFIG = {
	URL_KEYS = "https://raw.githubusercontent.com/simiao64santos-dot/sailent-/refs/heads/main/keys.json",
	ARQUIVO_CACHE = "sailent_gari_key.txt",
	NOME_SCRIPT = "Sailent Auto Gari v6.8",
	-- Link RAW deste script (usado para reexecutar após reconectar / trocar de servidor)
	URL_SCRIPT = "https://raw.githubusercontent.com/simiao64santos-dot/sailent-/refs/heads/main/main.lua",
	VERSAO = "6.8",
	REVALIDAR_SEG = 1800, -- revalida a key a cada 30 min
}

for _, name in ipairs({"SailentGari", "SailentFloatBtn", "SailentKeyUI", "SailentLoader", "SailentToast"}) do
	local old = CoreGui:FindFirstChild(name)
	if old then pcall(function() old:Destroy() end) end
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
	if not o or not o.Parent then return end
	local tw = TweenService:Create(o, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint), p)
	tw:Play()
	return tw
end

local function Log(msg) print("[Gari] " .. tostring(msg)) end

local function GetHttp()
	return (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
end

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
	local httpFn = GetHttp()
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

-- retorna: ok, entry|mensagem, erroDeRede
local function ValidarKey(keyInput)
	if not keyInput or keyInput == "" then return false, "Digite uma key!" end
	keyInput = keyInput:gsub("%s+", "")
	local dados, err = BaixarKeys()
	if not dados then return false, err, true end
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

local SGBToast = Instance.new("ScreenGui")
SGBToast.Name = "SailentToast"
SGBToast.ResetOnSpawn = false
SGBToast.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SGBToast.IgnoreGuiInset = true
SGBToast.DisplayOrder = 999
SGBToast.Parent = CoreGui

local toastContainer = Instance.new("Frame")
toastContainer.Size = UDim2.new(0, 300, 1, 0)
toastContainer.Position = UDim2.new(1, -320, 0, 0)
toastContainer.BackgroundTransparency = 1
toastContainer.Parent = SGBToast

local toastLay = Instance.new("UIListLayout")
toastLay.VerticalAlignment = Enum.VerticalAlignment.Bottom
toastLay.HorizontalAlignment = Enum.HorizontalAlignment.Right
toastLay.Padding = UDim.new(0, 6)
toastLay.SortOrder = Enum.SortOrder.LayoutOrder
toastLay.Parent = toastContainer

local toastCounter = 0
local ultimoToast = {}
local function Notificar(txt, cor, duracao)
	cor = cor or C.Accent
	duracao = duracao or 2.5
	local agora = tick()
	if ultimoToast[tostring(txt)] and (agora - ultimoToast[tostring(txt)]) < 1 then return end
	ultimoToast[tostring(txt)] = agora
	toastCounter = toastCounter + 1
	local t = Instance.new("TextLabel")
	t.Text = tostring(txt)
	t.Font = Enum.Font.GothamBold
	t.TextSize = 12
	t.TextColor3 = C.Black
	t.BackgroundColor3 = cor
	t.BackgroundTransparency = 1
	t.TextTransparency = 1
	t.Size = UDim2.new(1, 0, 0, 34)
	t.TextWrapped = true
	t.LayoutOrder = toastCounter
	t.Parent = toastContainer
	local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(0, 8); tc.Parent = t
	local tp = Instance.new("UIPadding")
	tp.PaddingLeft = UDim.new(0, 10); tp.PaddingRight = UDim.new(0, 10)
	tp.PaddingTop = UDim.new(0, 6); tp.PaddingBottom = UDim.new(0, 6); tp.Parent = t
	Tween(t, {BackgroundTransparency = 0.1, TextTransparency = 0}, 0.2)
	task.delay(duracao, function()
		Tween(t, {BackgroundTransparency = 1, TextTransparency = 1}, 0.4)
		task.wait(0.5); pcall(function() t:Destroy() end)
	end)
end

local function MostrarUILogin(callbackSucesso)
	local SGK = Instance.new("ScreenGui")
	SGK.Name = "SailentKeyUI"
	SGK.ResetOnSpawn = false
	SGK.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SGK.IgnoreGuiInset = true
	SGK.DisplayOrder = 999
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
	local BC = Instance.new("UICorner"); BC.CornerRadius = UDim.new(0, 14); BC.Parent = Box
	local BS = Instance.new("UIStroke"); BS.Color = C.Accent; BS.Thickness = 2; BS.Parent = Box

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
	local IC = Instance.new("UICorner"); IC.CornerRadius = UDim.new(0, 8); IC.Parent = Input
	local IS = Instance.new("UIStroke"); IS.Color = Color3.fromRGB(50,50,70); IS.Thickness = 1; IS.Parent = Input

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
	local BtnC = Instance.new("UICorner"); BtnC.CornerRadius = UDim.new(0, 8); BtnC.Parent = BtnValidar

	local BtnLimpar = Instance.new("TextButton")
	BtnLimpar.Text = "🗑️ Limpar key salva"
	BtnLimpar.Font = Enum.Font.Gotham
	BtnLimpar.TextSize = 10
	BtnLimpar.TextColor3 = Color3.fromRGB(120,120,140)
	BtnLimpar.BackgroundTransparency = 1
	BtnLimpar.Position = UDim2.new(0, 20, 0, 300)
	BtnLimpar.Size = UDim2.new(1, -40, 0, 20)
	BtnLimpar.Parent = Box

	local function SucessoLogin()
		Status.Text = "✅ Bem-vindo, " .. KeyState.nome .. "!"
		Status.TextColor3 = C.Green
		BtnValidar.Text = "✅ SUCESSO!"
		task.wait(0.3)
		pcall(function() SGK:Destroy() end)
		task.wait(0.1)
		callbackSucesso()
	end

	task.spawn(function()
		task.wait(0.2)
		local k = CarregarKeyLocal()
		if k and k ~= "" then
			Input.Text = k
			Status.Text = "🔄 Verificando key salva..."
			Status.TextColor3 = C.Yellow
			local ok, res = ValidarKey(k)
			if ok then SucessoLogin() else
				Status.Text = "❌ " .. tostring(res)
				Status.TextColor3 = C.Red
				LimparKeyLocal()
			end
		end
	end)

	BtnValidar.MouseButton1Click:Connect(function()
		local k = Input.Text:gsub("%s+", "")
		if k == "" then Status.Text = "⚠️ Cole uma key!"; Status.TextColor3 = C.Yellow; return end
		Status.Text = "🔄 Validando..."; Status.TextColor3 = C.Yellow
		BtnValidar.Text = "⏳ AGUARDE..."; BtnValidar.BackgroundColor3 = C.Yellow
		task.spawn(function()
			local ok, res = ValidarKey(k)
			if ok then SucessoLogin() else
				Status.Text = "❌ " .. tostring(res)
				Status.TextColor3 = C.Red
				BtnValidar.Text = "✅ VALIDAR KEY"
				BtnValidar.BackgroundColor3 = C.Green
			end
		end)
	end)

	BtnLimpar.MouseButton1Click:Connect(function()
		LimparKeyLocal(); Input.Text = ""
		Status.Text = "🗑️ Removida."; Status.TextColor3 = C.Sub
	end)
end

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

-- posição de BasePart / Model / Attachment
local function PosDe(obj)
	if not obj then return nil end
	if obj:IsA("BasePart") then return obj.Position end
	if obj:IsA("Attachment") then return obj.WorldPosition end
	if obj:IsA("Model") then
		local root = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
		if root then return root.Position end
	end
	for _, d in ipairs(obj:GetDescendants()) do
		if d:IsA("BasePart") then return d.Position
		elseif d:IsA("Attachment") then return d.WorldPosition end
	end
	return nil
end

-- CONFIG
local CONFIG_FILE = "sailent_gari_config.txt"
local Config = {
	velocidade = 100,
	velFly = 60,
	noclip = false,
	autoGari = false,
	somAtivo = true,
	antiAdmin = true,
	godMode = true,
	debug = false,
	modoVoo = false,
	-- novos
	antiAfk = true,
	autoReconnect = false,
	modoSeguro = false,
	fpsBoost = false,
	webhookAtivo = false,
	webhookUrl = "",
	webhookMin = 30,
	keyUI = "F2",
	keyPanic = "F1",
	keyGari = "G",
	keyVoo = "F",
}

local function SalvarConfig()
	local str = ""
	for k, v in pairs(Config) do
		if tostring(v) ~= "" then str = str .. k .. "=" .. tostring(v) .. "\n" end
	end
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
	Config.godMode = true
end

CarregarConfig()

local function Dbg(msg) if Config.debug then Log("[debug] " .. tostring(msg)) end end

local function TocarSom(tipo)
	if not Config.somAtivo then return end
	pcall(function()
		local sound = Instance.new("Sound")
		sound.Parent = SoundService
		if tipo == "coletou" then sound.SoundId = "rbxassetid://4612375230"
		elseif tipo == "entregou" then sound.SoundId = "rbxassetid://4612384334"
		elseif tipo == "reset" then sound.SoundId = "rbxassetid://6042053626" end
		sound.Volume = 0.15
		sound:Play()
		task.delay(2, function() sound:Destroy() end)
	end)
end

local Stats = {
	tempoInicio = tick(), coletados = 0, entregues = 0,
	lixosMinuto = 0, ultimaContagem = 0, ultimoTempo = tick(), mortesEvitadas = 0,
	erros = 0,
}

local function FmtTempo(seg)
	seg = math.floor(seg)
	return string.format("%02d:%02d:%02d", math.floor(seg / 3600), math.floor(seg % 3600 / 60), seg % 60)
end

local function ResumoStats()
	local dec = tick() - Stats.tempoInicio
	local horas = math.max(dec / 3600, 1 / 60)
	local porHora = math.floor(Stats.entregues / horas)
	return string.format("⏱ %s | 🗑 %d | 📤 %d | 📈 %d/h", FmtTempo(dec), Stats.coletados, Stats.entregues, porHora)
end

-- WEBHOOK DISCORD
local function Webhook(txt, forcar)
	if not forcar and (not Config.webhookAtivo or Config.webhookUrl == "") then return end
	if not Config.webhookUrl or Config.webhookUrl == "" then return end
	local httpFn = GetHttp()
	if not httpFn then return end
	task.spawn(function()
		pcall(function()
			httpFn({
				Url = Config.webhookUrl,
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = HttpService:JSONEncode({
					username = "Sailent Gari",
					content = "**[" .. lp.Name .. "]** " .. tostring(txt),
				}),
			})
		end)
	end)
end

-- HUMANIZAÇÃO (modo seguro)
local function Esp(t)
	if Config.modoSeguro then t = t * (0.8 + math.random() * 0.7) end
	task.wait(t)
end

local function PausaHumana()
	if Config.modoSeguro and math.random() < 0.08 then
		task.wait(math.random(15, 40) / 10)
	end
end

local function VelEfetiva()
	if Config.modoSeguro then return math.min(Config.velocidade, 32) end
	return Config.velocidade
end

local function VelFlyEfetiva()
	if Config.modoSeguro then return math.min(Config.velFly or 60, 35) end
	return Config.velFly or 60
end

local function AplicarVelocidade()
	local hum = GetHum()
	if hum then hum.WalkSpeed = VelEfetiva() end
end

-- ANTI-AFK
local afkConn = nil
local function SetAntiAfk(on)
	if afkConn then pcall(function() afkConn:Disconnect() end); afkConn = nil end
	if on then
		afkConn = lp.Idled:Connect(function()
			pcall(function()
				VirtualUser:CaptureController()
				VirtualUser:ClickButton2(Vector2.new())
			end)
		end)
	end
end

-- REEXECUTAR APÓS TELEPORTE
local function QueueReexec()
	if KEY_CONFIG.URL_SCRIPT ~= "" and queue_on_teleport then
		pcall(function()
			queue_on_teleport('loadstring(game:HttpGet("' .. KEY_CONFIG.URL_SCRIPT .. '"))()')
		end)
	end
end

-- AUTO-RECONECTAR
local function IniciarAutoReconnect()
	task.spawn(function()
		pcall(function()
			local prompt = CoreGui:WaitForChild("RobloxPromptGui", 15)
			local overlay = prompt and prompt:WaitForChild("promptOverlay", 15)
			if not overlay then return end
			overlay.ChildAdded:Connect(function(c)
				if c.Name == "ErrorPrompt" and Config.autoReconnect then
					Log("Desconectado — reconectando...")
					Webhook("⚠️ Desconectado. Tentando reconectar...")
					task.wait(2)
					QueueReexec()
					for _ = 1, 5 do
						pcall(function() TeleportService:Teleport(game.PlaceId, lp) end)
						task.wait(8)
					end
				end
			end)
		end)
	end)
end

-- TROCAR DE SERVIDOR
local function ServerHop()
	local httpFn = GetHttp()
	if not httpFn then Notificar("❌ Executor sem HTTP", C.Red, 2); return end
	Notificar("🌐 Procurando servidor...", C.Blue, 2)
	local ok, resp = pcall(function()
		return httpFn({
			Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", game.PlaceId),
			Method = "GET",
		})
	end)
	if not ok or not resp then Notificar("❌ Falha ao listar servidores", C.Red, 2); return end
	local ok2, dados = pcall(function() return HttpService:JSONDecode(resp.Body or resp.body) end)
	if not ok2 or not dados or not dados.data then Notificar("❌ Lista inválida", C.Red, 2); return end
	local candidatos = {}
	for _, s in ipairs(dados.data) do
		if s.id ~= game.JobId and s.playing and s.maxPlayers and s.playing < s.maxPlayers - 1 then
			table.insert(candidatos, s.id)
		end
	end
	if #candidatos == 0 then Notificar("⚠️ Nenhum servidor livre", C.Yellow, 2); return end
	QueueReexec()
	Webhook("🌐 Trocando de servidor...")
	pcall(function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, candidatos[math.random(1, #candidatos)], lp)
	end)
end

-- FPS BOOST
local fpsOrig = { parts = {} }
local function AplicarFPS(on)
	if on then
		fpsOrig.shadows = Lighting.GlobalShadows
		pcall(function() fpsOrig.quality = settings().Rendering.QualityLevel end)
		Lighting.GlobalShadows = false
		pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
		fpsOrig.parts = {}
		for _, o in ipairs(workspace:GetDescendants()) do
			if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Smoke") or o:IsA("Fire") or o:IsA("Sparkles") then
				if o.Enabled then
					table.insert(fpsOrig.parts, o)
					o.Enabled = false
				end
			end
		end
	else
		if fpsOrig.shadows ~= nil then Lighting.GlobalShadows = fpsOrig.shadows end
		if fpsOrig.quality then pcall(function() settings().Rendering.QualityLevel = fpsOrig.quality end) end
		for _, o in ipairs(fpsOrig.parts) do
			if o and o.Parent then pcall(function() o.Enabled = true end) end
		end
		fpsOrig.parts = {}
	end
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

-- ═══ FLY CFrame ═══
local function VoarAte(posAlvo, timeout)
	if not posAlvo then return false end
	local hrp = GetHRP()
	local hum = GetHum()
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

	local velFrame = VelFlyEfetiva() * 0.05

	-- FASE 1: voa até 6 studs do alvo
	while tick() - t0 < timeout do
		local h = GetHRP()
		if not h then break end

		local diff = posAlvo - h.Position
		if diff.Magnitude < 6 then break end

		local direcao = diff.Unit
		local novaPos = h.Position + (direcao * velFrame)

		pcall(function()
			h.CFrame = CFrame.new(novaPos)
		end)

		task.wait(0.03)
	end

	-- FASE 2: desce até o chão
	local tChao = tick()
	local ultimaY = nil
	local parado = 0
	while tick() - tChao < 5 do
		local h = GetHRP()
		if not h then break end

		local yAtual = h.Position.Y

		pcall(function()
			h.CFrame = CFrame.new(h.Position - Vector3.new(0, 0.8, 0))
		end)

		if ultimaY then
			if math.abs(yAtual - ultimaY) < 0.05 then
				parado = parado + 1
				if parado >= 5 then break end
			else
				parado = 0
			end
		end
		ultimaY = yAtual

		task.wait(0.05)
	end

	task.wait(0.15)

	for p, v in pairs(colideOriginal) do
		if p and p.Parent then
			pcall(function() p.CanCollide = v end)
		end
	end

	local h = GetHRP()
	if h then
		pcall(function()
			h.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		end)
	end

	return true
end

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
		if diff.Magnitude < distParada then hum:MoveTo(h.Position); return true end
		hum:MoveTo(posAlvo)
		task.wait(0.1)
	end
	return false
end

local function IrPara(posAlvo, timeout)
	if Config.modoVoo then return VoarAte(posAlvo, timeout)
	else return AndarAte(posAlvo, timeout) end
end

local GodModeConns = {}
local ultimaPosSegura = nil
local ultimoReset = 0
local godModeAtivo = true
local gariOn = false
local gariRun = 0
local gariCount = {coletados = 0, entregues = 0}
local setGariAtivoGlobal = nil
local noclipGariAtivo = false
local noclipConnGari = nil

local function AtivarNoclipGari()
	if noclipGariAtivo then return end
	noclipGariAtivo = true
	if noclipConnGari then pcall(function() noclipConnGari:Disconnect() end) end
	noclipConnGari = RunService.Stepped:Connect(function()
		if not noclipGariAtivo then return end
		local c = lp.Character
		if not c then return end
		for _, p in ipairs(c:GetDescendants()) do
			if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
		end
	end)
end

local function DesativarNoclipGari()
	noclipGariAtivo = false
	if noclipConnGari then pcall(function() noclipConnGari:Disconnect() end); noclipConnGari = nil end
end

local function AtivarGodModeNoChar(char)
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	local connLoop = RunService.Heartbeat:Connect(function()
		if not godModeAtivo then return end
		local h = char:FindFirstChildOfClass("Humanoid")
		if not h then return end
		if h.Health > 0 and h.Health < h.MaxHealth then
			h.Health = h.MaxHealth
			Stats.mortesEvitadas = Stats.mortesEvitadas + 1
		end
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
		local vel = hrp.AssemblyLinearVelocity
		local pos = hrp.Position
		if h.FloorMaterial ~= Enum.Material.Air and vel.Y > -10 then
			ultimaPosSegura = pos
			return
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
				Stats.mortesEvitadas = Stats.mortesEvitadas + 1
			end
		end
	end)
	table.insert(GodModeConns, connQueda)

	local connDied = hum.Died:Connect(function()
		if not godModeAtivo then return end
		Stats.mortesEvitadas = Stats.mortesEvitadas + 1
	end)
	table.insert(GodModeConns, connDied)

	local connZero = RunService.Heartbeat:Connect(function()
		if not godModeAtivo then return end
		local h = char:FindFirstChildOfClass("Humanoid")
		if not h then return end
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

local function ReconectarAposMorte()
	if not lp.Character then return end
	task.wait(0.5)
	AtivarGodModeNoChar(lp.Character)
	if gariOn and setGariAtivoGlobal then
		task.wait(0.3)
		pcall(function() setGariAtivoGlobal(false) end)
		task.wait(0.2)
		pcall(function() setGariAtivoGlobal(true) end)
		Webhook("♻️ Personagem renasceu, retomando coleta.")
	end
	AplicarVelocidade()
	Notificar("💀 Morreu — reconectando...", C.Red, 1.5)
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
		task.spawn(ReconectarAposMorte)
	end)
end

local function IniciarScript()

	for _, name in ipairs({"SailentKeyUI", "SailentGari", "SailentFloatBtn"}) do
		local old = CoreGui:FindFirstChild(name)
		if old then pcall(function() old:Destroy() end) end
	end
	task.wait(0.05)

	local SGBtn = Instance.new("ScreenGui")
	SGBtn.Name = "SailentFloatBtn"
	SGBtn.ResetOnSpawn = false
	SGBtn.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SGBtn.IgnoreGuiInset = true
	SGBtn.DisplayOrder = 5
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

	local BtnCorner = Instance.new("UICorner"); BtnCorner.CornerRadius = UDim.new(1, 0); BtnCorner.Parent = FloatBtn
	local BtnStroke = Instance.new("UIStroke"); BtnStroke.Color = C.Purple; BtnStroke.Thickness = 2; BtnStroke.Parent = FloatBtn

	-- indicador de status no botão flutuante (verde = rodando)
	local function AtualizarIndicador()
		Tween(FloatBtn, {BackgroundColor3 = gariOn and C.Green or C.Black}, 0.25)
		BtnStroke.Color = gariOn and C.Green or C.Purple
		BtnStroke.Thickness = gariOn and 3 or 2
	end

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
	SG.Name = "SailentGari"
	SG.ResetOnSpawn = false
	SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SG.IgnoreGuiInset = true
	SG.DisplayOrder = 10
	SG.Parent = CoreGui

	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0, 400, 0, 560)
	Main.Position = UDim2.new(0.5, -200, 0.5, -280)
	Main.BackgroundColor3 = C.BG
	Main.BorderSizePixel = 0
	Main.Parent = SG

	local MC = Instance.new("UICorner"); MC.CornerRadius = UDim.new(0, 14); MC.Parent = Main
	local MS = Instance.new("UIStroke"); MS.Color = C.Accent; MS.Thickness = 1.5; MS.Transparency = 0.3; MS.Parent = Main

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
	local TBC = Instance.new("UICorner"); TBC.CornerRadius = UDim.new(0, 14); TBC.Parent = TB
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
	TTitle.Text = "Auto Gari v" .. KEY_CONFIG.VERSAO .. " [" .. KeyState.nivel:upper() .. "]"
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
	local MinC = Instance.new("UICorner"); MinC.CornerRadius = UDim.new(0, 14); MinC.Parent = MinBtn

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
	local CC = Instance.new("UICorner"); CC.CornerRadius = UDim.new(0, 14); CC.Parent = CloseBtn

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

	local Lay = Instance.new("UIListLayout"); Lay.Padding = UDim.new(0, 8); Lay.Parent = Content

	local function Sec(txt, color)
		local f = Instance.new("Frame")
		f.Size = UDim2.new(1, 0, 0, 26)
		f.BackgroundColor3 = C.Card
		f.BorderSizePixel = 0
		f.Parent = Content
		local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = f
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
		local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = f
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
		local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = b
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
		local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = f
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
		local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(1, 0); bc.Parent = bg
		local k = Instance.new("Frame")
		k.Size = UDim2.new(0, 18, 0, 18)
		k.Position = UDim2.new(0, 2, 0.5, -9)
		k.BackgroundColor3 = C.Text
		k.BorderSizePixel = 0
		k.Parent = bg
		local kc = Instance.new("UICorner"); kc.CornerRadius = UDim.new(1, 0); kc.Parent = k
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
		if st then bg.BackgroundColor3 = C.Green; k.Position = UDim2.new(1, -20, 0.5, -9) end
		local cl = Instance.new("TextButton")
		cl.Text = ""
		cl.BackgroundTransparency = 1
		cl.Size = UDim2.new(1, 0, 1, 0)
		cl.Parent = f
		cl.MouseButton1Click:Connect(function() set(not st) end)
		return set
	end

	-- slider: retorna função para definir o valor por código
	local function CriarSlider(parent, label, min, max, default, callback)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 58)
		frame.BackgroundColor3 = C.Card
		frame.BorderSizePixel = 0
		frame.Parent = parent
		local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(0, 8); fc.Parent = frame

		local titulo = Instance.new("TextLabel")
		titulo.Text = label
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
		local bbc = Instance.new("UICorner"); bbc.CornerRadius = UDim.new(1, 0); bbc.Parent = bgBar

		local fillBar = Instance.new("Frame")
		fillBar.Size = UDim2.new(0, 0, 1, 0)
		fillBar.BackgroundColor3 = C.Green
		fillBar.BorderSizePixel = 0
		fillBar.Parent = bgBar
		local fbc = Instance.new("UICorner"); fbc.CornerRadius = UDim.new(1, 0); fbc.Parent = fillBar

		local knob = Instance.new("Frame")
		knob.Size = UDim2.new(0, 22, 0, 22)
		knob.Position = UDim2.new(0, -11, 0.5, -11)
		knob.BackgroundColor3 = C.Text
		knob.BorderSizePixel = 0
		knob.Parent = bgBar
		local kc = Instance.new("UICorner"); kc.CornerRadius = UDim.new(1, 0); kc.Parent = knob

		local valor = default
		local arrastando = false
		local function Aplicar(percent)
			valor = math.floor(min + (max - min) * percent)
			valorLabel.Text = tostring(valor)
			fillBar.Size = UDim2.new(percent, 0, 1, 0)
			knob.Position = UDim2.new(percent, -11, 0.5, -11)
			if callback then callback(valor) end
		end
		local function Atualizar(posX)
			local bgAbs = bgBar.AbsolutePosition.X
			local bgSize = bgBar.AbsoluteSize.X
			Aplicar(math.clamp((posX - bgAbs) / bgSize, 0, 1))
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
					SalvarConfig()
				end
			end
		end)
		return function(v)
			v = math.clamp(v, min, max)
			Aplicar((v - min) / (max - min))
		end
	end

	local function Campo(label, valorInicial, placeholder, cb)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 62)
		frame.BackgroundColor3 = C.Card
		frame.BorderSizePixel = 0
		frame.Parent = Content
		local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(0, 8); fc.Parent = frame
		local titulo = Instance.new("TextLabel")
		titulo.Text = label
		titulo.Font = Enum.Font.GothamBold
		titulo.TextSize = 12
		titulo.TextColor3 = C.Text
		titulo.BackgroundTransparency = 1
		titulo.Position = UDim2.new(0, 12, 0, 4)
		titulo.Size = UDim2.new(1, -24, 0, 18)
		titulo.TextXAlignment = Enum.TextXAlignment.Left
		titulo.Parent = frame
		local box = Instance.new("TextBox")
		box.Text = valorInicial or ""
		box.PlaceholderText = placeholder or ""
		box.Font = Enum.Font.Code
		box.TextSize = 11
		box.TextColor3 = C.Text
		box.PlaceholderColor3 = Color3.fromRGB(90,90,110)
		box.BackgroundColor3 = C.BG
		box.BorderSizePixel = 0
		box.ClearTextOnFocus = false
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.Position = UDim2.new(0, 12, 0, 26)
		box.Size = UDim2.new(1, -24, 0, 28)
		box.Parent = frame
		local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 6); bc.Parent = box
		local pad = Instance.new("UIPadding"); pad.PaddingLeft = UDim.new(0, 8); pad.Parent = box
		box.Focused:Connect(function() _G.SailentBloquearDrag = true end)
		box.FocusLost:Connect(function()
			_G.SailentBloquearDrag = false
			if cb then cb(box.Text) end
		end)
		return box
	end

	local UI = {} -- setters para perfis / hotkeys
	local PararTudo
	local noclipOn = false
	local noclipConn

	-- ===================== CONTA / ESTATÍSTICAS =====================
	Sec("👤 CONTA: " .. KeyState.nome .. " [" .. KeyState.nivel:upper() .. "]", C.Purple)
	Sec("📊 ESTATÍSTICAS", C.Blue)

	local statTempo = Stat("⏱️ Tempo: 0h 0min", C.Sub)
	local statLixosMin = Stat("📈 Lixos/min: 0", C.Sub)
	local statPerf = Stat("🎮 FPS: -- | Ping: --", C.Sub)
	local statMortes = Stat("🛡️ Mortes evitadas: 0", C.Green)
	local statResumo = Stat(ResumoStats(), C.Text)
	Btn("🔄 Zerar estatísticas", C.Purple, function()
		Stats.coletados, Stats.entregues, Stats.erros, Stats.mortesEvitadas = 0, 0, 0, 0
		Stats.ultimaContagem, Stats.ultimoTempo, Stats.tempoInicio = 0, tick(), tick()
		gariCount.coletados, gariCount.entregues = 0, 0
		Notificar("📊 Estatísticas zeradas", C.Purple, 1.5)
	end)

	Sec("🛡️ GOD MODE (7 camadas)", C.Green)
	local godStatus = Stat("Status: ● ATIVO", C.Green)

	-- ===================== AUTO GARI =====================
	Sec("🗑️ AUTO GARI (noclip embutido)", C.Green)

	local gariStatus = Stat("Status: PARADO", C.Sub)
	local gariStats = Stat("Coletados: 0 | Entregues: 0", C.Sub)
	local gariLixos = Stat("Lixos usados: 0/39", C.Sub)
	local gariProgresso = Stat("Progresso: ░░░░░░░░░░ 0%", C.Sub)

	local function AtualizarProgresso()
		local total = 0
		for _ in pairs(lixosUsados) do total = total + 1 end
		local pct = math.floor((total / 39) * 100)
		pct = math.clamp(pct, 0, 100)
		local cheio = math.floor(pct / 10)
		local vazio = 10 - cheio
		local barra = string.rep("█", cheio) .. string.rep("░", vazio)
		gariProgresso.Text = "Progresso: " .. barra .. " " .. pct .. "%"
		gariLixos.Text = "Lixos usados: " .. total .. "/39"
	end

	local function ErroLoop(err)
		Stats.erros = Stats.erros + 1
		Log("Erro: " .. tostring(err))
		gariStatus.Text = "⚠️ Erro: " .. tostring(err):sub(1, 38)
		gariStatus.TextColor3 = C.Red
		if Stats.erros % 5 == 0 then Webhook("❗ " .. Stats.erros .. " erros na sessão. Último: " .. tostring(err):sub(1, 120)) end
		task.wait(2)
	end

	local function CicloGari(myRun)
		if not GetHRP() then
			gariStatus.Text = "⏳ Aguardando personagem..."
			task.wait(1)
			return
		end
		PausaHumana()
		gariStatus.TextColor3 = C.Green
		if TemLixoNaMao() then
			gariStatus.Text = "📤 Indo pra TRASEIRA..."
			local cam = GetCaminhao()
			if not cam then
				gariStatus.Text = "⚠️ Spawne o caminhão!"
				gariStatus.TextColor3 = C.Yellow
				task.wait(2)
				return
			end
			local traseira = GetTraseira(cam)
			local pos = PosDe(traseira)
			if traseira and pos then
				IrPara(pos, 25)
				if myRun ~= gariRun then return end
				Esp(0.3)
				gariStatus.Text = "📤 Entregando..."
				local prompt = GetPrompt(traseira)
				if prompt then
					pcall(function() fireproximityprompt(prompt) end)
					Esp(0.5)
					if not TemLixoNaMao() then
						gariCount.entregues = gariCount.entregues + 1
						Stats.entregues = Stats.entregues + 1
						TocarSom("entregou")
						Notificar("📤 Lixo entregue!", C.Blue, 1.5)
					end
				end
			else
				gariStatus.Text = "⚠️ Traseira não encontrada"
				task.wait(1.5)
			end
		else
			gariStatus.Text = "📥 Procurando lixo..."
			local lixo = AcharProximoLixo()
			if lixo then
				gariStatus.Text = "📥 Indo pro lixo..."
				IrPara(lixo.Position, 25)
				if myRun ~= gariRun then return end
				Esp(0.3)
				gariStatus.Text = "📥 Coletando..."
				local prompt = GetPrompt(lixo)
				if prompt then
					pcall(function() fireproximityprompt(prompt) end)
					Esp(0.5)
					if TemLixoNaMao() then
						gariCount.coletados = gariCount.coletados + 1
						Stats.coletados = Stats.coletados + 1
						lixosUsados[lixo] = true
						TocarSom("coletou")
						Notificar("📥 Lixo coletado!", C.Green, 1.2)
					end
				end
			else
				gariStatus.Text = "⚠️ Sem lixo disponível"
				task.wait(1.5)
			end
		end
		gariStats.Text = "Coletados: " .. gariCount.coletados .. " | Entregues: " .. gariCount.entregues
		AtualizarProgresso()
		Dbg("ciclo ok | coletados=" .. Stats.coletados .. " entregues=" .. Stats.entregues)
	end

	setGariAtivoGlobal = Toggle("Auto Gari (noclip auto)", Config.autoGari, function(s)
		gariOn = s
		Config.autoGari = s
		SalvarConfig()
		gariRun = gariRun + 1
		AtualizarIndicador()
		if s then
			local myRun = gariRun
			AtivarNoclipGari()
			AplicarVelocidade()
			gariStatus.Text = "Status: ● ATIVO (noclip ON)"
			gariStatus.TextColor3 = C.Green
			Notificar("🗑️ Auto Gari ATIVADO + Noclip", C.Green)
			task.spawn(function()
				while gariOn and myRun == gariRun do
					local ok, err = pcall(CicloGari, myRun)
					if not ok then ErroLoop(err) end
					Esp(0.3)
				end
			end)
		else
			DesativarNoclipGari()
			gariStatus.Text = "Status: PARADO"
			gariStatus.TextColor3 = C.Sub
			Notificar("⏸️ Auto Gari DESATIVADO", C.Yellow, 1.5)
			local hum = GetHum()
			if hum then hum.WalkSpeed = 16 end
		end
	end)
	UI.setGari = setGariAtivoGlobal

	-- ===================== PERFIS =====================
	Sec("📁 PERFIS RÁPIDOS", C.Accent)

	local Perfis = {
		["⚡ Rápido"] = { velocidade = 100, velFly = 100, modoSeguro = false },
		["🛡️ Seguro"] = { velocidade = 30, velFly = 35, modoSeguro = true },
		["🌙 AFK"] = { velocidade = 45, velFly = 40, modoSeguro = true, antiAfk = true, autoReconnect = true },
	}

	local function AplicarPerfil(nome)
		local p = Perfis[nome]
		if not p then return end
		if p.velocidade and UI.setVel then UI.setVel(p.velocidade) end
		if p.velFly and UI.setVelFly then UI.setVelFly(p.velFly) end
		if p.modoSeguro ~= nil and UI.setSeguro then UI.setSeguro(p.modoSeguro) end
		if p.antiAfk ~= nil and UI.setAfk then UI.setAfk(p.antiAfk) end
		if p.autoReconnect ~= nil and UI.setReconnect then UI.setReconnect(p.autoReconnect) end
		SalvarConfig()
		Notificar("📁 Perfil " .. nome .. " aplicado", C.Accent, 1.8)
	end

	for _, nome in ipairs({"⚡ Rápido", "🛡️ Seguro", "🌙 AFK"}) do
		Btn(nome, C.Accent, function() AplicarPerfil(nome) end)
	end

	-- ===================== CONVENIÊNCIA =====================
	Sec("🛡️ CONVENIÊNCIA", C.Blue)
	UI.setSeguro = Toggle("Modo seguro (delays variáveis, vel. limitada)", Config.modoSeguro, function(s)
		Config.modoSeguro = s
		SalvarConfig()
		if gariOn then AplicarVelocidade() end
	end)
	UI.setAfk = Toggle("Anti-AFK", Config.antiAfk, function(s)
		Config.antiAfk = s
		SalvarConfig()
		SetAntiAfk(s)
	end)
	UI.setReconnect = Toggle("Auto-reconectar se cair", Config.autoReconnect, function(s)
		Config.autoReconnect = s
		SalvarConfig()
		if s and KEY_CONFIG.URL_SCRIPT == "" then
			Notificar("⚠️ Defina URL_SCRIPT para reexecutar após reconectar", C.Yellow, 3)
		end
	end)
	Toggle("FPS boost (sem sombras/partículas)", Config.fpsBoost, function(s)
		Config.fpsBoost = s
		SalvarConfig()
		AplicarFPS(s)
	end)
	Btn("🌐 Trocar de servidor (server hop)", C.Blue, function() ServerHop() end)

	-- ===================== WEBHOOK =====================
	Sec("📨 WEBHOOK DISCORD", C.Purple)
	Campo("URL do webhook", Config.webhookUrl, "https://discord.com/api/webhooks/...", function(txt)
		Config.webhookUrl = txt:gsub("%s+", "")
		SalvarConfig()
	end)
	Toggle("Enviar avisos pro Discord", Config.webhookAtivo, function(s)
		Config.webhookAtivo = s
		SalvarConfig()
	end)
	CriarSlider(Content, "⏲ Resumo a cada (min)", 5, 120, Config.webhookMin, function(v)
		Config.webhookMin = v
	end)
	Btn("🧪 Testar webhook", C.Purple, function()
		if Config.webhookUrl == "" then Notificar("⚠️ Cole a URL primeiro", C.Yellow, 2); return end
		Webhook("✅ Teste do Sailent Gari v" .. KEY_CONFIG.VERSAO, true)
		Notificar("📨 Teste enviado", C.Purple, 1.5)
	end)
	Btn("📊 Enviar resumo agora", C.Purple, function()
		Webhook("📊 " .. ResumoStats(), true)
		Notificar("📨 Resumo enviado", C.Purple, 1.5)
	end)

	-- ===================== LOCOMOÇÃO =====================
	Sec("🚁 MODO DE LOCOMOÇÃO", C.Yellow)
	local modoStatus = Stat("Modo atual: 🚶 A PÉ", C.Yellow)

	Btn("🚶 A PÉ (padrão)", C.Green, function()
		Config.modoVoo = false
		modoStatus.Text = "Modo atual: 🚶 A PÉ"
		modoStatus.TextColor3 = C.Green
		SalvarConfig()
		Notificar("🚶 Modo A PÉ ativado", C.Green, 1.5)
	end)

	Btn("🚁 VOAR (fly direto)", C.Blue, function()
		Config.modoVoo = true
		modoStatus.Text = "Modo atual: 🚁 VOANDO"
		modoStatus.TextColor3 = C.Blue
		SalvarConfig()
		Notificar("🚁 Modo VOAR ativado", C.Blue, 1.5)
	end)

	if Config.modoVoo then
		modoStatus.Text = "Modo atual: 🚁 VOANDO"
		modoStatus.TextColor3 = C.Blue
	end

	Sec("⚡ VELOCIDADE (A PÉ)", C.Yellow)
	UI.setVel = CriarSlider(Content, "⚡ Velocidade", 16, 200, Config.velocidade, function(valor)
		Config.velocidade = valor
		AplicarVelocidade()
	end)

	Sec("🚀 VELOCIDADE DE VOO", C.Blue)
	UI.setVelFly = CriarSlider(Content, "🚀 Velocidade voo", 16, 100, Config.velFly or 60, function(valor)
		Config.velFly = valor
	end)

	-- ===================== NOCLIP MANUAL =====================
	Sec("👻 NOCLIP MANUAL", C.Purple)

	Toggle("Noclip manual (extra)", Config.noclip, function(s)
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

	-- ===================== HOTKEYS =====================
	Sec("⌨️ HOTKEYS (clique e aperte a nova tecla)", C.Yellow)
	local aguardandoTecla = nil
	local botoesTecla = {}
	local Acoes = {
		{ cfg = "keyUI", nome = "Abrir/Fechar UI" },
		{ cfg = "keyPanic", nome = "PANIC" },
		{ cfg = "keyGari", nome = "Liga/Desliga Gari" },
		{ cfg = "keyVoo", nome = "Alternar Voo/A pé" },
	}
	for _, a in ipairs(Acoes) do
		local b
		b = Btn(a.nome .. ": " .. tostring(Config[a.cfg]), C.Yellow, function()
			aguardandoTecla = a.cfg
			b.Text = a.nome .. ": aperte uma tecla..."
		end)
		botoesTecla[a.cfg] = { btn = b, nome = a.nome }
	end

	-- ===================== EMERGÊNCIA =====================
	Sec("🚨 EMERGÊNCIA", C.Red)

	PararTudo = function()
		gariOn = false
		gariRun = gariRun + 1
		Config.autoGari = false
		if UI.setGari then UI.setGari(false) end
		noclipOn = false
		DesativarNoclipGari()
		if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
		gariStatus.Text = "Status: PARADO"
		gariStatus.TextColor3 = C.Sub
		local hum = GetHum()
		if hum then hum.WalkSpeed = 16 end
		AtualizarIndicador()
	end

	Btn("🛑 PARAR TUDO", C.Red, function()
		PararTudo()
		Notificar("🛑 Tudo parado!", C.Red, 2)
	end)

	Sec("🐛 DEBUG", C.Yellow)
	Toggle("Modo Debug (log no console)", Config.debug, function(s)
		Config.debug = s
		SalvarConfig()
	end)

	-- ===================== LOOP DE STATS =====================
	task.spawn(function()
		local fpsFrame = 0
		local fpsTime = tick()
		local fps = 60
		while SG.Parent do
			task.wait(1)
			pcall(function()
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
				statMortes.Text = "🛡️ Mortes evitadas: "..Stats.mortesEvitadas
				statResumo.Text = ResumoStats()
				fpsFrame = fpsFrame + 1
				local now = tick()
				if now - fpsTime >= 1 then
					fps = math.floor(fpsFrame / (now - fpsTime))
					fpsFrame = 0
					fpsTime = now
				end
				local ping = 0
				pcall(function() ping = math.floor(lp:GetNetworkPing() * 1000) end)
				statPerf.Text = "🎮 FPS: "..fps.." | Ping: "..ping.."ms"
			end)
		end
	end)

	-- ===================== ABRIR / FECHAR =====================
	local uiAberta = true

	local function FecharUI()
		uiAberta = false
		Tween(Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
		task.wait(0.2)
		Main.Visible = false
		FloatBtn.Text = "⚡"
		if not gariOn then Tween(FloatBtn, {BackgroundColor3 = C.Black}, 0.15) end
	end

	local function AbrirUI()
		uiAberta = true
		Main.Visible = true
		Main.Size = UDim2.new(0, 0, 0, 0)
		Tween(Main, {Size = UDim2.new(0, 400, 0, 560)}, 0.25)
		FloatBtn.Text = "✕"
		if not gariOn then Tween(FloatBtn, {BackgroundColor3 = C.Red}, 0.15) end
	end

	FloatBtn.MouseButton1Click:Connect(function()
		if btnMoveuSe then return end
		if uiAberta then FecharUI() else AbrirUI() end
	end)

	UserInput.InputBegan:Connect(function(input, gp)
		-- redefinir tecla
		if aguardandoTecla and input.UserInputType == Enum.UserInputType.Keyboard then
			local cfg = aguardandoTecla
			aguardandoTecla = nil
			if input.KeyCode ~= Enum.KeyCode.Escape then
				Config[cfg] = input.KeyCode.Name
				SalvarConfig()
			end
			local info = botoesTecla[cfg]
			if info then info.btn.Text = info.nome .. ": " .. tostring(Config[cfg]) end
			return
		end
		if gp then return end
		if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
		local nome = input.KeyCode.Name
		if nome == Config.keyUI then
			if uiAberta then FecharUI() else AbrirUI() end
		elseif nome == Config.keyPanic then
			PararTudo()
			FecharUI()
			Notificar("🚨 PANIC — Tudo parado", C.Red, 2)
		elseif nome == Config.keyGari then
			UI.setGari(not gariOn)
		elseif nome == Config.keyVoo then
			Config.modoVoo = not Config.modoVoo
			if Config.modoVoo then
				modoStatus.Text = "Modo atual: 🚁 VOANDO"
				modoStatus.TextColor3 = C.Blue
				Notificar("🚁 VOAR ativado (tecla " .. Config.keyVoo .. ")", C.Blue, 1.5)
			else
				modoStatus.Text = "Modo atual: 🚶 A PÉ"
				modoStatus.TextColor3 = C.Green
				Notificar("🚶 A PÉ ativado (tecla " .. Config.keyVoo .. ")", C.Green, 1.5)
			end
			SalvarConfig()
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

	CloseBtn.MouseButton1Click:Connect(function() FecharUI() end)

	-- ===================== ANTI-ADMIN =====================
	local function ChecarAdmins()
		if not Config.antiAdmin then return end
		local admins = {"admin", "mod", "owner", "staff", "adm", "moderator"}
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= lp then
				local nome = p.Name:lower()
				for _, kw in ipairs(admins) do
					if nome:find(kw) then
						if gariOn then
							PararTudo()
							Log("🚨 ADMIN DETECTADO: " .. p.Name)
							Notificar("🚨 Admin: "..p.Name, C.Red, 3)
							Webhook("🚨 Admin detectado no servidor: " .. p.Name .. ". Automação parada.")
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
			pcall(ChecarAdmins)
		end
	end)

	-- ===================== SERVIÇOS EM SEGUNDO PLANO =====================
	SetAntiAfk(Config.antiAfk)
	IniciarAutoReconnect()
	if Config.fpsBoost then AplicarFPS(true) end

	-- resumo periódico no Discord
	task.spawn(function()
		local ultimo = tick()
		while SG.Parent do
			task.wait(5)
			if Config.webhookAtivo and Config.webhookUrl ~= "" and tick() - ultimo >= Config.webhookMin * 60 then
				ultimo = tick()
				Webhook("📊 " .. ResumoStats())
			end
		end
	end)

	-- revalida a key periodicamente (derruba se revogada/expirada)
	task.spawn(function()
		while SG.Parent do
			task.wait(KEY_CONFIG.REVALIDAR_SEG)
			if not SG.Parent then break end
			local ok, res, erroRede = ValidarKey(KeyState.key)
			if not ok and not erroRede then
				PararTudo()
				LimparKeyLocal()
				Notificar("🚫 Key revogada/expirada: " .. tostring(res), C.Red, 5)
				Webhook("🚫 Key invalidada durante o uso: " .. tostring(res))
				task.wait(3)
				pcall(function() SG:Destroy() end)
				pcall(function() SGBtn:Destroy() end)
				break
			end
		end
	end)

	AtivarGodMode()
	godStatus.Text = "Status: ● ATIVO (7 camadas)"
	godStatus.TextColor3 = C.Green
	Notificar("🛡️ God Mode ATIVADO (7 camadas)", C.Green, 2)

	-- se estava ligado quando fechou, religa (o toggle salvo agora realmente inicia)
	if Config.autoGari then UI.setGari(true) end
	AtualizarIndicador()

	Log("═══════════════════════════════════")
	Log("🗑️ Sailent Auto Gari v" .. KEY_CONFIG.VERSAO .. " [FLY CFrame]")
	Log("👤 " .. KeyState.nome .. " | " .. KeyState.nivel:upper())
	Log("🛡️ God Mode: 7 camadas ativas")
	Log("🚁 Modo: " .. (Config.modoVoo and "VOAR" or "A PÉ"))
	Log("⌨️ UI=" .. Config.keyUI .. " | Panic=" .. Config.keyPanic .. " | Gari=" .. Config.keyGari .. " | Voo=" .. Config.keyVoo)
	Log("═══════════════════════════════════")
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

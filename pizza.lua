-- ============================================================
-- SAILENT AUTO PIZZA v3.2 — VOO ANTI-LIMBO + Region3 CORRIGIDO
-- Sobe 25 studs antes da água + nunca desce + anti-cair
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

local _ultimoVoo = 0
local _suspenderTudo = false
local _avisosAnticheat = 0

local KEY_CONFIG = {
	URL_KEYS = "https://raw.githubusercontent.com/simiao64santos-dot/sailent-/refs/heads/main/keys.json",
	ARQUIVO_CACHE = "sailent_gari_key.txt",
	NOME_SCRIPT = "Sailent Auto Pizza v3.2",
	URL_SCRIPT = "https://raw.githubusercontent.com/simiao64santos-dot/sailent-/refs/heads/main/pizza.lua",
	VERSAO = "3.2",
	REVALIDAR_SEG = 1800,
}

pcall(function()
	for _, name in ipairs({"SailentPizza", "SailentFloatBtn", "SailentKeyUI", "SailentToast"}) do
		local old = CoreGui:FindFirstChild(name)
		if old then old:Destroy() end
	end
end)

local C = {
	BG = Color3.fromRGB(12,12,18), Card = Color3.fromRGB(25,25,35),
	Accent = Color3.fromRGB(255,200,80), Text = Color3.fromRGB(240,240,245),
	Sub = Color3.fromRGB(150,150,165), Green = Color3.fromRGB(80,220,120),
	Red = Color3.fromRGB(230,70,80), Yellow = Color3.fromRGB(255,200,80),
	Blue = Color3.fromRGB(80,160,240), Purple = Color3.fromRGB(180,120,255),
	Black = Color3.fromRGB(10, 10, 15),
}

local function Tween(o, p, t)
	if not o or not o.Parent then return end
	local tw = TweenService:Create(o, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint), p)
	tw:Play()
	return tw
end

local function Log(msg) print("[Pizza] " .. tostring(msg)) end

local function GetHttp()
	return (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
end

-- SHA-256
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
	local bitLen = #msg * 8
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

-- TOAST
local SGBToast = Instance.new("ScreenGui")
SGBToast.Name = "SailentToast"; SGBToast.ResetOnSpawn = false
SGBToast.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SGBToast.IgnoreGuiInset = true; SGBToast.DisplayOrder = 999; SGBToast.Parent = CoreGui

local toastContainer = Instance.new("Frame")
toastContainer.Size = UDim2.new(0, 300, 1, 0)
toastContainer.Position = UDim2.new(1, -320, 0, 0)
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
	t.TextColor3 = C.Black; t.BackgroundColor3 = cor
	t.BackgroundTransparency = 1; t.TextTransparency = 1
	t.Size = UDim2.new(1, 0, 0, 34); t.TextWrapped = true
	t.LayoutOrder = toastCounter; t.Parent = toastContainer
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

task.spawn(function()
	pcall(function()
		local chat = lp.PlayerGui:WaitForChild("Chat", 10)
		if not chat then return end
		local frame = chat:FindFirstChild("Frame") or chat
		frame.ChildAdded:Connect(function(msg)
			local texto = ""
			pcall(function() texto = (msg.Text or ""):lower() end)
			if texto:find("fly") or texto:find("voar") or texto:find("ban") or texto:find("kick")
			   or texto:find("suspicious") or texto:find("hack") or texto:find("cheat")
			   or texto:find("detect") or texto:find("exploit") then
				_avisosAnticheat = _avisosAnticheat + 1
				Log("⚠️ AVISO ANTICHEAT: " .. texto)
				Notificar("⚠️ Anticheat! Pausando 60s", C.Red, 5)
				_suspenderTudo = true
				task.wait(60)
				_suspenderTudo = false
				Notificar("✅ Voo reativado", C.Green, 3)
			end
		end)
	end)
end)

-- LOGIN
local function MostrarUILogin(callbackSucesso)
	local SGK = Instance.new("ScreenGui")
	SGK.Name = "SailentKeyUI"; SGK.ResetOnSpawn = false
	SGK.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SGK.IgnoreGuiInset = true; SGK.DisplayOrder = 999; SGK.Parent = CoreGui

	local BG = Instance.new("Frame")
	BG.Size = UDim2.new(1, 0, 1, 0); BG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	BG.BackgroundTransparency = 0.4; BG.BorderSizePixel = 0; BG.Parent = SGK

	local Box = Instance.new("Frame")
	Box.Size = UDim2.new(0, 380, 0, 340); Box.Position = UDim2.new(0.5, -190, 0.5, -170)
	Box.BackgroundColor3 = C.BG; Box.BorderSizePixel = 0; Box.Parent = SGK
	local BC = Instance.new("UICorner"); BC.CornerRadius = UDim.new(0, 14); BC.Parent = Box
	local BS = Instance.new("UIStroke"); BS.Color = C.Accent; BS.Thickness = 2; BS.Parent = Box

	local Title = Instance.new("TextLabel")
	Title.Text = "🍕 SAILENT PIZZA — AUTH"
	Title.Font = Enum.Font.GothamBold; Title.TextSize = 18; Title.TextColor3 = C.Accent
	Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 0, 0, 18)
	Title.Size = UDim2.new(1, 0, 0, 26); Title.Parent = Box

	local Sub = Instance.new("TextLabel")
	Sub.Text = "Cole sua key para liberar o script"; Sub.Font = Enum.Font.Gotham
	Sub.TextSize = 12; Sub.TextColor3 = C.Sub; Sub.BackgroundTransparency = 1
	Sub.Position = UDim2.new(0, 0, 0, 48); Sub.Size = UDim2.new(1, 0, 0, 18); Sub.Parent = Box

	local hwidLbl = Instance.new("TextLabel")
	hwidLbl.Text = "HWID: " .. GetHWID():sub(1, 26) .. "..."
	hwidLbl.Font = Enum.Font.Code; hwidLbl.TextSize = 10
	hwidLbl.TextColor3 = Color3.fromRGB(100,100,120); hwidLbl.BackgroundTransparency = 1
	hwidLbl.Position = UDim2.new(0, 0, 0, 68); hwidLbl.Size = UDim2.new(1, 0, 0, 14); hwidLbl.Parent = Box

	local Input = Instance.new("TextBox")
	Input.PlaceholderText = "SAILENT-XXXX-XXXX-XXXX"; Input.Font = Enum.Font.Code
	Input.TextSize = 13; Input.TextColor3 = C.Text; Input.PlaceholderColor3 = Color3.fromRGB(90,90,110)
	Input.BackgroundColor3 = C.Card; Input.BorderSizePixel = 0; Input.ClearTextOnFocus = false
	Input.Text = ""; Input.Position = UDim2.new(0, 20, 0, 100); Input.Size = UDim2.new(1, -40, 0, 42); Input.Parent = Box
	local IC = Instance.new("UICorner"); IC.CornerRadius = UDim.new(0, 8); IC.Parent = Input
	local IS = Instance.new("UIStroke"); IS.Color = Color3.fromRGB(50,50,70); IS.Thickness = 1; IS.Parent = Input

	local Status = Instance.new("TextLabel")
	Status.Text = ""; Status.Font = Enum.Font.GothamBold; Status.TextSize = 11
	Status.TextColor3 = C.Red; Status.BackgroundTransparency = 1
	Status.Position = UDim2.new(0, 20, 0, 150); Status.Size = UDim2.new(1, -40, 0, 40)
	Status.TextWrapped = true; Status.TextYAlignment = Enum.TextYAlignment.Top; Status.Parent = Box

	local BtnValidar = Instance.new("TextButton")
	BtnValidar.Text = "✅ VALIDAR KEY"; BtnValidar.Font = Enum.Font.GothamBold
	BtnValidar.TextSize = 14; BtnValidar.TextColor3 = C.Black; BtnValidar.BackgroundColor3 = C.Green
	BtnValidar.BorderSizePixel = 0; BtnValidar.Position = UDim2.new(0, 20, 0, 200)
	BtnValidar.Size = UDim2.new(1, -40, 0, 46); BtnValidar.Parent = Box
	local BtnC = Instance.new("UICorner"); BtnC.CornerRadius = UDim.new(0, 8); BtnC.Parent = BtnValidar

	local BtnLimpar = Instance.new("TextButton")
	BtnLimpar.Text = "🗑️ Limpar key salva"; BtnLimpar.Font = Enum.Font.Gotham
	BtnLimpar.TextSize = 10; BtnLimpar.TextColor3 = Color3.fromRGB(120,120,140)
	BtnLimpar.BackgroundTransparency = 1; BtnLimpar.Position = UDim2.new(0, 20, 0, 300)
	BtnLimpar.Size = UDim2.new(1, -40, 0, 20); BtnLimpar.Parent = Box

	local function SucessoLogin()
		Status.Text = "✅ Bem-vindo, " .. KeyState.nome .. "!"
		Status.TextColor3 = C.Green; BtnValidar.Text = "✅ SUCESSO!"
		task.wait(0.3); pcall(function() SGK:Destroy() end)
		task.wait(0.1); callbackSucesso()
	end

	task.spawn(function()
		task.wait(0.2)
		local k = CarregarKeyLocal()
		if k and k ~= "" then
			Input.Text = k; Status.Text = "🔄 Verificando key salva..."; Status.TextColor3 = C.Yellow
			local ok, res = ValidarKey(k)
			if ok then SucessoLogin() else
				Status.Text = "❌ " .. tostring(res); Status.TextColor3 = C.Red; LimparKeyLocal()
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
				Status.Text = "❌ " .. tostring(res); Status.TextColor3 = C.Red
				BtnValidar.Text = "✅ VALIDAR KEY"; BtnValidar.BackgroundColor3 = C.Green
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

local CONFIG_FILE = "sailent_pizza_config.txt"
local Config = {
	velocidade = 100,
	velFly = 40,
	autoEntregar = false,
	antiAfk = true,
	autoReconnect = false,
	modoSeguro = false,
	fpsBoost = false,
	keyUI = "F2",
	keyPanic = "F1",
	keyEntregar = "F3",
	travarCamera = true,
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
end

CarregarConfig()

local Stats = { entregues = 0, pegos = 0, erros = 0, inicio = tick() }

local function FmtTempo(seg)
	seg = math.floor(seg)
	return string.format("%02d:%02d:%02d", math.floor(seg / 3600), math.floor(seg % 3600 / 60), seg % 60)
end

local function ResumoStats()
	local dec = tick() - Stats.inicio
	local horas = math.max(dec / 3600, 1 / 60)
	local porHora = math.floor(Stats.entregues / horas)
	local media = Stats.entregues > 0 and math.floor(dec / Stats.entregues) or 0
	return string.format("⏱ %s | 📦 %d | 📈 %d/h | ⌀ %ds", FmtTempo(dec), Stats.entregues, porHora, media)
end

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
	if Config.modoSeguro then return math.min(Config.velFly or 40, 35) end
	return Config.velFly or 40
end

local function AplicarVelocidade()
	local hum = GetHum()
	if hum then hum.WalkSpeed = VelEfetiva() end
end

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

local function QueueReexec()
	if KEY_CONFIG.URL_SCRIPT ~= "" and queue_on_teleport then
		pcall(function()
			queue_on_teleport('loadstring(game:HttpGet("' .. KEY_CONFIG.URL_SCRIPT .. '"))()')
		end)
	end
end

local function IniciarAutoReconnect()
	task.spawn(function()
		pcall(function()
			local prompt = CoreGui:WaitForChild("RobloxPromptGui", 15)
			local overlay = prompt and prompt:WaitForChild("promptOverlay", 15)
			if not overlay then return end
			overlay.ChildAdded:Connect(function(c)
				if c.Name == "ErrorPrompt" and Config.autoReconnect then
					Log("Desconectado — reconectando...")
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
	if not ok or not resp then Notificar("❌ Falha ao listar", C.Red, 2); return end
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
	pcall(function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, candidatos[math.random(1, #candidatos)], lp)
	end)
end

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

local function AcharPromptPorTexto(txt)
	local hrp = GetHRP()
	if not hrp then return nil end
	local maisPerto, menorDist = nil, math.huge
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("ProximityPrompt") then
			if obj.ActionText and obj.ActionText:lower():find(txt:lower()) then
				local pos = PosDe(obj.Parent)
				if pos then
					local dist = (pos - hrp.Position).Magnitude
					if dist < menorDist then
						menorDist = dist
						maisPerto = obj
					end
				end
			end
		end
	end
	return maisPerto
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
			local pos = PosDe(marcado)
			if pos then
				return {marcado = marcado, pos = pos, pad = pad}
			end
		end
	end
	return nil
end

-- CACHE ÁGUA/AREIA
local _aguaCache = {}
local _areiaCache = {}
local _ultimoScanCache = 0

local function AtualizarCacheAguaAreia()
	local agora = tick()
	if agora - _ultimoScanCache < 3 then return end
	_ultimoScanCache = agora
	_aguaCache = {}
	_areiaCache = {}
	local complementos = workspace:FindFirstChild("Complementos")
	if complementos then
		local aguas = complementos:FindFirstChild("Aguas")
		if aguas then
			for _, obj in ipairs(aguas:GetChildren()) do
				if obj:IsA("BasePart") then table.insert(_aguaCache, obj) end
			end
		end
	end
	if #_aguaCache == 0 then
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") then
				local n = obj.Name:lower()
				if n == "water" or n == "agua" or n == "água" then
					table.insert(_aguaCache, obj)
				end
			end
		end
	end
	for _, pastaNome in ipairs({"Areias", "AreiasPraia"}) do
		local pasta = workspace:FindFirstChild(pastaNome)
		if pasta then
			for _, obj in ipairs(pasta:GetChildren()) do
				if obj:IsA("BasePart") then table.insert(_areiaCache, obj) end
			end
		end
	end
end

local function DetectarAguaPorPart(pos, raio)
	raio = raio or 15
	AtualizarCacheAguaAreia()
	local maisPerto, menorDist, yAgua = nil, math.huge, nil
	for _, part in ipairs(_aguaCache) do
		if part and part.Parent then
			local p = part.Position
			local dist = (Vector3.new(p.X, 0, p.Z) - Vector3.new(pos.X, 0, pos.Z)).Magnitude
			local tamanho = part.Size
			local distReal = math.max(0, dist - math.max(tamanho.X, tamanho.Z) * 0.5)
			if distReal < raio and distReal < menorDist then
				menorDist = distReal; maisPerto = part; yAgua = p.Y
			end
		end
	end
	if maisPerto then return true, yAgua or (pos.Y - 5), menorDist end
	return false, nil, nil
end

local function DetectarAreia(pos, raio)
	raio = raio or 12
	AtualizarCacheAguaAreia()
	for _, part in ipairs(_areiaCache) do
		if part and part.Parent then
			local p = part.Position
			local dist = (Vector3.new(p.X, 0, p.Z) - Vector3.new(pos.X, 0, pos.Z)).Magnitude
			local tamanho = part.Size
			local distReal = math.max(0, dist - math.max(tamanho.X, tamanho.Z) * 0.5)
			if distReal < raio then return true, distReal end
		end
	end
	return false, nil
end

-- ⭐ DETECÇÃO ULTRA-FORTE (v3.2 — Region3 CORRIGIDO)
local function DetectarAguaForte(pos, raioBaixo, raioLonge, raioPerimetro)
	raioBaixo = raioBaixo or 30
	raioLonge = raioLonge or 8
	raioPerimetro = raioPerimetro or 15

	local temAgua, yAgua = DetectarAguaPorPart(pos, raioPerimetro)
	if temAgua then return true, yAgua end

	local hum = GetHum()
	local hrp = GetHRP()
	if hum and hrp and (hrp.Position - pos).Magnitude < 15 then
		if hum.FloorMaterial == Enum.Material.Water then
			return true, hrp.Position.Y
		end
	end

	-- ⭐ Region3 CORRIGIDO (garante min < max)
	local ok, material = pcall(function()
		local minY = pos.Y - raioBaixo
		local maxY = pos.Y + raioLonge
		if minY > maxY then minY, maxY = maxY, minY end

		local cantoA = Vector3.new(pos.X - 8, minY, pos.Z - 8)
		local cantoB = Vector3.new(pos.X + 8, maxY, pos.Z + 8)

		if (cantoB.X - cantoA.X) <= 0 or (cantoB.Y - cantoA.Y) <= 0 or (cantoB.Z - cantoA.Z) <= 0 then
			return false
		end

		local region = Region3.new(cantoA, cantoB):ExpandToGrid(4)
		local materiais = workspace.Terrain:ReadVoxels(region, 4)
		for x = 1, materiais.Size.X do
			for y = 1, materiais.Size.Y do
				for z = 1, materiais.Size.Z do
					if materiais[x][y][z] == Enum.Material.Water then
						return true
					end
				end
			end
		end
		return false
	end)

	if ok and material then return true, pos.Y - 5 end
	return false, nil
end

local function TemAguaNoCaminho(posA, posB)
	local distancia = (Vector3.new(posB.X, 0, posB.Z) - Vector3.new(posA.X, 0, posA.Z)).Magnitude
	local passos = math.max(8, math.floor(distancia / 5))
	local primeiroPontoAgua = nil
	local ultimoPontoAgua = nil

	for i = 1, passos do
		local t = i / passos
		local ponto = posA:Lerp(Vector3.new(posB.X, posA.Y, posB.Z), t)
		local temAgua = DetectarAguaPorPart(ponto, 12)
		if temAgua then
			if not primeiroPontoAgua then primeiroPontoAgua = ponto end
			ultimoPontoAgua = ponto
		end
	end

	if DetectarAguaPorPart(posB, 12) then
		if not primeiroPontoAgua then primeiroPontoAgua = posB end
		ultimoPontoAgua = posB
	end

	if primeiroPontoAgua then
		return true, primeiroPontoAgua, ultimoPontoAgua
	end
	return false, nil, nil
end

local function PrecisoVoar(posAlvo)
	local hrp = GetHRP()
	if not hrp then return false, "nochar" end
	if posAlvo.Y - hrp.Position.Y > 12 then return true, "alvo_alto" end
	if DetectarAguaPorPart(hrp.Position, 15) then return true, "agua_atual" end
	if DetectarAreia(hrp.Position, 12) then return true, "areia_atual" end
	local perigo, tipo = TemAguaNoCaminho(hrp.Position, posAlvo)
	if perigo then return true, tipo end
	return false, "chao"
end

-- CÂMERA
local _cameraConn = nil
local function TravarCameraNoAlvo(posAlvo)
	if not Config.travarCamera then return end
	local camera = workspace.CurrentCamera
	if not camera then return end
	if _cameraConn then pcall(function() _cameraConn:Disconnect() end); _cameraConn = nil end
	camera.CameraType = Enum.CameraType.Scriptable
	_cameraConn = RunService.RenderStepped:Connect(function()
		local hrp = GetHRP()
		if not hrp then return end
		local alvoPos = Vector3.new(posAlvo.X, posAlvo.Y + 3, posAlvo.Z)
		local origem = hrp.Position + Vector3.new(0, 8, 0)
		local dir = (alvoPos - origem).Unit
		local camPos = origem - dir * 12 + Vector3.new(0, 4, 0)
		camera.CFrame = CFrame.new(camPos, alvoPos)
	end)
end

local function DestravarCamera()
	if _cameraConn then pcall(function() _cameraConn:Disconnect() end); _cameraConn = nil end
	local camera = workspace.CurrentCamera
	if camera then
		camera.CameraType = Enum.CameraType.Custom
		local hum = GetHum()
		if hum then camera.CameraSubject = hum end
	end
end

-- ⭐ VOO STEALTH v3.2 — Passa POR CIMA da água
local function VooStealth(posAlvo, timeout)
	if not posAlvo then return false end
	if _suspenderTudo then return false end
	if tick() - _ultimoVoo < 2 then return false end

	local hrp = GetHRP(); local hum = GetHum()
	if not hrp or not hum then return false end

	local posInicial = hrp.Position
	local temAgua, pontoEntrada, pontoSaida = TemAguaNoCaminho(posInicial, posAlvo)
	local diffY = posAlvo.Y - posInicial.Y
	local alvoAlto = diffY > 12

	if not temAgua and not alvoAlto then return false end

	_ultimoVoo = tick()
	timeout = timeout or 40

	local alturaVoo
	if alvoAlto then
		alturaVoo = posAlvo.Y + 5
	else
		alturaVoo = posInicial.Y + 25
	end

	local distTotal = (Vector3.new(posAlvo.X, 0, posAlvo.Z) - Vector3.new(posInicial.X, 0, posInicial.Z)).Magnitude
	if distTotal < 20 then return false end

	local velBase = math.min(VelFlyEfetiva(), 45)
	local velAtual = velBase + math.random(-3, 3)

	local humProps = {
		WalkSpeed = hum.WalkSpeed,
		AutoRotate = hum.AutoRotate,
		PlatformStand = hum.PlatformStand,
	}

	pcall(function()
		hum.AutoRotate = true
		hum.WalkSpeed = 0
		hum:ChangeState(Enum.HumanoidStateType.Physics)
	end)

	local bv = Instance.new("BodyVelocity")
	bv.Name = "SailentBV_" .. math.random(10000, 99999)
	bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bv.Velocity = Vector3.new(0, 0, 0)
	bv.P = 3000
	bv.Parent = hrp

	local bg = Instance.new("BodyGyro")
	bg.Name = "SailentBG_" .. math.random(10000, 99999)
	bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	bg.P = 5000
	bg.D = 500
	bg.CFrame = hrp.CFrame
	bg.Parent = hrp

	local function LimparTudo()
		if bv and bv.Parent then pcall(function() bv:Destroy() end) end
		if bg and bg.Parent then pcall(function() bg:Destroy() end) end
	end

	-- FASE 1: SOBE 25 studs
	local t0 = tick()
	while tick() - t0 < 5 do
		local h = GetHRP()
		if not h or not h.Parent then break end
		local diffAltura = alturaVoo - h.Position.Y
		if diffAltura <= 1 then break end
		local velSubida = math.min(20, diffAltura * 3)
		bv.Velocity = Vector3.new(0, velSubida, 0)
		pcall(function() h.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end)
		task.wait(0.04)
	end

	-- FASE 2: VOO RETO
	local chegou = false
	local ultimaDist = distTotal
	local ultimoDir = Vector3.new(0, 0, -1)

	while tick() - t0 < timeout do
		local h = GetHRP()
		if not h or not h.Parent then break end

		local posAtual = h.Position
		local dirH = Vector3.new(posAlvo.X - posAtual.X, 0, posAlvo.Z - posAtual.Z)
		local distH = dirH.Magnitude

		if distH < 6 then chegou = true; break end
		if distH > ultimaDist + 3 then chegou = true; break end
		ultimaDist = distH

		local dirUnit = dirH.Unit
		ultimoDir = dirUnit

		local yAlvo = alturaVoo

		local temAguaAgora, nivelAgua = DetectarAguaForte(posAtual, 40, 8, 15)
		if temAguaAgora and nivelAgua then
			yAlvo = math.max(alturaVoo, nivelAgua + 20)
		end

		if posAtual.Y < alturaVoo - 8 then
			pcall(function()
				h.CFrame = CFrame.new(Vector3.new(posAtual.X, alturaVoo, posAtual.Z))
				h.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			end)
		end

		velAtual = velBase + math.random(-3, 3)
		if distH < 20 then velAtual = velAtual * 0.7 end
		if distH < 12 then velAtual = velAtual * 0.5 end

		local velY = math.clamp((yAlvo - posAtual.Y) * 3, -4, 10)
		bv.Velocity = Vector3.new(dirUnit.X * velAtual, velY, dirUnit.Z * velAtual)

		pcall(function()
			local look = CFrame.new(posAtual, Vector3.new(posAlvo.X, posAtual.Y, posAlvo.Z))
			bg.CFrame = look
		end)

		if _suspenderTudo then
			bv.Velocity = Vector3.new(0, 0, 0)
			break
		end

		task.wait(0.04)
	end

	-- FASE 3: DESCE
	bv.Velocity = Vector3.new(0, 0, 0)
	task.wait(0.15)

	local tDesce = tick()
	while tick() - tDesce < 5 do
		local h = GetHRP()
		if not h or not h.Parent then break end

		local temAguaAbaixo = DetectarAguaForte(h.Position, 12, 3, 8)
		if temAguaAbaixo then
			bv.Velocity = Vector3.new(ultimoDir.X * 15, 0, ultimoDir.Z * 15)
			task.wait(0.1)
			break
		end

		local diffY2 = h.Position.Y - (posAlvo.Y + 3)
		if diffY2 <= 0.5 then break end

		bv.Velocity = Vector3.new(0, -math.min(10, diffY2 * 3), 0)
		task.wait(0.04)
	end

	bv.Velocity = Vector3.new(0, 0, 0)
	task.wait(0.2)

	LimparTudo()

	pcall(function()
		hum.WalkSpeed = humProps.WalkSpeed or 100
		hum.AutoRotate = humProps.AutoRotate ~= false
		hum.PlatformStand = false
		hum:ChangeState(Enum.HumanoidStateType.Running)
	end)

	local h = GetHRP()
	if h then pcall(function() h.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end) end

	return chegou
end

local function AndarAte(posAlvo, timeout, distParada)
	if not posAlvo then return false end
	local hrp = GetHRP(); local hum = GetHum()
	if not hrp or not hum then return false end
	timeout = timeout or 30; distParada = distParada or 4
	local t0 = tick(); hum:MoveTo(posAlvo)
	while tick() - t0 < timeout do
		local h = GetHRP(); if not h then return false end
		local diff = Vector3.new(h.Position.X - posAlvo.X, 0, h.Position.Z - posAlvo.Z)
		if diff.Magnitude < distParada then hum:MoveTo(h.Position); return true end
		hum:MoveTo(posAlvo); task.wait(0.1)
	end
	return false
end

local function IrPara(posAlvo, timeout)
	if not posAlvo then return false end
	if _suspenderTudo then return AndarAte(posAlvo, timeout) end
	local precisa = PrecisoVoar(posAlvo)
	if precisa then
		if VooStealth(posAlvo, timeout) then return true end
		return AndarAte(posAlvo, timeout)
	end
	return AndarAte(posAlvo, timeout)
end

local function TemPizza()
	local doce = workspace:FindFirstChild(lp.Name)
	if doce then return doce:FindFirstChild("PizzaTemplate") ~= nil end
	return false
end

-- GOD MODE
local GodModeConns = {}
local ultimaPosSegura = nil; local ultimoReset = 0
local godModeAtivo = true

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

-- UI
local function IniciarScript()

	for _, name in ipairs({"SailentKeyUI", "SailentPizza", "SailentFloatBtn"}) do
		local old = CoreGui:FindFirstChild(name)
		if old then pcall(function() old:Destroy() end) end
	end
	task.wait(0.05)

	local SGBtn = Instance.new("ScreenGui")
	SGBtn.Name = "SailentFloatBtn"; SGBtn.ResetOnSpawn = false
	SGBtn.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SGBtn.IgnoreGuiInset = true; SGBtn.DisplayOrder = 5; SGBtn.Parent = CoreGui

	local FloatBtn = Instance.new("TextButton")
	FloatBtn.Text = "🍕"; FloatBtn.Font = Enum.Font.GothamBold; FloatBtn.TextSize = 26
	FloatBtn.TextColor3 = Color3.fromRGB(255, 255, 255); FloatBtn.BackgroundColor3 = C.Black
	FloatBtn.BorderSizePixel = 0; FloatBtn.Size = UDim2.new(0, 60, 0, 60)
	FloatBtn.Position = UDim2.new(0, 20, 0.5, -30); FloatBtn.AutoButtonColor = false
	FloatBtn.Active = true; FloatBtn.Parent = SGBtn

	local BtnCorner = Instance.new("UICorner"); BtnCorner.CornerRadius = UDim.new(1, 0); BtnCorner.Parent = FloatBtn
	local BtnStroke = Instance.new("UIStroke"); BtnStroke.Color = C.Accent; BtnStroke.Thickness = 2; BtnStroke.Parent = FloatBtn

	local function AtualizarIndicador()
		local rodando = Config.autoEntregar
		Tween(FloatBtn, {BackgroundColor3 = rodando and C.Green or C.Black}, 0.25)
		BtnStroke.Color = rodando and C.Green or C.Accent
		BtnStroke.Thickness = rodando and 3 or 2
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
	SG.Name = "SailentPizza"; SG.ResetOnSpawn = false
	SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SG.IgnoreGuiInset = true; SG.DisplayOrder = 10; SG.Parent = CoreGui

	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0, 400, 0, 560); Main.Position = UDim2.new(0.5, -200, 0.5, -280)
	Main.BackgroundColor3 = C.BG; Main.BorderSizePixel = 0; Main.Parent = SG

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
			if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
		end)
		UserInput.InputChanged:Connect(function(i)
			if i == di and d then up(i) end
		end)
	end

	local TB = Instance.new("Frame")
	TB.Size = UDim2.new(1, 0, 0, 56); TB.BackgroundColor3 = C.Card
	TB.BorderSizePixel = 0; TB.Parent = Main
	local TBC = Instance.new("UICorner"); TBC.CornerRadius = UDim.new(0, 14); TBC.Parent = TB
	local TBov = Instance.new("Frame")
	TBov.Size = UDim2.new(1, 0, 0, 14); TBov.Position = UDim2.new(0, 0, 1, -14)
	TBov.BackgroundColor3 = C.Card; TBov.BorderSizePixel = 0; TBov.Parent = TB

	local TLogo = Instance.new("TextLabel")
	TLogo.Text = "🍕"; TLogo.Font = Enum.Font.GothamBold; TLogo.TextSize = 22
	TLogo.BackgroundTransparency = 1; TLogo.Position = UDim2.new(0, 14, 0, 0)
	TLogo.Size = UDim2.new(0, 40, 1, 0); TLogo.Parent = TB

	local TTitle = Instance.new("TextLabel")
	TTitle.Text = "Auto Pizza v" .. KEY_CONFIG.VERSAO .. " 🚁 [" .. KeyState.nivel:upper() .. "]"
	TTitle.Font = Enum.Font.GothamBold; TTitle.TextSize = 14; TTitle.TextColor3 = C.Text
	TTitle.BackgroundTransparency = 1; TTitle.Position = UDim2.new(0, 55, 0, 0)
	TTitle.Size = UDim2.new(0, 250, 1, 0); TTitle.TextXAlignment = Enum.TextXAlignment.Left; TTitle.Parent = TB

	local MinBtn = Instance.new("TextButton")
	MinBtn.Text = "−"; MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 20
	MinBtn.TextColor3 = C.Yellow; MinBtn.BackgroundColor3 = C.Card; MinBtn.BorderSizePixel = 0
	MinBtn.Size = UDim2.new(0, 36, 1, 0); MinBtn.Position = UDim2.new(1, -92, 0, 0); MinBtn.Parent = TB
	local MinC = Instance.new("UICorner"); MinC.CornerRadius = UDim.new(0, 14); MinC.Parent = MinBtn

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Text = "✕"; CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 18
	CloseBtn.TextColor3 = C.Sub; CloseBtn.BackgroundColor3 = C.Card; CloseBtn.BorderSizePixel = 0
	CloseBtn.Size = UDim2.new(0, 56, 1, 0); CloseBtn.Position = UDim2.new(1, -56, 0, 0); CloseBtn.Parent = TB
	local CC = Instance.new("UICorner"); CC.CornerRadius = UDim.new(0, 14); CC.Parent = CloseBtn

	local Content = Instance.new("ScrollingFrame")
	Content.Size = UDim2.new(1, -20, 1, -76); Content.Position = UDim2.new(0, 10, 0, 66)
	Content.BackgroundTransparency = 1; Content.BorderSizePixel = 0
	Content.ScrollBarThickness = 4; Content.ScrollBarImageColor3 = C.Accent
	Content.CanvasSize = UDim2.new(0, 0, 0, 0)
	Content.AutomaticCanvasSize = Enum.AutomaticSize.Y; Content.Parent = Main

	local Lay = Instance.new("UIListLayout"); Lay.Padding = UDim.new(0, 8); Lay.Parent = Content

	local function Sec(txt, color)
		local f = Instance.new("Frame")
		f.Size = UDim2.new(1, 0, 0, 26); f.BackgroundColor3 = C.Card
		f.BorderSizePixel = 0; f.Parent = Content
		local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = f
		local l = Instance.new("TextLabel")
		l.Text = txt; l.Font = Enum.Font.GothamBold; l.TextSize = 11
		l.TextColor3 = color or C.Accent; l.BackgroundTransparency = 1
		l.Position = UDim2.new(0, 12, 0, 0); l.Size = UDim2.new(1, -24, 1, 0)
		l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
	end

	local function Stat(txt, color)
		local f = Instance.new("Frame")
		f.Size = UDim2.new(1, 0, 0, 32); f.BackgroundColor3 = C.Card
		f.BorderSizePixel = 0; f.Parent = Content
		local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = f
		local l = Instance.new("TextLabel")
		l.Text = txt; l.Font = Enum.Font.GothamBold; l.TextSize = 11
		l.TextColor3 = color or C.Text; l.BackgroundTransparency = 1
		l.Position = UDim2.new(0, 12, 0, 0); l.Size = UDim2.new(1, -24, 1, 0)
		l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
		return l
	end

	local function Btn(txt, color, cb)
		local b = Instance.new("TextButton")
		b.Text = txt; b.Font = Enum.Font.GothamBold; b.TextSize = 12
		b.TextColor3 = C.Text; b.BackgroundColor3 = C.Card; b.BorderSizePixel = 0
		b.Size = UDim2.new(1, 0, 0, 38); b.AutoButtonColor = false; b.Parent = Content
		local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = b
		b.MouseButton1Click:Connect(function()
			Tween(b, {BackgroundColor3 = color or C.Accent}, 0.08)
			task.wait(0.12); Tween(b, {BackgroundColor3 = C.Card}, 0.15)
			if cb then task.spawn(cb) end
		end)
		return b
	end

	local function Toggle(txt, default, cb)
		local f = Instance.new("Frame")
		f.Size = UDim2.new(1, 0, 0, 42); f.BackgroundColor3 = C.Card
		f.BorderSizePixel = 0; f.Parent = Content
		local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = f
		local l = Instance.new("TextLabel")
		l.Text = txt; l.Font = Enum.Font.GothamBold; l.TextSize = 12; l.TextColor3 = C.Text
		l.BackgroundTransparency = 1; l.Position = UDim2.new(0, 12, 0, 0)
		l.Size = UDim2.new(1, -70, 1, 0); l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
		local bg = Instance.new("Frame")
		bg.Size = UDim2.new(0, 44, 0, 22); bg.Position = UDim2.new(1, -56, 0.5, -11)
		bg.BackgroundColor3 = Color3.fromRGB(50,50,60); bg.BorderSizePixel = 0; bg.Parent = f
		local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(1, 0); bc.Parent = bg
		local k = Instance.new("Frame")
		k.Size = UDim2.new(0, 18, 0, 18); k.Position = UDim2.new(0, 2, 0.5, -9)
		k.BackgroundColor3 = C.Text; k.BorderSizePixel = 0; k.Parent = bg
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
		cl.Text = ""; cl.BackgroundTransparency = 1; cl.Size = UDim2.new(1, 0, 1, 0); cl.Parent = f
		cl.MouseButton1Click:Connect(function() set(not st) end)
		return set
	end

	local function CriarSlider(parent, label, min, max, default, callback)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 58); frame.BackgroundColor3 = C.Card
		frame.BorderSizePixel = 0; frame.Parent = parent
		local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(0, 8); fc.Parent = frame
		local titulo = Instance.new("TextLabel")
		titulo.Text = label; titulo.Font = Enum.Font.GothamBold; titulo.TextSize = 12
		titulo.TextColor3 = C.Text; titulo.BackgroundTransparency = 1
		titulo.Position = UDim2.new(0, 12, 0, 6); titulo.Size = UDim2.new(0.7, 0, 0, 18)
		titulo.TextXAlignment = Enum.TextXAlignment.Left; titulo.Parent = frame
		local valorLabel = Instance.new("TextLabel")
		valorLabel.Text = tostring(default); valorLabel.Font = Enum.Font.GothamBold
		valorLabel.TextSize = 14; valorLabel.TextColor3 = C.Green; valorLabel.BackgroundTransparency = 1
		valorLabel.Position = UDim2.new(0.7, 0, 0, 6); valorLabel.Size = UDim2.new(0.3, -12, 0, 18)
		valorLabel.TextXAlignment = Enum.TextXAlignment.Right; valorLabel.Parent = frame
		local bgBar = Instance.new("Frame")
		bgBar.Size = UDim2.new(1, -24, 0, 12); bgBar.Position = UDim2.new(0, 12, 0, 32)
		bgBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60); bgBar.BorderSizePixel = 0; bgBar.Parent = frame
		local bbc = Instance.new("UICorner"); bbc.CornerRadius = UDim.new(1, 0); bbc.Parent = bgBar
		local fillBar = Instance.new("Frame")
		fillBar.Size = UDim2.new(0, 0, 1, 0); fillBar.BackgroundColor3 = C.Green
		fillBar.BorderSizePixel = 0; fillBar.Parent = bgBar
		local fbc = Instance.new("UICorner"); fbc.CornerRadius = UDim.new(1, 0); fbc.Parent = fillBar
		local knob = Instance.new("Frame")
		knob.Size = UDim2.new(0, 22, 0, 22); knob.Position = UDim2.new(0, -11, 0.5, -11)
		knob.BackgroundColor3 = C.Text; knob.BorderSizePixel = 0; knob.Parent = bgBar
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
			local bgAbs = bgBar.AbsolutePosition.X; local bgSize = bgBar.AbsoluteSize.X
			Aplicar(math.clamp((posX - bgAbs) / bgSize, 0, 1))
		end
		local initPercent = (default - min) / (max - min)
		fillBar.Size = UDim2.new(initPercent, 0, 1, 0)
		knob.Position = UDim2.new(initPercent, -11, 0.5, -11)
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
		return function(v)
			v = math.clamp(v, min, max)
			Aplicar((v - min) / (max - min))
		end
	end

	local UI = {}
	local PararTudo
	local entregaRun = 0

	Sec("👤 CONTA: " .. KeyState.nome .. " [" .. KeyState.nivel:upper() .. "]", C.Purple)
	Sec("🛡️ ANTI-DETECÇÃO", C.Green)
	local statusAnti = Stat("Avisos anticheat: 0", C.Green)
	local statusVoo = Stat("Voo: ● STANDBY", C.Blue)

	Sec("📊 ESTATÍSTICAS", C.Blue)
	local statsLabel = Stat(ResumoStats(), C.Text)
	Btn("🔄 Zerar estatísticas", C.Purple, function()
		Stats.entregues, Stats.pegos, Stats.erros = 0, 0, 0
		Stats.inicio = tick()
		Notificar("📊 Zeradas", C.Purple, 1.5)
	end)

	Sec("🛡️ GOD MODE", C.Green)
	Stat("Status: ● ATIVO", C.Green)

	Sec("🍕 AUTO ENTREGADOR", C.Accent)
	local entregaStatus = Stat("Status: PARADO", C.Sub)

	local function ErroLoop(err)
		Stats.erros = Stats.erros + 1
		Log("Erro: " .. tostring(err))
		entregaStatus.Text = "⚠️ Erro: " .. tostring(err):sub(1, 38)
		entregaStatus.TextColor3 = C.Red
		task.wait(2)
	end

	local function CicloEntrega(myRun)
		if not GetHRP() then
			entregaStatus.Text = "⏳ Aguardando personagem..."
			task.wait(1)
			return
		end
		PausaHumana()
		entregaStatus.TextColor3 = C.Green
		if TemPizza() then
			entregaStatus.Text = "📤 Procurando cliente..."
			local info = AcharLocalMarcado()
			if info and info.pos then
				entregaStatus.Text = "📤 Indo pro cliente (" .. info.pad.Name .. ")..."
				TravarCameraNoAlvo(info.pos)
				IrPara(info.pos, 30)
				if myRun ~= entregaRun then DestravarCamera(); return end
				Esp(0.3)
				entregaStatus.Text = "📤 Entregando..."
				local prompt = AcharPromptPorTexto("Entregar Pedido")
				if prompt then
					local t0 = tick()
					local tentativas = 0
					while tick() - t0 < 30 do
						if not TemPizza() then break end
						pcall(function() fireproximityprompt(prompt) end)
						tentativas = tentativas + 1
						entregaStatus.Text = "📤 Entregando... (" .. tentativas .. "x)"
						task.wait(4)
					end
				else
					entregaStatus.Text = "⚠️ Prompt não encontrado"
				end
				DestravarCamera()
				if not TemPizza() then
					Stats.entregues = Stats.entregues + 1
					Notificar("📤 Entregue! #" .. Stats.entregues, C.Blue, 1.5)
				end
			else
				entregaStatus.Text = "⚠️ Sem cliente"
				task.wait(1.5)
			end
		else
			entregaStatus.Text = "📥 Procurando pedido..."
			local promptPegar = AcharPromptPorTexto("Pegar Pedido")
			if promptPegar then
				local pos = PosDe(promptPegar.Parent)
				if not pos then
					entregaStatus.Text = "⚠️ Posição inválida"
					task.wait(1.5)
					return
				end
				entregaStatus.Text = "📥 Indo pegar..."
				IrPara(pos, 30)
				if myRun ~= entregaRun then return end
				Esp(0.3)
				entregaStatus.Text = "📥 Pegando..."
				pcall(function() fireproximityprompt(promptPegar) end)
				Esp(1.2)
				Stats.pegos = Stats.pegos + 1
				Notificar("📥 Pego!", C.Green, 1.2)
			else
				entregaStatus.Text = "⚠️ Sem pedido"
				task.wait(1.5)
			end
		end
	end

	UI.setEntregar = Toggle("Auto Entregar Pizza", Config.autoEntregar, function(s)
		Config.autoEntregar = s
		SalvarConfig()
		AtualizarIndicador()
		entregaRun = entregaRun + 1
		if s then
			local myRun = entregaRun
			AtivarNoclip()
			AplicarVelocidade()
			entregaStatus.Text = "Status: ● ATIVO"
			entregaStatus.TextColor3 = C.Green
			Notificar("🍕 ATIVADO", C.Green, 1.5)
			task.spawn(function()
				while Config.autoEntregar and myRun == entregaRun do
					local ok, err = pcall(CicloEntrega, myRun)
					if not ok then ErroLoop(err) end
					Esp(0.5)
				end
				DestravarCamera()
			end)
		else
			DesativarNoclip()
			DestravarCamera()
			entregaStatus.Text = "Status: PARADO"
			entregaStatus.TextColor3 = C.Sub
			Notificar("🍕 DESATIVADO", C.Yellow, 1.5)
			local hum = GetHum()
			if hum then hum.WalkSpeed = 16 end
		end
	end)

	Sec("📁 PERFIS", C.Accent)
	local Perfis = {
		["⚡ Rápido"] = { velocidade = 100, velFly = 45, modoSeguro = false },
		["🛡️ Seguro"] = { velocidade = 30, velFly = 30, modoSeguro = true },
		["🌙 AFK"] = { velocidade = 45, velFly = 35, modoSeguro = true, antiAfk = true, autoReconnect = true },
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
		Notificar("📁 " .. nome .. " aplicado", C.Accent, 1.8)
	end
	for _, nome in ipairs({"⚡ Rápido", "🛡️ Seguro", "🌙 AFK"}) do
		Btn(nome, C.Accent, function() AplicarPerfil(nome) end)
	end

	Sec("🛡️ CONVENIÊNCIA", C.Blue)
	UI.setSeguro = Toggle("Modo seguro", Config.modoSeguro, function(s)
		Config.modoSeguro = s
		SalvarConfig()
		if Config.autoEntregar then AplicarVelocidade() end
	end)
	UI.setAfk = Toggle("Anti-AFK", Config.antiAfk, function(s)
		Config.antiAfk = s
		SalvarConfig()
		SetAntiAfk(s)
	end)
	UI.setReconnect = Toggle("Auto-reconectar", Config.autoReconnect, function(s)
		Config.autoReconnect = s
		SalvarConfig()
	end)
	Toggle("FPS boost", Config.fpsBoost, function(s)
		Config.fpsBoost = s
		SalvarConfig()
		AplicarFPS(s)
	end)
	Toggle("🎥 Travar câmera no cliente", Config.travarCamera, function(s)
		Config.travarCamera = s
		SalvarConfig()
		if not s then DestravarCamera() end
	end)
	Btn("🌐 Server hop", C.Blue, function() ServerHop() end)

	Sec("🚁 LOCOMOÇÃO 🚁 v" .. KEY_CONFIG.VERSAO, C.Yellow)
	Stat("Sobe 25 studs ANTES da água", C.Green)
	Stat("Region3 corrigido (sem erro)", C.Blue)
	Stat("Se cair, teleporta de volta", C.Purple)

	Sec("⚡ VELOCIDADE", C.Yellow)
	UI.setVel = CriarSlider(Content, "⚡ Velocidade a pé", 16, 200, Config.velocidade, function(valor)
		Config.velocidade = valor
		AplicarVelocidade()
	end)

	Sec("🚀 VELOCIDADE VOO", C.Blue)
	UI.setVelFly = CriarSlider(Content, "🚀 Velocidade voo", 16, 60, Config.velFly or 40, function(valor)
		Config.velFly = valor
	end)

	Sec("⌨️ HOTKEYS", C.Yellow)
	local aguardandoTecla = nil
	local botoesTecla = {}
	local Acoes = {
		{ cfg = "keyUI", nome = "Abrir/Fechar UI" },
		{ cfg = "keyPanic", nome = "PANIC" },
		{ cfg = "keyEntregar", nome = "Liga/Desliga" },
	}
	for _, a in ipairs(Acoes) do
		local b
		b = Btn(a.nome .. ": " .. tostring(Config[a.cfg]), C.Yellow, function()
			aguardandoTecla = a.cfg
			b.Text = a.nome .. ": aperte tecla..."
		end)
		botoesTecla[a.cfg] = { btn = b, nome = a.nome }
	end

	Sec("🚨 EMERGÊNCIA", C.Red)

	PararTudo = function()
		Config.autoEntregar = false
		entregaRun = entregaRun + 1
		if UI.setEntregar then UI.setEntregar(false) end
		DesativarNoclip()
		DestravarCamera()
		entregaStatus.Text = "Status: PARADO"
		entregaStatus.TextColor3 = C.Sub
		local hum = GetHum()
		if hum then hum.WalkSpeed = 16 end
		AtualizarIndicador()
	end

	Btn("🛑 PARAR TUDO", C.Red, function()
		PararTudo()
		Notificar("🛑 Parado!", C.Red, 2)
	end)

	local uiAberta = true
	local function FecharUI()
		uiAberta = false
		Tween(Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
		task.wait(0.2); Main.Visible = false
		FloatBtn.Text = "🍕"
	end
	local function AbrirUI()
		uiAberta = true; Main.Visible = true
		Main.Size = UDim2.new(0, 0, 0, 0)
		Tween(Main, {Size = UDim2.new(0, 400, 0, 560)}, 0.25)
		FloatBtn.Text = "✕"
	end

	FloatBtn.MouseButton1Click:Connect(function()
		if btnMoveuSe then return end
		if uiAberta then FecharUI() else AbrirUI() end
	end)

	UserInput.InputBegan:Connect(function(input, gp)
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
			Notificar("🚨 PANIC", C.Red, 2)
		elseif nome == Config.keyEntregar then
			UI.setEntregar(not Config.autoEntregar)
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

	task.spawn(function()
		while SG.Parent do
			task.wait(1)
			pcall(function()
				statsLabel.Text = ResumoStats()
				statusAnti.Text = "Avisos anticheat: " .. _avisosAnticheat
				if _suspenderTudo then
					statusVoo.Text = "Voo: ⏸️ SUSPENSO"
					statusVoo.TextColor3 = C.Red
				elseif tick() - _ultimoVoo < 2 then
					statusVoo.Text = "Voo: ⏱️ cooldown"
					statusVoo.TextColor3 = C.Yellow
				else
					statusVoo.Text = "Voo: ● STANDBY"
					statusVoo.TextColor3 = C.Blue
				end
			end)
		end
	end)

	lp.CharacterAdded:Connect(function()
		task.wait(1.5)
		if Config.autoEntregar then
			AplicarVelocidade()
			Notificar("♻️ Respawn", C.Blue, 2)
		end
	end)

	SetAntiAfk(Config.antiAfk)
	IniciarAutoReconnect()
	if Config.fpsBoost then AplicarFPS(true) end

	task.spawn(function()
		while SG.Parent do
			task.wait(KEY_CONFIG.REVALIDAR_SEG)
			if not SG.Parent then break end
			local ok, res, erroRede = ValidarKey(KeyState.key)
			if not ok and not erroRede then
				PararTudo()
				LimparKeyLocal()
				Notificar("🚫 Key revogada: " .. tostring(res), C.Red, 5)
				task.wait(3)
				pcall(function() SG:Destroy() end)
				pcall(function() SGBtn:Destroy() end)
				break
			end
		end
	end)

	AtivarGodMode()

	if Config.autoEntregar then UI.setEntregar(true) end
	AtualizarIndicador()

	Log("═══════════════════════════════════")
	Log("🍕 Sailent Auto Pizza v" .. KEY_CONFIG.VERSAO .. " 🚁")
	Log("👤 " .. KeyState.nome .. " | " .. KeyState.nivel:upper())
	Log("═══════════════════════════════════")

	Notificar("🍕 Auto Pizza v" .. KEY_CONFIG.VERSAO .. " 🚁 carregado!", C.Accent, 2.5)
end

Log("🔐 Verificando key...")

task.spawn(function()
	local k = CarregarKeyLocal()
	if k and k ~= "" then
		local ok = ValidarKey(k)
		if ok then
			Log("✅ Key salva válida!")
			IniciarScript()
			return
		else
			Log("⚠️ Key inválida, pedindo nova...")
		end
	end
	MostrarUILogin(function() IniciarScript() end)
end)

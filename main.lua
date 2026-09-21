-- ============================================================
-- SAILENT AUTO GARI v7.5 — LEVE E SEM TRAVAMENTO
-- ============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local lp = Players.LocalPlayer

local GITHUB_URL = "https://raw.githubusercontent.com/simiao64santos-dot/sailent-/refs/heads/main/keys.json"
local SAVE_FILE = "sailent_key_salva.txt"
local CACHE_FILE = "sailent_keys_cache.json"
local CONFIG_FILE = "sailent_gari_config.txt"
local KEY_DURACAO_LOCAL = 24 * 60 * 60
local CACHE_DURACAO = 6 * 60 * 60
local SCRIPT_VERSION = "7.5"

local IS_MOBILE = UserInput.TouchEnabled and not UserInput.KeyboardEnabled

-- Limpa UIs antigas
for _, name in ipairs({"SailentGari", "SailentFloatBtn", "SailentKeyUI", "SailentLoading"}) do
	pcall(function()
		if CoreGui:FindFirstChild(name) then CoreGui[name]:Destroy() end
	end)
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
	Purple = Color3.fromRGB(180,120,255),
	Black = Color3.fromRGB(10, 10, 15),
	Gold = Color3.fromRGB(255,215,0),
	Cyan = Color3.fromRGB(80,220,240),
}

-- ============================================================
-- UTILITÁRIOS
-- ============================================================
local function Log(m)
	pcall(function() print("[Sailent] " .. tostring(m)) end)
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

local function FormatarTempo(s)
	s = math.floor(s or 0)
	local h = math.floor(s/3600)
	local m = math.floor((s%3600)/60)
	local ss = s%60
	if h > 0 then return string.format("%dh %dm %ds", h, m, ss) end
	if m > 0 then return string.format("%dm %ds", m, ss) end
	return string.format("%ds", ss)
end

local function Tween(o, p, t)
	if not o or not o.Parent then return end
	local tw = TweenService:Create(o, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint), p)
	tw:Play()
	return tw
end

-- ============================================================
-- SHA-256 (mantido)
-- ============================================================
local function sha256(msg)
	local K = {
		0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
		0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
		0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
		0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
		0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
		0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
		0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
		0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2,
	}
	local H = {0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
	local function rrot(x,n) return (x >> n) | (x << (32-n)) & 0xffffffff end
	local function uint32(x) return x & 0xffffffff end
	local s = msg .. "\128"
	local l = #msg * 8
	while #s % 64 ~= 56 do s = s .. "\0" end
	for i = 7, 0, -1 do s = s .. string.char((l >> (i*8)) & 0xff) end
	for ci = 0, (#s / 64) - 1 do
		local chunk = s:sub(ci*64+1, ci*64+64)
		local w = {}
		for i = 1, 16 do
			local b1,b2,b3,b4 = chunk:byte((i-1)*4+1, i*4)
			w[i] = (b1 << 24) | (b2 << 16) | (b3 << 8) | b4
		end
		for i = 17, 64 do
			local s0 = rrot(w[i-15],7) ~ rrot(w[i-15],18) ~ (w[i-15] >> 3)
			local s1 = rrot(w[i-2],17) ~ rrot(w[i-2],19) ~ (w[i-2] >> 10)
			w[i] = uint32(w[i-16] + s0 + w[i-7] + s1)
		end
		local a,b,c,d,e,f,g,h = H[1],H[2],H[3],H[4],H[5],H[6],H[7],H[8]
		for i = 1, 64 do
			local S1 = rrot(e,6) ~ rrot(e,11) ~ rrot(e,25)
			local ch = (e & f) ~ ((~e) & g)
			local t1 = uint32(h + S1 + ch + K[i] + w[i])
			local S0 = rrot(a,2) ~ rrot(a,13) ~ rrot(a,22)
			local maj = (a & b) ~ (a & c) ~ (b & c)
			local t2 = uint32(S0 + maj)
			h=g; g=f; f=e; e=uint32(d+t1); d=c; c=b; b=a; a=uint32(t1+t2)
		end
		H[1]=uint32(H[1]+a); H[2]=uint32(H[2]+b); H[3]=uint32(H[3]+c); H[4]=uint32(H[4]+d)
		H[5]=uint32(H[5]+e); H[6]=uint32(H[6]+f); H[7]=uint32(H[7]+g); H[8]=uint32(H[8]+h)
	end
	local out = {}
	for _, v in ipairs(H) do out[#out+1] = string.format("%08x", v) end
	return table.concat(out)
end

-- ============================================================
-- HWID
-- ============================================================
local cachedHwid = nil
local function GetHWID()
	if cachedHwid then return cachedHwid end
	local parts = {}
	pcall(function() parts[#parts+1] = tostring(lp.UserId) end)
	pcall(function() parts[#parts+1] = tostring(game.PlaceId) end)
	pcall(function() parts[#parts+1] = tostring(game.JobId) end)
	pcall(function() parts[#parts+1] = gethwid and gethwid() or "" end)
	cachedHwid = sha256(table.concat(parts, "|")):sub(1, 32)
	return cachedHwid
end

-- ============================================================
-- ARQUIVOS
-- ============================================================
local function ReadFile(path)
	local ok, data = pcall(function()
		if isfile and isfile(path) and readfile then return readfile(path) end
	end)
	if ok and data and data ~= "" then return data end
	return nil
end

local function WriteFile(path, content)
	pcall(function() if writefile then writefile(path, content) end end)
end

local function DeleteFile(path)
	pcall(function() if delfile and isfile and isfile(path) then delfile(path) end end)
end

-- ============================================================
-- SISTEMA DE KEY
-- ============================================================
local function TemKeySalva()
	local dados = ReadFile(SAVE_FILE)
	if not dados then return nil end
	local key, expira, hwid = dados:match("([^|]+)|(%d+)|(.*)")
	if key and expira then
		expira = tonumber(expira)
		if expira and os.time() < expira then return key, hwid end
	end
	return nil
end

local function SalvarKey(key)
	WriteFile(SAVE_FILE, key .. "|" .. (os.time() + KEY_DURACAO_LOCAL) .. "|" .. GetHWID())
end

local function LimparKeySalva() DeleteFile(SAVE_FILE) end

local function BaixarKeys()
	local cache = ReadFile(CACHE_FILE)
	if cache then
		local ok, dados = pcall(function() return HttpService:JSONDecode(cache) end)
		if ok and dados and dados._cached_at and (os.time() - dados._cached_at) < CACHE_DURACAO then
			return dados
		end
	end

	-- HttpGet com timeout via task.spawn
	local resultado = nil
	local terminou = false
	task.spawn(function()
		pcall(function() resultado = game:HttpGet(GITHUB_URL, true) end)
		terminou = true
	end)

	local t0 = tick()
	while not terminou and tick() - t0 < 8 do
		task.wait(0.1)
	end

	if not terminou or not resultado or resultado == "" then
		if cache then
			local ok, dados = pcall(function() return HttpService:JSONDecode(cache) end)
			if ok and dados then return dados end
		end
		return nil, "Timeout/sem conexão"
	end

	local ok, dados = pcall(function() return HttpService:JSONDecode(resultado) end)
	if not ok or not dados then
		if cache then
			local ok2, d2 = pcall(function() return HttpService:JSONDecode(cache) end)
			if ok2 and d2 then return d2 end
		end
		return nil, "JSON inválido"
	end

	dados._cached_at = os.time()
	WriteFile(CACHE_FILE, HttpService:JSONEncode(dados))
	return dados
end

local function ValidarKey(key)
	if not key or key == "" then return false, "Key vazia" end
	local hashKey = sha256(key)
	local dados, erro = BaixarKeys()
	if not dados then return false, erro or "Sem conexão" end
	if not dados.keys then return false, "Keys não encontradas" end
	local info = dados.keys[hashKey] or dados.keys[key]
	if not info then return false, "Key inválida" end
	if info.status ~= "ativa" then return false, "Key bloqueada" end
	if info.expira and tonumber(info.expira) and os.time() > tonumber(info.expira) then
		return false, "Key expirada"
	end
	local meuHwid = GetHWID()
	if info.hwid and info.hwid ~= "" and info.hwid ~= meuHwid then
		return false, "Key de outro dispositivo"
	end
	if info.max_usos and info.max_usos > 0 then
		if (info.usos or 0) >= info.max_usos then
			return false, "Limite atingido"
		end
	end
	return true, info, hashKey
end

-- ============================================================
-- UI DE CARREGAMENTO
-- ============================================================
local function CriarLoading(txt)
	local SG = Instance.new("ScreenGui")
	SG.Name = "SailentLoading"
	SG.ResetOnSpawn = false
	SG.IgnoreGuiInset = true
	SG.Parent = CoreGui

	local F = Instance.new("Frame")
	F.Size = UDim2.new(0, 260, 0, 90)
	F.Position = UDim2.new(0.5, -130, 0.5, -45)
	F.BackgroundColor3 = C.BG
	F.BorderSizePixel = 0
	F.Parent = SG
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 12)
	c.Parent = F
	local s = Instance.new("UIStroke")
	s.Color = C.Green
	s.Thickness = 2
	s.Parent = F

	local L = Instance.new("TextLabel")
	L.Text = txt or "⏳ Carregando..."
	L.Font = Enum.Font.GothamBold
	L.TextSize = 14
	L.TextColor3 = C.Text
	L.BackgroundTransparency = 1
	L.Size = UDim2.new(1, 0, 1, 0)
	L.Parent = F

	return SG
end

-- ============================================================
-- ABRIR AUTO GARI (construção leve)
-- ============================================================
local function AbrirAutoGari(infoKey)
	infoKey = infoKey or {nome = "Cliente", nivel = "normal"}

	local Config = {
		velocidade = 100,
		noclip = false,
		somAtivo = true,
		vooAtivo = false,
		vooVelocidade = 80,
		vooAltura = 12,
		vooSuavidade = 3,
	}

	-- carrega config
	do
		local str = ReadFile(CONFIG_FILE)
		if str then
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
	end

	local function SalvarConfig()
		local str = ""
		for k, v in pairs(Config) do
			str = str .. k .. "=" .. tostring(v) .. "\n"
		end
		WriteFile(CONFIG_FILE, str)
	end

	local function TocarSom(tipo)
		if not Config.somAtivo then return end
		pcall(function()
			local s = Instance.new("Sound")
			s.Parent = SoundService
			if tipo == "coletou" then s.SoundId = "rbxassetid://4612375230"
			elseif tipo == "entregou" then s.SoundId = "rbxassetid://4612384334"
			elseif tipo == "reset" then s.SoundId = "rbxassetid://6042053626" end
			s.Volume = 0.5
			s:Play()
			task.delay(2, function() pcall(function() s:Destroy() end) end)
		end)
	end

	-- ============================================================
	-- VOO
	-- ============================================================
	local BodyVel = nil
	local BodyGy = nil

	local function IniciarVoo()
		local hrp = GetHRP()
		if not hrp then return end
		pcall(function()
			local a = hrp:FindFirstChild("SailentVooVel"); if a then a:Destroy() end
			local b = hrp:FindFirstChild("SailentVooGyro"); if b then b:Destroy() end
		end)
		local bv = Instance.new("BodyVelocity")
		bv.Name = "SailentVooVel"
		bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bv.Velocity = Vector3.zero
		bv.P = 1250
		bv.Parent = hrp
		BodyVel = bv

		local bg = Instance.new("BodyGyro")
		bg.Name = "SailentVooGyro"
		bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
		bg.P = 3000
		bg.D = 100
		bg.CFrame = hrp.CFrame
		bg.Parent = hrp
		BodyGy = bg
	end

	local function PararVoo()
		pcall(function()
			local hrp = GetHRP()
			if hrp then
				local a = hrp:FindFirstChild("SailentVooVel"); if a then a:Destroy() end
				local b = hrp:FindFirstChild("SailentVooGyro"); if b then b:Destroy() end
			end
		end)
		BodyVel = nil
		BodyGy = nil
	end

	local function VoarAte(posAlvo, timeout, distParada)
		if not posAlvo then return false end
		local hrp = GetHRP()
		if not hrp then return false end
		if not BodyVel or not BodyVel.Parent then IniciarVoo() end

		timeout = timeout or 30
		distParada = distParada or 5
		local vel = Config.vooVelocidade or 80
		local alt = Config.vooAltura or 12
		local suav = Config.vooSuavidade or 3

		local destino = Vector3.new(posAlvo.X, posAlvo.Y + alt, posAlvo.Z)
		local t0 = tick()
		local ultimaPos = hrp.Position
		local parado = 0
		local travou = 0

		while tick() - t0 < timeout do
			local h = GetHRP()
			if not h then return false end
			if not BodyVel or not BodyVel.Parent then IniciarVoo(); task.wait(0.1) end

			local pos = h.Position
			local diff = destino - pos
			local dist = diff.Magnitude
			local plano = Vector3.new(pos.X - posAlvo.X, 0, pos.Z - posAlvo.Z)

			if plano.Magnitude < distParada then
				if BodyVel then BodyVel.Velocity = Vector3.zero end
				return true
			end

			local fator = math.clamp(dist / 30, 0.3, 1)
			local velFinal = diff.Unit * vel * fator

			if BodyVel then
				BodyVel.Velocity = BodyVel.Velocity:Lerp(velFinal, math.clamp(suav * 0.1, 0.05, 0.5))
			end

			if BodyGy and BodyGy.Parent then
				local d = Vector3.new(diff.X, 0, diff.Z)
				if d.Magnitude > 1 then
					local look = CFrame.new(pos, pos + d.Unit)
					BodyGy.CFrame = BodyGy.CFrame:Lerp(look, 0.15)
				end
			end

			local moveu = (pos - ultimaPos).Magnitude
			if moveu < 0.5 then
				parado = parado + 0.1
				if parado > 1.5 then
					travou = travou + 1
					if BodyVel then BodyVel.Velocity = Vector3.new(0, vel * 0.6, 0) end
					task.wait(0.3)
					parado = 0
					if travou >= 4 then return false end
				end
			else
				parado = 0
			end

			ultimaPos = pos
			task.wait(0.1) -- mais lento pra não travar
		end
		return false
	end

	local function AndarAte(posAlvo, timeout, distParada)
		if not posAlvo then return false end
		local hum = GetHum()
		if not hum then return false end
		timeout = timeout or 30
		distParada = distParada or 4
		local t0 = tick()
		local ultimaPos = Vector3.zero
		local parado = 0
		local travou = 0

		hum:MoveTo(posAlvo)

		while tick() - t0 < timeout do
			local h = GetHRP()
			if not h or not hum.Parent then return false end

			local diff = Vector3.new(h.Position.X - posAlvo.X, 0, h.Position.Z - posAlvo.Z)
			if diff.Magnitude < distParada then
				hum:MoveTo(h.Position)
				return true
			end

			if ultimaPos ~= Vector3.zero then
				local moveu = (h.Position - ultimaPos).Magnitude
				if moveu < 0.5 then
					parado = parado + 0.1
					if parado > 1.5 then
						travou = travou + 1
						pcall(function() hum.Jump = true end)
						task.wait(0.3)
						hum:MoveTo(posAlvo)
						parado = 0
						if travou >= 3 then return false end
					end
				else
					parado = 0
					travou = 0
				end
			end

			ultimaPos = h.Position
			hum:MoveTo(posAlvo)
			task.wait(0.15)
		end
		return false
	end

	local function IrAte(posAlvo, timeout, distParada)
		if Config.vooAtivo then
			return VoarAte(posAlvo, timeout, distParada or 5)
		else
			return AndarAte(posAlvo, timeout, distParada or 4)
		end
	end

	local lixosUsados = {}
	local lixosFalhados = {}

	local function GetLixosContainer()
		local caminhos = {
			{"Construcoes", "SistemaGari", "Lixos"},
			{"SistemaGari", "Lixos"},
			{"Lixos"},
			{"Construcoes", "Lixos"},
		}
		for _, c in ipairs(caminhos) do
			local w = workspace
			local ok = true
			for _, n in ipairs(c) do
				w = w:FindFirstChild(n)
				if not w then ok = false; break end
			end
			if ok and w then return w end
		end
		return nil
	end

	local function GetCaminhao()
		local s = workspace:FindFirstChild("CarrosSpawnados")
		return s and s:FindFirstChild("Lixeiro")
	end

	local function GetTraseira(cam)
		if not cam then return nil end
		local body = cam:FindFirstChild("Body")
		if not body then return nil end
		local p = body:FindFirstChild("Proximitikk")
		if p then return p end
		return body:FindFirstChildWhichIsA("BasePart", true)
	end

	local function TemLixoNaMao()
		if not lp.Character then return false end
		for _, o in ipairs(lp.Character:GetChildren()) do
			if o:IsA("Tool") and (o.Name == "Lixo" or o.Name:lower():find("lixo")) then
				return true
			end
		end
		return false
	end

	local function AcharProximoLixo()
		local cont = GetLixosContainer()
		if not cont then return nil end
		local hrp = GetHRP()
		if not hrp then return nil end

		local disp = {}
		for _, lixo in ipairs(cont:GetChildren()) do
			if lixo:IsA("BasePart") and not lixosUsados[lixo] and not lixosFalhados[lixo] then
				table.insert(disp, {lixo = lixo, dist = (lixo.Position - hrp.Position).Magnitude})
			end
		end

		if #disp == 0 then
			TocarSom("reset")
			lixosUsados = {}
			lixosFalhados = {}
			for _, lixo in ipairs(cont:GetChildren()) do
				if lixo:IsA("BasePart") then
					table.insert(disp, {lixo = lixo, dist = (lixo.Position - hrp.Position).Magnitude})
				end
			end
		end

		table.sort(disp, function(a, b) return a.dist < b.dist end)
		if #disp > 0 then return disp[1].lixo end
		return nil
	end

	-- ============================================================
	-- UI (construção rápida)
	-- ============================================================
	local SGBtn = Instance.new("ScreenGui")
	SGBtn.Name = "SailentFloatBtn"
	SGBtn.ResetOnSpawn = false
	SGBtn.IgnoreGuiInset = true
	SGBtn.Parent = CoreGui

	local BTN = IS_MOBILE and 68 or 60
	local FloatBtn = Instance.new("TextButton")
	FloatBtn.Text = "⚡"
	FloatBtn.Font = Enum.Font.GothamBold
	FloatBtn.TextSize = IS_MOBILE and 32 or 28
	FloatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	FloatBtn.BackgroundColor3 = C.Black
	FloatBtn.BorderSizePixel = 0
	FloatBtn.Size = UDim2.new(0, BTN, 0, BTN)
	FloatBtn.Position = UDim2.new(0, 20, 0.5, -BTN/2)
	FloatBtn.AutoButtonColor = false
	FloatBtn.Active = true
	FloatBtn.Parent = SGBtn

	local BtnC = Instance.new("UICorner")
	BtnC.CornerRadius = UDim.new(1, 0)
	BtnC.Parent = FloatBtn

	local BtnS = Instance.new("UIStroke")
	BtnS.Color = infoKey.nivel == "admin" and C.Gold or (infoKey.nivel == "vip" and C.Purple or C.Green)
	BtnS.Thickness = IS_MOBILE and 3 or 2
	BtnS.Parent = FloatBtn

	local btnDragging, btnDragStart, btnStartPos, btnMoveuSe
	FloatBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			btnDragging = true
			btnMoveuSe = false
			btnDragStart = input.Position
			btnStartPos = FloatBtn.Position
		end
	end)
	FloatBtn.InputChanged:Connect(function(input)
		if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - btnDragStart
			if math.abs(delta.X) > 8 or math.abs(delta.Y) > 8 then btnMoveuSe = true end
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
	SG.IgnoreGuiInset = true
	SG.Parent = CoreGui

	local UI_W, UI_H
	if IS_MOBILE then
		local vp = workspace.CurrentCamera.ViewportSize
		UI_W = math.min(vp.X * 0.92, 420)
		UI_H = math.min(vp.Y * 0.85, 680)
	else
		UI_W, UI_H = 400, 660
	end

	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0, UI_W, 0, UI_H)
	Main.Position = UDim2.new(0.5, -UI_W/2, 0.5, -UI_H/2)
	Main.BackgroundColor3 = C.BG
	Main.BorderSizePixel = 0
	Main.Parent = SG
	local MC = Instance.new("UICorner")
	MC.CornerRadius = UDim.new(0, 14)
	MC.Parent = Main
	local MS = Instance.new("UIStroke")
	MS.Color = infoKey.nivel == "admin" and C.Gold or (infoKey.nivel == "vip" and C.Purple or C.Accent)
	MS.Thickness = 1.5
	MS.Transparency = 0.3
	MS.Parent = Main

	_G.SailentBloquearDrag = false

	do
		local d, di, ds, sp
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
			if i == di and d and not _G.SailentBloquearDrag then
				local x = i.Position - ds
				Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + x.X, sp.Y.Scale, sp.Y.Offset + x.Y)
			end
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
	TTitle.Text = "Auto Gari v" .. SCRIPT_VERSION
	TTitle.Font = Enum.Font.GothamBold
	TTitle.TextSize = IS_MOBILE and 14 or 16
	TTitle.TextColor3 = C.Text
	TTitle.BackgroundTransparency = 1
	TTitle.Position = UDim2.new(0, 50, 0, 0)
	TTitle.Size = UDim2.new(0, 160, 1, 0)
	TTitle.TextXAlignment = Enum.TextXAlignment.Left
	TTitle.Parent = TB

	local Badge = Instance.new("TextLabel")
	Badge.Text = string.upper(infoKey.nivel or "normal")
	Badge.Font = Enum.Font.GothamBold
	Badge.TextSize = 9
	Badge.TextColor3 = C.Black
	Badge.BackgroundColor3 = infoKey.nivel == "admin" and C.Gold or (infoKey.nivel == "vip" and C.Purple or C.Green)
	Badge.BorderSizePixel = 0
	Badge.Size = UDim2.new(0, 50, 0, 16)
	Badge.Position = UDim2.new(0, 175, 0.5, -8)
	Badge.Parent = TB
	local BadgeC = Instance.new("UICorner")
	BadgeC.CornerRadius = UDim.new(0, 4)
	BadgeC.Parent = Badge

	local MBTN_W = IS_MOBILE and 44 or 36
	local MinBtn = Instance.new("TextButton")
	MinBtn.Text = "−"
	MinBtn.Font = Enum.Font.GothamBold
	MinBtn.TextSize = IS_MOBILE and 24 or 20
	MinBtn.TextColor3 = C.Yellow
	MinBtn.BackgroundColor3 = C.Card
	MinBtn.BorderSizePixel = 0
	MinBtn.Size = UDim2.new(0, MBTN_W, 1, 0)
	MinBtn.Position = UDim2.new(1, -(MBTN_W + 56), 0, 0)
	MinBtn.Parent = TB
	local MinC = Instance.new("UICorner")
	MinC.CornerRadius = UDim.new(0, 14)
	MinC.Parent = MinBtn

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Text = "✕"
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = IS_MOBILE and 22 or 18
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
	Content.ScrollBarThickness = IS_MOBILE and 6 or 4
	Content.ScrollBarImageColor3 = C.Accent
	Content.CanvasSize = UDim2.new(0, 0, 0, 0)
	Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Content.Parent = Main

	local Lay = Instance.new("UIListLayout")
	Lay.Padding = UDim.new(0, 8)
	Lay.Parent = Content

	local H_SEC = IS_MOBILE and 30 or 26
	local H_STAT = IS_MOBILE and 38 or 32
	local H_BTN = IS_MOBILE and 48 or 38
	local H_TOG = IS_MOBILE and 52 or 42
	local FONT_S = IS_MOBILE and 12 or 11
	local FONT_B = IS_MOBILE and 13 or 12

	local function Sec(txt, cor)
		local f = Instance.new("Frame")
		f.Size = UDim2.new(1, 0, 0, H_SEC)
		f.BackgroundColor3 = C.Card
		f.BorderSizePixel = 0
		f.Parent = Content
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 6)
		c.Parent = f
		local l = Instance.new("TextLabel")
		l.Text = txt
		l.Font = Enum.Font.GothamBold
		l.TextSize = FONT_S
		l.TextColor3 = cor or C.Accent
		l.BackgroundTransparency = 1
		l.Position = UDim2.new(0, 12, 0, 0)
		l.Size = UDim2.new(1, -24, 1, 0)
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.Parent = f
	end

	local function Stat(txt, cor)
		local f = Instance.new("Frame")
		f.Size = UDim2.new(1, 0, 0, H_STAT)
		f.BackgroundColor3 = C.Card
		f.BorderSizePixel = 0
		f.Parent = Content
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 6)
		c.Parent = f
		local l = Instance.new("TextLabel")
		l.Text = txt
		l.Font = Enum.Font.GothamBold
		l.TextSize = FONT_S
		l.TextColor3 = cor or C.Text
		l.BackgroundTransparency = 1
		l.Position = UDim2.new(0, 12, 0, 0)
		l.Size = UDim2.new(1, -24, 1, 0)
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.Parent = f
		return l
	end

	local function Btn(txt, cor, cb)
		local b = Instance.new("TextButton")
		b.Text = txt
		b.Font = Enum.Font.GothamBold
		b.TextSize = FONT_B
		b.TextColor3 = C.Text
		b.BackgroundColor3 = C.Card
		b.BorderSizePixel = 0
		b.Size = UDim2.new(1, 0, 0, H_BTN)
		b.AutoButtonColor = false
		b.Parent = Content
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 8)
		c.Parent = b
		b.MouseButton1Click:Connect(function()
			Tween(b, {BackgroundColor3 = cor or C.Accent}, 0.08)
			task.wait(0.12)
			Tween(b, {BackgroundColor3 = C.Card}, 0.15)
			if cb then task.spawn(function() pcall(cb) end) end
		end)
		return b
	end

	local function Toggle(txt, default, cb)
		local f = Instance.new("Frame")
		f.Size = UDim2.new(1, 0, 0, H_TOG)
		f.BackgroundColor3 = C.Card
		f.BorderSizePixel = 0
		f.Parent = Content
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 8)
		c.Parent = f
		local l = Instance.new("TextLabel")
		l.Text = txt
		l.Font = Enum.Font.GothamBold
		l.TextSize = FONT_B
		l.TextColor3 = C.Text
		l.BackgroundTransparency = 1
		l.Position = UDim2.new(0, 12, 0, 0)
		l.Size = UDim2.new(1, -80, 1, 0)
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.Parent = f

		local BW = IS_MOBILE and 52 or 44
		local BH = IS_MOBILE and 26 or 22
		local KS = IS_MOBILE and 22 or 18

		local bg = Instance.new("Frame")
		bg.Size = UDim2.new(0, BW, 0, BH)
		bg.Position = UDim2.new(1, -(BW + 12), 0.5, -BH/2)
		bg.BackgroundColor3 = Color3.fromRGB(50,50,60)
		bg.BorderSizePixel = 0
		bg.Parent = f
		local bc = Instance.new("UICorner")
		bc.CornerRadius = UDim.new(1, 0)
		bc.Parent = bg

		local k = Instance.new("Frame")
		k.Size = UDim2.new(0, KS, 0, KS)
		k.Position = UDim2.new(0, 2, 0.5, -KS/2)
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
				Tween(k, {Position = UDim2.new(0, BW - KS - 2, 0.5, -KS/2)}, 0.2)
			else
				Tween(bg, {BackgroundColor3 = Color3.fromRGB(50,50,60)}, 0.2)
				Tween(k, {Position = UDim2.new(0, 2, 0.5, -KS/2)}, 0.2)
			end
			if cb then task.spawn(function() pcall(cb, st) end) end
		end
		if st then
			bg.BackgroundColor3 = C.Green
			k.Position = UDim2.new(0, BW - KS - 2, 0.5, -KS/2)
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

	local function Slider(parent, min, max, default, cb, titulo, cor, sufixo)
		local SH = IS_MOBILE and 80 or 58
		local KN = IS_MOBILE and 32 or 22
		local BRH = IS_MOBILE and 16 or 12

		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, SH)
		frame.BackgroundColor3 = C.Card
		frame.BorderSizePixel = 0
		frame.Parent = parent
		local fc = Instance.new("UICorner")
		fc.CornerRadius = UDim.new(0, 8)
		fc.Parent = frame

		local t = Instance.new("TextLabel")
		t.Text = titulo or "Valor"
		t.Font = Enum.Font.GothamBold
		t.TextSize = IS_MOBILE and 13 or 12
		t.TextColor3 = cor or C.Text
		t.BackgroundTransparency = 1
		t.Position = UDim2.new(0, 12, 0, 8)
		t.Size = UDim2.new(0.7, 0, 0, 18)
		t.TextXAlignment = Enum.TextXAlignment.Left
		t.Parent = frame

		local vl = Instance.new("TextLabel")
		vl.Text = tostring(default) .. (sufixo or "")
		vl.Font = Enum.Font.GothamBold
		vl.TextSize = IS_MOBILE and 16 or 14
		vl.TextColor3 = cor or C.Green
		vl.BackgroundTransparency = 1
		vl.Position = UDim2.new(0.7, 0, 0, 8)
		vl.Size = UDim2.new(0.3, -12, 0, 18)
		vl.TextXAlignment = Enum.TextXAlignment.Right
		vl.Parent = frame

		local bgBar = Instance.new("Frame")
		bgBar.Size = UDim2.new(1, -24, 0, BRH)
		bgBar.Position = UDim2.new(0, 12, 0, IS_MOBILE and 42 or 32)
		bgBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
		bgBar.BorderSizePixel = 0
		bgBar.Parent = frame
		local bbc = Instance.new("UICorner")
		bbc.CornerRadius = UDim.new(1, 0)
		bbc.Parent = bgBar

		local fill = Instance.new("Frame")
		fill.Size = UDim2.new(0, 0, 1, 0)
		fill.BackgroundColor3 = cor or C.Green
		fill.BorderSizePixel = 0
		fill.Parent = bgBar
		local fbc = Instance.new("UICorner")
		fbc.CornerRadius = UDim.new(1, 0)
		fbc.Parent = fill

		local knob = Instance.new("Frame")
		knob.Size = UDim2.new(0, KN, 0, KN)
		knob.Position = UDim2.new(0, -KN/2, 0.5, -KN/2)
		knob.BackgroundColor3 = C.Text
		knob.BorderSizePixel = 0
		knob.ZIndex = 2
		knob.Parent = bgBar
		local kc = Instance.new("UICorner")
		kc.CornerRadius = UDim.new(1, 0)
		kc.Parent = knob

		local valor = default
		local arrastando = false

		local function Atualizar(posX)
			local a = bgBar.AbsolutePosition.X
			local s = bgBar.AbsoluteSize.X
			local p = math.clamp((posX - a) / s, 0, 1)
			valor = math.floor(min + (max - min) * p)
			vl.Text = tostring(valor) .. (sufixo or "")
			fill.Size = UDim2.new(p, 0, 1, 0)
			knob.Position = UDim2.new(p, -KN/2, 0.5, -KN/2)
			if cb then task.spawn(function() pcall(cb, valor) end) end
		end

		local ip = (default - min) / (max - min)
		fill.Size = UDim2.new(ip, 0, 1, 0)
		knob.Position = UDim2.new(ip, -KN/2, 0.5, -KN/2)

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
	end

	-- ============================================================
	-- SEÇÕES
	-- ============================================================
	Sec("👤 USUÁRIO", infoKey.nivel == "admin" and C.Gold or C.Purple)
	Stat("Nome: " .. (infoKey.nome or "Cliente"), C.Text)
	Stat("Nível: " .. string.upper(infoKey.nivel or "normal"),
		infoKey.nivel == "admin" and C.Gold or (infoKey.nivel == "vip" and C.Purple or C.Green))

	Sec("🗑️ AUTO GARI", C.Green)
	local gariStatus = Stat("Status: PARADO", C.Sub)
	local gariStats = Stat("Coletados: 0 | Entregues: 0", C.Sub)
	local gariLixos = Stat("Lixos usados: 0/0", C.Sub)
	local gariTempo = Stat("Tempo: 00s | Por min: 0", C.Sub)

	local gariOn = false
	local gariCount = {coletados = 0, entregues = 0}
	local tempoInicio = 0

	local setGari = Toggle("Auto Coletar + Entregar", false, function(s)
		gariOn = s
		if s then
			gariStatus.Text = "Status: ● ATIVO"
			gariStatus.TextColor3 = C.Green
			tempoInicio = tick()
			local hum = GetHum()
			if hum then hum.WalkSpeed = velocidadeAtual end

			task.spawn(function()
				while gariOn do
					pcall(function()
						local temLixo = TemLixoNaMao()
						if temLixo then
							gariStatus.Text = (Config.vooAtivo and "✈️ Voando pra TRASEIRA..." or "📤 Indo pra TRASEIRA...")
							local cam = GetCaminhao()
							if not cam then
								gariStatus.Text = "⚠️ Spawne o caminhão!"
								task.wait(2)
								return
							end
							local traseira = GetTraseira(cam)
							if traseira then
								IrAte(traseira.Position, 30, Config.vooAtivo and 5 or 4)
								task.wait(0.5)
								gariStatus.Text = "📤 Entregando..."
								local prompt = GetPrompt(traseira)
								if prompt then
									pcall(function() fireproximityprompt(prompt) end)
									task.wait(0.8)
									if not TemLixoNaMao() then
										gariCount.entregues += 1
										TocarSom("entregou")
									end
								end
							end
						else
							gariStatus.Text = "📥 Procurando lixo..."
							local lixo = AcharProximoLixo()
							if lixo then
								gariStatus.Text = (Config.vooAtivo and "✈️ Voando pro lixo..." or "📥 Indo pro lixo...")
								local ok = IrAte(lixo.Position, 30, Config.vooAtivo and 5 or 4)
								task.wait(0.5)
								if ok then
									gariStatus.Text = "📥 Coletando..."
									local prompt = GetPrompt(lixo)
									if prompt then
										pcall(function() fireproximityprompt(prompt) end)
										task.wait(0.8)
										if TemLixoNaMao() then
											gariCount.coletados += 1
											lixosUsados[lixo] = true
											TocarSom("coletou")
										else
											lixosFalhados[lixo] = true
										end
									else
										lixosFalhados[lixo] = true
									end
								else
									lixosFalhados[lixo] = true
								end
							end
						end

						local usados = 0
						for _ in pairs(lixosUsados) do usados += 1 end
						local falhas = 0
						for _ in pairs(lixosFalhados) do falhas += 1 end

						local total = 0
						local cont = GetLixosContainer()
						if cont then
							for _, v in ipairs(cont:GetChildren()) do
								if v:IsA("BasePart") then total = total + 1 end
							end
						end

						local tempo = tick() - tempoInicio
						local tot = gariCount.coletados + gariCount.entregues
						local porMin = tempo > 0 and math.floor((tot / tempo) * 60) or 0

						gariStats.Text = "Coletados: "..gariCount.coletados.." | Entregues: "..gariCount.entregues
						gariLixos.Text = "Lixos: "..usados.."/"..total..(falhas > 0 and " ("..falhas.." falhas)" or "")
						gariTempo.Text = "Tempo: "..FormatarTempo(tempo).." | "..porMin.."/min"
					end)
					task.wait(1.2)
				end
			end)
		else
			gariStatus.Text = "Status: PARADO"
			gariStatus.TextColor3 = C.Sub
			local hum = GetHum()
			if hum then hum.WalkSpeed = 16 end
		end
	end)

	Sec("🚶 MODO", C.Cyan)
	local setVoo = Toggle("✈️ Voo Suave", Config.vooAtivo, function(s)
		Config.vooAtivo = s
		SalvarConfig()
		if s then IniciarVoo() else PararVoo() end
	end)

	Sec("✈️ AJUSTES DE VOO", C.Cyan)
	Slider(Content, 20, 300, Config.vooVelocidade, function(v) Config.vooVelocidade = v end, "✈️ Velocidade", C.Cyan, "")
	Slider(Content, 3, 60, Config.vooAltura, function(v) Config.vooAltura = v end, "📏 Altura", C.Cyan, "")
	Slider(Content, 1, 10, Config.vooSuavidade, function(v) Config.vooSuavidade = v end, "🌊 Suavidade", C.Cyan, "")

	Sec("⚡ VELOCIDADE A PÉ", C.Yellow)
	Slider(Content, 16, 200, Config.velocidade, function(v)
		velocidadeAtual = v
		Config.velocidade = v
		local hum = GetHum()
		if hum then hum.WalkSpeed = v end
	end, "⚡ Velocidade", C.Yellow, "")

	Sec("👻 NOCLIP", C.Purple)
	local noclipConn
	Toggle("Noclip", false, function(s)
		if s then
			if noclipConn then noclipConn:Disconnect() end
			noclipConn = RunService.Stepped:Connect(function()
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

	Sec("🚨 EMERGÊNCIA", C.Red)
	Btn("🛑 PARAR TUDO", C.Red, function()
		gariOn = false
		setGari(false)
		if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
		PararVoo()
		setVoo(false)
		gariStatus.Text = "Status: PARADO"
		gariStatus.TextColor3 = C.Sub
		local hum = GetHum()
		if hum then hum.WalkSpeed = 16 end
	end)

	-- UI TOGGLE
	local uiAberta = true
	local function FecharUI()
		uiAberta = false
		Tween(Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
		task.wait(0.25)
		Main.Visible = false
		FloatBtn.Text = "⚡"
		Tween(FloatBtn, {BackgroundColor3 = C.Black}, 0.15)
	end
	local function AbrirUI()
		uiAberta = true
		Main.Visible = true
		Main.Size = UDim2.new(0, 0, 0, 0)
		Tween(Main, {Size = UDim2.new(0, UI_W, 0, UI_H)}, 0.25)
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
		elseif input.KeyCode == Enum.KeyCode.F1 then
			gariOn = false
			setGari(false)
			if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
			PararVoo()
			setVoo(false)
			local hum = GetHum()
			if hum then hum.WalkSpeed = 16 end
			FecharUI()
		end
	end)

	local minimizado = false
	MinBtn.MouseButton1Click:Connect(function()
		minimizado = not minimizado
		if minimizado then
			Tween(Main, {Size = UDim2.new(0, UI_W, 0, 56)}, 0.25)
			MinBtn.Text = "+"
		else
			Tween(Main, {Size = UDim2.new(0, UI_W, 0, UI_H)}, 0.25)
			MinBtn.Text = "−"
		end
	end)

	CloseBtn.MouseButton1Click:Connect(function() FecharUI() end)

	-- reconexão
	lp.CharacterAdded:Connect(function()
		task.spawn(function()
			task.wait(2)
			pcall(function()
				local hum = GetHum()
				if hum and gariOn then
					hum.WalkSpeed = velocidadeAtual
					if Config.vooAtivo then IniciarVoo() end
				end
			end)
		end)
	end)

	Log("✅ Auto Gari v" .. SCRIPT_VERSION .. " pronto")
end

-- ============================================================
-- UI DE KEY (leve)
-- ============================================================
local function AbrirUIKey()
	local SG = Instance.new("ScreenGui")
	SG.Name = "SailentKeyUI"
	SG.ResetOnSpawn = false
	SG.IgnoreGuiInset = true
	SG.Parent = CoreGui

	local KW, KH
	if IS_MOBILE then
		local vp = workspace.CurrentCamera.ViewportSize
		KW = math.min(vp.X * 0.92, 400)
		KH = math.min(vp.Y * 0.75, 420)
	else
		KW, KH = 400, 400
	end

	local F = Instance.new("Frame")
	F.Size = UDim2.new(0, KW, 0, KH)
	F.Position = UDim2.new(0.5, -KW/2, 0.5, -KH/2)
	F.BackgroundColor3 = C.BG
	F.BorderSizePixel = 0
	F.Parent = SG
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 14)
	c.Parent = F
	local s = Instance.new("UIStroke")
	s.Color = C.Purple
	s.Thickness = 2
	s.Parent = F

	local T = Instance.new("TextLabel")
	T.Text = "🔐 SAILENT KEY SYSTEM"
	T.Font = Enum.Font.GothamBold
	T.TextSize = IS_MOBILE and 18 or 20
	T.TextColor3 = C.Text
	T.BackgroundTransparency = 1
	T.Size = UDim2.new(1, 0, 0, 50)
	T.Position = UDim2.new(0, 0, 0, 15)
	T.Parent = F

	local Sub = Instance.new("TextLabel")
	Sub.Text = "Digite sua key abaixo"
	Sub.Font = Enum.Font.GothamMedium
	Sub.TextSize = IS_MOBILE and 13 or 12
	Sub.TextColor3 = C.Sub
	Sub.BackgroundTransparency = 1
	Sub.Size = UDim2.new(1, 0, 0, 20)
	Sub.Position = UDim2.new(0, 0, 0, 62)
	Sub.Parent = F

	local HI = IS_MOBILE and 54 or 50
	local HB = IS_MOBILE and 54 or 50
	local P = IS_MOBILE and 20 or 30

	local Input = Instance.new("TextBox")
	Input.PlaceholderText = "SAILENT-XXXX-XXXX-XXXX"
	Input.Font = Enum.Font.Code
	Input.TextSize = IS_MOBILE and 15 or 14
	Input.TextColor3 = C.Text
	Input.PlaceholderColor3 = C.Sub
	Input.BackgroundColor3 = C.Card
	Input.BorderSizePixel = 0
	Input.Size = UDim2.new(1, -P*2, 0, HI)
	Input.Position = UDim2.new(0, P, 0, 95)
	Input.Text = ""
	Input.ClearTextOnFocus = false
	Input.Parent = F
	local ic = Instance.new("UICorner")
	ic.CornerRadius = UDim.new(0, 10)
	ic.Parent = Input

	local H = Instance.new("TextLabel")
	H.Text = "HWID: " .. GetHWID():sub(1,16) .. "..."
	H.Font = Enum.Font.Code
	H.TextSize = IS_MOBILE and 11 or 10
	H.TextColor3 = C.Sub
	H.BackgroundTransparency = 1
	H.Size = UDim2.new(1, -P*2, 0, 18)
	H.Position = UDim2.new(0, P, 0, 95 + HI + 8)
	H.Parent = F

	local St = Instance.new("TextLabel")
	St.Text = "Status: ● Aguardando"
	St.Font = Enum.Font.GothamBold
	St.TextSize = IS_MOBILE and 13 or 12
	St.TextColor3 = C.Yellow
	St.BackgroundTransparency = 1
	St.Size = UDim2.new(1, -P*2, 0, 20)
	St.Position = UDim2.new(0, P, 0, 95 + HI + 32)
	St.Parent = F

	local VB = Instance.new("TextButton")
	VB.Text = "🔓 VALIDAR KEY"
	VB.Font = Enum.Font.GothamBold
	VB.TextSize = IS_MOBILE and 16 or 15
	VB.TextColor3 = C.Text
	VB.BackgroundColor3 = C.Green
	VB.BorderSizePixel = 0
	VB.Size = UDim2.new(1, -P*2, 0, HB)
	VB.Position = UDim2.new(0, P, 0, 95 + HI + 60)
	VB.AutoButtonColor = false
	VB.Parent = F
	local vc = Instance.new("UICorner")
	vc.CornerRadius = UDim.new(0, 10)
	vc.Parent = VB

	local CB = Instance.new("TextButton")
	CB.Text = "📋 Copiar HWID"
	CB.Font = Enum.Font.GothamBold
	CB.TextSize = IS_MOBILE and 12 or 11
	CB.TextColor3 = C.Text
	CB.BackgroundColor3 = C.Card
	CB.BorderSizePixel = 0
	CB.Size = UDim2.new(1, -P*2, 0, HB - 10)
	CB.Position = UDim2.new(0, P, 0, 95 + HI + 60 + HB + 10)
	CB.AutoButtonColor = false
	CB.Parent = F
	local cbc = Instance.new("UICorner")
	cbc.CornerRadius = UDim.new(0, 8)
	cbc.Parent = CB

	CB.MouseButton1Click:Connect(function()
		pcall(function() if setclipboard then setclipboard(GetHWID()) end end)
		CB.Text = "✅ Copiado!"
		task.wait(1.5)
		CB.Text = "📋 Copiar HWID"
	end)

	local Inf = Instance.new("TextLabel")
	Inf.Text = "Se não tiver key, fale com o dono"
	Inf.Font = Enum.Font.GothamMedium
	Inf.TextSize = IS_MOBILE and 12 or 11
	Inf.TextColor3 = C.Sub
	Inf.BackgroundTransparency = 1
	Inf.Size = UDim2.new(1, -P*2, 0, 20)
	Inf.Position = UDim2.new(0, P, 0, 95 + HI + 60 + HB + 60)
	Inf.Parent = F

	VB.MouseEnter:Connect(function()
		Tween(VB, {BackgroundColor3 = Color3.fromRGB(100, 240, 140)}, 0.15)
	end)
	VB.MouseLeave:Connect(function()
		Tween(VB, {BackgroundColor3 = C.Green}, 0.15)
	end)

	local validando = false
	VB.MouseButton1Click:Connect(function()
		if validando then return end
		local key = Input.Text
		if key == "" then
			St.Text = "Status: ❌ Digite a key"
			St.TextColor3 = C.Red
			return
		end
		validando = true
		St.Text = "Status: ⏳ Validando..."
		St.TextColor3 = C.Yellow

		task.spawn(function()
			local valida, info, hash = ValidarKey(key)
			validando = false

			if valida then
				St.Text = "Status: ✅ Key válida!"
				St.TextColor3 = C.Green
				Inf.Text = "Bem-vindo, " .. (info.nome or "Cliente") .. "!"
				SalvarKey(hash or key)
				task.wait(1.5)
				SG:Destroy()
				AbrirAutoGari(info)
			else
				St.Text = "Status: ❌ " .. tostring(info or "Erro")
				St.TextColor3 = C.Red
			end
		end)
	end)
end

-- ============================================================
-- INICIAR (com loading)
-- ============================================================
task.spawn(function()
	local loading = CriarLoading("🔐 Verificando key...")

	task.wait(0.3)

	local keySalva, hwidSalvo = TemKeySalva()

	if keySalva then
		if hwidSalvo and hwidSalvo ~= "" and hwidSalvo ~= GetHWID() then
			LimparKeySalva()
		else
			local valida, info = ValidarKey(keySalva)
			if valida then
				loading:Destroy()
				AbrirAutoGari(info)
				return
			else
				LimparKeySalva()
			end
		end
	end

	loading:Destroy()
	AbrirUIKey()
end)

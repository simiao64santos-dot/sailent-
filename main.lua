-- ============================================================
-- SAILENT AUTO GARI v6.4 — VOO SUAVE + KEY NOVA
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
-- CONFIG — LINK DO GITHUB
-- ============================================================
local GITHUB_URL = "https://raw.githubusercontent.com/simiao64santos-dot/sailent-/refs/heads/main/keys.json"
local SAVE_FILE = "sailent_key_salva.txt"
local KEY_DURACAO_LOCAL = 24 * 60 * 60

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
	Cyan = Color3.fromRGB(80,220,240),
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

-- ============================================================
-- SHA-256 (para o sistema de key)
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
-- SISTEMA DE KEY
-- ============================================================
local function TemKeySalva()
	local dados
	pcall(function()
		if isfile and isfile(SAVE_FILE) and readfile then
			dados = readfile(SAVE_FILE)
		end
	end)
	if not dados or dados == "" then return nil end
	local key, expira, hwid = dados:match("([^|]+)|(%d+)|(.*)")
	if key and expira then
		expira = tonumber(expira)
		if expira and os.time() < expira then return key, hwid end
	end
	return nil
end

local function SalvarKey(key)
	pcall(function()
		if writefile then
			writefile(SAVE_FILE, key .. "|" .. (os.time() + KEY_DURACAO_LOCAL) .. "|" .. GetHWID())
		end
	end)
end

local function LimparKeySalva()
	pcall(function()
		if delfile and isfile and isfile(SAVE_FILE) then delfile(SAVE_FILE) end
	end)
end

local function BaixarKeys()
	local ok, resultado = pcall(function()
		return game:HttpGet(GITHUB_URL, true)
	end)
	if not ok or not resultado then return nil, "Erro ao baixar" end

	local ok2, dados = pcall(function()
		return HttpService:JSONDecode(resultado)
	end)
	if not ok2 or not dados then return nil, "Erro no JSON" end
	return dados
end

local function ValidarKey(key)
	if not key or key == "" then return false, "Key vazia" end

	local hashKey = sha256(key)
	local dados, erro = BaixarKeys()
	if not dados then return false, erro end
	if not dados.keys then return false, "Keys não encontradas" end

	-- procura pelo hash (novo) ou pelo texto (compatibilidade)
	local info = dados.keys[hashKey] or dados.keys[key]
	if not info then return false, "Key inválida" end
	if info.status ~= "ativa" then return false, "Key bloqueada" end
	if info.expira and tonumber(info.expira) and os.time() > tonumber(info.expira) then
		return false, "Key expirada"
	end

	local meuHwid = GetHWID()
	if info.hwid and info.hwid ~= "" and info.hwid ~= meuHwid then
		return false, "Key vinculada a outro dispositivo"
	end

	return true, info, hashKey
end

-- ============================================================
-- FUNÇÃO QUE ABRE O AUTO GARI
-- ============================================================
local function AbrirAutoGari(infoKey)
	infoKey = infoKey or {nome = "Cliente", nivel = "normal"}

	local CONFIG_FILE = "sailent_gari_config.txt"
	local Config = {
		velocidade = 100,
		noclip = false,
		autoGari = false,
		somAtivo = true,
		vooAtivo = false,
		vooVelocidade = 80,
		vooAltura = 12,
		vooSuavidade = 3,
	}

	local function SalvarConfig()
		local str = ""
		for k, v in pairs(Config) do
			str = str .. k .. "=" .. tostring(v) .. "\n"
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
			task.delay(2, function() s:Destroy() end)
		end)
	end

	-- ============================================================
	-- SISTEMA DE VOO SUAVE
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
			task.wait(0.1)
		end
		return false
	end

	-- ============================================================
	-- ANDAR A PÉ
	-- ============================================================
	local function AndarAte(posAlvo, timeout, distParada)
		if not posAlvo then return false end
		local hrp = GetHRP()
		local hum = GetHum()
		if not hrp or not hum then return false end
		timeout = timeout or 30
		distParada = distParada or 4
		local t0 = tick()
		local ultimaPos = hrp.Position
		local tempoParado = 0
		local tentativas = 0
		hum:MoveTo(posAlvo)

		while tick() - t0 < timeout do
			local h = GetHRP()
			if not h then return false end
			local diff = Vector3.new(h.Position.X - posAlvo.X, 0, h.Position.Z - posAlvo.Z)
			if diff.Magnitude < distParada then
				hum:MoveTo(h.Position)
				return true
			end

			local moveu = (h.Position - ultimaPos).Magnitude
			if moveu < 0.5 then
				tempoParado = tempoParado + 0.1
				if tempoParado > 1.5 then
					tentativas = tentativas + 1
					pcall(function() hum.Jump = true end)
					task.wait(0.3)
					hum:MoveTo(posAlvo)
					tempoParado = 0
					if tentativas >= 3 then return false end
				end
			else
				tempoParado = 0
			end

			ultimaPos = h.Position
			hum:MoveTo(posAlvo)
			task.wait(0.1)
		end
		return false
	end

	-- ============================================================
	-- IR ATÉ (voo ou pé)
	-- ============================================================
	local function IrAte(posAlvo, timeout, distParada)
		if Config.vooAtivo then
			return VoarAte(posAlvo, timeout, distParada or 5)
		else
			return AndarAte(posAlvo, timeout, distParada or 4)
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
		local disp = {}
		for _, lixo in ipairs(cont:GetChildren()) do
			if lixo:IsA("BasePart") and not lixosUsados[lixo] then
				table.insert(disp, {lixo = lixo, dist = (lixo.Position - hrp.Position).Magnitude})
			end
		end
		if #disp == 0 then
			TocarSom("reset")
			lixosUsados = {}
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

	-- BOTÃO FLUTUANTE
	local SGBtn = Instance.new("ScreenGui")
	SGBtn.Name = "SailentFloatBtn"
	SGBtn.ResetOnSpawn = false
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
	BtnStroke.Color = infoKey.nivel == "admin" and Color3.fromRGB(255,215,0) or (infoKey.nivel == "vip" and C.Purple or C.Green)
	BtnStroke.Thickness = 2
	BtnStroke.Parent = FloatBtn

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
			if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then btnMoveuSe = true end
			FloatBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
		end
	end)
	UserInput.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			btnDragging = false
		end
	end)

	-- UI PRINCIPAL
	local SG = Instance.new("ScreenGui")
	SG.Name = "SailentGari"
	SG.ResetOnSpawn = false
	SG.IgnoreGuiInset = true
	SG.Parent = CoreGui

	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0, 400, 0, 640)
	Main.Position = UDim2.new(0.5, -200, 0.5, -320)
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
	TTitle.Text = "Auto Gari v6.4"
	TTitle.Font = Enum.Font.GothamBold
	TTitle.TextSize = 16
	TTitle.TextColor3 = C.Text
	TTitle.BackgroundTransparency = 1
	TTitle.Position = UDim2.new(0, 55, 0, 0)
	TTitle.Size = UDim2.new(0, 160, 1, 0)
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

	local function CriarSlider(parent, min, max, default, callback, tituloTexto, corTitulo)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 58)
		frame.BackgroundColor3 = C.Card
		frame.BorderSizePixel = 0
		frame.Parent = parent
		local fc = Instance.new("UICorner")
		fc.CornerRadius = UDim.new(0, 8)
		fc.Parent = frame

		local titulo = Instance.new("TextLabel")
		titulo.Text = tituloTexto or "⚡ Valor"
		titulo.Font = Enum.Font.GothamBold
		titulo.TextSize = 12
		titulo.TextColor3 = corTitulo or C.Text
		titulo.BackgroundTransparency = 1
		titulo.Position = UDim2.new(0, 12, 0, 6)
		titulo.Size = UDim2.new(0.7, 0, 0, 18)
		titulo.TextXAlignment = Enum.TextXAlignment.Left
		titulo.Parent = frame

		local valorLabel = Instance.new("TextLabel")
		valorLabel.Text = tostring(default)
		valorLabel.Font = Enum.Font.GothamBold
		valorLabel.TextSize = 14
		valorLabel.TextColor3 = corTitulo or C.Green
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
		fillBar.BackgroundColor3 = corTitulo or C.Green
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
			if bgSize == 0 then return end
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
					SalvarConfig()
				end
			end
		end)
	end

	Sec("👤 USUÁRIO", infoKey.nivel == "admin" and Color3.fromRGB(255,215,0) or C.Purple)
	Stat("Nome: " .. (infoKey.nome or "Cliente"), C.Text)
	Stat("Nível: " .. string.upper(infoKey.nivel or "normal"),
		infoKey.nivel == "admin" and Color3.fromRGB(255,215,0) or (infoKey.nivel == "vip" and C.Purple or C.Green))

	Sec("🗑️ AUTO GARI", C.Green)
	local gariStatus = Stat("Status: PARADO", C.Sub)
	local gariStats = Stat("Coletados: 0 | Entregues: 0", C.Sub)
	local gariLixos = Stat("Lixos usados: 0/39", C.Sub)

	local gariOn = false
	local gariCount = {coletados = 0, entregues = 0}

	local setGariAtivo
	setGariAtivo = Toggle("Auto Coletar + Entregar", false, function(s)
		gariOn = s
		if s then
			gariStatus.Text = "Status: ● ATIVO"
			gariStatus.TextColor3 = C.Green
			local hum = GetHum()
			if hum then hum.WalkSpeed = velocidadeAtual end

			task.spawn(function()
				while gariOn do
					local temLixo = TemLixoNaMao()

					if temLixo then
						gariStatus.Text = (Config.vooAtivo and "✈️ Voando pra TRASEIRA..." or "📤 Indo pra TRASEIRA...")
						local cam = GetCaminhao()
						if not cam then
							gariStatus.Text = "⚠️ Spawne o caminhão!"
							task.wait(2)
							continue
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
							IrAte(lixo.Position, 30, Config.vooAtivo and 5 or 4)
							task.wait(0.5)
							gariStatus.Text = "📥 Coletando..."
							local prompt = GetPrompt(lixo)
							if prompt then
								pcall(function() fireproximityprompt(prompt) end)
								task.wait(0.8)
								if TemLixoNaMao() then
									gariCount.coletados += 1
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

	Sec("🚶 MODO DE MOVIMENTO", C.Cyan)
	Stat("A pé pega o lixo normal. Voo é mais rápido e ignora obstáculos.", C.Sub)

	local setVooAtivo
	setVooAtivo = Toggle("✈️ Voo Suave (ignora obstáculos)", Config.vooAtivo, function(s)
		Config.vooAtivo = s
		SalvarConfig()
		if s then IniciarVoo() else PararVoo() end
	end)

	Sec("✈️ AJUSTES DE VOO", C.Cyan)

	CriarSlider(Content, 20, 300, Config.vooVelocidade, function(v)
		Config.vooVelocidade = v
	end, "✈️ Velocidade de voo", C.Cyan)

	CriarSlider(Content, 3, 60, Config.vooAltura, function(v)
		Config.vooAltura = v
	end, "📏 Altura do voo", C.Cyan)

	CriarSlider(Content, 1, 10, Config.vooSuavidade, function(v)
		Config.vooSuavidade = v
	end, "🌊 Suavidade", C.Cyan)

	Sec("⚡ VELOCIDADE A PÉ", C.Yellow)
	CriarSlider(Content, 16, 200, Config.velocidade, function(valor)
		velocidadeAtual = valor
		Config.velocidade = valor
		local hum = GetHum()
		if hum then hum.WalkSpeed = valor end
	end, "⚡ Velocidade", C.Yellow)

	Sec("👻 NOCLIP", C.Purple)
	local noclipOn = false
	local noclipConn

	Toggle("Noclip (atravessar paredes)", false, function(s)
		noclipOn = s
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

	Sec("🚨 EMERGÊNCIA", C.Red)
	Btn("🛑 PARAR TUDO", C.Red, function()
		gariOn = false
		setGariAtivo(false)
		noclipOn = false
		if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
		PararVoo()
		setVooAtivo(false)
		gariStatus.Text = "Status: PARADO"
		gariStatus.TextColor3 = C.Sub
		local hum = GetHum()
		if hum then hum.WalkSpeed = 16 end
	end)

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
		Tween(Main, {Size = UDim2.new(0, 400, 0, 640)}, 0.25)
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
			setGariAtivo(false)
			noclipOn = false
			if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
			PararVoo()
			setVooAtivo(false)
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
			Tween(Main, {Size = UDim2.new(0, 400, 0, 640)}, 0.25)
			MinBtn.Text = "−"
		end
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		FecharUI()
	end)

	Log("═══════════════════════════════════")
	Log("🗑️ Sailent Auto Gari v6.4 — VOO + KEY")
	Log("═══════════════════════════════════")
end

-- ============================================================
-- UI DE KEY
-- ============================================================
local function AbrirUIKey()
	local SGScreen = Instance.new("ScreenGui")
	SGScreen.Name = "SailentKeyUI"
	SGScreen.ResetOnSpawn = false
	SGScreen.IgnoreGuiInset = true
	SGScreen.Parent = CoreGui

	local KeyFrame = Instance.new("Frame")
	KeyFrame.Size = UDim2.new(0, 400, 0, 400)
	KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -200)
	KeyFrame.BackgroundColor3 = C.BG
	KeyFrame.BorderSizePixel = 0
	KeyFrame.Parent = SGScreen

	local MC = Instance.new("UICorner")
	MC.CornerRadius = UDim.new(0, 14)
	MC.Parent = KeyFrame

	local MS = Instance.new("UIStroke")
	MS.Color = C.Purple
	MS.Thickness = 2
	MS.Parent = KeyFrame

	local Titulo = Instance.new("TextLabel")
	Titulo.Text = "🔐 SAILENT GERAL KEY"
	Titulo.Font = Enum.Font.GothamBold
	Titulo.TextSize = 20
	Titulo.TextColor3 = C.Text
	Titulo.BackgroundTransparency = 1
	Titulo.Size = UDim2.new(1, 0, 0, 50)
	Titulo.Position = UDim2.new(0, 0, 0, 20)
	Titulo.Parent = KeyFrame

	local Sub = Instance.new("TextLabel")
	Sub.Text = "Digite sua key abaixo"
	Sub.Font = Enum.Font.GothamMedium
	Sub.TextSize = 12
	Sub.TextColor3 = C.Sub
	Sub.BackgroundTransparency = 1
	Sub.Size = UDim2.new(1, 0, 0, 20)
	Sub.Position = UDim2.new(0, 0, 0, 70)
	Sub.Parent = KeyFrame

	local KeyInput = Instance.new("TextBox")
	KeyInput.PlaceholderText = "SAILENT-XXXX-XXXX-XXXX"
	KeyInput.Font = Enum.Font.Code
	KeyInput.TextSize = 14
	KeyInput.TextColor3 = C.Text
	KeyInput.PlaceholderColor3 = C.Sub
	KeyInput.BackgroundColor3 = C.Card
	KeyInput.BorderSizePixel = 0
	KeyInput.Size = UDim2.new(1, -60, 0, 50)
	KeyInput.Position = UDim2.new(0, 30, 0, 110)
	KeyInput.Text = ""
	KeyInput.ClearTextOnFocus = false
	KeyInput.Parent = KeyFrame

	local IC = Instance.new("UICorner")
	IC.CornerRadius = UDim.new(0, 10)
	IC.Parent = KeyInput

	local HWIDLabel = Instance.new("TextLabel")
	HWIDLabel.Text = "Seu HWID: " .. GetHWID():sub(1,16) .. "..."
	HWIDLabel.Font = Enum.Font.Code
	HWIDLabel.TextSize = 10
	HWIDLabel.TextColor3 = C.Sub
	HWIDLabel.BackgroundTransparency = 1
	HWIDLabel.Size = UDim2.new(1, -60, 0, 18)
	HWIDLabel.Position = UDim2.new(0, 30, 0, 168)
	HWIDLabel.Parent = KeyFrame

	local Status = Instance.new("TextLabel")
	Status.Text = "Status: ● Aguardando"
	Status.Font = Enum.Font.GothamBold
	Status.TextSize = 12
	Status.TextColor3 = C.Yellow
	Status.BackgroundTransparency = 1
	Status.Size = UDim2.new(1, -60, 0, 20)
	Status.Position = UDim2.new(0, 30, 0, 195)
	Status.Parent = KeyFrame

	local ValidarBtn = Instance.new("TextButton")
	ValidarBtn.Text = "🔓 VALIDAR KEY"
	ValidarBtn.Font = Enum.Font.GothamBold
	ValidarBtn.TextSize = 15
	ValidarBtn.TextColor3 = C.Text
	ValidarBtn.BackgroundColor3 = C.Green
	ValidarBtn.BorderSizePixel = 0
	ValidarBtn.Size = UDim2.new(1, -60, 0, 50)
	ValidarBtn.Position = UDim2.new(0, 30, 0, 225)
	ValidarBtn.AutoButtonColor = false
	ValidarBtn.Parent = KeyFrame

	local VC = Instance.new("UICorner")
	VC.CornerRadius = UDim.new(0, 10)
	VC.Parent = ValidarBtn

	local CopiarBtn = Instance.new("TextButton")
	CopiarBtn.Text = "📋 Copiar HWID"
	CopiarBtn.Font = Enum.Font.GothamBold
	CopiarBtn.TextSize = 11
	CopiarBtn.TextColor3 = C.Text
	CopiarBtn.BackgroundColor3 = C.Card
	CopiarBtn.BorderSizePixel = 0
	CopiarBtn.Size = UDim2.new(1, -60, 0, 32)
	CopiarBtn.Position = UDim2.new(0, 30, 0, 290)
	CopiarBtn.AutoButtonColor = false
	CopiarBtn.Parent = KeyFrame

	local CCopiar = Instance.new("UICorner")
	CCopiar.CornerRadius = UDim.new(0, 8)
	CCopiar.Parent = CopiarBtn

	CopiarBtn.MouseButton1Click:Connect(function()
		pcall(function() if setclipboard then setclipboard(GetHWID()) end end)
		CopiarBtn.Text = "✅ Copiado!"
		task.wait(1.5)
		CopiarBtn.Text = "📋 Copiar HWID"
	end)

	local Info = Instance.new("TextLabel")
	Info.Text = "Se não tiver key, fale com o dono"
	Info.Font = Enum.Font.GothamMedium
	Info.TextSize = 11
	Info.TextColor3 = C.Sub
	Info.BackgroundTransparency = 1
	Info.Size = UDim2.new(1, -60, 0, 20)
	Info.Position = UDim2.new(0, 30, 0, 335)
	Info.Parent = KeyFrame

	ValidarBtn.MouseEnter:Connect(function()
		Tween(ValidarBtn, {BackgroundColor3 = Color3.fromRGB(100, 240, 140)}, 0.15)
	end)
	ValidarBtn.MouseLeave:Connect(function()
		Tween(ValidarBtn, {BackgroundColor3 = C.Green}, 0.15)
	end)

	ValidarBtn.MouseButton1Click:Connect(function()
		local key = KeyInput.Text
		if key == "" then
			Status.Text = "Status: ❌ Digite a key"
			Status.TextColor3 = C.Red
			return
		end

		Status.Text = "Status: ⏳ Validando..."
		Status.TextColor3 = C.Yellow

		local valida, info, hash = ValidarKey(key)

		if valida then
			Status.Text = "Status: ✅ Key válida!"
			Status.TextColor3 = C.Green
			Info.Text = "Bem-vindo, " .. (info.nome or "Cliente") .. "!"
			SalvarKey(hash or key)
			task.wait(1.5)
			SGScreen:Destroy()
			AbrirAutoGari(info)
		else
			Status.Text = "Status: ❌ " .. (info or "Erro")
			Status.TextColor3 = C.Red
		end
	end)
end

-- ============================================================
-- INICIAR
-- ============================================================
task.spawn(function()
	local keySalva, hwidSalvo = TemKeySalva()

	if keySalva then
		Log("🔐 Key salva encontrada, validando...")
		if hwidSalvo and hwidSalvo ~= "" and hwidSalvo ~= GetHWID() then
			Log("⚠️ HWID diferente, limpando...")
			LimparKeySalva()
		else
			local valida, info = ValidarKey(keySalva)
			if valida then
				Log("✅ Key salva válida!")
				AbrirAutoGari(info)
				return
			else
				Log("⚠️ " .. tostring(info))
				LimparKeySalva()
			end
		end
	end

	Log("🔐 Precisa validar key")
	AbrirUIKey()
end)

-- ============================================================
-- SAILENT AUTO GARI v7.3 — PC + MOBILE + VOO SUAVE
-- ============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local lp = Players.LocalPlayer

-- ============================================================
-- CONFIG
-- ============================================================
local GITHUB_URL = "https://raw.githubusercontent.com/simiao64santos-dot/sailent-/refs/heads/main/keys.json"
local SAVE_FILE = "sailent_key_salva.txt"
local CACHE_FILE = "sailent_keys_cache.json"
local CONFIG_FILE = "sailent_gari_config.txt"
local KEY_DURACAO_LOCAL = 24 * 60 * 60
local CACHE_DURACAO = 6 * 60 * 60
local SCRIPT_VERSION = "7.3"

-- ============================================================
-- DETECÇÃO DE MOBILE
-- ============================================================
local IS_MOBILE = UserInput.TouchEnabled and not UserInput.KeyboardEnabled
local IS_TABLET = IS_MOBILE and workspace.CurrentCamera.ViewportSize.X >= 700

for _, name in ipairs({"SailentGari", "SailentFloatBtn", "SailentKeyUI"}) do
	if CoreGui:FindFirstChild(name) then CoreGui[name]:Destroy() end
end

local C = {
	BG = Color3.fromRGB(12,12,18),
	Card = Color3.fromRGB(25,25,35),
	CardHover = Color3.fromRGB(35,35,48),
	Accent = Color3.fromRGB(80,220,120),
	Text = Color3.fromRGB(240,240,245),
	Sub = Color3.fromRGB(150,150,165),
	Green = Color3.fromRGB(80,220,120),
	Red = Color3.fromRGB(230,70,80),
	Yellow = Color3.fromRGB(255,200,80),
	Blue = Color3.fromRGB(80,160,240),
	Purple = Color3.fromRGB(180,120,255),
	Black = Color3.fromRGB(10, 10, 15),
	Gold = Color3.fromRGB(255,215,0),
	Cyan = Color3.fromRGB(80,220,240),
}

-- ============================================================
-- UTILS
-- ============================================================
local function Tween(o, p, t)
	local tw = TweenService:Create(o, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint), p)
	tw:Play()
	return tw
end

local function Log(msg)
	print("[Sailent] " .. tostring(msg))
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

local function FormatarTempo(seg)
	seg = math.floor(seg)
	local h = math.floor(seg / 3600)
	local m = math.floor((seg % 3600) / 60)
	local s = seg % 60
	if h > 0 then return string.format("%dh %dm %ds", h, m, s) end
	if m > 0 then return string.format("%dm %ds", m, s) end
	return string.format("%ds", s)
end

-- ============================================================
-- SHA-256
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
	local function pad(s)
		local l = #s * 8
		s = s .. "\128"
		while #s % 64 ~= 56 do s = s .. "\0" end
		for i = 7, 0, -1 do s = s .. string.char((l >> (i*8)) & 0xff) end
		return s
	end
	local function uint32(x) return x & 0xffffffff end
	local padded = pad(msg)
	for ci = 0, (#padded / 64) - 1 do
		local chunk = padded:sub(ci*64+1, ci*64+64)
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
	pcall(function() parts[#parts+1] = game:GetService("RbxAnalyticsService"):GetClientId() end)
	cachedHwid = sha256(table.concat(parts, "|")):sub(1, 32)
	return cachedHwid
end

-- ============================================================
-- ARQUIVOS
-- ============================================================
local function SafeReadFile(path)
	local ok, data = pcall(function()
		if isfile and isfile(path) and readfile then return readfile(path) end
	end)
	if ok and data and data ~= "" then return data end
	return nil
end

local function SafeWriteFile(path, content)
	pcall(function() if writefile then writefile(path, content) end end)
end

local function SafeDeleteFile(path)
	pcall(function() if delfile and isfile and isfile(path) then delfile(path) end end)
end

-- ============================================================
-- SISTEMA DE KEY
-- ============================================================
local function TemKeySalva()
	local dados = SafeReadFile(SAVE_FILE)
	if not dados then return nil end
	local key, expira, hwid = dados:match("([^|]+)|(%d+)|(.*)")
	if key and expira then
		expira = tonumber(expira)
		if expira and os.time() < expira then return key, hwid end
	end
	return nil
end

local function SalvarKey(key)
	local hwid = GetHWID()
	SafeWriteFile(SAVE_FILE, key .. "|" .. (os.time() + KEY_DURACAO_LOCAL) .. "|" .. hwid)
end

local function LimparKeySalva() SafeDeleteFile(SAVE_FILE) end

local function BaixarKeys()
	local cache = SafeReadFile(CACHE_FILE)
	if cache then
		local ok, dados = pcall(function() return HttpService:JSONDecode(cache) end)
		if ok and dados and dados._cached_at and (os.time() - dados._cached_at) < CACHE_DURACAO then
			return dados, true
		end
	end
	local ok, resultado = pcall(function() return game:HttpGet(GITHUB_URL, true) end)
	if not ok or not resultado or resultado == "" then
		if cache then
			local ok2, dados = pcall(function() return HttpService:JSONDecode(cache) end)
			if ok2 and dados then return dados, true end
		end
		return nil, "Erro ao baixar keys"
	end
	local ok2, dados = pcall(function() return HttpService:JSONDecode(resultado) end)
	if not ok2 or not dados then
		if cache then
			local ok3, dados2 = pcall(function() return HttpService:JSONDecode(cache) end)
			if ok3 and dados2 then return dados2, true end
		end
		return nil, "Erro no JSON"
	end
	dados._cached_at = os.time()
	SafeWriteFile(CACHE_FILE, HttpService:JSONEncode(dados))
	return dados, false
end

local function ValidarKey(key)
	if not key or key == "" then return false, "Key vazia" end
	local hashKey = sha256(key)
	local dados, erro = BaixarKeys()
	if not dados then return false, erro or "Erro de conexão" end
	if not dados.keys then return false, "Keys não encontradas" end
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
	if info.max_usos and info.max_usos > 0 then
		if (info.usos or 0) >= info.max_usos then
			return false, "Limite de usos atingido"
		end
	end
	return true, info, hashKey
end

-- ============================================================
-- ABRIR AUTO GARI
-- ============================================================
local function AbrirAutoGari(infoKey)
	infoKey = infoKey or {nome = "Cliente", nivel = "normal"}

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
		SafeWriteFile(CONFIG_FILE, str)
	end

	local function CarregarConfig()
		local str = SafeReadFile(CONFIG_FILE)
		if not str then return end
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
	CarregarConfig()

	local function TocarSom(tipo)
		if not Config.somAtivo then return end
		pcall(function()
			local s = Instance.new("Sound")
			s.Parent = SoundService
			if tipo == "coletou" then s.SoundId = "rbxassetid://4612375230"
			elseif tipo == "entregou" then s.SoundId = "rbxassetid://4612384334"
			elseif tipo == "reset" then s.SoundId = "rbxassetid://6042053626"
			elseif tipo == "travou" then s.SoundId = "rbxassetid://6042053626" end
			s.Volume = 0.5
			s:Play()
			task.delay(2, function() s:Destroy() end)
		end)
	end

	-- ============================================================
	-- SISTEMA DE VOO SUAVE
	-- ============================================================
	local BodyVelocityVoo = nil
	local BodyGyroVoo = nil
	local voando = false

	local function IniciarVoo()
		local hrp = GetHRP()
		if not hrp then return false end

		-- limpa
		if hrp:FindFirstChild("SailentVooVel") then hrp.SailentVooVel:Destroy() end
		if hrp:FindFirstChild("SailentVooGyro") then hrp.SailentVooGyro:Destroy() end

		-- BodyVelocity (movimento suave)
		local bv = Instance.new("BodyVelocity")
		bv.Name = "SailentVooVel"
		bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bv.Velocity = Vector3.zero
		bv.P = 1250
		bv.Parent = hrp
		BodyVelocityVoo = bv

		-- BodyGyro (mantém orientação estável)
		local bg = Instance.new("BodyGyro")
		bg.Name = "SailentVooGyro"
		bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
		bg.P = 3000
		bg.D = 100
		bg.CFrame = hrp.CFrame
		bg.Parent = hrp
		BodyGyroVoo = bg

		-- desativa física de queda do Humanoid
		local hum = GetHum()
		if hum then
			hum.PlatformStand = false
		end

		voando = true
		return true
	end

	local function PararVoo()
		voando = false
		local hrp = GetHRP()
		if hrp then
			local bv = hrp:FindFirstChild("SailentVooVel")
			if bv then bv:Destroy() end
			local bg = hrp:FindFirstChild("SailentVooGyro")
			if bg then bg:Destroy() end
		end
		BodyVelocityVoo = nil
		BodyGyroVoo = nil
	end

	-- ============================================================
	-- VOAR ATÉ (suave, com desaceleração)
	-- ============================================================
	local function VoarAte(posAlvo, timeout, distParada)
		if not posAlvo then return false end
		local hrp = GetHRP()
		local hum = GetHum()
		if not hrp or not hum then return false end

		timeout = timeout or 30
		distParada = distParada or 5

		-- garante que o voo está ativo
		if not BodyVelocityVoo or not BodyVelocityVoo.Parent then
			IniciarVoo()
		end

		local velocidadeVoo = Config.vooVelocidade or 80
		local alturaVoo = Config.vooAltura or 12
		local suavidade = Config.vooSuavidade or 3

		-- destino com altura
		local destino = Vector3.new(posAlvo.X, posAlvo.Y + alturaVoo, posAlvo.Z)

		local t0 = tick()
		local ultimaPos = hrp.Position
		local tempoParado = 0

		while tick() - t0 < timeout do
			local h = GetHRP()
			if not h then return false end

			local posAtual = h.Position
			local diff = destino - posAtual
			local dist = diff.Magnitude

			-- Verifica se chegou
			local diffPlano = Vector3.new(posAtual.X - posAlvo.X, 0, posAtual.Z - posAlvo.Z)
			if diffPlano.Magnitude < distParada then
				-- desacelera
				if BodyVelocityVoo then
					BodyVelocityVoo.Velocity = BodyVelocityVoo.Velocity * 0.5
					task.wait(0.1)
					BodyVelocityVoo.Velocity = Vector3.zero
				end
				return true
			end

			-- Desaceleração perto do destino (evita passar reto)
			local fator = math.clamp(dist / 30, 0.3, 1)
			local velFinal = diff.Unit * velocidadeVoo * fator

			-- suavização (interpola velocidade)
			if BodyVelocityVoo then
				local velAtual = BodyVelocityVoo.Velocity
				local novaVel = velAtual:Lerp(velFinal, math.clamp(suavidade * 0.1, 0.05, 0.5))
				BodyVelocityVoo.Velocity = novaVel
			end

			-- atualiza Gyro pra olhar pro destino
			if BodyGyroVoo then
				local dir = Vector3.new(diff.X, 0, diff.Z)
				if dir.Magnitude > 1 then
					local look = CFrame.new(posAtual, posAtual + dir.Unit)
					BodyGyroVoo.CFrame = BodyGyroVoo.CFrame:Lerp(look, 0.15)
				end
			end

			-- Anti-travamento
			local moveu = (posAtual - ultimaPos).Magnitude
			if moveu < 0.5 then
				tempoParado = tempoParado + 0.1
				if tempoParado > 1.5 then
					-- tenta subir mais pra desviar
					if BodyVelocityVoo then
						BodyVelocityVoo.Velocity = Vector3.new(0, velocidadeVoo * 0.6, 0)
					end
					task.wait(0.3)
					tempoParado = 0
				end
			else
				tempoParado = 0
			end

			ultimaPos = posAtual
			task.wait(0.05)
		end
		return false
	end

	-- ============================================================
	-- ANDAR A PÉ COM ANTI-TRAVAMENTO
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
		local tentativasTravou = 0

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
					tentativasTravou = tentativasTravou + 1
					TocarSom("travou")
					hum.Jump = true
					task.wait(0.3)
					hum:MoveTo(posAlvo)
					tempoParado = 0
					if tentativasTravou >= 3 then
						Log("⚠️ Travou 3x ao ir pra " .. tostring(posAlvo))
						return false
					end
				end
			else
				tempoParado = 0
				tentativasTravou = 0
			end

			ultimaPos = h.Position
			hum:MoveTo(posAlvo)
			task.wait(0.1)
		end
		return false
	end

	-- ============================================================
	-- IR ATÉ (escolhe voo ou a pé baseado no toggle)
	-- ============================================================
	local function IrAte(posAlvo, timeout, distParada)
		if Config.vooAtivo then
			return VoarAte(posAlvo, timeout, distParada or 5)
		else
			return AndarAte(posAlvo, timeout, distParada or 4)
		end
	end

	local lixosUsados = {}
	local lixosFalhados = {}

	-- ============================================================
	-- DETECÇÃO DE LIXO
	-- ============================================================
	local function GetLixosContainer()
		local caminhos = {
			{"Construcoes", "SistemaGari", "Lixos"},
			{"SistemaGari", "Lixos"},
			{"Lixos"},
			{"Construcoes", "Lixos"},
		}
		for _, caminho in ipairs(caminhos) do
			local w = workspace
			local ok = true
			for _, n in ipairs(caminho) do
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
		if not cont then return nil, 0 end
		local hrp = GetHRP()
		if not hrp then return nil, 0 end

		local disp = {}
		local totalLixos = 0
		for _, lixo in ipairs(cont:GetChildren()) do
			if lixo:IsA("BasePart") then
				totalLixos = totalLixos + 1
				if not lixosUsados[lixo] and not lixosFalhados[lixo] then
					table.insert(disp, {lixo = lixo, dist = (lixo.Position - hrp.Position).Magnitude})
				end
			end
		end

		if #disp == 0 then
			TocarSom("reset")
			Log("🔄 Todos lixos usados — resetando lista")
			lixosUsados = {}
			lixosFalhados = {}
			for _, lixo in ipairs(cont:GetChildren()) do
				if lixo:IsA("BasePart") then
					table.insert(disp, {lixo = lixo, dist = (lixo.Position - hrp.Position).Magnitude})
				end
			end
		end

		table.sort(disp, function(a, b) return a.dist < b.dist end)
		if #disp > 0 then return disp[1].lixo, totalLixos end
		return nil, totalLixos
	end

	-- ============================================================
	-- BOTÃO FLUTUANTE
	-- ============================================================
	local SGBtn = Instance.new("ScreenGui")
	SGBtn.Name = "SailentFloatBtn"
	SGBtn.ResetOnSpawn = false
	SGBtn.IgnoreGuiInset = true
	SGBtn.Parent = CoreGui

	local BTN_SIZE = IS_MOBILE and 68 or 60

	local FloatBtn = Instance.new("TextButton")
	FloatBtn.Text = "⚡"
	FloatBtn.Font = Enum.Font.GothamBold
	FloatBtn.TextSize = IS_MOBILE and 32 or 28
	FloatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	FloatBtn.BackgroundColor3 = C.Black
	FloatBtn.BorderSizePixel = 0
	FloatBtn.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
	FloatBtn.Position = UDim2.new(0, 20, 0.5, -BTN_SIZE/2)
	FloatBtn.AutoButtonColor = false
	FloatBtn.Active = true
	FloatBtn.Parent = SGBtn

	local BtnCorner = Instance.new("UICorner")
	BtnCorner.CornerRadius = UDim.new(1, 0)
	BtnCorner.Parent = FloatBtn

	local BtnStroke = Instance.new("UIStroke")
	BtnStroke.Color = infoKey.nivel == "admin" and C.Gold or (infoKey.nivel == "vip" and C.Purple or C.Green)
	BtnStroke.Thickness = IS_MOBILE and 3 or 2
	BtnStroke.Parent = FloatBtn

	local btnDragging, btnDragStart, btnStartPos, btnMoveuSe
	FloatBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			btnDragging = true
			btnMoveuSe = false
			btnDragStart = input.Position
			btnStartPos = FloatBtn.Position
		end
	end)
	FloatBtn.InputChanged:Connect(function(input)
		if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - btnDragStart
			if math.abs(delta.X) > 8 or math.abs(delta.Y) > 8 then btnMoveuSe = true end
			FloatBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
		end
	end)
	UserInput.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			btnDragging = false
		end
	end)

	-- ============================================================
	-- UI PRINCIPAL
	-- ============================================================
	local SG = Instance.new("ScreenGui")
	SG.Name = "SailentGari"
	SG.ResetOnSpawn = false
	SG.IgnoreGuiInset = true
	SG.Parent = CoreGui

	local UI_W, UI_H
	if IS_MOBILE then
		local vp = workspace.CurrentCamera.ViewportSize
		UI_W = math.min(vp.X * 0.92, 420)
		UI_H = math.min(vp.Y * 0.85, 700)
	else
		UI_W, UI_H = 400, 680
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
		local function up(i)
			if _G.SailentBloquearDrag then return end
			local x = i.Position - ds
			Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + x.X, sp.Y.Scale, sp.Y.Offset + x.Y)
		end
		Main.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1
				or i.UserInputType == Enum.UserInputType.Touch then
				if _G.SailentBloquearDrag then return end
				d = true; ds = i.Position; sp = Main.Position
				i.Changed:Connect(function()
					if i.UserInputState == Enum.UserInputState.End then d = false end
				end)
			end
		end)
		Main.InputChanged:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseMovement
				or i.UserInputType == Enum.UserInputType.Touch then
				di = i
			end
		end)
		UserInput.InputChanged:Connect(function(i)
			if i == di and d then up(i) end
		end)
	end

	-- HEADER
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
	local H_TOGGLE = IS_MOBILE and 52 or 42
	local FONT_S = IS_MOBILE and 12 or 11
	local FONT_B = IS_MOBILE and 13 or 12

	local function Sec(txt, color)
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
		l.TextColor3 = color or C.Accent
		l.BackgroundTransparency = 1
		l.Position = UDim2.new(0, 12, 0, 0)
		l.Size = UDim2.new(1, -24, 1, 0)
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.Parent = f
	end

	local function Stat(txt, color)
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
			Tween(b, {BackgroundColor3 = color or C.Accent}, 0.08)
			task.wait(0.12)
			Tween(b, {BackgroundColor3 = C.Card}, 0.15)
			if cb then task.spawn(cb) end
		end)
		return b
	end

	local function Toggle(txt, default, cb)
		local f = Instance.new("Frame")
		f.Size = UDim2.new(1, 0, 0, H_TOGGLE)
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

		local BG_W = IS_MOBILE and 52 or 44
		local BG_H = IS_MOBILE and 26 or 22
		local K_SIZE = IS_MOBILE and 22 or 18

		local bg = Instance.new("Frame")
		bg.Size = UDim2.new(0, BG_W, 0, BG_H)
		bg.Position = UDim2.new(1, -(BG_W + 12), 0.5, -BG_H/2)
		bg.BackgroundColor3 = Color3.fromRGB(50,50,60)
		bg.BorderSizePixel = 0
		bg.Parent = f
		local bc = Instance.new("UICorner")
		bc.CornerRadius = UDim.new(1, 0)
		bc.Parent = bg

		local k = Instance.new("Frame")
		k.Size = UDim2.new(0, K_SIZE, 0, K_SIZE)
		k.Position = UDim2.new(0, 2, 0.5, -K_SIZE/2)
		k.BackgroundColor3 = C.Text
		k.BorderSizePixel = 0
		k.Parent = bg
		local kc = Instance.new("UICorner")
		kc.CornerRadius = UDim.new(1, 0)
		kc.Parent = k

		local st = default or false
		local function set(v)
			st = v
			local onX = BG_W - K_SIZE - 2
			if st then
				Tween(bg, {BackgroundColor3 = C.Green}, 0.2)
				Tween(k, {Position = UDim2.new(0, onX, 0.5, -K_SIZE/2)}, 0.2)
			else
				Tween(bg, {BackgroundColor3 = Color3.fromRGB(50,50,60)}, 0.2)
				Tween(k, {Position = UDim2.new(0, 2, 0.5, -K_SIZE/2)}, 0.2)
			end
			if cb then cb(st) end
		end
		if st then
			bg.BackgroundColor3 = C.Green
			k.Position = UDim2.new(0, BG_W - K_SIZE - 2, 0.5, -K_SIZE/2)
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

	local function CriarSlider(parent, min, max, default, callback, tituloTexto, corTitulo, sufixo)
		local SLIDER_H = IS_MOBILE and 80 or 58
		local KNOB = IS_MOBILE and 32 or 22
		local BAR_H = IS_MOBILE and 16 or 12

		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, SLIDER_H)
		frame.BackgroundColor3 = C.Card
		frame.BorderSizePixel = 0
		frame.Parent = parent
		local fc = Instance.new("UICorner")
		fc.CornerRadius = UDim.new(0, 8)
		fc.Parent = frame

		local titulo = Instance.new("TextLabel")
		titulo.Text = tituloTexto or "⚡ Valor"
		titulo.Font = Enum.Font.GothamBold
		titulo.TextSize = IS_MOBILE and 13 or 12
		titulo.TextColor3 = corTitulo or C.Text
		titulo.BackgroundTransparency = 1
		titulo.Position = UDim2.new(0, 12, 0, 8)
		titulo.Size = UDim2.new(0.7, 0, 0, 18)
		titulo.TextXAlignment = Enum.TextXAlignment.Left
		titulo.Parent = frame

		local valorLabel = Instance.new("TextLabel")
		valorLabel.Text = tostring(default) .. (sufixo or "")
		valorLabel.Font = Enum.Font.GothamBold
		valorLabel.TextSize = IS_MOBILE and 16 or 14
		valorLabel.TextColor3 = corTitulo or C.Green
		valorLabel.BackgroundTransparency = 1
		valorLabel.Position = UDim2.new(0.7, 0, 0, 8)
		valorLabel.Size = UDim2.new(0.3, -12, 0, 18)
		valorLabel.TextXAlignment = Enum.TextXAlignment.Right
		valorLabel.Parent = frame

		local bgBar = Instance.new("Frame")
		bgBar.Size = UDim2.new(1, -24, 0, BAR_H)
		bgBar.Position = UDim2.new(0, 12, 0, IS_MOBILE and 42 or 32)
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
		knob.Size = UDim2.new(0, KNOB, 0, KNOB)
		knob.Position = UDim2.new(0, -KNOB/2, 0.5, -KNOB/2)
		knob.BackgroundColor3 = C.Text
		knob.BorderSizePixel = 0
		knob.ZIndex = 2
		knob.Parent = bgBar
		local kc = Instance.new("UICorner")
		kc.CornerRadius = UDim.new(1, 0)
		kc.Parent = knob

		local touchArea = Instance.new("TextButton")
		touchArea.Text = ""
		touchArea.BackgroundTransparency = 1
		touchArea.Size = UDim2.new(1, 0, 0, KNOB + 20)
		touchArea.Position = UDim2.new(0, 0, 0.5, -(KNOB + 20)/2)
		touchArea.Parent = bgBar

		local valor = default
		local arrastando = false

		local function Atualizar(posX)
			local bgAbs = bgBar.AbsolutePosition.X
			local bgSize = bgBar.AbsoluteSize.X
			local percent = math.clamp((posX - bgAbs) / bgSize, 0, 1)
			valor = math.floor(min + (max - min) * percent)
			valorLabel.Text = tostring(valor) .. (sufixo or "")
			fillBar.Size = UDim2.new(percent, 0, 1, 0)
			knob.Position = UDim2.new(percent, -KNOB/2, 0.5, -KNOB/2)
			if callback then callback(valor) end
		end

		local initPercent = (default - min) / (max - min)
		fillBar.Size = UDim2.new(initPercent, 0, 1, 0)
		knob.Position = UDim2.new(initPercent, -KNOB/2, 0.5, -KNOB/2)

		bgBar.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1
				or i.UserInputType == Enum.UserInputType.Touch then
				arrastando = true
				_G.SailentBloquearDrag = true
				Atualizar(i.Position.X)
			end
		end)
		UserInput.InputChanged:Connect(function(i)
			if arrastando and (i.UserInputType == Enum.UserInputType.MouseMovement
				or i.UserInputType == Enum.UserInputType.Touch) then
				Atualizar(i.Position.X)
			end
		end)
		UserInput.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1
				or i.UserInputType == Enum.UserInputType.Touch then
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
	if infoKey.expira and infoKey.expira < 99999999999 then
		local restante = infoKey.expira - os.time()
		local dias = math.floor(restante / 86400)
		Stat("Expira em: " .. dias .. " dias", restante < 86400 and C.Red or C.Yellow)
	end

	Sec("🗑️ AUTO GARI", C.Green)
	local gariStatus = Stat("Status: PARADO", C.Sub)
	local gariStats = Stat("Coletados: 0 | Entregues: 0", C.Sub)
	local gariLixos = Stat("Lixos usados: 0/0", C.Sub)
	local gariTempo = Stat("Tempo: 00s | Por min: 0", C.Sub)

	local gariOn = false
	local gariCount = {coletados = 0, entregues = 0}
	local tempoInicio = 0

	local setGariAtivo = Toggle("Auto Coletar + Entregar", false, function(s)
		gariOn = s
		if s then
			gariStatus.Text = "Status: ● ATIVO"
			gariStatus.TextColor3 = C.Green
			tempoInicio = tick()
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
						local lixo, total = AcharProximoLixo()
						if lixo then
							gariStatus.Text = (Config.vooAtivo and "✈️ Voando pro lixo..." or "📥 Indo pro lixo...")
							local sucesso = IrAte(lixo.Position, 30, Config.vooAtivo and 5 or 4)
							task.wait(0.5)
							if sucesso then
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
					local totalUsados = 0
					for _ in pairs(lixosUsados) do totalUsados += 1 end
					local totalFalhados = 0
					for _ in pairs(lixosFalhados) do totalFalhados += 1 end

					local totalLixos = 0
					local cont = GetLixosContainer()
					if cont then
						for _, v in ipairs(cont:GetChildren()) do
							if v:IsA("BasePart") then totalLixos = totalLixos + 1 end
						end
					end

					local tempoRodando = tick() - tempoInicio
					local totalColetado = gariCount.coletados + gariCount.entregues
					local porMinuto = tempoRodando > 0 and math.floor((totalColetado / tempoRodando) * 60) or 0

					gariStats.Text = "Coletados: "..gariCount.coletados.." | Entregues: "..gariCount.entregues
					gariLixos.Text = "Lixos: "..totalUsados.."/"..totalLixos..(totalFalhados > 0 and " ("..totalFalhados.." falhas)" or "")
					gariTempo.Text = "Tempo: "..FormatarTempo(tempoRodando).." | "..porMinuto.."/min"

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

	-- ============================================================
	-- MODO DE MOVIMENTO (A pé / Voo)
	-- ============================================================
	Sec("🚶 MODO DE MOVIMENTO", C.Cyan)
	Stat("A pé pega o lixo normalmente. Voo é mais rápido e ignora obstáculos.", C.Sub)

	local setVooAtivo = Toggle("✈️ Voo Suave (ignora obstáculos)", false, function(s)
		Config.vooAtivo = s
		SalvarConfig()
		if s then
			IniciarVoo()
		else
			PararVoo()
		end
	end)

	Sec("✈️ AJUSTES DE VOO", C.Cyan)

	CriarSlider(Content, 20, 300, Config.vooVelocidade, function(v)
		Config.vooVelocidade = v
	end, "✈️ Velocidade de voo", C.Cyan, " studs/s")

	CriarSlider(Content, 3, 60, Config.vooAltura, function(v)
		Config.vooAltura = v
	end, "📏 Altura do voo", C.Cyan, " studs")

	CriarSlider(Content, 1, 10, Config.vooSuavidade, function(v)
		Config.vooSuavidade = v
	end, "🌊 Suavidade", C.Cyan, "")

	-- ============================================================
	-- VELOCIDADE A PÉ
	-- ============================================================
	Sec("⚡ VELOCIDADE A PÉ", C.Yellow)
	CriarSlider(Content, 16, 200, Config.velocidade, function(valor)
		velocidadeAtual = valor
		Config.velocidade = valor
		local hum = GetHum()
		if hum then hum.WalkSpeed = valor end
	end, "⚡ Velocidade", C.Yellow, "")

	-- ============================================================
	-- NOCLIP
	-- ============================================================
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

	Sec("🔊 SOM", C.Blue)
	Toggle("Sons ativados", Config.somAtivo, function(s)
		Config.somAtivo = s
		SalvarConfig()
	end)

	Sec("🚨 EMERGÊNCIA", C.Red)
	Btn("🛑 PARAR TUDO", C.Red, function()
		gariOn = false
		setGariAtivo(false)
		noclipOn = false
		if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
		PararVoo()
		if setVooAtivo then setVooAtivo(false) end
		gariStatus.Text = "Status: PARADO"
		gariStatus.TextColor3 = C.Sub
		local hum = GetHum()
		if hum then hum.WalkSpeed = 16 end
	end)

	if infoKey.nivel == "admin" then
		Sec("⚙️ ADMIN", C.Gold)
		Btn("🚪 Deslogar Key", C.Red, function()
			PararVoo()
			LimparKeySalva()
			SafeDeleteFile(CACHE_FILE)
			lp:Kick("Key removida. Reabra o script.")
		end)
	end

	-- ============================================================
	-- ABRIR/FECHAR UI
	-- ============================================================
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
			setGariAtivo(false)
			noclipOn = false
			if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
			PararVoo()
			if setVooAtivo then setVooAtivo(false) end
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

	if IS_MOBILE then
		workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			local vp = workspace.CurrentCamera.ViewportSize
			local nW = math.min(vp.X * 0.92, 420)
			local nH = math.min(vp.Y * 0.85, 700)
			UI_W, UI_H = nW, nH
			if uiAberta and not minimizado then
				Main.Size = UDim2.new(0, nW, 0, nH)
				Main.Position = UDim2.new(0.5, -nW/2, 0.5, -nH/2)
			end
		end)
	end

	-- ============================================================
	-- RECONEXÃO
	-- ============================================================
	lp.CharacterAdded:Connect(function(char)
		Log("🔄 Character respawnou, aguardando...")
		task.wait(2)
		local hum = char:FindFirstChild("Humanoid")
		if hum and gariOn then
			hum.WalkSpeed = velocidadeAtual
			if Config.vooAtivo then
				task.wait(0.5)
				IniciarVoo()
			end
			Log("✅ Reconectado, continuando...")
		end
	end)

	-- Aplica config inicial
	if Config.vooAtivo then
		setVooAtivo(true)
	end

	Log("🗑️ Sailent Auto Gari v" .. SCRIPT_VERSION .. " | " .. (infoKey.nome or "Cliente") .. " | " .. (IS_MOBILE and "MOBILE" or "PC"))
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

	local KW, KH
	if IS_MOBILE then
		local vp = workspace.CurrentCamera.ViewportSize
		KW = math.min(vp.X * 0.92, 400)
		KH = math.min(vp.Y * 0.75, 420)
	else
		KW, KH = 400, 400
	end

	local KeyFrame = Instance.new("Frame")
	KeyFrame.Size = UDim2.new(0, KW, 0, KH)
	KeyFrame.Position = UDim2.new(0.5, -KW/2, 0.5, -KH/2)
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
	Titulo.Text = "🔐 SAILENT KEY SYSTEM"
	Titulo.Font = Enum.Font.GothamBold
	Titulo.TextSize = IS_MOBILE and 18 or 20
	Titulo.TextColor3 = C.Text
	Titulo.BackgroundTransparency = 1
	Titulo.Size = UDim2.new(1, 0, 0, 50)
	Titulo.Position = UDim2.new(0, 0, 0, 15)
	Titulo.Parent = KeyFrame

	local Sub = Instance.new("TextLabel")
	Sub.Text = "Digite sua key abaixo"
	Sub.Font = Enum.Font.GothamMedium
	Sub.TextSize = IS_MOBILE and 13 or 12
	Sub.TextColor3 = C.Sub
	Sub.BackgroundTransparency = 1
	Sub.Size = UDim2.new(1, 0, 0, 20)
	Sub.Position = UDim2.new(0, 0, 0, 62)
	Sub.Parent = KeyFrame

	local H_INPUT = IS_MOBILE and 54 or 50
	local H_BTN = IS_MOBILE and 54 or 50
	local PAD = IS_MOBILE and 20 or 30

	local KeyInput = Instance.new("TextBox")
	KeyInput.PlaceholderText = "SAILENT-XXXX-XXXX-XXXX"
	KeyInput.Font = Enum.Font.Code
	KeyInput.TextSize = IS_MOBILE and 15 or 14
	KeyInput.TextColor3 = C.Text
	KeyInput.PlaceholderColor3 = C.Sub
	KeyInput.BackgroundColor3 = C.Card
	KeyInput.BorderSizePixel = 0
	KeyInput.Size = UDim2.new(1, -PAD*2, 0, H_INPUT)
	KeyInput.Position = UDim2.new(0, PAD, 0, 95)
	KeyInput.Text = ""
	KeyInput.ClearTextOnFocus = false
	KeyInput.Parent = KeyFrame

	local IC = Instance.new("UICorner")
	IC.CornerRadius = UDim.new(0, 10)
	IC.Parent = KeyInput

	local HWIDLabel = Instance.new("TextLabel")
	HWIDLabel.Text = "Seu HWID: " .. GetHWID():sub(1,16) .. "..."
	HWIDLabel.Font = Enum.Font.Code
	HWIDLabel.TextSize = IS_MOBILE and 11 or 10
	HWIDLabel.TextColor3 = C.Sub
	HWIDLabel.BackgroundTransparency = 1
	HWIDLabel.Size = UDim2.new(1, -PAD*2, 0, 18)
	HWIDLabel.Position = UDim2.new(0, PAD, 0, 95 + H_INPUT + 8)
	HWIDLabel.Parent = KeyFrame

	local Status = Instance.new("TextLabel")
	Status.Text = "Status: ● Aguardando"
	Status.Font = Enum.Font.GothamBold
	Status.TextSize = IS_MOBILE and 13 or 12
	Status.TextColor3 = C.Yellow
	Status.BackgroundTransparency = 1
	Status.Size = UDim2.new(1, -PAD*2, 0, 20)
	Status.Position = UDim2.new(0, PAD, 0, 95 + H_INPUT + 32)
	Status.Parent = KeyFrame

	local ValidarBtn = Instance.new("TextButton")
	ValidarBtn.Text = "🔓 VALIDAR KEY"
	ValidarBtn.Font = Enum.Font.GothamBold
	ValidarBtn.TextSize = IS_MOBILE and 16 or 15
	ValidarBtn.TextColor3 = C.Text
	ValidarBtn.BackgroundColor3 = C.Green
	ValidarBtn.BorderSizePixel = 0
	ValidarBtn.Size = UDim2.new(1, -PAD*2, 0, H_BTN)
	ValidarBtn.Position = UDim2.new(0, PAD, 0, 95 + H_INPUT + 60)
	ValidarBtn.AutoButtonColor = false
	ValidarBtn.Parent = KeyFrame

	local VC = Instance.new("UICorner")
	VC.CornerRadius = UDim.new(0, 10)
	VC.Parent = ValidarBtn

	local CopiarBtn = Instance.new("TextButton")
	CopiarBtn.Text = "📋 Copiar HWID"
	CopiarBtn.Font = Enum.Font.GothamBold
	CopiarBtn.TextSize = IS_MOBILE and 12 or 11
	CopiarBtn.TextColor3 = C.Text
	CopiarBtn.BackgroundColor3 = C.Card
	CopiarBtn.BorderSizePixel = 0
	CopiarBtn.Size = UDim2.new(1, -PAD*2, 0, H_BTN - 10)
	CopiarBtn.Position = UDim2.new(0, PAD, 0, 95 + H_INPUT + 60 + H_BTN + 10)
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
	Info.TextSize = IS_MOBILE and 12 or 11
	Info.TextColor3 = C.Sub
	Info.BackgroundTransparency = 1
	Info.Size = UDim2.new(1, -PAD*2, 0, 20)
	Info.Position = UDim2.new(0, PAD, 0, 95 + H_INPUT + 60 + H_BTN + 60)
	Info.Parent = KeyFrame

	ValidarBtn.MouseEnter:Connect(function()
		Tween(ValidarBtn, {BackgroundColor3 = Color3.fromRGB(100, 240, 140)}, 0.15)
	end)
	ValidarBtn.MouseLeave:Connect(function()
		Tween(ValidarBtn, {BackgroundColor3 = C.Green}, 0.15)
	end)

	local validando = false
	ValidarBtn.MouseButton1Click:Connect(function()
		if validando then return end
		local key = KeyInput.Text
		if key == "" then
			Status.Text = "Status: ❌ Digite a key"
			Status.TextColor3 = C.Red
			return
		end
		validando = true
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
			Status.Text = "Status: ❌ " .. tostring(info or "Erro")
			Status.TextColor3 = C.Red
		end
		validando = false
	end)
end

-- ============================================================
-- INICIAR
-- ============================================================
task.spawn(function()
	Log("🗑️ Sailent Auto Gari v" .. SCRIPT_VERSION)
	Log("📱 Modo: " .. (IS_MOBILE and (IS_TABLET and "TABLET" or "MOBILE") or "PC"))
	Log("🔑 HWID: " .. GetHWID())

	local keySalva, hwidSalvo = TemKeySalva()

	if keySalva then
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

	AbrirUIKey()
end)-- ============================================================
-- SAILENT AUTO GARI v7.3 — PC + MOBILE + VOO SUAVE
-- ============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local lp = Players.LocalPlayer

-- ============================================================
-- CONFIG
-- ============================================================
local GITHUB_URL = "https://raw.githubusercontent.com/simiao64santos-dot/sailent-/refs/heads/main/keys.json"
local SAVE_FILE = "sailent_key_salva.txt"
local CACHE_FILE = "sailent_keys_cache.json"
local CONFIG_FILE = "sailent_gari_config.txt"
local KEY_DURACAO_LOCAL = 24 * 60 * 60
local CACHE_DURACAO = 6 * 60 * 60
local SCRIPT_VERSION = "7.3"

-- ============================================================
-- DETECÇÃO DE MOBILE
-- ============================================================
local IS_MOBILE = UserInput.TouchEnabled and not UserInput.KeyboardEnabled
local IS_TABLET = IS_MOBILE and workspace.CurrentCamera.ViewportSize.X >= 700

for _, name in ipairs({"SailentGari", "SailentFloatBtn", "SailentKeyUI"}) do
	if CoreGui:FindFirstChild(name) then CoreGui[name]:Destroy() end
end

local C = {
	BG = Color3.fromRGB(12,12,18),
	Card = Color3.fromRGB(25,25,35),
	CardHover = Color3.fromRGB(35,35,48),
	Accent = Color3.fromRGB(80,220,120),
	Text = Color3.fromRGB(240,240,245),
	Sub = Color3.fromRGB(150,150,165),
	Green = Color3.fromRGB(80,220,120),
	Red = Color3.fromRGB(230,70,80),
	Yellow = Color3.fromRGB(255,200,80),
	Blue = Color3.fromRGB(80,160,240),
	Purple = Color3.fromRGB(180,120,255),
	Black = Color3.fromRGB(10, 10, 15),
	Gold = Color3.fromRGB(255,215,0),
	Cyan = Color3.fromRGB(80,220,240),
}

-- ============================================================
-- UTILS
-- ============================================================
local function Tween(o, p, t)
	local tw = TweenService:Create(o, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint), p)
	tw:Play()
	return tw
end

local function Log(msg)
	print("[Sailent] " .. tostring(msg))
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

local function FormatarTempo(seg)
	seg = math.floor(seg)
	local h = math.floor(seg / 3600)
	local m = math.floor((seg % 3600) / 60)
	local s = seg % 60
	if h > 0 then return string.format("%dh %dm %ds", h, m, s) end
	if m > 0 then return string.format("%dm %ds", m, s) end
	return string.format("%ds", s)
end

-- ============================================================
-- SHA-256
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
	local function pad(s)
		local l = #s * 8
		s = s .. "\128"
		while #s % 64 ~= 56 do s = s .. "\0" end
		for i = 7, 0, -1 do s = s .. string.char((l >> (i*8)) & 0xff) end
		return s
	end
	local function uint32(x) return x & 0xffffffff end
	local padded = pad(msg)
	for ci = 0, (#padded / 64) - 1 do
		local chunk = padded:sub(ci*64+1, ci*64+64)
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
	pcall(function() parts[#parts+1] = game:GetService("RbxAnalyticsService"):GetClientId() end)
	cachedHwid = sha256(table.concat(parts, "|")):sub(1, 32)
	return cachedHwid
end

-- ============================================================
-- ARQUIVOS
-- ============================================================
local function SafeReadFile(path)
	local ok, data = pcall(function()
		if isfile and isfile(path) and readfile then return readfile(path) end
	end)
	if ok and data and data ~= "" then return data end
	return nil
end

local function SafeWriteFile(path, content)
	pcall(function() if writefile then writefile(path, content) end end)
end

local function SafeDeleteFile(path)
	pcall(function() if delfile and isfile and isfile(path) then delfile(path) end end)
end

-- ============================================================
-- SISTEMA DE KEY
-- ============================================================
local function TemKeySalva()
	local dados = SafeReadFile(SAVE_FILE)
	if not dados then return nil end
	local key, expira, hwid = dados:match("([^|]+)|(%d+)|(.*)")
	if key and expira then
		expira = tonumber(expira)
		if expira and os.time() < expira then return key, hwid end
	end
	return nil
end

local function SalvarKey(key)
	local hwid = GetHWID()
	SafeWriteFile(SAVE_FILE, key .. "|" .. (os.time() + KEY_DURACAO_LOCAL) .. "|" .. hwid)
end

local function LimparKeySalva() SafeDeleteFile(SAVE_FILE) end

local function BaixarKeys()
	local cache = SafeReadFile(CACHE_FILE)
	if cache then
		local ok, dados = pcall(function() return HttpService:JSONDecode(cache) end)
		if ok and dados and dados._cached_at and (os.time() - dados._cached_at) < CACHE_DURACAO then
			return dados, true
		end
	end
	local ok, resultado = pcall(function() return game:HttpGet(GITHUB_URL, true) end)
	if not ok or not resultado or resultado == "" then
		if cache then
			local ok2, dados = pcall(function() return HttpService:JSONDecode(cache) end)
			if ok2 and dados then return dados, true end
		end
		return nil, "Erro ao baixar keys"
	end
	local ok2, dados = pcall(function() return HttpService:JSONDecode(resultado) end)
	if not ok2 or not dados then
		if cache then
			local ok3, dados2 = pcall(function() return HttpService:JSONDecode(cache) end)
			if ok3 and dados2 then return dados2, true end
		end
		return nil, "Erro no JSON"
	end
	dados._cached_at = os.time()
	SafeWriteFile(CACHE_FILE, HttpService:JSONEncode(dados))
	return dados, false
end

local function ValidarKey(key)
	if not key or key == "" then return false, "Key vazia" end
	local hashKey = sha256(key)
	local dados, erro = BaixarKeys()
	if not dados then return false, erro or "Erro de conexão" end
	if not dados.keys then return false, "Keys não encontradas" end
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
	if info.max_usos and info.max_usos > 0 then
		if (info.usos or 0) >= info.max_usos then
			return false, "Limite de usos atingido"
		end
	end
	return true, info, hashKey
end

-- ============================================================
-- ABRIR AUTO GARI
-- ============================================================
local function AbrirAutoGari(infoKey)
	infoKey = infoKey or {nome = "Cliente", nivel = "normal"}

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
		SafeWriteFile(CONFIG_FILE, str)
	end

	local function CarregarConfig()
		local str = SafeReadFile(CONFIG_FILE)
		if not str then return end
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
	CarregarConfig()

	local function TocarSom(tipo)
		if not Config.somAtivo then return end
		pcall(function()
			local s = Instance.new("Sound")
			s.Parent = SoundService
			if tipo == "coletou" then s.SoundId = "rbxassetid://4612375230"
			elseif tipo == "entregou" then s.SoundId = "rbxassetid://4612384334"
			elseif tipo == "reset" then s.SoundId = "rbxassetid://6042053626"
			elseif tipo == "travou" then s.SoundId = "rbxassetid://6042053626" end
			s.Volume = 0.5
			s:Play()
			task.delay(2, function() s:Destroy() end)
		end)
	end

	-- ============================================================
	-- SISTEMA DE VOO SUAVE
	-- ============================================================
	local BodyVelocityVoo = nil
	local BodyGyroVoo = nil
	local voando = false

	local function IniciarVoo()
		local hrp = GetHRP()
		if not hrp then return false end

		-- limpa
		if hrp:FindFirstChild("SailentVooVel") then hrp.SailentVooVel:Destroy() end
		if hrp:FindFirstChild("SailentVooGyro") then hrp.SailentVooGyro:Destroy() end

		-- BodyVelocity (movimento suave)
		local bv = Instance.new("BodyVelocity")
		bv.Name = "SailentVooVel"
		bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bv.Velocity = Vector3.zero
		bv.P = 1250
		bv.Parent = hrp
		BodyVelocityVoo = bv

		-- BodyGyro (mantém orientação estável)
		local bg = Instance.new("BodyGyro")
		bg.Name = "SailentVooGyro"
		bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
		bg.P = 3000
		bg.D = 100
		bg.CFrame = hrp.CFrame
		bg.Parent = hrp
		BodyGyroVoo = bg

		-- desativa física de queda do Humanoid
		local hum = GetHum()
		if hum then
			hum.PlatformStand = false
		end

		voando = true
		return true
	end

	local function PararVoo()
		voando = false
		local hrp = GetHRP()
		if hrp then
			local bv = hrp:FindFirstChild("SailentVooVel")
			if bv then bv:Destroy() end
			local bg = hrp:FindFirstChild("SailentVooGyro")
			if bg then bg:Destroy() end
		end
		BodyVelocityVoo = nil
		BodyGyroVoo = nil
	end

	-- ============================================================
	-- VOAR ATÉ (suave, com desaceleração)
	-- ============================================================
	local function VoarAte(posAlvo, timeout, distParada)
		if not posAlvo then return false end
		local hrp = GetHRP()
		local hum = GetHum()
		if not hrp or not hum then return false end

		timeout = timeout or 30
		distParada = distParada or 5

		-- garante que o voo está ativo
		if not BodyVelocityVoo or not BodyVelocityVoo.Parent then
			IniciarVoo()
		end

		local velocidadeVoo = Config.vooVelocidade or 80
		local alturaVoo = Config.vooAltura or 12
		local suavidade = Config.vooSuavidade or 3

		-- destino com altura
		local destino = Vector3.new(posAlvo.X, posAlvo.Y + alturaVoo, posAlvo.Z)

		local t0 = tick()
		local ultimaPos = hrp.Position
		local tempoParado = 0

		while tick() - t0 < timeout do
			local h = GetHRP()
			if not h then return false end

			local posAtual = h.Position
			local diff = destino - posAtual
			local dist = diff.Magnitude

			-- Verifica se chegou
			local diffPlano = Vector3.new(posAtual.X - posAlvo.X, 0, posAtual.Z - posAlvo.Z)
			if diffPlano.Magnitude < distParada then
				-- desacelera
				if BodyVelocityVoo then
					BodyVelocityVoo.Velocity = BodyVelocityVoo.Velocity * 0.5
					task.wait(0.1)
					BodyVelocityVoo.Velocity = Vector3.zero
				end
				return true
			end

			-- Desaceleração perto do destino (evita passar reto)
			local fator = math.clamp(dist / 30, 0.3, 1)
			local velFinal = diff.Unit * velocidadeVoo * fator

			-- suavização (interpola velocidade)
			if BodyVelocityVoo then
				local velAtual = BodyVelocityVoo.Velocity
				local novaVel = velAtual:Lerp(velFinal, math.clamp(suavidade * 0.1, 0.05, 0.5))
				BodyVelocityVoo.Velocity = novaVel
			end

			-- atualiza Gyro pra olhar pro destino
			if BodyGyroVoo then
				local dir = Vector3.new(diff.X, 0, diff.Z)
				if dir.Magnitude > 1 then
					local look = CFrame.new(posAtual, posAtual + dir.Unit)
					BodyGyroVoo.CFrame = BodyGyroVoo.CFrame:Lerp(look, 0.15)
				end
			end

			-- Anti-travamento
			local moveu = (posAtual - ultimaPos).Magnitude
			if moveu < 0.5 then
				tempoParado = tempoParado + 0.1
				if tempoParado > 1.5 then
					-- tenta subir mais pra desviar
					if BodyVelocityVoo then
						BodyVelocityVoo.Velocity = Vector3.new(0, velocidadeVoo * 0.6, 0)
					end
					task.wait(0.3)
					tempoParado = 0
				end
			else
				tempoParado = 0
			end

			ultimaPos = posAtual
			task.wait(0.05)
		end
		return false
	end

	-- ============================================================
	-- ANDAR A PÉ COM ANTI-TRAVAMENTO
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
		local tentativasTravou = 0

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
					tentativasTravou = tentativasTravou + 1
					TocarSom("travou")
					hum.Jump = true
					task.wait(0.3)
					hum:MoveTo(posAlvo)
					tempoParado = 0
					if tentativasTravou >= 3 then
						Log("⚠️ Travou 3x ao ir pra " .. tostring(posAlvo))
						return false
					end
				end
			else
				tempoParado = 0
				tentativasTravou = 0
			end

			ultimaPos = h.Position
			hum:MoveTo(posAlvo)
			task.wait(0.1)
		end
		return false
	end

	-- ============================================================
	-- IR ATÉ (escolhe voo ou a pé baseado no toggle)
	-- ============================================================
	local function IrAte(posAlvo, timeout, distParada)
		if Config.vooAtivo then
			return VoarAte(posAlvo, timeout, distParada or 5)
		else
			return AndarAte(posAlvo, timeout, distParada or 4)
		end
	end

	local lixosUsados = {}
	local lixosFalhados = {}

	-- ============================================================
	-- DETECÇÃO DE LIXO
	-- ============================================================
	local function GetLixosContainer()
		local caminhos = {
			{"Construcoes", "SistemaGari", "Lixos"},
			{"SistemaGari", "Lixos"},
			{"Lixos"},
			{"Construcoes", "Lixos"},
		}
		for _, caminho in ipairs(caminhos) do
			local w = workspace
			local ok = true
			for _, n in ipairs(caminho) do
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
		if not cont then return nil, 0 end
		local hrp = GetHRP()
		if not hrp then return nil, 0 end

		local disp = {}
		local totalLixos = 0
		for _, lixo in ipairs(cont:GetChildren()) do
			if lixo:IsA("BasePart") then
				totalLixos = totalLixos + 1
				if not lixosUsados[lixo] and not lixosFalhados[lixo] then
					table.insert(disp, {lixo = lixo, dist = (lixo.Position - hrp.Position).Magnitude})
				end
			end
		end

		if #disp == 0 then
			TocarSom("reset")
			Log("🔄 Todos lixos usados — resetando lista")
			lixosUsados = {}
			lixosFalhados = {}
			for _, lixo in ipairs(cont:GetChildren()) do
				if lixo:IsA("BasePart") then
					table.insert(disp, {lixo = lixo, dist = (lixo.Position - hrp.Position).Magnitude})
				end
			end
		end

		table.sort(disp, function(a, b) return a.dist < b.dist end)
		if #disp > 0 then return disp[1].lixo, totalLixos end
		return nil, totalLixos
	end

	-- ============================================================
	-- BOTÃO FLUTUANTE
	-- ============================================================
	local SGBtn = Instance.new("ScreenGui")
	SGBtn.Name = "SailentFloatBtn"
	SGBtn.ResetOnSpawn = false
	SGBtn.IgnoreGuiInset = true
	SGBtn.Parent = CoreGui

	local BTN_SIZE = IS_MOBILE and 68 or 60

	local FloatBtn = Instance.new("TextButton")
	FloatBtn.Text = "⚡"
	FloatBtn.Font = Enum.Font.GothamBold
	FloatBtn.TextSize = IS_MOBILE and 32 or 28
	FloatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	FloatBtn.BackgroundColor3 = C.Black
	FloatBtn.BorderSizePixel = 0
	FloatBtn.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
	FloatBtn.Position = UDim2.new(0, 20, 0.5, -BTN_SIZE/2)
	FloatBtn.AutoButtonColor = false
	FloatBtn.Active = true
	FloatBtn.Parent = SGBtn

	local BtnCorner = Instance.new("UICorner")
	BtnCorner.CornerRadius = UDim.new(1, 0)
	BtnCorner.Parent = FloatBtn

	local BtnStroke = Instance.new("UIStroke")
	BtnStroke.Color = infoKey.nivel == "admin" and C.Gold or (infoKey.nivel == "vip" and C.Purple or C.Green)
	BtnStroke.Thickness = IS_MOBILE and 3 or 2
	BtnStroke.Parent = FloatBtn

	local btnDragging, btnDragStart, btnStartPos, btnMoveuSe
	FloatBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			btnDragging = true
			btnMoveuSe = false
			btnDragStart = input.Position
			btnStartPos = FloatBtn.Position
		end
	end)
	FloatBtn.InputChanged:Connect(function(input)
		if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - btnDragStart
			if math.abs(delta.X) > 8 or math.abs(delta.Y) > 8 then btnMoveuSe = true end
			FloatBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
		end
	end)
	UserInput.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			btnDragging = false
		end
	end)

	-- ============================================================
	-- UI PRINCIPAL
	-- ============================================================
	local SG = Instance.new("ScreenGui")
	SG.Name = "SailentGari"
	SG.ResetOnSpawn = false
	SG.IgnoreGuiInset = true
	SG.Parent = CoreGui

	local UI_W, UI_H
	if IS_MOBILE then
		local vp = workspace.CurrentCamera.ViewportSize
		UI_W = math.min(vp.X * 0.92, 420)
		UI_H = math.min(vp.Y * 0.85, 700)
	else
		UI_W, UI_H = 400, 680
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
		local function up(i)
			if _G.SailentBloquearDrag then return end
			local x = i.Position - ds
			Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + x.X, sp.Y.Scale, sp.Y.Offset + x.Y)
		end
		Main.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1
				or i.UserInputType == Enum.UserInputType.Touch then
				if _G.SailentBloquearDrag then return end
				d = true; ds = i.Position; sp = Main.Position
				i.Changed:Connect(function()
					if i.UserInputState == Enum.UserInputState.End then d = false end
				end)
			end
		end)
		Main.InputChanged:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseMovement
				or i.UserInputType == Enum.UserInputType.Touch then
				di = i
			end
		end)
		UserInput.InputChanged:Connect(function(i)
			if i == di and d then up(i) end
		end)
	end

	-- HEADER
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
	local H_TOGGLE = IS_MOBILE and 52 or 42
	local FONT_S = IS_MOBILE and 12 or 11
	local FONT_B = IS_MOBILE and 13 or 12

	local function Sec(txt, color)
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
		l.TextColor3 = color or C.Accent
		l.BackgroundTransparency = 1
		l.Position = UDim2.new(0, 12, 0, 0)
		l.Size = UDim2.new(1, -24, 1, 0)
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.Parent = f
	end

	local function Stat(txt, color)
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
			Tween(b, {BackgroundColor3 = color or C.Accent}, 0.08)
			task.wait(0.12)
			Tween(b, {BackgroundColor3 = C.Card}, 0.15)
			if cb then task.spawn(cb) end
		end)
		return b
	end

	local function Toggle(txt, default, cb)
		local f = Instance.new("Frame")
		f.Size = UDim2.new(1, 0, 0, H_TOGGLE)
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

		local BG_W = IS_MOBILE and 52 or 44
		local BG_H = IS_MOBILE and 26 or 22
		local K_SIZE = IS_MOBILE and 22 or 18

		local bg = Instance.new("Frame")
		bg.Size = UDim2.new(0, BG_W, 0, BG_H)
		bg.Position = UDim2.new(1, -(BG_W + 12), 0.5, -BG_H/2)
		bg.BackgroundColor3 = Color3.fromRGB(50,50,60)
		bg.BorderSizePixel = 0
		bg.Parent = f
		local bc = Instance.new("UICorner")
		bc.CornerRadius = UDim.new(1, 0)
		bc.Parent = bg

		local k = Instance.new("Frame")
		k.Size = UDim2.new(0, K_SIZE, 0, K_SIZE)
		k.Position = UDim2.new(0, 2, 0.5, -K_SIZE/2)
		k.BackgroundColor3 = C.Text
		k.BorderSizePixel = 0
		k.Parent = bg
		local kc = Instance.new("UICorner")
		kc.CornerRadius = UDim.new(1, 0)
		kc.Parent = k

		local st = default or false
		local function set(v)
			st = v
			local onX = BG_W - K_SIZE - 2
			if st then
				Tween(bg, {BackgroundColor3 = C.Green}, 0.2)
				Tween(k, {Position = UDim2.new(0, onX, 0.5, -K_SIZE/2)}, 0.2)
			else
				Tween(bg, {BackgroundColor3 = Color3.fromRGB(50,50,60)}, 0.2)
				Tween(k, {Position = UDim2.new(0, 2, 0.5, -K_SIZE/2)}, 0.2)
			end
			if cb then cb(st) end
		end
		if st then
			bg.BackgroundColor3 = C.Green
			k.Position = UDim2.new(0, BG_W - K_SIZE - 2, 0.5, -K_SIZE/2)
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

	local function CriarSlider(parent, min, max, default, callback, tituloTexto, corTitulo, sufixo)
		local SLIDER_H = IS_MOBILE and 80 or 58
		local KNOB = IS_MOBILE and 32 or 22
		local BAR_H = IS_MOBILE and 16 or 12

		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, SLIDER_H)
		frame.BackgroundColor3 = C.Card
		frame.BorderSizePixel = 0
		frame.Parent = parent
		local fc = Instance.new("UICorner")
		fc.CornerRadius = UDim.new(0, 8)
		fc.Parent = frame

		local titulo = Instance.new("TextLabel")
		titulo.Text = tituloTexto or "⚡ Valor"
		titulo.Font = Enum.Font.GothamBold
		titulo.TextSize = IS_MOBILE and 13 or 12
		titulo.TextColor3 = corTitulo or C.Text
		titulo.BackgroundTransparency = 1
		titulo.Position = UDim2.new(0, 12, 0, 8)
		titulo.Size = UDim2.new(0.7, 0, 0, 18)
		titulo.TextXAlignment = Enum.TextXAlignment.Left
		titulo.Parent = frame

		local valorLabel = Instance.new("TextLabel")
		valorLabel.Text = tostring(default) .. (sufixo or "")
		valorLabel.Font = Enum.Font.GothamBold
		valorLabel.TextSize = IS_MOBILE and 16 or 14
		valorLabel.TextColor3 = corTitulo or C.Green
		valorLabel.BackgroundTransparency = 1
		valorLabel.Position = UDim2.new(0.7, 0, 0, 8)
		valorLabel.Size = UDim2.new(0.3, -12, 0, 18)
		valorLabel.TextXAlignment = Enum.TextXAlignment.Right
		valorLabel.Parent = frame

		local bgBar = Instance.new("Frame")
		bgBar.Size = UDim2.new(1, -24, 0, BAR_H)
		bgBar.Position = UDim2.new(0, 12, 0, IS_MOBILE and 42 or 32)
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
		knob.Size = UDim2.new(0, KNOB, 0, KNOB)
		knob.Position = UDim2.new(0, -KNOB/2, 0.5, -KNOB/2)
		knob.BackgroundColor3 = C.Text
		knob.BorderSizePixel = 0
		knob.ZIndex = 2
		knob.Parent = bgBar
		local kc = Instance.new("UICorner")
		kc.CornerRadius = UDim.new(1, 0)
		kc.Parent = knob

		local touchArea = Instance.new("TextButton")
		touchArea.Text = ""
		touchArea.BackgroundTransparency = 1
		touchArea.Size = UDim2.new(1, 0, 0, KNOB + 20)
		touchArea.Position = UDim2.new(0, 0, 0.5, -(KNOB + 20)/2)
		touchArea.Parent = bgBar

		local valor = default
		local arrastando = false

		local function Atualizar(posX)
			local bgAbs = bgBar.AbsolutePosition.X
			local bgSize = bgBar.AbsoluteSize.X
			local percent = math.clamp((posX - bgAbs) / bgSize, 0, 1)
			valor = math.floor(min + (max - min) * percent)
			valorLabel.Text = tostring(valor) .. (sufixo or "")
			fillBar.Size = UDim2.new(percent, 0, 1, 0)
			knob.Position = UDim2.new(percent, -KNOB/2, 0.5, -KNOB/2)
			if callback then callback(valor) end
		end

		local initPercent = (default - min) / (max - min)
		fillBar.Size = UDim2.new(initPercent, 0, 1, 0)
		knob.Position = UDim2.new(initPercent, -KNOB/2, 0.5, -KNOB/2)

		bgBar.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1
				or i.UserInputType == Enum.UserInputType.Touch then
				arrastando = true
				_G.SailentBloquearDrag = true
				Atualizar(i.Position.X)
			end
		end)
		UserInput.InputChanged:Connect(function(i)
			if arrastando and (i.UserInputType == Enum.UserInputType.MouseMovement
				or i.UserInputType == Enum.UserInputType.Touch) then
				Atualizar(i.Position.X)
			end
		end)
		UserInput.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1
				or i.UserInputType == Enum.UserInputType.Touch then
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
	if infoKey.expira and infoKey.expira < 99999999999 then
		local restante = infoKey.expira - os.time()
		local dias = math.floor(restante / 86400)
		Stat("Expira em: " .. dias .. " dias", restante < 86400 and C.Red or C.Yellow)
	end

	Sec("🗑️ AUTO GARI", C.Green)
	local gariStatus = Stat("Status: PARADO", C.Sub)
	local gariStats = Stat("Coletados: 0 | Entregues: 0", C.Sub)
	local gariLixos = Stat("Lixos usados: 0/0", C.Sub)
	local gariTempo = Stat("Tempo: 00s | Por min: 0", C.Sub)

	local gariOn = false
	local gariCount = {coletados = 0, entregues = 0}
	local tempoInicio = 0

	local setGariAtivo = Toggle("Auto Coletar + Entregar", false, function(s)
		gariOn = s
		if s then
			gariStatus.Text = "Status: ● ATIVO"
			gariStatus.TextColor3 = C.Green
			tempoInicio = tick()
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
						local lixo, total = AcharProximoLixo()
						if lixo then
							gariStatus.Text = (Config.vooAtivo and "✈️ Voando pro lixo..." or "📥 Indo pro lixo...")
							local sucesso = IrAte(lixo.Position, 30, Config.vooAtivo and 5 or 4)
							task.wait(0.5)
							if sucesso then
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
					local totalUsados = 0
					for _ in pairs(lixosUsados) do totalUsados += 1 end
					local totalFalhados = 0
					for _ in pairs(lixosFalhados) do totalFalhados += 1 end

					local totalLixos = 0
					local cont = GetLixosContainer()
					if cont then
						for _, v in ipairs(cont:GetChildren()) do
							if v:IsA("BasePart") then totalLixos = totalLixos + 1 end
						end
					end

					local tempoRodando = tick() - tempoInicio
					local totalColetado = gariCount.coletados + gariCount.entregues
					local porMinuto = tempoRodando > 0 and math.floor((totalColetado / tempoRodando) * 60) or 0

					gariStats.Text = "Coletados: "..gariCount.coletados.." | Entregues: "..gariCount.entregues
					gariLixos.Text = "Lixos: "..totalUsados.."/"..totalLixos..(totalFalhados > 0 and " ("..totalFalhados.." falhas)" or "")
					gariTempo.Text = "Tempo: "..FormatarTempo(tempoRodando).." | "..porMinuto.."/min"

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

	-- ============================================================
	-- MODO DE MOVIMENTO (A pé / Voo)
	-- ============================================================
	Sec("🚶 MODO DE MOVIMENTO", C.Cyan)
	Stat("A pé pega o lixo normalmente. Voo é mais rápido e ignora obstáculos.", C.Sub)

	local setVooAtivo = Toggle("✈️ Voo Suave (ignora obstáculos)", false, function(s)
		Config.vooAtivo = s
		SalvarConfig()
		if s then
			IniciarVoo()
		else
			PararVoo()
		end
	end)

	Sec("✈️ AJUSTES DE VOO", C.Cyan)

	CriarSlider(Content, 20, 300, Config.vooVelocidade, function(v)
		Config.vooVelocidade = v
	end, "✈️ Velocidade de voo", C.Cyan, " studs/s")

	CriarSlider(Content, 3, 60, Config.vooAltura, function(v)
		Config.vooAltura = v
	end, "📏 Altura do voo", C.Cyan, " studs")

	CriarSlider(Content, 1, 10, Config.vooSuavidade, function(v)
		Config.vooSuavidade = v
	end, "🌊 Suavidade", C.Cyan, "")

	-- ============================================================
	-- VELOCIDADE A PÉ
	-- ============================================================
	Sec("⚡ VELOCIDADE A PÉ", C.Yellow)
	CriarSlider(Content, 16, 200, Config.velocidade, function(valor)
		velocidadeAtual = valor
		Config.velocidade = valor
		local hum = GetHum()
		if hum then hum.WalkSpeed = valor end
	end, "⚡ Velocidade", C.Yellow, "")

	-- ============================================================
	-- NOCLIP
	-- ============================================================
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

	Sec("🔊 SOM", C.Blue)
	Toggle("Sons ativados", Config.somAtivo, function(s)
		Config.somAtivo = s
		SalvarConfig()
	end)

	Sec("🚨 EMERGÊNCIA", C.Red)
	Btn("🛑 PARAR TUDO", C.Red, function()
		gariOn = false
		setGariAtivo(false)
		noclipOn = false
		if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
		PararVoo()
		if setVooAtivo then setVooAtivo(false) end
		gariStatus.Text = "Status: PARADO"
		gariStatus.TextColor3 = C.Sub
		local hum = GetHum()
		if hum then hum.WalkSpeed = 16 end
	end)

	if infoKey.nivel == "admin" then
		Sec("⚙️ ADMIN", C.Gold)
		Btn("🚪 Deslogar Key", C.Red, function()
			PararVoo()
			LimparKeySalva()
			SafeDeleteFile(CACHE_FILE)
			lp:Kick("Key removida. Reabra o script.")
		end)
	end

	-- ============================================================
	-- ABRIR/FECHAR UI
	-- ============================================================
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
			setGariAtivo(false)
			noclipOn = false
			if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
			PararVoo()
			if setVooAtivo then setVooAtivo(false) end
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

	if IS_MOBILE then
		workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			local vp = workspace.CurrentCamera.ViewportSize
			local nW = math.min(vp.X * 0.92, 420)
			local nH = math.min(vp.Y * 0.85, 700)
			UI_W, UI_H = nW, nH
			if uiAberta and not minimizado then
				Main.Size = UDim2.new(0, nW, 0, nH)
				Main.Position = UDim2.new(0.5, -nW/2, 0.5, -nH/2)
			end
		end)
	end

	-- ============================================================
	-- RECONEXÃO
	-- ============================================================
	lp.CharacterAdded:Connect(function(char)
		Log("🔄 Character respawnou, aguardando...")
		task.wait(2)
		local hum = char:FindFirstChild("Humanoid")
		if hum and gariOn then
			hum.WalkSpeed = velocidadeAtual
			if Config.vooAtivo then
				task.wait(0.5)
				IniciarVoo()
			end
			Log("✅ Reconectado, continuando...")
		end
	end)

	-- Aplica config inicial
	if Config.vooAtivo then
		setVooAtivo(true)
	end

	Log("🗑️ Sailent Auto Gari v" .. SCRIPT_VERSION .. " | " .. (infoKey.nome or "Cliente") .. " | " .. (IS_MOBILE and "MOBILE" or "PC"))
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

	local KW, KH
	if IS_MOBILE then
		local vp = workspace.CurrentCamera.ViewportSize
		KW = math.min(vp.X * 0.92, 400)
		KH = math.min(vp.Y * 0.75, 420)
	else
		KW, KH = 400, 400
	end

	local KeyFrame = Instance.new("Frame")
	KeyFrame.Size = UDim2.new(0, KW, 0, KH)
	KeyFrame.Position = UDim2.new(0.5, -KW/2, 0.5, -KH/2)
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
	Titulo.Text = "🔐 SAILENT KEY SYSTEM"
	Titulo.Font = Enum.Font.GothamBold
	Titulo.TextSize = IS_MOBILE and 18 or 20
	Titulo.TextColor3 = C.Text
	Titulo.BackgroundTransparency = 1
	Titulo.Size = UDim2.new(1, 0, 0, 50)
	Titulo.Position = UDim2.new(0, 0, 0, 15)
	Titulo.Parent = KeyFrame

	local Sub = Instance.new("TextLabel")
	Sub.Text = "Digite sua key abaixo"
	Sub.Font = Enum.Font.GothamMedium
	Sub.TextSize = IS_MOBILE and 13 or 12
	Sub.TextColor3 = C.Sub
	Sub.BackgroundTransparency = 1
	Sub.Size = UDim2.new(1, 0, 0, 20)
	Sub.Position = UDim2.new(0, 0, 0, 62)
	Sub.Parent = KeyFrame

	local H_INPUT = IS_MOBILE and 54 or 50
	local H_BTN = IS_MOBILE and 54 or 50
	local PAD = IS_MOBILE and 20 or 30

	local KeyInput = Instance.new("TextBox")
	KeyInput.PlaceholderText = "SAILENT-XXXX-XXXX-XXXX"
	KeyInput.Font = Enum.Font.Code
	KeyInput.TextSize = IS_MOBILE and 15 or 14
	KeyInput.TextColor3 = C.Text
	KeyInput.PlaceholderColor3 = C.Sub
	KeyInput.BackgroundColor3 = C.Card
	KeyInput.BorderSizePixel = 0
	KeyInput.Size = UDim2.new(1, -PAD*2, 0, H_INPUT)
	KeyInput.Position = UDim2.new(0, PAD, 0, 95)
	KeyInput.Text = ""
	KeyInput.ClearTextOnFocus = false
	KeyInput.Parent = KeyFrame

	local IC = Instance.new("UICorner")
	IC.CornerRadius = UDim.new(0, 10)
	IC.Parent = KeyInput

	local HWIDLabel = Instance.new("TextLabel")
	HWIDLabel.Text = "Seu HWID: " .. GetHWID():sub(1,16) .. "..."
	HWIDLabel.Font = Enum.Font.Code
	HWIDLabel.TextSize = IS_MOBILE and 11 or 10
	HWIDLabel.TextColor3 = C.Sub
	HWIDLabel.BackgroundTransparency = 1
	HWIDLabel.Size = UDim2.new(1, -PAD*2, 0, 18)
	HWIDLabel.Position = UDim2.new(0, PAD, 0, 95 + H_INPUT + 8)
	HWIDLabel.Parent = KeyFrame

	local Status = Instance.new("TextLabel")
	Status.Text = "Status: ● Aguardando"
	Status.Font = Enum.Font.GothamBold
	Status.TextSize = IS_MOBILE and 13 or 12
	Status.TextColor3 = C.Yellow
	Status.BackgroundTransparency = 1
	Status.Size = UDim2.new(1, -PAD*2, 0, 20)
	Status.Position = UDim2.new(0, PAD, 0, 95 + H_INPUT + 32)
	Status.Parent = KeyFrame

	local ValidarBtn = Instance.new("TextButton")
	ValidarBtn.Text = "🔓 VALIDAR KEY"
	ValidarBtn.Font = Enum.Font.GothamBold
	ValidarBtn.TextSize = IS_MOBILE and 16 or 15
	ValidarBtn.TextColor3 = C.Text
	ValidarBtn.BackgroundColor3 = C.Green
	ValidarBtn.BorderSizePixel = 0
	ValidarBtn.Size = UDim2.new(1, -PAD*2, 0, H_BTN)
	ValidarBtn.Position = UDim2.new(0, PAD, 0, 95 + H_INPUT + 60)
	ValidarBtn.AutoButtonColor = false
	ValidarBtn.Parent = KeyFrame

	local VC = Instance.new("UICorner")
	VC.CornerRadius = UDim.new(0, 10)
	VC.Parent = ValidarBtn

	local CopiarBtn = Instance.new("TextButton")
	CopiarBtn.Text = "📋 Copiar HWID"
	CopiarBtn.Font = Enum.Font.GothamBold
	CopiarBtn.TextSize = IS_MOBILE and 12 or 11
	CopiarBtn.TextColor3 = C.Text
	CopiarBtn.BackgroundColor3 = C.Card
	CopiarBtn.BorderSizePixel = 0
	CopiarBtn.Size = UDim2.new(1, -PAD*2, 0, H_BTN - 10)
	CopiarBtn.Position = UDim2.new(0, PAD, 0, 95 + H_INPUT + 60 + H_BTN + 10)
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
	Info.TextSize = IS_MOBILE and 12 or 11
	Info.TextColor3 = C.Sub
	Info.BackgroundTransparency = 1
	Info.Size = UDim2.new(1, -PAD*2, 0, 20)
	Info.Position = UDim2.new(0, PAD, 0, 95 + H_INPUT + 60 + H_BTN + 60)
	Info.Parent = KeyFrame

	ValidarBtn.MouseEnter:Connect(function()
		Tween(ValidarBtn, {BackgroundColor3 = Color3.fromRGB(100, 240, 140)}, 0.15)
	end)
	ValidarBtn.MouseLeave:Connect(function()
		Tween(ValidarBtn, {BackgroundColor3 = C.Green}, 0.15)
	end)

	local validando = false
	ValidarBtn.MouseButton1Click:Connect(function()
		if validando then return end
		local key = KeyInput.Text
		if key == "" then
			Status.Text = "Status: ❌ Digite a key"
			Status.TextColor3 = C.Red
			return
		end
		validando = true
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
			Status.Text = "Status: ❌ " .. tostring(info or "Erro")
			Status.TextColor3 = C.Red
		end
		validando = false
	end)
end

-- ============================================================
-- INICIAR
-- ============================================================
task.spawn(function()
	Log("🗑️ Sailent Auto Gari v" .. SCRIPT_VERSION)
	Log("📱 Modo: " .. (IS_MOBILE and (IS_TABLET and "TABLET" or "MOBILE") or "PC"))
	Log("🔑 HWID: " .. GetHWID())

	local keySalva, hwidSalvo = TemKeySalva()

	if keySalva then
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

	AbrirUIKey()
end)

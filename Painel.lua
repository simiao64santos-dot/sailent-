-- ============================================================
-- SAILENT — PAINEL GERADOR DE KEYS (só pro dono usar)
-- ============================================================
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local UserInput = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ============================================================
-- CONFIG — SUA CHAVE DE ADMIN DO PAINEL
-- ============================================================
local SENHA_PAINEL = "sailent-dono-2025" -- MUDE ISSO!

for _, n in ipairs({"SailentPainel", "SailentPainelBtn"}) do
	if CoreGui:FindFirstChild(n) then CoreGui[n]:Destroy() end
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
	Gold = Color3.fromRGB(255,215,0),
	Black = Color3.fromRGB(10,10,15),
}

local function Tween(o,p,t)
	local tw = TweenService:Create(o, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint), p)
	tw:Play()
	return tw
end

-- ============================================================
-- SHA-256 (mesma função do main)
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
-- GERADOR DE KEY ALEATÓRIA
-- ============================================================
local function GerarKeyAleatoria()
	local chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
	local function bloco()
		local s = ""
		for i = 1, 4 do
			local idx = math.random(1, #chars)
			s = s .. chars:sub(idx, idx)
		end
		return s
	end
	return "SAILENT-" .. bloco() .. "-" .. bloco() .. "-" .. bloco()
end

-- ============================================================
-- ESTADO (keys geradas na sessão)
-- ============================================================
local KeysGeradas = {} -- lista de {key, hash, nome, nivel, expira, hwid, max_usos, criada}

local function GerarJSON()
	local obj = {
		versao = "2.0",
		ultima_atualizacao = os.time(),
		keys = {}
	}
	for _, k in ipairs(KeysGeradas) do
		obj.keys[k.hash] = {
			nome = k.nome,
			nivel = k.nivel,
			criada = k.criada,
			expira = k.expira,
			status = "ativa",
			hwid = k.hwid or (function() return nil end)(),
			max_usos = k.max_usos or -1,
			usos = 0,
		}
	end
	-- remove null manualmente (JSONEncode do Roblox não gosta)
	local json = HttpService:JSONEncode(obj)
	json = json:gsub('"hwid":null,', '') -- remove hwid null
	return json
end

-- ============================================================
-- UI
-- ============================================================
local SenhaOK = false

local SGSenha = Instance.new("ScreenGui")
SGSenha.Name = "SailentPainel"
SGSenha.ResetOnSpawn = false
SGSenha.IgnoreGuiInset = true
SGSenha.Parent = CoreGui

local SenhaFrame = Instance.new("Frame")
SenhaFrame.Size = UDim2.new(0, 340, 0, 220)
SenhaFrame.Position = UDim2.new(0.5, -170, 0.5, -110)
SenhaFrame.BackgroundColor3 = C.BG
SenhaFrame.BorderSizePixel = 0
SenhaFrame.Parent = SGSenha
local SFC = Instance.new("UICorner")
SFC.CornerRadius = UDim.new(0, 14)
SFC.Parent = SenhaFrame
local SFS = Instance.new("UIStroke")
SFS.Color = C.Gold
SFS.Thickness = 2
SFS.Parent = SenhaFrame

local STitulo = Instance.new("TextLabel")
STitulo.Text = "🔒 PAINEL DO DONO"
STitulo.Font = Enum.Font.GothamBold
STitulo.TextSize = 18
STitulo.TextColor3 = C.Gold
STitulo.BackgroundTransparency = 1
STitulo.Size = UDim2.new(1, 0, 0, 40)
STitulo.Position = UDim2.new(0, 0, 0, 15)
STitulo.Parent = SenhaFrame

local SInput = Instance.new("TextBox")
SInput.PlaceholderText = "Digite a senha do painel"
SInput.Font = Enum.Font.Code
SInput.TextSize = 14
SInput.TextColor3 = C.Text
SInput.PlaceholderColor3 = C.Sub
SInput.BackgroundColor3 = C.Card
SInput.BorderSizePixel = 0
SInput.Size = UDim2.new(1, -60, 0, 44)
SInput.Position = UDim2.new(0, 30, 0, 70)
SInput.Text = ""
SInput.Parent = SenhaFrame
local SIC = Instance.new("UICorner")
SIC.CornerRadius = UDim.new(0, 8)
SIC.Parent = SInput

local SBtn = Instance.new("TextButton")
SBtn.Text = "🔓 ENTRAR"
SBtn.Font = Enum.Font.GothamBold
SBtn.TextSize = 14
SBtn.TextColor3 = C.Text
SBtn.BackgroundColor3 = C.Gold
SBtn.BorderSizePixel = 0
SBtn.Size = UDim2.new(1, -60, 0, 44)
SBtn.Position = UDim2.new(0, 30, 0, 130)
SBtn.AutoButtonColor = false
SBtn.Parent = SenhaFrame
local SBC = Instance.new("UICorner")
SBC.CornerRadius = UDim.new(0, 8)
SBC.Parent = SBtn

local SStatus = Instance.new("TextLabel")
SStatus.Text = ""
SStatus.Font = Enum.Font.GothamBold
SStatus.TextSize = 11
SStatus.TextColor3 = C.Red
SStatus.BackgroundTransparency = 1
SStatus.Size = UDim2.new(1, -60, 0, 20)
SStatus.Position = UDim2.new(0, 30, 0, 180)
SStatus.Parent = SenhaFrame

SBtn.MouseButton1Click:Connect(function()
	if SInput.Text == SENHA_PAINEL then
		SenhaOK = true
		SenhaFrame:Destroy()
		-- abre painel principal
		local function AbrirPainelPrincipal()
			local SG = Instance.new("ScreenGui")
			SG.Name = "SailentPainel"
			SG.ResetOnSpawn = false
			SG.IgnoreGuiInset = true
			SG.Parent = CoreGui

			local Main = Instance.new("Frame")
			Main.Size = UDim2.new(0, 620, 0, 620)
			Main.Position = UDim2.new(0.5, -310, 0.5, -310)
			Main.BackgroundColor3 = C.BG
			Main.BorderSizePixel = 0
			Main.Parent = SG
			local MC = Instance.new("UICorner")
			MC.CornerRadius = UDim.new(0, 14)
			MC.Parent = Main
			local MS = Instance.new("UIStroke")
			MS.Color = C.Gold
			MS.Thickness = 2
			MS.Parent = Main

			-- drag
			do
				local d, ds, sp
				local di
				local function up(i)
					local x = i.Position - ds
					Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + x.X, sp.Y.Scale, sp.Y.Offset + x.Y)
				end
				Main.InputBegan:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
						d = true; ds = i.Position; sp = Main.Position
						i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then d = false end end)
					end
				end)
				Main.InputChanged:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
				end)
				UserInput.InputChanged:Connect(function(i) if i == di and d then up(i) end end)
			end

			-- header
			local Header = Instance.new("Frame")
			Header.Size = UDim2.new(1, 0, 0, 56)
			Header.BackgroundColor3 = C.Card
			Header.BorderSizePixel = 0
			Header.Parent = Main
			local HC = Instance.new("UICorner")
			HC.CornerRadius = UDim.new(0, 14)
			HC.Parent = Header

			local HT = Instance.new("TextLabel")
			HT.Text = "🔑 SAILENT KEY GENERATOR"
			HT.Font = Enum.Font.GothamBold
			HT.TextSize = 16
			HT.TextColor3 = C.Gold
			HT.BackgroundTransparency = 1
			HT.Position = UDim2.new(0, 15, 0, 0)
			HT.Size = UDim2.new(0.7, 0, 1, 0)
			HT.TextXAlignment = Enum.TextXAlignment.Left
			HT.Parent = Header

			local XBtn = Instance.new("TextButton")
			XBtn.Text = "✕"
			XBtn.Font = Enum.Font.GothamBold
			XBtn.TextSize = 18
			XBtn.TextColor3 = C.Sub
			XBtn.BackgroundColor3 = C.Card
			XBtn.BorderSizePixel = 0
			XBtn.Size = UDim2.new(0, 56, 1, 0)
			XBtn.Position = UDim2.new(1, -56, 0, 0)
			XBtn.Parent = Header
			local XC = Instance.new("UICorner")
			XC.CornerRadius = UDim.new(0, 14)
			XC.Parent = XBtn
			XBtn.MouseButton1Click:Connect(function() SG:Destroy() end)

			-- coluna esquerda — formulário
			local Left = Instance.new("Frame")
			Left.Size = UDim2.new(0.5, -15, 1, -76)
			Left.Position = UDim2.new(0, 10, 0, 66)
			Left.BackgroundTransparency = 1
			Left.Parent = Main

			local LLay = Instance.new("UIListLayout")
			LLay.Padding = UDim.new(0, 8)
			LLay.Parent = Left

			local function Label(txt)
				local l = Instance.new("TextLabel")
				l.Text = txt
				l.Font = Enum.Font.GothamBold
				l.TextSize = 11
				l.TextColor3 = C.Sub
				l.BackgroundTransparency = 1
				l.Size = UDim2.new(1, 0, 0, 18)
				l.TextXAlignment = Enum.TextXAlignment.Left
				l.Parent = Left
				return l
			end

			local function Input(placeholder)
				local t = Instance.new("TextBox")
				t.PlaceholderText = placeholder
				t.Font = Enum.Font.Code
				t.TextSize = 13
				t.TextColor3 = C.Text
				t.PlaceholderColor3 = C.Sub
				t.BackgroundColor3 = C.Card
				t.BorderSizePixel = 0
				t.Size = UDim2.new(1, 0, 0, 36)
				t.Text = ""
				t.ClearTextOnFocus = false
				t.Parent = Left
				local c = Instance.new("UICorner")
				c.CornerRadius = UDim.new(0, 6)
				c.Parent = t
				return t
			end

			local function Dropdown(opcoes, default)
				local f = Instance.new("Frame")
				f.Size = UDim2.new(1, 0, 0, 36)
				f.BackgroundColor3 = C.Card
				f.BorderSizePixel = 0
				f.Parent = Left
				local c = Instance.new("UICorner")
				c.CornerRadius = UDim.new(0, 6)
				c.Parent = f
				local atual = default
				local lbl = Instance.new("TextLabel")
				lbl.Text = atual
				lbl.Font = Enum.Font.GothamBold
				lbl.TextSize = 12
				lbl.TextColor3 = C.Text
				lbl.BackgroundTransparency = 1
				lbl.Size = UDim2.new(1, -40, 1, 0)
				lbl.Position = UDim2.new(0, 10, 0, 0)
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.Parent = f
				local arrow = Instance.new("TextLabel")
				arrow.Text = "▼"
				arrow.Font = Enum.Font.GothamBold
				arrow.TextSize = 10
				arrow.TextColor3 = C.Sub
				arrow.BackgroundTransparency = 1
				arrow.Size = UDim2.new(0, 20, 1, 0)
				arrow.Position = UDim2.new(1, -25, 0, 0)
				arrow.Parent = f
				local btn = Instance.new("TextButton")
				btn.Text = ""
				btn.BackgroundTransparency = 1
				btn.Size = UDim2.new(1, 0, 1, 0)
				btn.Parent = f
				local aberto = false
				local lista = Instance.new("Frame")
				lista.Visible = false
				lista.Size = UDim2.new(1, 0, 0, 0)
				lista.AutomaticSize = Enum.AutomaticSize.Y
				lista.Position = UDim2.new(0, 0, 1, 2)
				lista.BackgroundColor3 = C.Card
				lista.BorderSizePixel = 0
				lista.ZIndex = 5
				lista.Parent = f
				local lc = Instance.new("UICorner")
				lc.CornerRadius = UDim.new(0, 6)
				lc.Parent = lista
				local ll = Instance.new("UIListLayout")
				ll.Parent = lista
				for _, op in ipairs(opcoes) do
					local o = Instance.new("TextButton")
					o.Text = op
					o.Font = Enum.Font.GothamBold
					o.TextSize = 12
					o.TextColor3 = C.Text
					o.BackgroundColor3 = C.Card
					o.BorderSizePixel = 0
					o.Size = UDim2.new(1, 0, 0, 30)
					o.AutoButtonColor = false
					o.ZIndex = 6
					o.Parent = lista
					o.MouseButton1Click:Connect(function()
						atual = op
						lbl.Text = op
						lista.Visible = false
						aberto = false
					end)
				end
				btn.MouseButton1Click:Connect(function()
					aberto = not aberto
					lista.Visible = aberto
				end)
				return function() return atual end
			end

			Label("Nome do cliente")
			local NomeInput = Input("Ex: João Silva")

			Label("Nível da key")
			local getNivel = Dropdown({"normal", "vip", "admin"}, "normal")

			Label("Duração (dias) — 0 = nunca expira")
			local DuracaoInput = Input("Ex: 30")

			Label("HWID (opcional — deixa vazio pra liberar geral)")
			local HwidInput = Input("cole o HWID do cliente ou deixe vazio")

			Label("Máximo de usos (-1 = ilimitado)")
			local UsosInput = Input("-1")

			-- BOTÃO GERAR
			local GerarBtn = Instance.new("TextButton")
			GerarBtn.Text = "✨ GERAR KEY"
			GerarBtn.Font = Enum.Font.GothamBold
			GerarBtn.TextSize = 14
			GerarBtn.TextColor3 = C.Text
			GerarBtn.BackgroundColor3 = C.Green
			GerarBtn.BorderSizePixel = 0
			GerarBtn.Size = UDim2.new(1, 0, 0, 44)
			GerarBtn.AutoButtonColor = false
			GerarBtn.Parent = Left
			local GBC = Instance.new("UICorner")
			GBC.CornerRadius = UDim.new(0, 8)
			GBC.Parent = GerarBtn

			-- coluna direita — lista
			local Right = Instance.new("Frame")
			Right.Size = UDim2.new(0.5, -15, 1, -76)
			Right.Position = UDim2.new(0.5, 5, 0, 66)
			Right.BackgroundTransparency = 1
			Right.Parent = Main

			local RT = Instance.new("TextLabel")
			RT.Text = "📋 KEYS GERADAS NESTA SESSÃO"
			RT.Font = Enum.Font.GothamBold
			RT.TextSize = 12
			RT.TextColor3 = C.Gold
			RT.BackgroundTransparency = 1
			RT.Size = UDim2.new(1, 0, 0, 24)
			RT.TextXAlignment = Enum.TextXAlignment.Left
			RT.Parent = Right

			local Scroll = Instance.new("ScrollingFrame")
			Scroll.Size = UDim2.new(1, 0, 1, -30)
			Scroll.Position = UDim2.new(0, 0, 0, 30)
			Scroll.BackgroundColor3 = C.Card
			Scroll.BorderSizePixel = 0
			Scroll.ScrollBarThickness = 4
			Scroll.ScrollBarImageColor3 = C.Gold
			Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
			Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
			Scroll.Parent = Right
			local SC = Instance.new("UICorner")
			SC.CornerRadius = UDim.new(0, 8)
			SC.Parent = Scroll
			local SLay = Instance.new("UIListLayout")
			SLay.Padding = UDim.new(0, 4)
			SLay.Parent = Scroll
			local SPad = Instance.new("UIPadding")
			SPad.PaddingTop = UDim.new(0, 6)
			SPad.PaddingBottom = UDim.new(0, 6)
			SPad.PaddingLeft = UDim.new(0, 6)
			SPad.PaddingRight = UDim.new(0, 6)
			SPad.Parent = Scroll

			local function AtualizarLista()
				for _, c in ipairs(Scroll:GetChildren()) do
					if c:IsA("Frame") or c:IsA("TextButton") then c:Destroy() end
				end
				for i = #KeysGeradas, 1, -1 do
					local k = KeysGeradas[i]
					local Item = Instance.new("TextButton")
					Item.Text = ""
					Item.BackgroundColor3 = C.BG
					Item.BorderSizePixel = 0
					Item.Size = UDim2.new(1, 0, 0, 60)
					Item.AutoButtonColor = false
					Item.Parent = Scroll
					local IC2 = Instance.new("UICorner")
					IC2.CornerRadius = UDim.new(0, 6)
					IC2.Parent = Item

					local L1 = Instance.new("TextLabel")
					L1.Text = k.key
					L1.Font = Enum.Font.Code
					L1.TextSize = 11
					L1.TextColor3 = C.Green
					L1.BackgroundTransparency = 1
					L1.Position = UDim2.new(0, 8, 0, 4)
					L1.Size = UDim2.new(1, -16, 0, 18)
					L1.TextXAlignment = Enum.TextXAlignment.Left
					L1.Parent = Item

					local L2 = Instance.new("TextLabel")
					local dias = k.expira >= 99999999999 and "∞" or math.floor((k.expira - os.time()) / 86400) .. "d"
					L2.Text = k.nome .. " • " .. k.nivel:upper() .. " • " .. dias
					L2.Font = Enum.Font.GothamMedium
					L2.TextSize = 10
					L2.TextColor3 = C.Sub
					L2.BackgroundTransparency = 1
					L2.Position = UDim2.new(0, 8, 0, 24)
					L2.Size = UDim2.new(1, -16, 0, 14)
					L2.TextXAlignment = Enum.TextXAlignment.Left
					L2.Parent = Item

					local L3 = Instance.new("TextLabel")
					L3.Text = "📋 clique pra copiar"
					L3.Font = Enum.Font.GothamBold
					L3.TextSize = 9
					L3.TextColor3 = C.Yellow
					L3.BackgroundTransparency = 1
					L3.Position = UDim2.new(0, 8, 0, 42)
					L3.Size = UDim2.new(1, -16, 0, 12)
					L3.TextXAlignment = Enum.TextXAlignment.Left
					L3.Parent = Item

					Item.MouseButton1Click:Connect(function()
						pcall(function() if setclipboard then setclipboard(k.key) end end)
						L3.Text = "✅ copiada!"
						L3.TextColor3 = C.Green
						task.wait(1.2)
						L3.Text = "📋 clique pra copiar"
						L3.TextColor3 = C.Yellow
					end)
				end
			end

			-- BOTÕES DE AÇÃO (embaixo do formulário)
			local AcoesFrame = Instance.new("Frame")
			AcoesFrame.Size = UDim2.new(1, 0, 0, 90)
			AcoesFrame.BackgroundTransparency = 1
			AcoesFrame.Parent = Left
			local ALay = Instance.new("UIListLayout")
			ALay.Padding = UDim.new(0, 6)
			ALay.Parent = AcoesFrame

			local CopiarJSON = Instance.new("TextButton")
			CopiarJSON.Text = "📋 COPIAR JSON COMPLETO"
			CopiarJSON.Font = Enum.Font.GothamBold
			CopiarJSON.TextSize = 12
			CopiarJSON.TextColor3 = C.Text
			CopiarJSON.BackgroundColor3 = C.Blue
			CopiarJSON.BorderSizePixel = 0
			CopiarJSON.Size = UDim2.new(1, 0, 0, 38)
			CopiarJSON.AutoButtonColor = false
			CopiarJSON.Parent = AcoesFrame
			local CJC = Instance.new("UICorner")
			CJC.CornerRadius = UDim.new(0, 8)
			CJC.Parent = CopiarJSON
			CopiarJSON.MouseButton1Click:Connect(function()
				local json = GerarJSON()
				pcall(function() if setclipboard then setclipboard(json) end end)
				CopiarJSON.Text = "✅ JSON COPIADO!"
				task.wait(1.5)
				CopiarJSON.Text = "📋 COPIAR JSON COMPLETO"
			end)

			local LimparTudo = Instance.new("TextButton")
			LimparTudo.Text = "🗑️ LIMPAR LISTA"
			LimparTudo.Font = Enum.Font.GothamBold
			LimparTudo.TextSize = 12
			LimparTudo.TextColor3 = C.Text
			LimparTudo.BackgroundColor3 = C.Red
			LimparTudo.BorderSizePixel = 0
			LimparTudo.Size = UDim2.new(1, 0, 0, 38)
			LimparTudo.AutoButtonColor = false
			LimparTudo.Parent = AcoesFrame
			local LTC = Instance.new("UICorner")
			LTC.CornerRadius = UDim.new(0, 8)
			LTC.Parent = LimparTudo
			LimparTudo.MouseButton1Click:Connect(function()
				KeysGeradas = {}
				AtualizarLista()
			end)

			-- LÓGICA DO GERAR
			GerarBtn.MouseButton1Click:Connect(function()
				local nome = NomeInput.Text ~= "" and NomeInput.Text or "Cliente"
				local nivel = getNivel()
				local dias = tonumber(DuracaoInput.Text) or 30
				local hwid = HwidInput.Text ~= "" and HwidInput.Text or nil
				local usos = tonumber(UsosInput.Text) or -1

				local novaKey = GerarKeyAleatoria()
				local hash = sha256(novaKey)
				local expira = dias == 0 and 99999999999 or (os.time() + dias * 86400)

				table.insert(KeysGeradas, {
					key = novaKey,
					hash = hash,
					nome = nome,
					nivel = nivel,
					expira = expira,
					hwid = hwid,
					max_usos = usos,
					criada = os.time(),
				})

				-- limpa campos
				NomeInput.Text = ""
				DuracaoInput.Text = ""
				HwidInput.Text = ""
				UsosInput.Text = "-1"

				AtualizarLista()

				GerarBtn.Text = "✅ KEY GERADA!"
				task.wait(1.2)
				GerarBtn.Text = "✨ GERAR KEY"
			end)

			AtualizarLista()
		end

		AbrirPainelPrincipal()
	else
		SStatus.Text = "❌ Senha incorreta"
		task.wait(1.5)
		SStatus.Text = ""
	end
end)

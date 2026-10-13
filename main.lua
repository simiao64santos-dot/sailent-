-- ===== AUTH =====
local authOk = loadstring(game:HttpGet("https://raw.githubusercontent.com/simiao64santos-dot/sailent-/refs/heads/main/auth.lua"))()
if not authOk then return end
-- ===== FIM AUTH =====

-- ============================================================
-- SAILENT AUTO GARI v7.0 — UI Pizza + Velocidade Única (LIMPO)
-- ============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local lp = Players.LocalPlayer

for _, name in ipairs({"SailentGari", "SailentFloatBtn"}) do
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
local function Log(m) print("[Gari] "..tostring(m)) end

-- Helpers
local function HRP() local c = lp.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function HUM() local c = lp.Character; return c and c:FindFirstChildOfClass("Humanoid") end

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

local function GetPrompt(item)
	if not item then return nil end
	return item:FindFirstChildWhichIsA("ProximityPrompt", true)
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
local CONFIG_FILE = "sailent_gari_cfg.txt"
local CFG = {
	vel = 100,
	alturaVoo = 2,
	modoVoo = false,
	noclip = true,
	antiAfk = true,
	godMode = true,
	travarCam = true,
	autoGari = false,
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
CFG.godMode = true

local function Salvar()
	local s = ""
	for k, v in pairs(CFG) do if tostring(v) ~= "" then s = s .. k .. "=" .. tostring(v) .. "\n" end end
	pcall(function() if writefile then writefile(CONFIG_FILE, s) end end)
end

-- Achar lixo/caminhão
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
	local hrp = HRP()
	if not hrp then return nil end
	local disponiveis = {}
	for _, lixo in ipairs(cont:GetChildren()) do
		if lixo:IsA("BasePart") and not lixosUsados[lixo] then
			table.insert(disponiveis, {lixo = lixo, dist = (lixo.Position - hrp.Position).Magnitude})
		end
	end
	if #disponiveis == 0 then
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

	local velFrame = CFG.vel * 0.05

	local t0 = tick()
	while tick() - t0 < timeout do
		local h = HRP()
		if not h then break end
		local diff = posAlvo - h.Position
		if diff.Magnitude < 6 then break end
		local direcao = diff.Unit
		local novaPos = h.Position + (direcao * velFrame)
		pcall(function() h.CFrame = CFrame.new(novaPos) end)
		task.wait(0.03)
	end

	local t2 = tick()
	local ultimaY = nil
	local parado = 0
	while tick() - t2 < 5 do
		local h = HRP()
		if not h then break end
		local yAtual = h.Position.Y
		pcall(function() h.CFrame = CFrame.new(h.Position - Vector3.new(0, 0.8, 0)) end)
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
		if p and p.Parent then pcall(function() p.CanCollide = v end) end
	end
	local h = HRP()
	if h then pcall(function() h.AssemblyLinearVelocity = Vector3.new(0,0,0) end) end
	return true
end

local function IrPara(pos, timeout)
	if CFG.modoVoo then return Voar(pos, timeout) else return Andar(pos, timeout) end
end

-- God Mode
local GodConns = {}
local ultimaPosSegura = nil
local ultimoReset = 0
local godModeAtivo = true

local function AtivarGodNoChar(char)
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	local connLoop = RunService.Heartbeat:Connect(function()
		if not godModeAtivo then return end
		local h = char:FindFirstChildOfClass("Humanoid"); if not h then return end
		if h.Health > 0 and h.Health < h.MaxHealth then h.Health = h.MaxHealth end
	end)
	table.insert(GodConns, connLoop)

	local connHealth = hum.HealthChanged:Connect(function(novaVida)
		if not godModeAtivo then return end
		if novaVida < hum.MaxHealth and novaVida > 0 then hum.Health = hum.MaxHealth end
	end)
	table.insert(GodConns, connHealth)

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
	table.insert(GodConns, connFalling)

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
			end
		end
	end)
	table.insert(GodConns, connQueda)

	local connZero = RunService.Heartbeat:Connect(function()
		if not godModeAtivo then return end
		local h = char:FindFirstChildOfClass("Humanoid"); if not h then return end
		if h.Health <= 0 and h:GetState() ~= Enum.HumanoidStateType.Dead then
			pcall(function() h.Health = h.MaxHealth end)
		end
	end)
	table.insert(GodConns, connZero)

	pcall(function() hum.MaxHealth = 10000; hum.Health = 10000 end)
	local connMaxH = hum:GetPropertyChangedSignal("MaxHealth"):Connect(function()
		pcall(function()
			if hum.MaxHealth < 10000 then hum.MaxHealth = 10000; hum.Health = 10000 end
		end)
	end)
	table.insert(GodConns, connMaxH)
	pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
end

local function AtivarGod()
	for _, c in ipairs(GodConns) do pcall(function() c:Disconnect() end) end
	GodConns = {}
	if lp.Character then AtivarGodNoChar(lp.Character) end
	if _G.SailentCharConn then pcall(function() _G.SailentCharConn:Disconnect() end); _G.SailentCharConn = nil end
	_G.SailentCharConn = lp.CharacterAdded:Connect(function(novoChar)
		task.wait(0.3)
		ultimaPosSegura = nil
		AtivarGodNoChar(novoChar)
	end)
end

-- Stats
local Stats = { coletados = 0, entregues = 0, inicio = tick() }
local function FmtT(s) s = math.floor(s); return string.format("%02d:%02d:%02d", math.floor(s/3600), math.floor(s%3600/60), s%60) end
local function Resumo() local d = tick() - Stats.inicio; return string.format("⏱ %s  🗑 %d  📤 %d", FmtT(d), Stats.coletados, Stats.entregues) end

-- Travar cam
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
	for _, n in ipairs({"SailentGari", "SailentFloatBtn"}) do
		local o = CoreGui:FindFirstChild(n); if o then pcall(function() o:Destroy() end) end
	end
	task.wait(0.05)

	local SGB = Instance.new("ScreenGui")
	SGB.Name = "SailentFloatBtn"; SGB.ResetOnSpawn = false; SGB.IgnoreGuiInset = true; SGB.DisplayOrder = 5; SGB.Parent = CoreGui

	local FB = Instance.new("TextButton")
	FB.Text = "🗑️"; FB.Font = Enum.Font.GothamBold; FB.TextSize = 26
	FB.TextColor3 = Color3.fromRGB(255,255,255); FB.BackgroundColor3 = C.Black
	FB.BorderSizePixel = 0; FB.Size = UDim2.new(0,60,0,60)
	FB.Position = UDim2.new(0,20,0.5,-30); FB.AutoButtonColor = false; FB.Parent = SGB

	local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(1,0); fc.Parent = FB
	local fs = Instance.new("UIStroke"); fs.Color = C.Accent; fs.Thickness = 2; fs.Parent = FB

	local function AtualizarInd()
		local r = CFG.autoGari
		Tween(FB, {BackgroundColor3 = r and C.Green or C.Black}, 0.25)
		fs.Color = r and C.Green or C.Accent
		fs.Thickness = r and 3 or 2
	end

	local SG = Instance.new("ScreenGui")
	SG.Name = "SailentGari"; SG.ResetOnSpawn = false; SG.IgnoreGuiInset = true; SG.DisplayOrder = 10; SG.Parent = CoreGui

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
	li.Text = "🗑️"; li.Font = Enum.Font.GothamBold; li.TextSize = 22
	li.BackgroundTransparency = 1; li.Size = UDim2.new(1,0,1,0); li.Parent = lg

	local tt = Instance.new("TextLabel")
	tt.Text = "Auto Gari"; tt.Font = Enum.Font.GothamBold; tt.TextSize = 15
	tt.TextColor3 = C.Text; tt.BackgroundTransparency = 1
	tt.Position = UDim2.new(0,62,0,12); tt.Size = UDim2.new(0,200,0,18); tt.TextXAlignment = Enum.TextXAlignment.Left; tt.Parent = H

	local vp = Instance.new("Frame")
	vp.Size = UDim2.new(0,160,0,16); vp.Position = UDim2.new(0,62,0,34)
	vp.BackgroundColor3 = C.Yellow; vp.BackgroundTransparency = 0.75; vp.BorderSizePixel = 0; vp.Parent = H
	local vpc = Instance.new("UICorner"); vpc.CornerRadius = UDim.new(1,0); vpc.Parent = vp
	local vt = Instance.new("TextLabel")
	vt.Text = "v7.0 • ".._G.SailentNome; vt.Font = Enum.Font.GothamBold; vt.TextSize = 8
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
	local gariOn = false
	local gariRun = 0
	local PararTudo

	Sec("Conta", C.Purple)
	StatL("👤 "..(_G.SailentNome or "?").." ["..(_G.SailentNivel or "?").."]", C.Purple)

	Sec("Stats", C.Blue)
	local statsLabel = StatL(Resumo(), C.Text)

	Sec("🗑️ Auto Gari (noclip embutido)", C.Green)
	local gariStatus = StatL("Status: PARADO", C.Sub)
	local gariStats = StatL("Coletados: 0 | Entregues: 0", C.Sub)

	local function CicloGari(myRun)
		if not HRP() then gariStatus.Text = "⏳ Aguardando..."; task.wait(1); return end
		gariStatus.TextColor3 = C.Green
		if TemLixoNaMao() then
			gariStatus.Text = "📤 Indo pra traseira..."
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
				task.wait(0.3)
				gariStatus.Text = "📤 Entregando..."
				local prompt = GetPrompt(traseira)
				if prompt then
					pcall(function() fireproximityprompt(prompt) end)
					task.wait(0.5)
					if not TemLixoNaMao() then
						Stats.entregues = Stats.entregues + 1
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
				task.wait(0.3)
				gariStatus.Text = "📥 Coletando..."
				local prompt = GetPrompt(lixo)
				if prompt then
					pcall(function() fireproximityprompt(prompt) end)
					task.wait(0.5)
					if TemLixoNaMao() then
						Stats.coletados = Stats.coletados + 1
						lixosUsados[lixo] = true
					end
				end
			else
				gariStatus.Text = "⚠️ Sem lixo disponível"
				task.wait(1.5)
			end
		end
		gariStats.Text = "Coletados: "..Stats.coletados.." | Entregues: "..Stats.entregues
	end

	UI.setGari = Toggle("🗑️ Ativar Auto Gari", CFG.autoGari, C.Green, function(s)
		gariOn = s
		CFG.autoGari = s
		Salvar()
		AtualizarInd()
		gariRun = gariRun + 1
		if s then
			local myRun = gariRun
			if CFG.noclip then AtivarNoclip() end
			local h = HUM(); if h then h.WalkSpeed = CFG.vel end
			gariStatus.Text = "Status: ● ATIVO"
			gariStatus.TextColor3 = C.Green
			task.spawn(function()
				while gariOn and myRun == gariRun do
					local ok, e = pcall(CicloGari, myRun)
					if not ok then
						gariStatus.Text = "⚠️ Erro: "..tostring(e):sub(1,38)
						gariStatus.TextColor3 = C.Red
						task.wait(2)
					end
					task.wait(0.3)
				end
			end)
		else
			if CFG.noclip then DesativarNoclip() end
			gariStatus.Text = "Status: PARADO"
			gariStatus.TextColor3 = C.Sub
			local h = HUM(); if h then h.WalkSpeed = 16 end
		end
	end)

	Sec("⚡ VELOCIDADE", C.Green)
	UI.setVel = Slider(Cnt, "⚡ Velocidade", 16, 300, CFG.vel, C.Green, function(v)
		CFG.vel = v
		local h = HUM()
		if h and not CFG.modoVoo then h.WalkSpeed = v end
	end)

	Sec("🚁 Modo de Locomoção", C.Yellow)
	local modoStatus = StatL(CFG.modoVoo and "Modo: 🚁 VOANDO" or "Modo: 🚶 A PÉ", C.Yellow)

	Btn("🚶 A PÉ", C.Green, function()
		CFG.modoVoo = false
		modoStatus.Text = "Modo: 🚶 A PÉ"
		modoStatus.TextColor3 = C.Green
		Salvar()
	end)

	Btn("🚁 VOAR", C.Blue, function()
		CFG.modoVoo = true
		modoStatus.Text = "Modo: 🚁 VOANDO"
		modoStatus.TextColor3 = C.Blue
		Salvar()
	end)

	Sec("Comportamento", C.Purple)
	UI.setNoclip = Toggle("🚪 Noclip", CFG.noclip, C.Green, function(s)
		CFG.noclip = s; Salvar()
		if s then
			if gariOn then AtivarNoclip() end
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
	UI.setGod = Toggle("🛡️ God Mode", CFG.godMode, C.Green, function(s)
		CFG.godMode = s; Salvar()
		godModeAtivo = s
		if s then AtivarGod() end
	end)

	Sec("Emergência", C.Red)
	PararTudo = function()
		gariOn = false
		CFG.autoGari = false
		gariRun = gariRun + 1
		if UI.setGari then UI.setGari(false) end
		DestravarCam()
		DesativarNoclip()
		gariStatus.Text = "Status: PARADO"
		local h = HUM(); if h then h.WalkSpeed = 16 end
		AtualizarInd()
	end

	Btn("🛑 PARAR TUDO", C.Red, function()
		PararTudo()
	end)

	local aberta = true
	local function Fechar()
		aberta = false
		Tween(M, {Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.5,0,0.5,0)}, 0.25)
		task.wait(0.25); M.Visible = false
		FB.Text = "🗑️"
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
		if n == "F2" then
			if aberta then Fechar() else Abrir() end
		elseif n == "F1" then
			PararTudo(); Fechar()
		elseif n == "F3" then
			UI.setGari(not CFG.autoGari)
		elseif n == "F4" then
			CFG.modoVoo = not CFG.modoVoo
			if CFG.modoVoo then
				modoStatus.Text = "Modo: 🚁 VOANDO"
				modoStatus.TextColor3 = C.Blue
			else
				modoStatus.Text = "Modo: 🚶 A PÉ"
				modoStatus.TextColor3 = C.Green
			end
			Salvar()
		end
	end)

	task.spawn(function()
		while SG.Parent do
			task.wait(1)
			pcall(function() statsLabel.Text = Resumo() end)
		end
	end)

	SetAFK(CFG.antiAfk)
	AtivarGod()
	if CFG.autoGari then UI.setGari(true) end
	AtualizarInd()

	Log("🗑️ Auto Gari v7.0 pronto! ".._G.SailentNome)
end

Iniciar()

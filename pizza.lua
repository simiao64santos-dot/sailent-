-- ===== AUTH =====
local authOk = loadstring(game:HttpGet("https://raw.githubusercontent.com/simiao64santos-dot/sailent-/refs/heads/main/auth.lua"))()
if not authOk then return end
-- ===== FIM AUTH =====

-- ============================================================
-- SAILENT AUTO PIZZA v6.1b — ANTI-KICK + ANTI-DANO DE QUEDA
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

local _suspenderTudo = false
local _ultimoVoo = 0

local VER = "6.1b"

local CFG = {
	vel = 80,
	vooAtivo = false,
	alturaVoo = 2,
	antiSit = true,
	autoEnt = false,
	antiAfk = true,
	travarCam = true,
	noclip = true,
	esperaEntrega = 5,
}

pcall(function()
	if isfile and isfile("sailent_pizza_cfg.txt") and readfile then
		for l in readfile("sailent_pizza_cfg.txt"):gmatch("[^\n]+") do
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
	pcall(function() if writefile then writefile("sailent_pizza_cfg.txt", s) end end)
end

pcall(function()
	for _, n in ipairs({"SailentPizza","SailentFloatBtn"}) do
		local o = CoreGui:FindFirstChild(n); if o then o:Destroy() end
	end
end)

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
local function Log(m) print("[Pizza] "..tostring(m)) end

-- Helpers
local function HRP() local c = lp.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function HUM() local c = lp.Character; return c and c:FindFirstChild("Humanoid") end

local Terrain = workspace:FindFirstChildOfClass("Terrain")

local function getPos(o)
	if not o then return nil end
	if o:IsA("BasePart") then return o.Position end
	if o:IsA("Attachment") then return o.WorldPosition end
	if o:IsA("Model") then
		local r = o:FindFirstChild("HumanoidRootPart") or o.PrimaryPart
		if r then return r.Position end
	end
	for _, d in ipairs(o:GetDescendants()) do
		if d:IsA("BasePart") then return d.Position end
	end
	return nil
end

local function DistanciaDe(pos)
	local h = HRP()
	if not h or not pos then return math.huge end
	return (h.Position - pos).Magnitude
end

local function EstaNaAgua()
	if not Terrain then return false end
	local h = HRP()
	if not h then return false end
	local ok, mat = pcall(function()
		return Terrain:GetMaterialAtPosition(h.Position)
	end)
	if not ok then return false end
	return mat == Enum.Material.Water
end

local function TemAguaNoCaminho(posAlvo)
	if not Terrain then return false end
	local h = HRP()
	if not h then return false end
	local passos = 15
	for i = 1, passos do
		local alpha = i / passos
		local p = h.Position:Lerp(posAlvo, alpha)
		local p2 = Vector3.new(p.X, 0, p.Z)
		local ok, mat = pcall(function()
			return Terrain:GetMaterialAtPosition(p2)
		end)
		if ok and mat == Enum.Material.Water then
			return true
		end
	end
	return false
end

local function AcharPrompt(txt)
	local hrp = HRP(); if not hrp then return nil end
	local mais, menor = nil, math.huge
	for _, o in ipairs(workspace:GetDescendants()) do
		if o:IsA("ProximityPrompt") and o.ActionText and o.ActionText:lower():find(txt:lower()) then
			local p = getPos(o.Parent)
			if p then
				local d = (p - hrp.Position).Magnitude
				if d < menor then menor = d; mais = o end
			end
		end
	end
	return mais
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
			local pos = getPos(marcado)
			if pos then
				return {marcado = marcado, pos = pos, pad = pad}
			end
		end
	end
	return nil
end

local function TemPizza()
	local d = workspace:FindFirstChild(lp.Name)
	return d and d:FindFirstChild("PizzaTemplate") ~= nil
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
	local c = lp.Character
	if c then
		for _, p in ipairs(c:GetDescendants()) do
			if p:IsA("BasePart") then pcall(function() p.CanCollide = true end) end
		end
	end
end

-- Anti-Sentar
local antiSitConns = {}
local function AtivarAntiSit()
	for _, c in ipairs(antiSitConns) do pcall(function() c:Disconnect() end) end
	antiSitConns = {}

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
	for _, c in ipairs(antiSitConns) do pcall(function() c:Disconnect() end) end
	antiSitConns = {}
	if _G.SailentAntiSitConn then pcall(function() _G.SailentAntiSitConn:Disconnect() end); _G.SailentAntiSitConn = nil end
end

-- Anti-Dano de Queda
local fallConn = nil
local fallDamageProtectAtivo = false
local fallCharConn = nil

local function AtivarAntiDano()
	if fallConn then pcall(function() fallConn:Disconnect() end) end
	if fallCharConn then pcall(function() fallCharConn:Disconnect() end) end
	fallDamageProtectAtivo = true

	local function AplicarNoChar(char)
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum then return end
		pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end)
		pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) end)
		pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Landed, false) end)
		pcall(function() hum.BreakJointsOnDeath = false end)
	end

	if lp.Character then AplicarNoChar(lp.Character) end
	fallCharConn = lp.CharacterAdded:Connect(function(c)
		task.wait(0.3)
		AplicarNoChar(c)
	end)

	fallConn = RunService.Heartbeat:Connect(function()
		if not fallDamageProtectAtivo then return end
		local hrp = HRP()
		if not hrp or not hrp.Parent then return end
		local vel = hrp.AssemblyLinearVelocity
		if vel.Y < -40 then
			hrp.AssemblyLinearVelocity = Vector3.new(vel.X, -40, vel.Z)
		end
	end)
end

local function DesativarAntiDano()
	if fallConn then pcall(function() fallConn:Disconnect() end); fallConn = nil end
	if fallCharConn then pcall(function() fallCharConn:Disconnect() end); fallCharConn = nil end
	fallDamageProtectAtivo = false
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

-- Stats
local StatsD = { entregues = 0, pegos = 0, inicio = tick() }
local function FmtT(s) s = math.floor(s); return string.format("%02d:%02d:%02d", math.floor(s/3600), math.floor(s%3600/60), s%60) end
local function Resumo() local d = tick() - StatsD.inicio; return string.format("⏱ %s  📦 %d  🎯 %d", FmtT(d), StatsD.entregues, StatsD.pegos) end

-- ANDAR RÁPIDO
local function AndarRapido(posAlvo, timeout, dist)
	if not posAlvo then return false end
	if _suspenderTudo then return false end

	local hrp = HRP(); local hum = HUM()
	if not hrp or not hum then return false end

	timeout = timeout or 90
	dist = dist or 5

	local velOrig = hum.WalkSpeed
	pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
	pcall(function() hum.PlatformStand = false end)
	pcall(function() hum.AutoRotate = true end)

	local t0 = tick()
	local ultimaPos = hrp.Position
	local travado = 0
	local ultimoPulo = 0
	local velExtra = 0

	while tick() - t0 < timeout do
		if _suspenderTudo then break end
		local h = HRP(); if not h or not h.Parent then break end

		local posAtual = h.Position
		local df = Vector3.new(posAtual.X - posAlvo.X, 0, posAtual.Z - posAlvo.Z)
		if df.Magnitude < dist then
			hum:MoveTo(posAtual)
			hum.WalkSpeed = velOrig
			return true
		end

		hum.WalkSpeed = (CFG.vel or 80) + velExtra

		local v = h.AssemblyLinearVelocity
		if v.Y < -40 then
			h.AssemblyLinearVelocity = Vector3.new(v.X, -40, v.Z)
		end

		local moveu = (posAtual - ultimaPos).Magnitude
		if moveu < 0.8 then
			travado = travado + 1
			if tick() - ultimoPulo > 0.4 then
				ultimoPulo = tick()
				local hv = HRP()
				if hv then
					local vv = hv.AssemblyLinearVelocity
					if vv.Y < 25 then
						hv.AssemblyLinearVelocity = Vector3.new(vv.X, 25, vv.Z)
					end
				end
			end
			if travado > 45 then velExtra = 40 end
			if travado > 90 then velExtra = 80 end
		else
			if travado > 0 then travado = math.max(0, travado - 2) end
			if travado < 20 then velExtra = 0 end
		end
		ultimaPos = posAtual

		hum:MoveTo(posAlvo)

		if travado > 60 then
			local dir = Vector3.new(posAlvo.X - posAtual.X, 0, posAlvo.Z - posAtual.Z)
			if dir.Magnitude > 1 then
				local angulo = math.rad(math.random(-60, 60))
				local dirRot = CFrame.Angles(0, angulo, 0) * dir
				pcall(function()
					hum:MoveTo(posAtual + dirRot.Unit * 15)
				end)
			end
		end

		task.wait(0.03)
	end

	hum.WalkSpeed = velOrig
	return false
end

-- VOO
local function Voar(posAlvo, timeout)
	if not posAlvo then return false end
	if _suspenderTudo then return false end
	if tick() - _ultimoVoo < 0.5 then return false end

	local hrp = HRP(); local hum = HUM()
	if not hrp or not hum then return false end

	local posInicial = hrp.Position
	local distTotal = (Vector3.new(posAlvo.X, 0, posAlvo.Z) - Vector3.new(posInicial.X, 0, posInicial.Z)).Magnitude
	if distTotal < 12 then return true end

	_ultimoVoo = tick()
	timeout = timeout or 60

	local diffY = posAlvo.Y - posInicial.Y
	local alturaVoo
	if diffY > 5 then
		alturaVoo = posAlvo.Y + 2
	elseif diffY < -5 then
		alturaVoo = posAlvo.Y + 2
	else
		alturaVoo = posInicial.Y + (CFG.alturaVoo or 2)
	end

	local humProps = { WalkSpeed = hum.WalkSpeed, AutoRotate = hum.AutoRotate, PlatformStand = hum.PlatformStand }

	pcall(function()
		hum.AutoRotate = true
		hum.WalkSpeed = 0
		hum:ChangeState(Enum.HumanoidStateType.Physics)
	end)
	pcall(function()
		hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
	end)

	local bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
	bv.Velocity = Vector3.new(0, 0, 0)
	bv.P = 8000
	bv.Parent = hrp

	local bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	bg.P = 5000
	bg.D = 500
	bg.CFrame = hrp.CFrame
	bg.Parent = hrp

	local t0 = tick()
	while tick() - t0 < 4 do
		local h = HRP()
		if not h or not h.Parent then break end
		local diff = alturaVoo - h.Position.Y
		if math.abs(diff) <= 1 then break end
		local velSubida = math.clamp((CFG.vel or 80) * 0.6, 20, 60)
		if diff > 0 then
			bv.Velocity = Vector3.new(0, math.min(velSubida, diff * 5), 0)
		else
			bv.Velocity = Vector3.new(0, math.max(-25, diff * 5), 0)
		end
		task.wait(0.03)
	end

	local chegou = false
	local minDist = distTotal
	local tVoo = tick()

	while tick() - tVoo < timeout do
		local h = HRP()
		if not h or not h.Parent then break end
		local posAtual = h.Position
		local dirH = Vector3.new(posAlvo.X - posAtual.X, 0, posAlvo.Z - posAtual.Z)
		local distH = dirH.Magnitude
		if distH < 6 then chegou = true; break end
		if distH < minDist then minDist = distH end
		if distH > minDist + 50 then chegou = true; break end

		local dirUnit = dirH.Unit
		local yAlvo = alturaVoo
		if distH < 20 then yAlvo = posAlvo.Y + 2 end

		if posAtual.Y < alturaVoo - 5 then
			pcall(function()
				h.CFrame = CFrame.new(Vector3.new(posAtual.X, alturaVoo, posAtual.Z))
				h.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			end)
		end

		local velAtual = CFG.vel or 80
		if distH < 25 then velAtual = math.min(velAtual, 80) end
		if distH < 15 then velAtual = math.min(velAtual, 40) end

		local velY = math.clamp((yAlvo - posAtual.Y) * 3, -18, 18)
		bv.Velocity = Vector3.new(dirUnit.X * velAtual, velY, dirUnit.Z * velAtual)

		pcall(function()
			local look = CFrame.new(posAtual, Vector3.new(posAlvo.X, posAtual.Y, posAlvo.Z))
			bg.CFrame = look
		end)

		if _suspenderTudo then bv.Velocity = Vector3.new(0, 0, 0); break end
		task.wait(0.03)
	end

	bv.Velocity = Vector3.new(0, 0, 0)
	task.wait(0.08)

	local tDesce = tick()
	while tick() - tDesce < 3 do
		local h = HRP()
		if not h or not h.Parent then break end
		local diffY2 = h.Position.Y - (posAlvo.Y + 2)
		if math.abs(diffY2) <= 0.5 then break end
		if diffY2 > 0 then
			bv.Velocity = Vector3.new(0, -math.min(20, diffY2 * 4), 0)
		else
			bv.Velocity = Vector3.new(0, math.min(20, -diffY2 * 4), 0)
		end
		task.wait(0.03)
	end

	bv.Velocity = Vector3.new(0, 0, 0)
	task.wait(0.12)
	pcall(function() bv:Destroy() end)
	pcall(function() bg:Destroy() end)

	pcall(function()
		hum.WalkSpeed = humProps.WalkSpeed or 80
		hum.AutoRotate = humProps.AutoRotate ~= false
		hum.PlatformStand = false
		hum:ChangeState(Enum.HumanoidStateType.Running)
	end)

	local h = HRP()
	if h then pcall(function() h.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end) end

	return chegou
end

local function Mover(posAlvo, timeout)
	if not posAlvo then return false end
	if CFG.vooAtivo then
		if TemAguaNoCaminho(posAlvo) then
			return AndarRapido(posAlvo, timeout or 90)
		end
		return Voar(posAlvo, timeout or 60)
	else
		return AndarRapido(posAlvo, timeout or 90)
	end
end

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
	for _, n in ipairs({"SailentPizza","SailentFloatBtn"}) do
		local o = CoreGui:FindFirstChild(n); if o then pcall(function() o:Destroy() end) end
	end
	task.wait(0.05)

	local SGB = Instance.new("ScreenGui")
	SGB.Name = "SailentFloatBtn"; SGB.ResetOnSpawn = false; SGB.IgnoreGuiInset = true; SGB.DisplayOrder = 5; SGB.Parent = CoreGui

	local FB = Instance.new("TextButton")
	FB.Text = "🍕"; FB.Font = Enum.Font.GothamBold; FB.TextSize = 26
	FB.TextColor3 = Color3.fromRGB(255,255,255); FB.BackgroundColor3 = C.Black
	FB.BorderSizePixel = 0; FB.Size = UDim2.new(0,60,0,60)
	FB.Position = UDim2.new(0,20,0.5,-30); FB.AutoButtonColor = false; FB.Parent = SGB

	local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(1,0); fc.Parent = FB
	local fs = Instance.new("UIStroke"); fs.Color = C.Accent; fs.Thickness = 2; fs.Parent = FB

	local function AtualizarInd()
		local r = CFG.autoEnt
		Tween(FB, {BackgroundColor3 = r and C.Green or C.Black}, 0.25)
		fs.Color = r and C.Green or C.Accent
		fs.Thickness = r and 3 or 2
	end

	local SG = Instance.new("ScreenGui")
	SG.Name = "SailentPizza"; SG.ResetOnSpawn = false; SG.IgnoreGuiInset = true; SG.DisplayOrder = 10; SG.Parent = CoreGui

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
	li.Text = "🍕"; li.Font = Enum.Font.GothamBold; li.TextSize = 22
	li.BackgroundTransparency = 1; li.Size = UDim2.new(1,0,1,0); li.Parent = lg

	local tt = Instance.new("TextLabel")
	tt.Text = "Auto Pizza"; tt.Font = Enum.Font.GothamBold; tt.TextSize = 15
	tt.TextColor3 = C.Text; tt.BackgroundTransparency = 1
	tt.Position = UDim2.new(0,62,0,12); tt.Size = UDim2.new(0,200,0,18); tt.TextXAlignment = Enum.TextXAlignment.Left; tt.Parent = H

	local vp = Instance.new("Frame")
	vp.Size = UDim2.new(0,180,0,16); vp.Position = UDim2.new(0,62,0,34)
	vp.BackgroundColor3 = C.Green; vp.BackgroundTransparency = 0.75; vp.BorderSizePixel = 0; vp.Parent = H
	local vpc = Instance.new("UICorner"); vpc.CornerRadius = UDim.new(1,0); vpc.Parent = vp
	local vt = Instance.new("TextLabel")
	vt.Text = "v"..VER.." • "..(_G.SailentNome or "Cliente"); vt.Font = Enum.Font.GothamBold; vt.TextSize = 7
	vt.TextColor3 = C.Green; vt.BackgroundTransparency = 1; vt.Size = UDim2.new(1,0,1,0); vt.Parent = vp

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
	local entregaRun = 0
	local PararTudo

	Sec("Conta", C.Purple)
	StatL("👤 "..(_G.SailentNome or "?").." ["..(_G.SailentNivel or "?").."]", C.Purple)

	Sec("Stats", C.Blue)
	local statsLabel = StatL(Resumo(), C.Text)

	Sec("🛡️ MODO SEGURO", C.Green)
	local statusModo = StatL("Modo: ● ANDAR (anti-kick)", C.Green)

	Sec("Auto Entregador", C.Accent)
	local entregaSt = StatL("Status: PARADO", C.Sub)

	local function ErroLoop(err)
		entregaSt.Text = "⚠️ Erro: "..tostring(err):sub(1,38)
		entregaSt.TextColor3 = C.Red
		task.wait(2)
	end

	local function Ciclo(run)
		if not HRP() then entregaSt.Text = "⏳ Aguardando..."; task.wait(1); return end
		entregaSt.TextColor3 = C.Green

		if TemPizza() then
			entregaSt.Text = "📤 Procurando cliente..."
			local info = AcharLocalMarcado()
			if info and info.pos then
				local nomePad = "Cliente"
				pcall(function() if info.pad then nomePad = info.pad.Name end end)
				entregaSt.Text = "📤 Indo pro "..nomePad.."..."
				TravarCam(info.pos)

				if CFG.vooAtivo and TemAguaNoCaminho(info.pos) then
					entregaSt.Text = "🌊 Água no caminho — andando..."
					entregaSt.TextColor3 = C.Yellow
				end

				Mover(info.pos, 90)
				if run ~= entregaRun then DestravarCam(); return end

				if DistanciaDe(info.pos) > 25 then
					entregaSt.Text = "⚠️ Longe do cliente ("..math.floor(DistanciaDe(info.pos))..")"
					entregaSt.TextColor3 = C.Yellow
					AndarRapido(info.pos, 60, 6)
					if DistanciaDe(info.pos) > 25 then
						entregaSt.Text = "⚠️ Ainda longe — pulando"
						entregaSt.TextColor3 = C.Red
						DestravarCam()
						task.wait(1.5)
						return
					end
				end

				if EstaNaAgua() then
					entregaSt.Text = "💧 Na água! Pulando entrega"
					entregaSt.TextColor3 = C.Red
					DestravarCam()
					task.wait(1.5)
					return
				end

				task.wait(0.3)
				entregaSt.Text = "📤 Entregando..."
				entregaSt.TextColor3 = C.Green

				local pr = AcharPrompt("Entregar Pedido")
				if pr then
					local promptPos = getPos(pr.Parent)
					if promptPos and (promptPos - info.pos).Magnitude > 30 then
						pr = nil
					end
				end

				if pr then
					local t0 = tick(); local tent = 0
					while tick() - t0 < 30 do
						if not TemPizza() then break end
						if run ~= entregaRun then DestravarCam(); return end
						if DistanciaDe(info.pos) > 25 then break end
						if EstaNaAgua() then break end
						pcall(function() fireproximityprompt(pr) end)
						tent = tent + 1
						entregaSt.Text = "📤 Entregando... ("..tent.."x)"
						task.wait(4)
					end
				end

				DestravarCam()
				if not TemPizza() then
					StatsD.entregues = StatsD.entregues + 1

					local espera = tonumber(CFG.esperaEntrega) or 5
					if espera > 0 then
						entregaSt.Text = "⏳ Aguardando "..espera.."s..."
						entregaSt.TextColor3 = C.Yellow
						local tEsp = tick()
						while tick() - tEsp < espera do
							if not CFG.autoEnt or run ~= entregaRun then return end
							if _suspenderTudo then return end
							task.wait(0.2)
						end
					end
				end
			else
				entregaSt.Text = "⚠️ Sem cliente ativo"
				task.wait(1.5)
			end
		else
			entregaSt.Text = "📥 Procurando pedido..."
			local pr = AcharPrompt("Pegar Pedido")
			if pr then
				local p = getPos(pr.Parent)
				if p then
					entregaSt.Text = "📥 Indo pegar..."
					Mover(p, 90)
					if run ~= entregaRun then return end
					task.wait(0.3)
					entregaSt.Text = "📥 Pegando..."
					pcall(function() fireproximityprompt(pr) end)
					task.wait(1.2)
					StatsD.pegos = StatsD.pegos + 1
				end
			else
				entregaSt.Text = "⚠️ Sem pedido"
				task.wait(1.5)
			end
		end
	end

	UI.setEnt = Toggle("🍕 Auto Entregar Pizza", CFG.autoEnt, C.Accent, function(s)
		CFG.autoEnt = s
		Salvar()
		AtualizarInd()
		entregaRun = entregaRun + 1
		if s then
			local run = entregaRun
			local h = HUM(); if h then h.WalkSpeed = CFG.vel end
			if CFG.noclip then AtivarNoclip() end
			if CFG.antiSit then AtivarAntiSit() end
			AtivarAntiDano()
			entregaSt.Text = "Status: ● ATIVO"; entregaSt.TextColor3 = C.Green
			task.spawn(function()
				while CFG.autoEnt and run == entregaRun do
					local ok, e = pcall(Ciclo, run)
					if not ok then ErroLoop(e) end
					task.wait(0.5)
				end
				DestravarCam()
			end)
		else
			DestravarCam()
			if CFG.noclip then DesativarNoclip() end
			if CFG.antiSit then DesativarAntiSit() end
			DesativarAntiDano()
			entregaSt.Text = "Status: PARADO"; entregaSt.TextColor3 = C.Sub
			local h = HUM(); if h then h.WalkSpeed = 16 end
		end
	end)

	Sec("⚡ VELOCIDADE", C.Green)
	UI.setVel = Slider(Cnt, "⚡ Velocidade", 20, 300, CFG.vel, C.Green, function(v)
		CFG.vel = v
		local h = HUM()
		if h and CFG.autoEnt then
			local hrp = HRP()
			local voando = false
			if hrp then
				for _, c in ipairs(hrp:GetChildren()) do
					if c:IsA("BodyVelocity") then voando = true; break end
				end
			end
			if not voando then h.WalkSpeed = v end
		end
	end)

	Sec("⏳ ESPERA ENTRE ENTREGAS", C.Yellow)
	UI.setEspera = Slider(Cnt, "⏱️ Segundos de espera", 0, 30, CFG.esperaEntrega or 5, C.Yellow, function(v)
		CFG.esperaEntrega = v
	end)

	Sec("🛸 VOO AÉREO (RISCO DE KICK!)", C.Red)
	UI.setVoo = Toggle("🛸 Ativar voo aéreo", CFG.vooAtivo, C.Red, function(s)
		CFG.vooAtivo = s; Salvar()
		if s then
			statusModo.Text = "Modo: ● VOO (pode kickar)"
			statusModo.TextColor3 = C.Red
		else
			statusModo.Text = "Modo: ● ANDAR (anti-kick)"
			statusModo.TextColor3 = C.Green
		end
	end)
	UI.setAltura = Slider(Cnt, "📏 Altura do voo", 1, 15, CFG.alturaVoo or 2, C.Purple, function(v)
		CFG.alturaVoo = v
	end)

	Sec("Comportamento", C.Purple)
	UI.setNoclip = Toggle("🚪 Noclip", CFG.noclip, C.Green, function(s)
		CFG.noclip = s; Salvar()
		if s then
			if CFG.autoEnt then AtivarNoclip() end
		else
			DesativarNoclip()
		end
	end)
	UI.setAntiSit = Toggle("🪑 Anti-Sentar", CFG.antiSit, C.Yellow, function(s)
		CFG.antiSit = s; Salvar()
		if s then
			if CFG.autoEnt then AtivarAntiSit() end
		else
			DesativarAntiSit()
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
		CFG.autoEnt = false
		entregaRun = entregaRun + 1
		if UI.setEnt then UI.setEnt(false) end
		DestravarCam()
		if CFG.noclip then DesativarNoclip() end
		if CFG.antiSit then DesativarAntiSit() end
		DesativarAntiDano()
		entregaSt.Text = "Status: PARADO"; entregaSt.TextColor3 = C.Sub
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
		FB.Text = "🍕"
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
			UI.setEnt(not CFG.autoEnt)
		end
	end)

	task.spawn(function()
		while SG.Parent do
			task.wait(1)
			pcall(function()
				statsLabel.Text = Resumo()
				if CFG.vooAtivo then
					statusModo.Text = "Modo: ● VOO (pode kickar)"
					statusModo.TextColor3 = C.Red
				else
					statusModo.Text = "Modo: ● ANDAR (anti-kick)"
					statusModo.TextColor3 = C.Green
				end
			end)
		end
	end)

	SetAFK(CFG.antiAfk)
	if CFG.antiSit then AtivarAntiSit() end
	if CFG.autoEnt then UI.setEnt(true) end
	AtualizarInd()

	Log("🍕 Auto Pizza v"..VER.." pronto! ".._G.SailentNome)
end

Iniciar()

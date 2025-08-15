local player = game.Players.LocalPlayer

-- GUI base
local gui = Instance.new("ScreenGui")
gui.Name = "BytecodeEditorGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 495, 0, 400)
mainFrame.Position = UDim2.new(0.5, -247, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 20)
header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
header.BorderSizePixel = 0
header.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Editor Bytecode Falso"
title.Font = Enum.Font.SourceSansSemibold
title.TextSize = 16
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 20)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Botones (con UIListLayout para espacio)
local buttonBar = Instance.new("Frame")
buttonBar.Size = UDim2.new(1, 0, 0, 30)
buttonBar.Position = UDim2.new(0, 0, 0, 20)
buttonBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
buttonBar.BorderSizePixel = 0
buttonBar.Parent = mainFrame

local buttonLayout = Instance.new("UIListLayout")
buttonLayout.FillDirection = Enum.FillDirection.Horizontal
buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
buttonLayout.Padding = UDim.new(0, 6)
buttonLayout.Parent = buttonBar

local function makeButton(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 70, 1, 0)
	btn.Text = text
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 14
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BorderSizePixel = 0
	btn.Parent = buttonBar
	return btn
end

local convertBtn = makeButton("Convertir")
local clearBtn = makeButton("Limpiar")
local guardarBtn = makeButton("Guardar")
local openModulesBtn = makeButton("Módulos")
local themeBtn = makeButton("Tema: Oscuro")
local editBtn = makeButton("Editar")

-- Contenedor para editor y líneas con scroll
local editorContainer = Instance.new("Frame")
editorContainer.Size = UDim2.new(1, -10, 1, -60)
editorContainer.Position = UDim2.new(0, 5, 0, 55)
editorContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
editorContainer.BorderSizePixel = 0
editorContainer.ClipsDescendants = true
editorContainer.Parent = mainFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
scrollFrame.ScrollBarThickness = 8
scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollFrame.Parent = editorContainer

-- Números de línea
local lineNumbers = Instance.new("TextLabel")
lineNumbers.Size = UDim2.new(0, 35, 1, 0)
lineNumbers.Position = UDim2.new(0, 0, 0, 0)
lineNumbers.TextXAlignment = Enum.TextXAlignment.Center
lineNumbers.TextYAlignment = Enum.TextYAlignment.Top
lineNumbers.Font = Enum.Font.Code
lineNumbers.TextSize = 14
lineNumbers.TextColor3 = Color3.fromRGB(100, 100, 100)
lineNumbers.BackgroundTransparency = 1
lineNumbers.Text = "1"
lineNumbers.Parent = scrollFrame

-- TextBox para código
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -35, 1, 0)
inputBox.Position = UDim2.new(0, 35, 0, 0)
inputBox.Text = "-- Escribe tu código aquí"
inputBox.Font = Enum.Font.Code
inputBox.TextSize = 14
inputBox.TextColor3 = Color3.new(1, 1, 1)
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.TextYAlignment = Enum.TextYAlignment.Top
inputBox.BackgroundTransparency = 1
inputBox.ClearTextOnFocus = false
inputBox.MultiLine = true
inputBox.TextWrapped = false
inputBox.TextEditable = false
inputBox.Parent = scrollFrame

-- Bloqueador encima del TextBox
local blocker = Instance.new("TextLabel")
blocker.Size = inputBox.Size
blocker.Position = inputBox.Position
blocker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
blocker.BackgroundTransparency = 1
blocker.Text = ""
blocker.Active = true
blocker.Selectable = true
blocker.ZIndex = inputBox.ZIndex + 1
blocker.Parent = scrollFrame
blocker.Visible = true

blocker.MouseEnter:Connect(function()
	blocker.Active = false
end)
blocker.MouseLeave:Connect(function()
	blocker.Active = true
end)

-- Actualizar líneas
local function actualizarNumerosLineas(texto)
	local lineas = select(2, texto:gsub("\n", "\n")) + 1
	local contenido = ""
	for i = 1, lineas do
		contenido ..= i .. "\n"
	end
	lineNumbers.Text = contenido
	
	local altoTexto = math.max(inputBox.TextBounds.Y, scrollFrame.AbsoluteSize.Y)
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, altoTexto + 20)
end

inputBox:GetPropertyChangedSignal("Text"):Connect(function()
	actualizarNumerosLineas(inputBox.Text)
end)
inputBox:GetPropertyChangedSignal("TextBounds"):Connect(function()
	actualizarNumerosLineas(inputBox.Text)
end)
actualizarNumerosLineas(inputBox.Text)

-- ===== Bytecode falso con closures anidados =====
local function makeClosure(level)
	if level <= 0 then return "" end
	local innerLevel = math.random(0, level - 1)
	local code = string.format("v%d = function()\n", level)
	code ..= "    -- proto pool id: " .. level .. "\n"
	code ..= "    -- num upvalues: " .. math.random(0, level) .. "\n"
	code ..= "    -- num inner protos: " .. innerLevel .. "\n"
	code ..= "    -- size instructions: " .. math.random(1, 10) .. "\n"
	code ..= "    -- size constants: " .. math.random(1, 5) .. "\n"
	code ..= "    -- max stack size: " .. math.random(2, 5) .. "\n"
	code ..= "    -- is typed: " .. tostring(math.random(0,1) == 1) .. "\n"
	if innerLevel > 0 then
		code ..= makeClosure(innerLevel)
	end
	code ..= "end\n"
	return code
end

local function toBytecodeFake(text)
	local lines = {}
	local i = 1
	for line in text:gmatch("[^\r\n]+") do
		local opcode = ({"GETIMPORT","LOADK","CALL","RETURN","JMP"})[math.random(1,5)]
		local v = "v" .. math.random(0, 4)
		local closureLevels = math.random(1, 3)
		table.insert(lines, string.format("[%03d] :%03d:%s   %s = %s\n%s", 
			i, math.random(10,99), opcode, v, line, makeClosure(closureLevels)))
		i += 1
	end
	return table.concat(lines, "\n")
end

-- Botones
convertBtn.MouseButton1Click:Connect(function()
	local txt = inputBox.Text
	if txt == "" or txt == "-- Escribe tu código aquí" then
		inputBox.Text = "-- Inserta algo primero --"
	else
		local converted = toBytecodeFake(txt)
		inputBox.Text = converted
		actualizarNumerosLineas(converted)
	end
end)

clearBtn.MouseButton1Click:Connect(function()
	inputBox.Text = ""
	lineNumbers.Text = "1"
	actualizarNumerosLineas("")
end)

guardarBtn.MouseButton1Click:Connect(function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local savedModulesFolder = ReplicatedStorage:FindFirstChild("SavedModules")
	if not savedModulesFolder then
		savedModulesFolder = Instance.new("Folder")
		savedModulesFolder.Name = "SavedModules"
		savedModulesFolder.Parent = ReplicatedStorage
	end

	local texto = inputBox.Text
	if texto == "" then return end

	local modName = "Modulo_" .. tostring(#savedModulesFolder:GetChildren() + 1)
	if savedModulesFolder:FindFirstChild(modName) then
		modName = modName .. "_" .. tostring(math.random(1, 999))
	end

	local newModule = Instance.new("ModuleScript")
	newModule.Name = modName
	newModule.Source = texto
	newModule.Parent = savedModulesFolder
end)

openModulesBtn.MouseButton1Click:Connect(function()
	print("Botón Módulos presionado")
end)

-- Tema
local darkMode = true
themeBtn.MouseButton1Click:Connect(function()
	darkMode = not darkMode
	local darkColors = {Frame=Color3.fromRGB(30,30,30),Header=Color3.fromRGB(45,45,45),
	Button=Color3.fromRGB(60,60,60),Text=Color3.new(1,1,1),
	Background=Color3.fromRGB(40,40,40),LineNumbers=Color3.fromRGB(100,100,100)}
	local lightColors = {Frame=Color3.fromRGB(240,240,240),Header=Color3.fromRGB(220,220,220),
	Button=Color3.fromRGB(180,180,180),Text=Color3.new(0,0,0),
	Background=Color3.fromRGB(230,230,230),LineNumbers=Color3.fromRGB(120,120,120)}
	local colors = darkMode and darkColors or lightColors

	mainFrame.BackgroundColor3 = colors.Frame
	header.BackgroundColor3 = colors.Header
	buttonBar.BackgroundColor3 = colors.Button
	title.TextColor3 = colors.Text
	lineNumbers.TextColor3 = colors.LineNumbers
	scrollFrame.BackgroundColor3 = colors.Background
	inputBox.TextColor3 = colors.Text

	for _, btn in pairs(buttonBar:GetChildren()) do
		if btn:IsA("TextButton") then
			btn.BackgroundColor3 = colors.Button
			btn.TextColor3 = colors.Text
		end
	end

	themeBtn.Text = darkMode and "Tema: Oscuro" or "Tema: Claro"
end)

-- Editar/Bloquear
editBtn.MouseButton1Click:Connect(function()
	if blocker.Visible then
		blocker.Visible = false
		inputBox.TextEditable = true
		editBtn.Text = "Bloquear"
		inputBox:CaptureFocus()
	else
		blocker.Visible = true
		inputBox.TextEditable = false
		editBtn.Text = "Editar"
		inputBox:ReleaseFocus()
	end
end)

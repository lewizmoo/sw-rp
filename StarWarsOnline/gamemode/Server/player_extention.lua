
--This alows me to add functions to the player object
local Player = FindMetaTable("Player")

--This is only called at the begining so that the char sellection can display the name and such
function Player:LoadChars()
	local FilePath = "starwarsonline/"..self:UniqueID().."/chars.txt"
	if file.Exists(FilePath) then
		print("realy?")
		local contents = util.KeyValuesToTable(file.Read(FilePath))
		self.Chars = contents
		datastream.StreamToClients(self,"chardata",{Chars = contents})
	else

	end
end

function Player:SaveChars()
	local FilePath = "starwarsonline/"..self:UniqueID().."/chars.txt"
	if file.Exists(FilePath) then
		print("realy?")

		file.Write(FilePath,util.TableToKeyValues(self.Chars))
	else
		local CharsTable = {}
		table.Merge(CharsTable, CharTable)

		self.Chars = CharTable
		file.Write(FilePath,util.TableToKeyValues(CharTable))
		contents = CharTable
	end
end

function Player:MakeChar(CharTable)
	local FilePath = "starwarsonline/"..self:UniqueID().."/chars.txt"
	if file.Exists(FilePath) then
		print("realy?")
		local contents = util.KeyValuesToTable(file.Read(FilePath))

		table.Merge(contents, CharTable)
		self.Chars = contents
		file.Write(FilePath,util.TableToKeyValues(contents))
	else
		local CharsTable = {}
		table.Merge(CharsTable, CharTable)

		self.Chars = CharTable
		file.Write(FilePath,util.TableToKeyValues(CharTable))
		contents = CharTable
	end
	
	datastream.StreamToClients(self,"chardata",{Chars = self.Chars})
end

function IncomingHook( pl, handler, id, encoded, decoded )

	print( "GLON Encoded: " .. encoded );
	print( "Decoded:" );
	PrintTable( decoded );
	
	pl:MakeChar(decoded)
 
end
datastream.Hook( "PlayerChar", IncomingHook );

function Player:Load(charkey)
	self:SetNWInt("char",charkey)
	self:Kill()
end

function LoadPlyCon(ply, cmd, args)
	local lol = string.Implode(" ", args)
	local lol = string.lower(lol)
	PrintTable(args)
	print(lol)
	ply.Char = ply.Chars[lol]
end
concommand.Add("SWOLoadChar", LoadPlyCon)

function Player:GiveAllWeapons()
end
function Player:GiveAllAmmo()
end

function Player:GetClass()
	return CLASS_JEDI
end
function Player:GetForce()
	self.Char.Force = self.Char.Force or 100
	return self.Char.Force
end
function Player:TakeForce( NumForce, DontRegen ) 
	self.Char.Force = self.Char.Force - NumForce
	if( self.Char.Force < 0 ) then
		self.Char.Force = 0
	end
	if( DontRegen != true ) then
		timer.Create( "ForceBackUpTimer", 0.1, 0, function()
			self:AddForce( 1 )
			self:SetNWInt( "PlayerForce", self:GetForce() )
			if( self:GetForce() >= self:GetMaxForce() ) then
				timer.Destroy( "ForceBackUpTimer" )
			end
		end )
	end
	self:SetNWInt( "PlayerForce", self:GetForce() )
end
function Player:AddForce( NumForce )
	self.Char.Force = self.Char.Force + NumForce
	if( self.Char.Force > self:GetMaxForce() ) then
		self.Char.Force = self:GetMaxForce()
	end
	print( "Force: "..self.Char.Force )
end
function Player:GetMaxForce()
	return self.Char.MaxForce or 100
end
























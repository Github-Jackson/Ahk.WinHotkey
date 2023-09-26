#SingleInstance Force
CoordMode,ToolTip,Screen

global main:={tip:{}}
global Config:=ReadConfig()
global BasePath:=Config.basePath
main.tip:=""
$Main(){
	Loop,Files,%BasePath%\Win\*
	{
		FileGetShortcut,%A_LoopFileLongPath%,Target
		key:=KeyGenerator(SubStr(A_LoopFileLongPath,StrLen(BasePath)+2),Config.Keys,A_LoopFileExt)
		main.tip .= key ":" Target "`n"
	}
}
$Main()

#If GetKeyState("Ctrl")
tip:=main.tip
ToolTip,%tip%,0,0
#If

~Ctrl Up::
ToolTip
return



#R::Reload
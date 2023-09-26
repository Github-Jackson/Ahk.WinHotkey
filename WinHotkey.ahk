#SingleInstance Force
#NoTrayIcon
#UseHook
SetBatchLines,-1

#Include <Script>
#Include <File>
#Include <Application>
#Include <WinHotkeyDirector>

SendMode Input
SetTitleMatchMode,2

$main(){
	SetWorkingDir,% Application.Config.Config.Directory
	loop Files,*.*,R 
	{
		WinHotkeyDirector.Register.Call(A_LoopFilePath,A_LoopFileExt)
	}
	OnExit(WinHotkeyDirector.OnExit)
}
$main()

	
ShowAll(){
	WinHotkeyDirector.OnExit()
}
ChangeWindow(){
	current:=WinHotkeyDirector.Current
	current.IsExist()
	current.IsActive()
	current.wins.InsertAt(1,current.wins.Pop())
	current.Activate()
}
ChangeProcess(){
	current:=WinHotkeyDirector.Current
	current.update()
	current.list.InsertAt(1,current.list.Pop())
	current.IsExist()
	current.Activate()
}


;QQ多窗体
;进程更新
;窗体更新
;如果进程激活,更换当前管理窗体
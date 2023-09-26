Class IUWP{
	static exe:="ahk_exe C:\Windows\System32\ApplicationFrameHost.exe"
	__New(filename){
		this.filename:=filename
		lindex:=InStr(filename,"{"),rindex:=InStr(filename,"}")
		this.title:=SubStr(filename,lindex+1,rindex?rindex-lindex-1:0)
		;if(!this.title)
		;	return new IDirectory(filename)
		this._Initial(filename)
	}
	_Initial(filename){
		this.title:=this.title " " this.exe
	}
	IsNew(){
		return !WinExist(this.title)
	}
	New(){
		Run(this.filename)
	}
	IsExist(){
		this.win:=new Window(WinExist(this.title))
		return this.win.id
	}
	IsActive(){
		return this.win.Active()
	}
	Activate(){
		return this.win.Show().Activate()
	}
	Deactivate(){
		;this.win.Hide()
		this.win.Bottom()
		WinHotkeyDirector.OnHide()
		;WinHotkeyDirector.HideWindows[this.win.id]:=this.win
	}
}
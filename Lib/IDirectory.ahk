Class IDirectory{
	; __New(filename){
	; 	this.filename:=filename
	; }
	; IsNew(){
	; 	return 1
	; }
	; New(){
	; 	Run(this.filename)
; }
	static exe:="explorer.exe"
	__New(filename,target){
		this.filename:=filename
		this.target:=target
	}
	IsNew(){
		return !this.win
	}
	New(forced:=0){
		if(this.IsExist()){
			this.Activate()
		}else{
			Run(this.filename)
			WinWait(this.target . @(this.exe),,2)
			this.wins:= new Windows(this.target " ahk_exe explorer.exe")
			this.win:=this.wins.Window()
		}
	}

	IsExist(){
		try{
			DetectHiddenWindows()
			return this.win.Exist()
		} finally {
			DetectHiddenWindows("Off")
		}
		
	}
	IsActive(){
		return this.win.Active()
	}
	Activate(){
		return this.win.Show().Activate()
	}
	Deactivate(){
		this.win.Bottom().Hide()
		WinHotkeyDirector.OnHide(this.win)
		return this.win
	}
}

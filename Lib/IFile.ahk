#Include <FileTool>
#Include <ISend>
#Include <ILnk>
Class IFile{
	static exReg:="^$"
	__New(filename){
		fileInfo:=SplitPath(filename)
		ext:=StringLower(fileInfo.ext)
		if(ext=="send")
			return new ISend(filename)
		if(ext=="lnk")
			return new ILnk(filename)
		this._Initial(filename)
		return this
	}
	_Initial(filename){
		this.filename:=filename
		this.title:=FileTool.GetTitle(filename)
	}
	wins{
		get{
			if(!this.list.last.wins)
				this.list.last.wins:=this.list.last.Windows().Exclude(this.exReg)
			return this.list.last.wins
		}
		set{
			return this.list.last.wins:=value
		}
	}
	Update(){
		if(!this.list)
			return this.list:=new Processes(this.title)
		for k,v in new Processes(this.title)
			if(!this._IsExist(v.id))
				this.list.InsertAt(1,v)
	}
	_IsExist(pid){
		for k,v in this.list
			if(pid == v.id)
				return 1
		return 0
	}
	IsNew(){
		if(!this.list.Length()){
			this.list:=new Processes(this.title)
			this.wins:=this.list.last.windows().Exclude(this.exReg)
		}
		WinHotkeyDirector.Current:=this
		return !this.list.Length()
	}
	New(forced:=0){
		if(this.list.Length()==0||forced)
			this.list.Push(new Process(Run(this.filename)))
		if(!this.wins.Length())
			this.wins:=this.list.Last.Windows().Exclude(this.exReg)
		this.Activate()
		return this.wins.Length()
	}
	IsExist(){
		if(!this.list.Length())
			return 0
		if(this.list.Last.Exist())
			return this.IsWinExist()
		this.list.Pop()
		if(!this.wins.Length())
			this.wins:=this.list.last.windows().Exclude(this.exReg)
		return this.IsExist()
	}
	IsWinExist(){
		if(this.wins.Length()==0){
			this.wins:=this.list.last.windows().Exclude(this.exReg)
			if(this.wins.Length()==0){
				this.Update()
				this.list.InsertAt(this.list.Pop())
			}
			return this.wins.Length()
		}
		DetectHiddenWindows()
		if(this.wins.Last.Exist()){
			DetectHiddenWindows,Off
			return 1
		}
		this.wins.Pop()
		DetectHiddenWindows,Off
		return this.IsWinExist()
	}
	IsActive(){
		for k,v in this.list
			if(v.Active()){
				this.list.Push(this.list.RemoveAt(k))
				if(!this.wins.Length())
					this.wins:=this.list.last.windows().Exclude(this.exReg)
				for k,v1 in this.wins
					if(v1.Active())
						return this.wins.Push(this.wins.RemoveAt(k))
				return this.wins.Push(v.Active())
			}
		return 0
	}
	Activate(){
		WinHotkeyDirector.Current:=this
		if(this.wins.count()==1)
			this.wins.Last.Show().Activate()
		else if(this.wins.Count()>1)
			this.wins.last.Show().Activate()
		;else
		;	MsgBox % "0000CurrentWindows:" this.wins.Count()
		return
		;逻辑不合理
		;该逻辑导致系统界面激活时, 目标窗口无法获得Active()焦点, 触发隐藏
		if(!this.wins.last.Active()){
			this.wins.last.Hide()
		}
	}
	Deactivate(){
		this.wins.Last.Bottom().Hide()
		WinHotkeyDirector.OnHide(this.wins.Last)	
	}
}
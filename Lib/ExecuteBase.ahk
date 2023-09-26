#Include <IFile>
Class ExecuteBase{
	__New(filename){
		this._Initial(filename)
	}
	_Initial(filename){
		this.files:=[new IFile(filename)]
		this.index:=1
	}
	file{
		get{
			return this.files[this.index]
		}
	}
	Call(){
		if(this.IsNew()||state:=Application.Config.Config.New.GetState())
			return this.New(state)
		if(this.IsExist()){
			if(this.IsActive())
				return this.Deactivate()
			return this.Activate()
		}else
			return this.New()
	}
	IsNew(){
		return this.file.isNew()
	}
	New(forced:=0){
		return this.file.New(forced)
	}
	IsExist(){
		return this.file.IsExist()
	}
	IsActive(){
		return this.file.IsActive()
	}
	Activate(){
		return this.file.Activate()
	}
	Deactivate(){
		return this.file.Deactivate()
	}
}
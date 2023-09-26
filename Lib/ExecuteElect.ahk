#Include <ExecuteMult>
Class ExecuteElect extends ExecuteMult{
	file{
		get{
			this.index:=mod(this.index,this.files.Length())
			return this.files[this.index+1]
		}
	}
	Push(filename){
		this.files.Push(new IFile(filename))
	}
	Call(){
		if(this.IsNew()|state:=Application.Config.Config.New.GetState())
			return this.New(state)
		if(this.IsExist()){
			if(this.IsActive())
				return this.Deactivate()
			return this.Activate()
		}else
			return this.New()
	}
	IsNew(){
		result:=1
		for k,v in this.files
			if(!v.IsNew())
				result:=0
		return result
	}
	New(state:=0){
		for k,v in this.files
				v.New(state)
	}
	IsExist(){
		count:=this.files.Length()
		loop %count% {
			if(this.file.IsExist())
				return 1
			this.index++
		}
		return 0
	}
	IsActive(){
		for k,v in this.files
			if(v.IsActive())
				return 1|(this.index:=k-1)
		return 0
	}
	DeActivate(){
		this.index++
		this.IsExist()
		this.file.Activate()
	}
}
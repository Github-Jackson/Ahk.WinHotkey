Class ISend{
	__New(filename){
		this._Initial(filename)
	}
	_Initial(filename){
		this.Send:=FileRead(filename)
	}
	IsNew(){
		return 1
	}
	New(){
		Send % this.Send
	}
}
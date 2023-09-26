#Include <ExecuteBase>
#Include <ExecuteMult>
Class Execute extends ExecuteBase{
	__New(filename){
		this._Initial(filename)
	}
	Push(filename){
		if(this.index==1){
			this.index:=0
			this.base:=ExecuteMult
		}
		this.files.Push(new IFile(filename))
	}
}
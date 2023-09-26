#Include <IDirectory>
#Include <IUWP>
Class ILnk extends IFile{
	__New(filename){
		target:=FileGetShortcut(filename).target
		if(InStr(FileGetAttrib(target),"D")){
			return new IDirectory(filename,target)
		}
		if(target==""){
			return new IUWP(filename)
		}
		this._Initial(filename)
	}
}
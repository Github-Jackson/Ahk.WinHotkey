#Include <Windows>
#Include <Execute>
Class WinHotkeyDirector{
  static Register:=WinHotkeyDirector.Build.Bind(new WinHotkeyDirector())
  static director:={}
  static HideWindows:={}
  static Current:=[]
  static latelyWindows:=new Windows([])

  Build(fileName,ext){
    key:=this.GetKey(StrReplace(fileName,"." ext))
    key:=this.ReplaceKey(key)
    if(this.director.HasKey(key))
      return this.director[key].Push(fileName)
    if(InStr(key,Application.Config.Config.ModifierEnd)){
      arr:=StrSplit(key,Application.Config.Config.ModifierEnd)
      key:=arr[2]
      modifier:=arr[1]
    }
    modifier:=this.GetModifier(modifier)
    if(!this.director[modifier . key]){
      try this.director[modifier . key]:=new Hotkey(key,new Execute(filename),modifier)
      try this.director[modifier . key].New(Application.Config.Config.NewModifier . key,,modifier,Application.Config.Config.New)
    }else
    this.director[modifier . key].Push(filename)
  }
  GetKey(e){
    if(index:=InStr(e,Application.Config.Config.HotkeyEnd))
      return SubStr(e,1,index-1)
    return e
  }
  ReplaceKey(e){
    for k,v in Application.Config.KeyMap
      e:=StrReplace(e,k,v)
    return e
  }
  GetModifier(e){
    for k,v in Application.Config.ModifierMap
      e:=StrReplace(e,k,v)
    return StrReplace(e,"\","&")
  }
  OnExit(){
    for k,v in WinHotkeyDirector.HideWindows
      try v.Show()
  }
  OnHide(win){
    ;SendInput,!{Esc}
    if(win){
      WinHotkeyDirector.HideWindows[win.id]:=win
    }
    this._OnHideOfWinActivate(win)
    ;this._OnHideOfGetNextWindow(win)
  }
  _OnHideOfWinActivate(win){
    titleMatchMode:=A_TitleMatchMode
    SetTitleMatchMode, RegEx
    excludeTitle := "(^$"

    Loop
    {
      if(winid := WinExist(".+",,excludeTitle ")")){
        newWin:=new Window(winid)
        if(newWin.GetExStyle()&0x8){
          excludeTitle := excludeTitle "|" newWin.GetTitle()
          continue
        }else{
					newWin.Show().Activate()
				}
      }
      break
    }

    SetTitleMatchMode, % titleMatchMode
  }
  _OnHideOfGetNextWindow(win){
    result := win.id
    Loop
    {
      result := GetNextWindow(result)
      if(result==0){
        return
      }
      newWin := new Window(result)
      if(newWin.GetTitle()){
        newWin.Activate()
        break
      }
    }
  }
}

GetNextWindow(hWnd){
  return DllCall("GetWindow","Ptr",hWnd,"UInt",2)
}

/*
	增加WindowManage软件
 1. 提供win+qwerasdfzxc系列快捷键, 用于快捷管理当前窗口
 	> 对应的快捷键管理窗口为空就录入当前活动窗口
	> 快捷键管理窗口已经不存在就录入当前活动窗口
 	> 管理窗口处于活动就隐藏
 	> 管理窗口未处于活动就显示并激活
 2. 提供>+修饰符事件:
  > 快捷键管理的窗口为空则录入当前活动窗口
	> 快捷键管理的窗口处于活动状态则打开新窗口
	> 快捷键管理的窗口不处于活动状态则录入新窗口

	? 窗口组管理? 
		快捷键对单个窗口做激活隐藏
		快捷键对多个窗口归为组管理, 进行循环切换
		>+修饰符(或>^修饰符)将当前窗口移除快捷键管理

	?动态新增快捷键? 
		按下>Shift开始接受按键录入, 按键结束将对应按键注册成快捷键?
		存储上次管理的快捷键组, 重新启动时提示是否恢复?
		如果恢复因为存在管理目标, 那么快捷键应该启动应用程序与1.1/2.1其一冲突

	控制窗口位置? 覆盖win+方向键
	
*/
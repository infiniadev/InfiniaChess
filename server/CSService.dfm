object CLServerService: TCLServerService
  OldCreateOrder = False
  AllowPause = False
  Dependencies = <
    item
      Name = 'MSSQLSERVER'
      IsGroup = False
    end>
  DisplayName = 'CLServer'
  StartType = stManual
  OnShutdown = ServiceShutdown
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 540
  Width = 778
end

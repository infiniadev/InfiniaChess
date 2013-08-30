unit CSDbTestThread;

interface

uses
  Classes;

type
  TDbTestThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

implementation

uses CSDb;

{ TDbTestThread }

procedure TDbTestThread.Execute;
var
  db: TDb;
begin
  db := TDb.Create;
  fDB.TestingLongCall;
end;

end.

unit CSDataStructures;

interface

uses contnrs, classes;

type
  TCSTree = class
  private
    ParentNode: TCSTree;
    Nodes: TObjectList;
    function GetNodesCount: integer;
    function GetNode(Index: integer): TCSTree;
  public
    Value: string;
    Obj: TObject;

    constructor Create;
    destructor Destroy; override;

    function AddNode: TCSTree;
    property NodesCount: integer read GetNodesCount;
    property Node[Index: integer]: TCSTree read GetNode; default;
  end;

implementation

{ TCSTree }
//==============================================================================
function TCSTree.AddNode: TCSTree;
var
  Node: TCSTree;
begin
  Node := TCSTree.Create;
  Node.ParentNode := Self;
  result := Node;
end;
//==============================================================================
constructor TCSTree.Create;
begin
  Nodes := TObjectList.Create;
end;
//==============================================================================
destructor TCSTree.Destroy;
begin
  Nodes.Free;
  inherited;
end;
//==============================================================================
function TCSTree.GetNode(Index: integer): TCSTree;
begin
  result := Nodes[Index] as TCSTree;
end;
//==============================================================================
function TCSTree.GetNodesCount: integer;
begin
  result := Nodes.Count;
end;
//==============================================================================
end.

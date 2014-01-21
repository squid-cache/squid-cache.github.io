{{{
#!highlight ada
with Ada.Strings;
use  Ada.Strings;
with Ada.Text_IO;
use  Ada.Text_IO;
 
procedure Main is
  Str  : String (1..5);
  Last : Natural;
begin
  Ada.Text_IO.Get_Line (Str, Last);
  Put_Line("ERR");

loop
  Ada.Text_IO.Get_Line (Str, Last);
  Put_Line("ERR");
end loop;

end;
}}}

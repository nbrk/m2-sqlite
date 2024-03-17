MODULE Test;

IMPORT libsqlite3;

FROM STextIO IMPORT WriteString, WriteChar, WriteLn;
FROM SWholeIO IMPORT WriteInt, WriteCard;

FROM DynamicStrings IMPORT String, InitStringCharStar, CopyOut, Fin;

CONST path = "/home/nbrk/tmp/foobar.db3";

VAR
   db : libsqlite3.sqlite3;
   stmt : libsqlite3.sqlite3_stmt;
   tail : POINTER TO CHAR;
   ctext : POINTER TO CHAR;
   text : ARRAY [1..80] OF CHAR;
   ret : INTEGER;
   colcnt : CARDINAL;
   str : String;
BEGIN
   ret := libsqlite3.sqlite3_open(path, db);
   WriteString ("sqlite3_open results: "); WriteInt (ret, 4); WriteLn;

   ret :=
       libsqlite3.sqlite3_prepare_v2
          (db, "SELECT name FROM sqlite_schema WHERE type = 'table'; # lala",
           1024, stmt, tail);
   WriteString ("sqlite3_prepare_v2 results: "); WriteInt (ret, 4); WriteLn;
   WriteString ("The tail points to: "); WriteChar (tail^); WriteLn;
   INC(tail);
   WriteString ("INC tail points to: "); WriteChar (tail^); WriteLn;
   INC(tail);
   WriteString ("INC tail points to: "); WriteChar (tail^); WriteLn;

   colcnt := libsqlite3.sqlite3_column_count(stmt);
   WriteString ("sqlite3_column_count value: "); WriteCard (colcnt, 4); WriteLn;

   ret := libsqlite3.sqlite3_step(stmt);
   WriteString ("sqlite3_step results: "); WriteInt (ret, 4); WriteLn;
   (* step loop *)
   WHILE ret = libsqlite3.SQLITE_ROW DO
      str := InitStringCharStar( libsqlite3.sqlite3_column_text(stmt, 0));
      CopyOut (text, str);
      Fin(str);
      WriteString ("A row, text value: "); WriteString (text); WriteLn;

      ret := libsqlite3.sqlite3_step(stmt);
      WriteString ("sqlite3_step results: "); WriteInt (ret, 4); WriteLn;
   END;

   ret := libsqlite3.sqlite3_finalize(stmt);
   WriteString ("sqlite3_finalize results: "); WriteInt (ret, 4); WriteLn;

   WriteString("*****************************"); WriteLn;

   ret :=
          libsqlite3.sqlite3_prepare_v2 (db,
              "SELECT name FROM sqlite_schema WHERE type = :type LIMIT ?",
              1024, stmt, tail);
   WriteString ("sqlite3_prepare_v2 results: "); WriteInt (ret, 4); WriteLn;

   ret := libsqlite3.sqlite3_bind_text(stmt, 1, "table", 5, NIL);
   WriteString ("sqlite3_bind_text (index 1) results: "); WriteInt (ret, 4); WriteLn;
   ret := libsqlite3.sqlite3_bind_int(stmt, 2, 2);
   WriteString ("sqlite3_bind_int (index 2) results: "); WriteInt (ret, 4); WriteLn;
   ret := libsqlite3.sqlite3_step(stmt);
   WriteString ("sqlite3_step results: "); WriteInt (ret, 4); WriteLn;
   (* step loop *)
   WHILE ret = libsqlite3.SQLITE_ROW DO
      str := InitStringCharStar( libsqlite3.sqlite3_column_text(stmt, 0));
      CopyOut (text, str);
      Fin(str);
      WriteString ("A row, text value: "); WriteString (text); WriteLn;

      ret := libsqlite3.sqlite3_step(stmt);
      WriteString ("sqlite3_step results: "); WriteInt (ret, 4); WriteLn;
   END;


   ret := libsqlite3.sqlite3_finalize(stmt);
   WriteString ("sqlite3_finalize results: "); WriteInt (ret, 4); WriteLn;

   libsqlite3.sqlite3_close(db);


END Test.

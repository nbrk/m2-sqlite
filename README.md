# m2-sqlite
GNU Modula-2 bindings to SQLite 3

This is a low-level, direct bindings using the FFI. Its coverage is **far from complete** and
contains only the basic constants and routines of the `sqlite3` C API for now:
- opening/closing of the DB
- preparation/stepping/finalization of the statements
- binding basic parameters
- basic column accesses

Consult the DEFINITION MODULE itself for the documentation.

The provided example can be compiled like that:

``` bash
$ gm2-14 -fsoft-check-all -fiso -g -O2 -Wall Test.mod -lsqlite3
```


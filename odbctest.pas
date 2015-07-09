program ODBCTest;



uses
	ODBCConn,
	SqlDb,
	SysUtils;
	

	
const
	TBL_TST = 						'pascal_test';
	FLD_TST_ID = 					'record_id';
	FLD_TST_CHAR = 					'field_char';
	FLD_TST_NUM = 					'field_number';
	FLD_TST_RCD = 					'rcd';
	FLD_TST_RLU = 					'rlu';
	
	

var
	conn: TODBCConnection; 			// uses ODBCConn
	transaction: TSQLTransaction;   // uses sqldb
	query: TSQLQuery; 				// uses sqldb
	
	
	
procedure DatabaseOpen();
begin
	conn := TODBCCOnnection.Create(nil);
	query := TSQLQuery.Create(nil);
	transaction := TSQLTransaction.Create(nil);
	
	conn.DatabaseName := 'DSN_ADBEHEER_USER'; // Data Source Name (DSN)
	conn.UserName:= 'ADBEHEER_USER'; //replace with your user name
    conn.Password:= 'WG5X6AHVUM2ZgQL-0O_gVmFAVcTucSzJ'; //replace with your password
	conn.Transaction := transaction;
end;


procedure DatabaseInsert();
var
	q: string;
	i: integer;
begin
	for i := 1 to 10 do
	begin
		q := 'INSERT INTO ' + TBL_TST + '(' + FLD_TST_CHAR + ') VALUES(''test line ' + IntToStr(i) + ''')';
		WriteLn(q);
		conn.ExecuteDirect(q);
		transaction.Commit;
	end;
end;
	


procedure DatabaseSelect();
begin
	query.DataBase := conn;
	
	query.PacketRecords := -1;
	query.SQL.Text := 'SELECT '+ FLD_TST_ID + ' FROM ' + TBL_TST + ';';
	query.Open;
	while not query.EOF do
    begin
		WriteLn(query.FieldByName(FLD_TST_ID).AsString);
		query.Next;
	end;
	query.Free;
end;



procedure DatabaseClose();
begin
	transaction.Free;
	conn.Free;
end;



begin
	DatabaseOpen();
	DatabaseSelect();
	DatabaseInsert();
	DatabaseClose();
end.
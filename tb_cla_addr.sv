module tb_cla_addr;
	
    logic [7:0] a, b, sum;
    logic cin, cout;

     full_adder uut (
        .a(a),
        .b(b),
        .cin(cin),
        .s(sum),
        .cout(cout)
    );

    initial begin
 
	$monitor("T=%0t | a=%d b=%d cin=%d -> sum=%d cout=%d",  $time, a, b, cin, sum, cout);
	// Case 1
        a = 8'd55; b = 8'h0F; cin = 0; #10;

        // Case 2
        a = 8'hFF; b = 8'h01; cin = 0; #10;

        // Case 3
        a = 8'hAA; b = 8'h55; cin = 1; #10;

        $finish;
    end
endmodule


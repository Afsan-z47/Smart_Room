module people_count_next
(
	input  logic [4:0] current_count,
	input  logic switch_A,
	input  logic switch_B,
	output logic [4:0] next_count
);

	logic [4:0] next_count;
	logic inc, dec;
	logic [4:0] add, sub;
	logic [4:0] mux_0, mux_1;

	logic inc = (switch_A & !(current_count[4] & current_count[3] & current_count[2] & current_count[1] & current_count[0])); //max 31

	logic dec = (switch_B & (current_count[4] | current_count[3] | current_count[2] | current_count[1] | current_count[0])); //min 0

	full_adder #(5) adding(
		.a(current_count),
		.b(5'b00001),
		.cin(1'b0),
		.s(add),
	//	.cout()
	);

	full_adder #(5) subtracting(
		.a(current_count),
		.b(5'b11110), // 2's complement of 1
		.cin(1'b1),
		.s(sub),
	//	.cout()
	);

	mux2 #(5) m0(current_count, add, inc, mux_0);
	mux2 #(5) m1(current_count, sub, !inc, mux_1);
	mux2 #(5) m2(mux_0, mux_1, dec, next_count);
//	always_comb
//	case({inc,dec})
//		2'b01: next_count = dec;
//		2'b10: next_count = add;
//		default: next_count = current_count;
//	endcase

endmodule

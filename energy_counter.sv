module energy_count_next (
	input logic [5:0] old_clk,
	input logic [4:0] people_count,
	input logic [7:0] old_energy,
	
	output logic [5:0] next_clk,
	output logic [7:0] next_energy
);

logic [7:0] new_energy;
logic is_energy_up;

full_adder #(6) add_clk(
	.a(old_clk),
	.b(people_count),
	.cin(1'b0),
	.s(next_clk),
	.cout(is_energy_up)
);

full_adder #(8) add_energy(
	.a(8'b0000001),
	.b(old_energy),
	.cin(1'b0),
	.s(new_energy),
//	.cout()
);

mux2 #(8) m1(old_energy, new_energy, is_energy_up, next_energy);


endmodule

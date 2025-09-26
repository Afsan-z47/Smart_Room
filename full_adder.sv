module full_adder
	#( parameter width = 8 )
	(
	input logic  [width-1:0] a,
	input logic  [width-1:0] b,
	input logic  cin,
	output logic [width-1:0] s,
	output logic cout
	);

	logic [width-1:0] p;
	logic [width-1:0] g;
	logic [width:0]   c;
	integer i;
always_comb
	begin
	// Carry Initialization
	c[0] = cin;
	cout = c[width-1];
	// Generate & Propagate
	p = a ^ b;
	g = a & b;
	

	// Carry Look Ahead Logic
	for (i=0 ; i< width; i++) 
		begin
			c[i+1] = g[i] | (p[i] & c[i]);
			s[i]   = p[i] ^ c[i];
		end
	end

endmodule

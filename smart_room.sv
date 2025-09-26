module smart_room (
	input  logic        clk,
	input  logic        reset,
	input  logic        switchA,   // increment
	input  logic        switchB,   // decrement
	output logic [6:0]  seg_people, // 7-seg display for people count
	output logic [6:0]  seg_energy, // 7-seg display for energy usage
	output logic [3:0]  green_leds, // lights (half of people)
	output logic [3:0]  red_leds,   // fans (half of people)
	output logic        room_full   // room full indicator
);

// Person counter
logic [4:0] people_count; // allow >10 for detection
logic [4:0] people_next; 

logic [7:0] energy_usage;
logic [7:0] energy_next;
logic [5:0] clk_div; // clock divider for proportional energy usage
logic [5:0] clk_div_next;
logic r1, r2;
// Person counting

people_count_next p_count (
    .current_count(people_count),
    .switch_A(switchA),
    .switch_B(switchB),
    .next_count(people_next)
);

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        people_count <= 0;
    else
        people_count <= people_next;
end

//Energy increment 
energy_count_next e_count (
	.old_clk(clk_div),
	.people_count(people_count),
	.old_energy(energy_usage),
	.next_clk(clk_div_next),
	.next_energy(energy_next)
);


// Energy usage counter
always_ff @(posedge clk or posedge reset) begin
	if (reset) 
		begin
		clk_div <= 0;
		energy_usage <= 0;
		end 
	else 
		begin
			energy_usage <= energy_next;
			clk_div <= clk_div_next;
		end
end

always_comb
	begin
	// Room full indicator
	r1 = (people_count[3] & people_count[2]);
	r2 = (people_count[3] & people_count[1] & people_count[0]);
	room_full = r1 | r2;

	// Lights and Fans (half people count)
	green_leds[3:0] = people_count[4:1]; 
	red_leds[3:0]   = people_count[4:1];

end


	// Assign 7-seg outputs

	sevenseg people (
		.data(people_count),
		.segments(seg_people)
	);
	sevenseg energy (
		.data(energy_usage),
		.segments(seg_energy)
	);

endmodule


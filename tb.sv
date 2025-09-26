`timescale 1ns/1ps

module tb_smart_room;

    // Testbench signals    
    reg clk;
    reg reset;
    reg switchA, switchB;
    wire [6:0] seg_people;
    wire [6:0] seg_energy;
    wire [3:0] green_leds;
    wire [3:0] red_leds;
    wire room_full;

    // Instantiate DUT
    smart_room uut (
        .clk(clk),
        .reset(reset),
        .switchA(switchA),
        .switchB(switchB),
        .seg_people(seg_people),
        .seg_energy(seg_energy),
        .green_leds(green_leds),
        .red_leds(red_leds),
        .room_full(room_full)
    );

    // Clock generator (10ns period = 100 MHz)
    always #5 clk = ~clk;

    // Task: Pulse switch A once (person enters)
    task automatic person_in();
    begin
	switchA = 1;
        @(posedge clk);
        switchA = 0;
        @(posedge clk);
	end
    endtask

    // Task: Pulse switch B once (person exits)
    task automatic person_out();
    begin
        switchB = 1;
        @(posedge clk);
        switchB = 0;
        @(posedge clk);
	end
	endtask

    // Initial test sequence
    initial begin
	
	$dumpfile("smart_room.vcd");   // Name of the VCD file
	$dumpvars(0, tb_smart_room);   // Dump all signals in this module and submodules
	
	// Initialize
        clk = 0;
        reset = 1;
        switchA = 0;
        switchB = 0;
        repeat (2) @(posedge clk);
        reset = 0;

        $display("=== Test: Reset state ===");
        $monitor("T=%0t | People=%0d | Energy_CLK=%b |Energy=%0d | Green=%b | Red=%b | RoomFull=%b | Seg_pep=%b | Seg_ener=%b |", $time, uut.people_count, uut.clk_div, uut.energy_usage, green_leds, red_leds, room_full, seg_people, seg_energy);

        // Test increment up to 5
        $display("\n=== Test: Incrementing People Count ===");
        repeat (5) person_in();

        // Test decrement to 0
        $display("\n=== Test: Decrementing People Count ===");
        repeat (3) person_out();
        repeat (5) person_out(); // extra to test underflow protection

        // Fill room above 10
        $display("\n=== Test: Room Full Indicator ===");
        repeat (12) person_in();  // push count above 10

        // Let energy counter run for a while (people present)
        $display("\n=== Test: Energy Usage Increment ===");
        repeat (200) @(posedge clk);

        // Reset during operation
        $display("\n=== Test: Reset During Operation ===");
        reset = 1; @(posedge clk);
        reset = 0;

        // Run a bit more
        repeat (20) @(posedge clk);

        $display("\n=== Test Complete ===");
        $finish;
    end

endmodule


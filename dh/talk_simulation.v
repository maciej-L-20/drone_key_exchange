module talk_simulation 
#(parameter N=8)
(
input init1, init2,
input  	   	  	 rst,
input  			  	 clk,
input  			  	 ena
);

wire [N-1:0] key_drone1, key_drone2, key_CC;
wire key_rdy_drone1, key_rdy_drone2,key_rdy_CC;
wire [N-1:0] mess_input1, mess_input2,mess_outCC;
wire received1,received2;
wire [2*N-1:0] mess_out1, mess_out2, mess_inputCC;
wire mess_rdy1, mess_rdy2;
wire drone_rdy,cc_rdy;
wire wait_for_cc_drone1, wait_for_cc_drone2;


assign mess_inputCC = (mess_rdy1 == 1'b1) ? mess_out1 : (mess_rdy2 == 1'b1) ? mess_out2 : 0;
assign drone_rdy = (mess_rdy1 == 1'b1) ? mess_rdy1 : (mess_rdy2 == 1'b1) ? mess_rdy2 : 0;
assign mess_input1 = (wait_for_cc_drone1 == 1'b1) ? mess_outCC:0;
assign mess_input2 = (wait_for_cc_drone2 == 1'b1) ? mess_outCC:0;
assign received1 = (wait_for_cc_drone1 == 1'b1) ? cc_rdy:0;
assign received2 = (wait_for_cc_drone2 == 1'b1) ? cc_rdy:0;


drone #(N,137,5,1) drone1(
.rst(rst),
.clk(clk),
.ena(ena),
.mess_input(mess_input1),
.received(received1),
.init(init1),
.mess_out(mess_out1),
.mess_rdy(mess_rdy1),
.key(key_drone1),
.key_rdy(key_rdy_drone1),
.wait_for_cc(wait_for_cc_drone1)
);

drone #(N,229,2,2) drone2(
.rst(rst),
.clk(clk),
.ena(ena),
.mess_input(mess_input2),
.received(received2),
.init(init2),
.mess_out(mess_out2),
.mess_rdy(mess_rdy2),
.key(key_drone2),
.key_rdy(key_rdy_drone2),
.wait_for_cc(wait_for_cc_drone2)
);

cc #(N,137,5,229,2) cc_inst(
.rst(rst),
.clk(clk),
.ena(ena),
.drone_rdy(drone_rdy),
.mess_input(mess_inputCC),
.mess_out(mess_outCC),
.mess_rdy(cc_rdy),
.key(key_CC),
.key_rdy(key_rdy_CC)
);

endmodule
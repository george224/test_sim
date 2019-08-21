`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/21 21:20:06
// Design Name: 
// Module Name: axivideo_size
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module axivideo_size #(
parameter DATA_WIDTH  = 8
)
(
    input wire clk,
    input wire rst,
//in stream 
    input wire s_axis_video_tuser,
    input wire s_axis_video_tlast,
    input wire s_axis_video_tvalid,
    input wire [DATA_WIDTH-1:0] s_axis_video_tdata,   
    output wire s_axis_video_tready,
//out stream
    output wire m_axis_video_tuser,
    output wire m_axis_video_tlast,
    output wire m_axis_video_tvalid,
    output wire [DATA_WIDTH-1:0] m_axis_video_tdata,   
    input wire m_axis_video_tready,
//output    
    output wire [15:0] hsize,
    output wire [15:0] vsize
);

reg [15:0] hsize_reg=16'd0;
reg [15:0] vsize_reg=16'd0;  

assign hsize = (s_axis_video_tvalid&s_axis_video_tready&s_axis_video_tlast)?hsize_reg:hsize;
assign vsize = (s_axis_video_tvalid&s_axis_video_tready&s_axis_video_tuser)?vsize_reg:vsize;

always @(posedge clk or posedge rst) begin
    if(rst) 
        hsize_reg <= 16'd0;
    else if(s_axis_video_tvalid&s_axis_video_tready&s_axis_video_tlast)
        hsize_reg <= 16'd0;
    else if(s_axis_video_tvalid&s_axis_video_tready)
        hsize_reg <= hsize_reg + 1;
    else
        ;
end

always @(posedge clk or posedge rst) begin
    if(rst) 
        vsize_reg <= 16'd0;
    else if(s_axis_video_tvalid&s_axis_video_tready&s_axis_video_tuser)
        vsize_reg <= 16'd0;
    else if(s_axis_video_tvalid&s_axis_video_tready&s_axis_video_tlast)
        vsize_reg <= hsize_reg + 1;
    else
        ;
end


//bypass
assign m_axis_video_tuser = s_axis_video_tuser;
assign m_axis_video_tlast = s_axis_video_tlast;
assign m_axis_video_tvalid = s_axis_video_tvalid;
assign m_axis_video_tdata = s_axis_video_tdata;
assign s_axis_video_tready = m_axis_video_tready;


endmodule

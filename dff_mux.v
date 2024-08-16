module dff_mux(clk,rst,en,cen,d,q);
parameter RSTTYPE ="SYNC" ;
parameter WIDTH =18 ;
input clk,rst,en,cen;
input [WIDTH-1:0]d;
output reg[WIDTH-1:0]q;
reg [WIDTH-1:0]out_reg;
generate
    if (RSTTYPE=="ASYCN") begin
         always @(posedge clk or posedge rst) begin
            if (rst) begin
                out_reg<=0;
            end
            else if (cen) begin
                    out_reg<=d;
                end
        end
    end
    
    else begin
     always @(posedge clk) begin
            if (rst) begin
                out_reg<=0;
            end
            else if (cen) begin
                    out_reg<=d;
                end
        end
    end
endgenerate
always @(d) begin
    if (en) begin
        q=out_reg;
    end
    else q=d;
end
    
endmodule

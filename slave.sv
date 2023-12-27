module slave (
    input [0:0] PCLK,
    input [0:0] PRESET,
    input [0:0] PSEL,
    input [0:0] PENABLE,
    input [0:0] PWRITE,
    input [31:0] PRWADDR,          // Master Out, Slave In
    input [31:0] PRWDATA,
    output reg [31:0] PRDATA1,     // Master In, Slave Out
    output reg [0:0] PREADY      // Slave PREADY
);

reg [3:0] state;        // Состояние конечного автомата
reg [31:0] memory [0:127];
reg [2:0] c;

always @(PRESET) begin

if (PRESET == 1'b1) begin
    // Сброс в начальное состояние
    state <= 4'b0000;
    PRDATA1 <= 32'b00000000000000000000000000000000;

    PREADY = 0;


end
end

// Логика конечного автомата
always @(posedge PCLK or posedge PRESET) begin

if (PRESET) begin
    // Сброс в начальное состояние
    state <= 4'b0000;
    PRDATA1 <= 32'b00000000000000000000000000000000;
end else begin    
    
    $display("in slave");

    if(PSEL == 1'b1 && PENABLE == 1'b0 && PWRITE == 1'b0) begin 
        $display("if1");
        PREADY = 0; 
    end
        
    else if(PSEL == 1'b1 && PENABLE == 1'b1 && PWRITE == 1'b0) begin  
        $display("wriite in slave");
        PRDATA1 <= memory[PRWADDR];
        PREADY = 1;
    end

    else if(PSEL == 1'b1 && PENABLE == 1'b0 && PWRITE == 1'b1) begin  
        $display("if2");
        PREADY = 0; 
    end

    else if(PSEL == 1'b1 && PENABLE == 1'b1 && PWRITE == 1'b1) begin  
        $display("if3");
        PREADY = 1;
        PRDATA1 <= PRWDATA;
        memory[PRWADDR] <= PRWDATA;
        c = c + 1;
    end

    else begin
        PREADY = 0;
        $display("if4");
    end

    end
end
endmodule

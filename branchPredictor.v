`include "constants.v"

module branchPredictor (
    input clk,
    input rst,
    input [`WORD_SIZE-1:0] PC,
    input [`WORD_SIZE-1:0] CurrentPC,
    input BranchE, 
    input ZeroE,
    input [`WORD_SIZE-1:0] PCTargetE,
    input wire [`WORD_SIZE-1:0] PCPlus4F,
    output wire [`WORD_SIZE-1:0] NextInstruction,
    output wire TakingBranch
    );

    reg [`WORD_SIZE-1:0] BranchPC [0:`BRANCH_PREDICTOR_NUM_LINES-1];
    reg [`WORD_SIZE-1:0] TargetPC [0:`BRANCH_PREDICTOR_NUM_LINES-1];
    reg [1:0] Prediction [0:`BRANCH_PREDICTOR_NUM_LINES-1];
    reg Valid_reg [0:`BRANCH_PREDICTOR_NUM_LINES-1];
    wire taken;
    reg [`WORD_SIZE-1:0] NextInstruction_reg;

    initial begin

        Valid_reg[0] = 0;
        Valid_reg[1] = 0;
        Valid_reg[2] = 0;
        Valid_reg[3] = 0;

        Prediction[0] = 2'b01;
        Prediction[1] = 2'b01;
        Prediction[2] = 2'b01;
        Prediction[3] = 2'b01;

        TargetPC[0] = 0;
        TargetPC[1] = 0;
        TargetPC[2] = 0;
        TargetPC[3] = 0;

        BranchPC[0] = 0;
        BranchPC[1] = 0;
        BranchPC[2] = 0;
        BranchPC[3] = 0;
        $display("BranchPredictor: Initialized");
        $display("BranchPredictor: Prediction = %b", Prediction[0]);
        $display("BranchPredictor: Prediction = %b", Prediction[1]);
        $display("BranchPredictor: Prediction = %b", Prediction[2]);
        $display("BranchPredictor: Prediction = %b", Prediction[3]);
    end

    always @(posedge clk) begin
        $display("ENTERING CASE BranchPredictor: PC = %h", PC);
        $display ("BranchPredictor: Valid_reg = %b", Valid_reg[PC[`BINDEX]]);
        $display("BranchPredictor: BranchPC = %h", BranchPC[PC[`BINDEX]]);
        if (BranchE & Valid_reg[PC[`BINDEX]] & BranchPC[PC[`BINDEX]] == PC) begin
            $display("BranchPredictor: current Prediction = %b", Prediction[PC[`BINDEX]]);
            case (Prediction[PC[`BINDEX]])
                2'b00: begin
                    Prediction[PC[`BINDEX]] = (taken) ? 2'b01 : 2'b00;
                end
                2'b01: begin
                    Prediction[PC[`BINDEX]] = (taken) ? 2'b10 : 2'b00;
                end
                2'b10: begin
                    Prediction[PC[`BINDEX]] = (taken) ? 2'b11 : 2'b01;
                end
                2'b11: begin
                    Prediction[PC[`BINDEX]] = (taken) ? 2'b11 : 2'b10;
                end
            endcase
            $display("BranchPredictor: after Prediction = %b", Prediction[PC[`BINDEX]]);

        end else if (BranchE & ZeroE) begin
            $display("BranchPredictor: adding new PC = %h to predictor", PC);
            BranchPC[PC[`BINDEX]] <= PC;
            TargetPC[PC[`BINDEX]] <= PCTargetE;
            Valid_reg[PC[`BINDEX]] <= 1'b1;
            Prediction[PC[`BINDEX]] <= 2'b10;
        end
    end

    // always @(*) begin
    //     NextInstruction_reg <= PCPlus4F;
    //     if (PC == BranchPC[PC[`BINDEX]] ) begin
    //         if (Prediction[PC[`BINDEX]] == 2'b10 | Prediction[PC[`BINDEX]] == 2'b11) begin
    //             NextInstruction_reg <= TargetPC[PC[`BINDEX]];
    //             $display("BranchPredictor: predicting branch for PC = %h", PC);
    //         end
    //     end
    // end

    always @(posedge clk) begin
        $display (".......................................");
        $display ("BranchPredictor: BranchPC = %h", BranchPC[0]);
        $display ("BranchPredictor: BranchPC = %h", BranchPC[1]);
        $display ("BranchPredictor: BranchPC = %h", BranchPC[2]);
        $display ("BranchPredictor: BranchPC = %h", BranchPC[3]);
        $display (".......................................");
        if (Prediction[PC[`BINDEX]] == 2'b11) begin
            $display("BranchPredictor: Prediction = %b", Prediction[PC[`BINDEX]]);
            $display("BranchPredictor: TargetPC = %b", TargetPC[PC[`BINDEX]]);
        end else begin
            $display("BranchPredictor: Prediction = %b", Prediction[PC[`BINDEX]]);
            $display("BranchPredictor: PCPlus4F = %b", PCPlus4F);
        end
    end
    assign TakingBranch = ((Prediction[CurrentPC[`BINDEX]] == 2'b10 | Prediction[CurrentPC[`BINDEX]] == 2'b11) & Valid_reg[CurrentPC[`BINDEX]] & BranchPC[CurrentPC[`BINDEX]] == CurrentPC) ? 1 : 0;
    assign NextInstruction = TakingBranch ? TargetPC[CurrentPC[`BINDEX]] : PCPlus4F;
    assign taken = BranchE & ZeroE;
endmodule
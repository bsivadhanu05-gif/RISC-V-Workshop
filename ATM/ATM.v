`timescale 1ns/1ps
// Educational ATM Controller (simulation model)
// Supports: PIN authentication (3 attempts), balance enquiry, withdrawal,
// deposit, PIN change, transaction cancel, and card ejection.
// This is a behavioral teaching model, NOT production banking/security logic.

module ATM (
    input  wire       clk,
    input  wire       reset,

    // Card/PIN interface
    input  wire       card_insert,
    input  wire       pin_submit,
    input  wire [3:0] pin_entry,

    // Menu: 1=Balance, 2=Withdraw, 3=Deposit, 4=Change PIN, 5=Cancel
    input  wire       menu_valid,
    input  wire [2:0] menu_choice,

    // Transaction interface
    input  wire       amount_valid,
    input  wire [7:0] amount,
    input  wire       new_pin_valid,
    input  wire [3:0] new_pin,

    // Cancel can be asserted during menu/transaction states
    input  wire       cancel,

    // Status / outputs
    output reg        pin_prompt,
    output reg        menu_display,
    output reg        balance_display,
    output reg        dispense_cash,
    output reg        deposit_done,
    output reg        pin_changed,
    output reg        transaction_done,
    output reg        insufficient_funds,
    output reg        invalid_amount,
    output reg        card_eject,
    output reg        cancelled,
    output reg [7:0]  balance,
    output reg [7:0]  cash_dispensed,
    output reg [1:0]  pin_attempts_left,
    output reg [3:0]  current_state
);

    localparam S_IDLE          = 4'd0;
    localparam S_PIN           = 4'd1;
    localparam S_MENU          = 4'd2;
    localparam S_BALANCE       = 4'd3;
    localparam S_WITHDRAW      = 4'd4;
    localparam S_DEPOSIT       = 4'd5;
    localparam S_PIN_CHANGE    = 4'd6;
    localparam S_DONE          = 4'd7;
    localparam S_CANCEL        = 4'd8;
    localparam S_EJECT         = 4'd9;
    localparam S_LOCKED        = 4'd10;

    localparam MENU_BALANCE = 3'd1;
    localparam MENU_WITHDRAW= 3'd2;
    localparam MENU_DEPOSIT = 3'd3;
    localparam MENU_PIN     = 3'd4;
    localparam MENU_CANCEL  = 3'd5;

    reg [3:0] state;
    reg [3:0] stored_pin;
    reg [7:0] pending_amount;
    reg [1:0] attempts;

    // State and datapath registers
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state             <= S_IDLE;
            stored_pin        <= 4'd5;       // Default demo PIN: 5
            balance           <= 8'd100;     // Initial demo balance: 100
            pending_amount    <= 8'd0;
            cash_dispensed    <= 8'd0;
            attempts           <= 2'd3;
            pin_attempts_left <= 2'd3;
        end else begin
            // Default one-cycle action outputs
            dispense_cash      <= 1'b0;
            deposit_done       <= 1'b0;
            pin_changed        <= 1'b0;
            transaction_done   <= 1'b0;
            insufficient_funds <= 1'b0;
            invalid_amount     <= 1'b0;
            cancelled          <= 1'b0;

            case (state)
                S_IDLE: begin
                    attempts <= 2'd3;
                    pin_attempts_left <= 2'd3;
                    if (card_insert)
                        state <= S_PIN;
                end

                S_PIN: begin
                    if (pin_submit) begin
                        if (pin_entry == stored_pin) begin
                            attempts <= 2'd3;
                            pin_attempts_left <= 2'd3;
                            state <= S_MENU;
                        end else if (attempts <= 2'd1) begin
                            attempts <= 2'd0;
                            pin_attempts_left <= 2'd0;
                            state <= S_LOCKED;
                        end else begin
                            attempts <= attempts - 1'b1;
                            pin_attempts_left <= attempts - 1'b1;
                        end
                    end
                end

                S_MENU: begin
                    if (cancel)
                        state <= S_CANCEL;
                    else if (menu_valid) begin
                        case (menu_choice)
                            MENU_BALANCE:  state <= S_BALANCE;
                            MENU_WITHDRAW: state <= S_WITHDRAW;
                            MENU_DEPOSIT:  state <= S_DEPOSIT;
                            MENU_PIN:      state <= S_PIN_CHANGE;
                            MENU_CANCEL:   state <= S_CANCEL;
                            default:       state <= S_MENU;
                        endcase
                    end
                end

                S_BALANCE: begin
                    // balance_display is asserted while in this state
                    if (cancel) state <= S_CANCEL;
                    else state <= S_DONE;
                end

                S_WITHDRAW: begin
                    if (cancel) state <= S_CANCEL;
                    else if (amount_valid) begin
                        if (amount == 0) begin
                            invalid_amount <= 1'b1;
                            state <= S_DONE;
                        end else if (amount > balance) begin
                            insufficient_funds <= 1'b1;
                            state <= S_DONE;
                        end else begin
                            pending_amount <= amount;
                            balance <= balance - amount;
                            cash_dispensed <= amount;
                            dispense_cash <= 1'b1;
                            state <= S_DONE;
                        end
                    end
                end

                S_DEPOSIT: begin
                    if (cancel) state <= S_CANCEL;
                    else if (amount_valid) begin
                        if (amount == 0) begin
                            invalid_amount <= 1'b1;
                            state <= S_DONE;
                        end else if ((balance + amount) > 8'hFF) begin
                            invalid_amount <= 1'b1; // 8-bit balance overflow
                            state <= S_DONE;
                        end else begin
                            balance <= balance + amount;
                            deposit_done <= 1'b1;
                            state <= S_DONE;
                        end
                    end
                end

                S_PIN_CHANGE: begin
                    if (cancel) state <= S_CANCEL;
                    else if (new_pin_valid) begin
                        stored_pin <= new_pin;
                        pin_changed <= 1'b1;
                        state <= S_DONE;
                    end
                end

                S_DONE: begin
                    transaction_done <= 1'b1;
                    state <= S_MENU;
                end

                S_CANCEL: begin
                    cancelled <= 1'b1;
                    state <= S_MENU;
                end

                S_EJECT: begin
                    state <= S_IDLE;
                end

                S_LOCKED: begin
                    state <= S_EJECT;
                end

                default: state <= S_IDLE;
            endcase
        end
    end

    // Moore-style status outputs
    always @(*) begin
        pin_prompt      = (state == S_PIN);
        menu_display    = (state == S_MENU);
        balance_display = (state == S_BALANCE);
        card_eject      = (state == S_EJECT) || (state == S_LOCKED);
    current_state     = state;
    end

endmodule

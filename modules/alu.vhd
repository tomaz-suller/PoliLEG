---------------------------------------------------------------
entity fa1bit is
    port(
        a, b, cin: in bit;
        result, cout: out bit
    );
end entity;
architecture structural of fa1bit is
begin
    result <= a xor b xor cin;
    cout <= (a and b) or (a and cin) or (b and cin);
end architecture;
---------------------------------------------------------------
---------------------------------------------------------------
entity alu1bit is
    port(
        a, b, less, cin: in bit;
        result, cout, set, overflow: out bit;
        ainvert, binvert: in bit;
        operation: in bit_vector(1 downto 0)
    );
end entity;
architecture arch of alu1bit is

    component fa1bit is
        port(
            a, b, cin: in bit;
            result, cout: out bit
        );
    end component;

    signal firstOperand, secondOperand, sum, CO: bit;
begin

    firstOperand <= 
        a when ainvert = '0' else
        not a;
    secondOperand <=
        b when binvert = '0' else
        not b;

    adder: fa1bit port map(
        firstOperand, secondOperand, cin,
        sum, CO
    );

    with operation select result <= 
        firstOperand and secondOperand when "00",
        firstOperand or secondOperand when "01",
        sum when "10",
        b when "11";

    set <= sum;
    overflow <= cin xor CO;
    cout <= CO;

end architecture;
---------------------------------------------------------------
---------------------------------------------------------------
library ieee;
use ieee.numeric_bit.all;

entity alu is
    generic(
        size: natural := 10
    );
    port(
        A, B: in bit_vector(size-1 downto 0);
        F: out bit_vector(size-1 downto 0);
        S: in bit_vector(3 downto 0);
        Z, Ov, Co: out bit
    );
end entity;
architecture stuctural of alu is

    component alu1bit is
        port(
            a, b, less, cin: in bit;
            result, cout, set, overflow: out bit;
            ainvert, binvert: in bit;
            operation: in bit_vector(1 downto 0)
        );
    end component;

    signal ainvert, binvert: bit;
    signal operation: bit_vector(1 downto 0);
    signal coutBv: bit_vector(size-2 downto 0);
    signal resultBv, setBv, overflowBv, zero: bit_vector(size-1 downto 0);

begin

    ainvert <= S(3);
    binvert <= S(2);
    operation <= S(1 downto 0);

    firstAlu: alu1bit port map(
        A(0), B(0), '0', binvert,
        resultBv(0), coutBv(0), setBv(0), overflowBv(0),
        ainvert, binvert,
        operation
    );
    zero(0) <= resultBv(0);

    lastAlu: alu1bit port map(
       A(size-1), B(size-1), '0', coutBv(size-2), 
       resultBv(size-1), Co, setBv(size-1), Ov,
       ainvert, binvert,
       operation
    );
    zero(size-1) <= zero(size-2) or resultBv(size-1);

    Alus: for i in size-2 downto 1 generate
        Alu_i: alu1bit port map(
            A(i), B(i), '0', coutBv(i-1), 
            resultBv(i), coutBv(i), setBv(i), overflowBv(i),
            ainvert, binvert,
            operation
        );
        zero(i) <= zero(i-1) or resultBv(i);
    end generate;

    Z <= not zero(size-1);
    F <= resultBv;

end architecture;
---------------------------------------------------------------

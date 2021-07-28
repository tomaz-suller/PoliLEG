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

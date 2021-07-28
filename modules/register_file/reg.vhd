library ieee;
use ieee.numeric_bit.rising_edge;

entity reg is
    generic(
        wordSize: natural := 64
    );
    port(
        clock, reset, enable, wr: in bit;
        dataIn: in bit_vector(wordSize-1 downto 0);
        dataOut: out bit_vector(wordSize-1 downto 0)
    );
end entity;
architecture functional of reg is
    signal internalData: bit_vector(wordSize-1 downto 0);
begin
    dataOut <= internalData;
    update: process(clock, reset)
    begin
        if reset = '1' then
            internalData <= (others => '0');
        elsif wr = '1' and enable = '1'
                and rising_edge(clock) then
            internalData <= dataIn;
        end if;
    end process;
end architecture;

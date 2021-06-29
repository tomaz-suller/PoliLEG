library ieee;
use ieee.numeric_bit.all;
use ieee.std_logic_1164.all;

entity ram is
    generic (
        address_size_in_bits    : natural := 64;
        word_size_in_bits       : natural := 32;
        delay_in_clocks         : positive := 1
    );
    port (
        ck, enable, write_enable: in bit;
        addr: in bit_vector(address_size_in_bits-1 downto 0);
        data: inout std_logic_vector(word_size_in_bits-1 downto 0);
        bsy: out bit
    );
end ram;

architecture arch of ram is
    type memory_type is array(2**address_size_in_bits-1 downto 0)
        of std_logic_vector(word_size_in_bits-1 downto 0);
    signal memory: memory_type;
begin

    process(ck, enable)
        variable delay_count: natural := 0;
    begin

        if write_enable = '1' then
            data <= (others=>'Z');
        end if;

        if rising_edge(ck) then
            bsy <= '0';
            if enable = '1' then 
                if delay_count < delay_in_clocks then
                    delay_count := delay_count + 1;
                    bsy <= '1';
                else
                    delay_count := 0;
                    bsy <= '0';
                    if write_enable = '1' then
                        memory(to_integer(unsigned(addr))) <= data; 
                    else
                        data <= memory(to_integer(unsigned(addr)));
                    end if;
                end if;
            end if;
        end if;
        
        if falling_edge(enable) then
            delay_count := 0;
            bsy <= '0';
        end if;

    end process;

end arch;
library ieee;
use ieee.std_logic_1164.all;

entity ram_tb is 
end entity;

architecture arch of ram_tb is

    component ram is
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
    end component;

    constant ADDRESS_SIZE: natural := 4;
    constant WORD_SIZE: natural := 4;
    constant CLOCK_DELAY: positive := 5;

    constant CK_PERIOD: time := 1 ns;
    signal sim: bit := '0';

    signal ck, enable, write_enable: bit;
    signal addr: bit_vector(ADDRESS_SIZE-1 downto 0);
    signal data: std_logic_vector(WORD_SIZE-1 downto 0);
    signal bsy: bit;

begin

    dut: ram 
        generic map(ADDRESS_SIZE, WORD_SIZE, CLOCK_DELAY)
        port map(ck, enable, write_enable, addr, data, bsy);

    ck <= sim and not ck after CK_PERIOD;

    tb: process
    begin
        report "BOT";
        sim <= '1';

        addr <= "0000";
        data <= "0101";
        wait for CK_PERIOD;
        enable <= '1';
        write_enable <= '1';
        wait until bsy = '0';
        
        enable <= '0';

        write_enable <= '0';
        data <= (others=>'Z');
        wait for CK_PERIOD;
        enable <= '1';
        wait until bsy = '0';

        report "EOT";
        sim <= '0';
        wait;
    end process;

end architecture arch;
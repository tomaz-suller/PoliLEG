library ieee;
use ieee.math_real.ceil;
use ieee.math_real.log2;
use ieee.numeric_bit.all;

entity regfile_tb is
end entity;

architecture arch of regfile_tb is

    component regfile is
        generic(
            regn: natural := 32;
            wordSize: natural := 64
        );
        port(
            clock, reset, regWrite: in bit;
            rr1, rr2, wr: in bit_vector(natural(ceil(log2(real(regn))))-1 downto 0);
            d: in bit_vector(wordSize-1 downto 0);
            q1, q2: out bit_vector(wordSize-1 downto 0)
        );
    end component;

    constant NUMBER_OF_REGISTERS: natural := 4;
    constant WORD_SIZE_IN_BITS: natural := 4;
    signal clock, reset, regWrite: bit;
    signal rr1, rr2, wr: bit_vector(
        natural(ceil(log2(real(NUMBER_OF_REGISTERS))))-1 downto 0);
    signal d, q1, q2: bit_vector(WORD_SIZE_IN_BITS-1 downto 0);

    constant CLOCK_PERIOD: time := 1 ns;
    signal simulate: bit := '0';

begin

    dut: regfile
        generic map(
            NUMBER_OF_REGISTERS,
            WORD_SIZE_IN_BITS
        )
        port map(
            clock, reset, regWrite,
            rr1, rr2, wr,
            d,
            q1, q2
        );

    clock <= (not clock and simulate) after CLOCK_PERIOD/2;

    tb: process
    begin
        report "BOT";
        simulate <= '1';

        reset <= '1';
        wait for CLOCK_PERIOD/10;
        reset <= '0';
        wait until rising_edge(clock);

        regWrite <= '1';
        wr <= "11";
        d <= "1010";
        wait for CLOCK_PERIOD;
        regWrite <= '0';

        rr1 <= "11";
        wait for 1 ps;
        assert q1 = "0000" report "Escrita no XZR falhou" severity warning;
        wait until rising_edge(clock);

        regWrite <= '1';
        wr <= "00";
        d <= "1010";
        wait for CLOCK_PERIOD;
        regWrite <= '0';

        rr1 <= "00";
        wait for 1 ps;
        assert q1 = "1010" report "Escrita no X0 falhou" severity warning;
        wait until rising_edge(clock);

        rr2 <= "00";
        wait for 1 ps;
        assert q2 = "1010" report "Leitura por RR2 falhou" severity warning;
        wait until rising_edge(clock);

        regWrite <= '1';
        wr <= "10";
        d <= "0100";
        wait for CLOCK_PERIOD;
        regWrite <= '0';

        rr1 <= "10";
        wait for 1 ps;
        assert q1 = "0100" report "Escrita em X2 falhou" severity warning;
        wait until rising_edge(clock);

        reset <= '1';
        wait for CLOCK_PERIOD/10;
        reset <= '0';

        assert q1 = "0000" report "Reset falhou" severity warning;
        assert q2 = "0000" report "Reset falhou" severity warning;

        report "EOT";
        simulate <= '0';
        wait;
    end process;

end architecture arch;

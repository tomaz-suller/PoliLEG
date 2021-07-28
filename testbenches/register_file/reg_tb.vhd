entity reg_tb is
end entity;

architecture arch of reg_tb is

    component reg is
        generic(
            wordSize: natural := 64
        );
        port(
            clock, reset, enable, wr: in bit;
            dataIn: in bit_vector(wordSize-1 downto 0);
            dataOut: out bit_vector(wordSize-1 downto 0)
        );
    end component;

    constant WORD_SIZE: natural := 4;
    signal clock, reset, enable, wr: bit;
    signal dataIn, dataOut: bit_vector(WORD_SIZE-1 downto 0);

    constant CLOCK_PERIOD: time := 1 ns;
    signal simulate: bit := '0';

begin

    dut: reg
        generic map(WORD_SIZE)
        port map(clock, reset, enable, wr, dataIn, dataOut);

    clock <= (not clock and simulate) after CLOCK_PERIOD/2;

    tb: process
    begin
        report "BOT";
        simulate <= '1';
        enable <= '1';

        reset <= '1';
        wait for CLOCK_PERIOD;
        reset <= '0';
        wait for 1 ps;

        dataIn <= "1010";
        wr <= '1';
        wait for CLOCK_PERIOD;
        wr <= '0';
        assert dataOut = "1010" report "Falhou na primeira escrita" severity warning;

        wait for CLOCK_PERIOD/4;
        reset <= '1';
        wait for 10 ps;
        reset <= '0';
        assert dataOut = "0000" report "Falhou no reset" severity warning;
        wait for 1 ps;

        dataIn <= "0101";
        wr <= '1';
        wait for CLOCK_PERIOD;
        wr <= '0';
        assert dataOut = "0101" report "Falhou na segunda escrita" severity warning;

        enable <= '0';
        dataIn <= "1111";
        wr <= '1';
        wait for CLOCK_PERIOD;
        assert dataOut = "0101" report "Enable falhou" severity warning;

        simulate <= '0';
        report "EOT";
        wait;
    end process;

end architecture arch;

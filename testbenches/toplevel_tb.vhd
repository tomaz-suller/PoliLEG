entity toplevel_tb is
end entity;

architecture arch of toplevel_tb is

    component toplevel is
        port(
            clock, reset: in bit
        );
    end component;

    constant CK_PERIOD: time := 1 ns;
    signal sim: bit := '0';
    signal clock: bit;

begin
    clock <= sim and not clock after CK_PERIOD/2;
    dut: toplevel port map(clock, '0');

    tb: process
    begin
        report "BOT";
        sim <= '1';

        wait for 20*CK_PERIOD;

        report "EOT";
        sim <= '0';
        wait;
    end process;

end architecture arch;

entity ram_tb is
end entity;

architecture arch of ram_tb is

    component ram is
        generic(
            mem_width_in_bits: natural := 64;
            word_size: natural := 64;
            mem_word_size: natural := 8;
            init_file: string := "../software/gcd/ram.dat"
        );
        port(
            ck, wr : in  bit;
            addr   : in  bit_vector(mem_width_in_bits-1 downto 0);
            data_i : in  bit_vector(word_size-1 downto 0);
            data_o : out bit_vector(word_size-1 downto 0)
        );
    end component;

    constant MEM_WIDTH_IN_BITS: natural := 11;
    constant WORD_SIZE: natural := 64;
    constant MEMORY_WORD_SIZE: natural := 8;
    constant INITIAL_FILENAME: string := "../software/gcd/ram.dat";

    signal addr: bit_vector(MEM_WIDTH_IN_BITS-1 downto 0);
    signal data_i, data_o: bit_vector(WORD_SIZE-1 downto 0);

    constant CK_PERIOD: time := 1 ns;
    signal sim: bit := '0';
    signal ck, wr: bit;

begin
    ck <= sim and (not ck) after CK_PERIOD;

    dut: ram
        generic map(
            MEM_WIDTH_IN_BITS,
            WORD_SIZE,
            MEMORY_WORD_SIZE,
            INITIAL_FILENAME
        )
        port map(
            ck, wr,
            addr,
            data_i,
            data_o
        );

    tb: process
    begin
        report "BOT";
        sim <= '1';

        wait for CK_PERIOD/2;

        addr <= "00000011000";
        data_i <=
            "1111111111111111111111111111111111111111111111111111111111111111";
        wr <= '1';
        wait for CK_PERIOD;

        assert data_o =
            "1111111111111111111111111111111111111111111111111111111111111111";

        wait for 2*CK_PERIOD;

        report "EOT";
        sim <= '0';
        wait;
    end process;

end architecture arch;

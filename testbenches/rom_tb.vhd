use work.utils.all;

entity rom_tb is 
end entity;

architecture arch of rom_tb is

    component rom is
        generic(
            mem_width_in_bits: natural := 64;
            word_size: natural := 64;
            init_file: string := "../software/rom.dat"
        );
        port(
            addr   : in  bit_vector(mem_width_in_bits-1 downto 0);
            data_o : out bit_vector(word_size-1 downto 0)
        );
    end component;

    constant MEM_WIDTH_IN_BITS: natural := 10;
    constant WORD_SIZE: natural := 32;
    constant INITIAL_FILENAME: string := "../software/rom.dat";

    type test_case_type is record 
        stimulus: bit_vector(MEM_WIDTH_IN_BITS-1 downto 0);
        response: bit_vector(WORD_SIZE-1 downto 0);
    end record;
    type test_case_array is array(1 to 4) of test_case_type;
    constant TEST_CASES: test_case_array := (
        ("0000000000", "11111000010000000000001111100001"),
        ("0000000100", "11111000010000001000001111100010"),
        ("0000001000", "11111000010000010000001111100011"),
        ("0000001100", "11001011000000110000000001000100")
    );

    signal addr: bit_vector(MEM_WIDTH_IN_BITS-1 downto 0);
    signal data_o: bit_vector(WORD_SIZE-1 downto 0);

begin

    dut: rom
        generic map(
            MEM_WIDTH_IN_BITS,
            WORD_SIZE,
            INITIAL_FILENAME
        )
        port map(
            addr,
            data_o
        );

    tb: process
        variable expected: bit_vector(WORD_SIZE-1 downto 0);
    begin
        report "BOT";
        for index in TEST_CASES'range loop
            report integer'image(index);
            addr <= TEST_CASES(index).stimulus;
            wait for 1 ps;
            expected := TEST_CASES(index).response;
            assertEquals(expected, data_o);
        end loop;

        report "EOT";
        wait;
    end process;

end architecture arch;
